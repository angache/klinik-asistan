import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { sendFcmToTokens } from '../_shared/fcm.ts';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

function todayIstanbul(): string {
  const fmt = new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Europe/Istanbul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
  return fmt.format(new Date()); // YYYY-MM-DD
}

// 3 veya daha az kayıt → tek tek; fazlası → tek özet bildirim.
const INDIVIDUAL_THRESHOLD = 3;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: cors });
  }

  try {
    // Cron secret koruması (opsiyonel ama önerilir)
    const cronSecret = Deno.env.get('CRON_SECRET');
    if (cronSecret) {
      const auth = req.headers.get('Authorization') ?? '';
      if (auth !== `Bearer ${cronSecret}`) {
        return new Response('Unauthorized', { status: 401, headers: cors });
      }
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const today = todayIstanbul();
    const summary: Record<string, unknown> = { today };

    // Bir klinikteki (opsiyonel: belirli üyenin) cihaz token'larını getir.
    async function tokensForClinic(
      klinikId: string,
      memberId?: string | null,
    ): Promise<string[]> {
      let memberQuery = supabase
        .from('klinik_uyeleri')
        .select('id, user_id')
        .eq('klinik_id', klinikId);
      if (memberId) memberQuery = memberQuery.eq('id', memberId);
      const { data: members } = await memberQuery;
      const ids = (members ?? []).map((m) => m.user_id as string);
      if (ids.length === 0) return [];
      const { data: tokens } = await supabase
        .from('device_tokens')
        .select('token')
        .in('user_id', ids);
      return (tokens ?? []).map((t) => t.token as string);
    }

    // ── Takipler: hatırlatma günü = bugün ─────────────────
    // planlanan_tarih - hatirlatma_gun_once = today
    // SQL tarafında hesaplamak için tüm açık takipleri çekip filtreliyoruz
    // (klinik başına üye token'larına göndeririz).
    const { data: followUps } = await supabase
      .from('takipler')
      .select(
        'id, klinik_id, baslik, tur, planlanan_tarih, hatirlatma_gun_once, son_push_tarihi, hastalar(ad_soyad)',
      )
      .eq('tamamlandi', false);

    const dueFollowUps = (followUps ?? []).filter((f) => {
      const plan = new Date(`${f.planlanan_tarih}T00:00:00`);
      const days = (f.hatirlatma_gun_once as number) ?? 0;
      plan.setDate(plan.getDate() - days);
      const y = plan.getFullYear();
      const m = String(plan.getMonth() + 1).padStart(2, '0');
      const d = String(plan.getDate()).padStart(2, '0');
      return `${y}-${m}-${d}` === today && f.son_push_tarihi !== today;
    });

    // Klinik + tür (lab / kontrol) başına grupla; az ise tek tek, çok ise özet.
    type FollowKind = 'lab' | 'kontrol';
    const followKind = (tur: unknown): FollowKind =>
      tur === 'lab' ? 'lab' : 'kontrol';

    const followGroups = new Map<string, typeof dueFollowUps>();
    for (const f of dueFollowUps) {
      const kind = followKind(f.tur);
      const key = `${f.klinik_id}:${kind}`;
      followGroups.set(key, [...(followGroups.get(key) ?? []), f]);
    }

    let followSent = 0;
    for (const [key, group] of followGroups) {
      const [klinikId, kind] = key.split(':') as [string, FollowKind];
      const list = await tokensForClinic(klinikId);
      if (list.length === 0) continue;

      const isLab = kind === 'lab';
      const itemTitle = isLab ? 'Lab takibi' : 'Kontrol';
      const summaryTitle = isLab ? 'Günün lab takipleri' : 'Günün kontrolleri';
      const summaryBody = isLab
        ? `${group.length} lab takibi bugün`
        : `${group.length} kontrol bugün`;
      const summaryType = isLab ? 'lab_summary' : 'follow_up_summary';

      if (group.length <= INDIVIDUAL_THRESHOLD) {
        for (const f of group) {
          const hasta =
            (f.hastalar as { ad_soyad?: string } | null)?.ad_soyad ?? 'Hasta';
          const r = await sendFcmToTokens({
            tokens: list,
            title: `${itemTitle}: ${hasta}`,
            body: f.baslik as string,
            data: {
              type: isLab ? 'lab' : 'follow_up',
              id: f.id as string,
            },
          });
          followSent += r.sent;
        }
      } else {
        const r = await sendFcmToTokens({
          tokens: list,
          title: summaryTitle,
          body: summaryBody,
          data: { type: summaryType, klinik_id: klinikId },
        });
        followSent += r.sent;
      }

      await supabase
        .from('takipler')
        .update({ son_push_tarihi: today })
        .in('id', group.map((f) => f.id as string));
    }
    summary.followUps = {
      due: dueFollowUps.length,
      groups: followGroups.size,
      sent: followSent,
    };

    // ── Yapılacaklar: zamanı gelen ve henüz push atılmamış ───────
    const { data: todos } = await supabase
      .from('klinik_todolar')
      .select(
        'id, klinik_id, icerik, planlanan_tarih, planlanan_zaman, ' +
          'hatirlatma_dakika_once, son_hatirlatma_tarihi, sorumlu_uye_id',
      )
      .eq('tamamlandi', false);

    const now = new Date();
    const dueTodos = (todos ?? []).filter((t) => {
      if (t.son_hatirlatma_tarihi) return false;
      if (t.planlanan_zaman) {
        const target = new Date(t.planlanan_zaman as string);
        const minutes = (t.hatirlatma_dakika_once as number) ?? 0;
        return target.getTime() - minutes * 60_000 <= now.getTime();
      }
      return Boolean(t.planlanan_tarih && t.planlanan_tarih <= today);
    });

    // Klinik + sorumlu başına tek özet bildirim
    const groups = new Map<string, typeof dueTodos>();
    for (const t of dueTodos) {
      const key = `${t.klinik_id}:${t.sorumlu_uye_id ?? 'all'}`;
      groups.set(key, [...(groups.get(key) ?? []), t]);
    }

    let todoSent = 0;
    for (const group of groups.values()) {
      const first = group[0];
      const klinikId = first.klinik_id as string;
      const assignedMemberId = first.sorumlu_uye_id as string | null;

      const list = await tokensForClinic(klinikId, assignedMemberId);
      if (list.length === 0) continue;

      const title = assignedMemberId
        ? 'Size atanan görevler'
        : 'Günün yapılacakları';

      if (group.length <= INDIVIDUAL_THRESHOLD) {
        for (const t of group) {
          const r = await sendFcmToTokens({
            tokens: list,
            title,
            body: (t.icerik as string | null) ?? 'Açık görev',
            data: { type: 'clinic_todos', klinik_id: klinikId },
          });
          todoSent += r.sent;
        }
      } else {
        const r = await sendFcmToTokens({
          tokens: list,
          title,
          body: `${group.length} açık görev zamanı geldi`,
          data: { type: 'clinic_todos', klinik_id: klinikId },
        });
        todoSent += r.sent;
      }

      await supabase
        .from('klinik_todolar')
        .update({ son_hatirlatma_tarihi: now.toISOString() })
        .in('id', group.map((t) => t.id as string));
    }
    summary.todos = { due: dueTodos.length, groups: groups.size, sent: todoSent };

    return new Response(JSON.stringify(summary), {
      headers: { ...cors, 'Content-Type': 'application/json' },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, 'Content-Type': 'application/json' },
    });
  }
});
