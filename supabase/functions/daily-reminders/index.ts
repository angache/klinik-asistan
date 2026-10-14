import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  initials,
  sendFcmToTokens,
  unauthorizedResponse,
} from '../_shared/fcm.ts';
import { groupByLang, type Lang, type LangToken, t } from '../_shared/i18n.ts';

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
    const denied = unauthorizedResponse(req, cors);
    if (denied) return denied;

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const today = todayIstanbul();
    const summary: Record<string, unknown> = { today };

    let pruned = 0;
    async function send(opts: Parameters<typeof sendFcmToTokens>[0]) {
      const r = await sendFcmToTokens(opts);
      if (r.invalid.length > 0) {
        await supabase.from('device_tokens').delete().in('token', r.invalid);
        pruned += r.invalid.length;
      }
      return r;
    }

    // Bir klinikteki (opsiyonel: belirli üyenin) cihaz token'ları, dile göre.
    async function tokensForClinic(
      klinikId: string,
      memberId?: string | null,
    ): Promise<Map<Lang, string[]>> {
      let memberQuery = supabase
        .from('klinik_uyeleri')
        .select('id, user_id')
        .eq('klinik_id', klinikId);
      if (memberId) memberQuery = memberQuery.eq('id', memberId);
      const { data: members } = await memberQuery;
      const ids = (members ?? []).map((m) => m.user_id as string);
      if (ids.length === 0) return new Map();
      const { data: tokens } = await supabase
        .from('device_tokens')
        .select('token, dil')
        .in('user_id', ids);
      return groupByLang((tokens ?? []) as LangToken[]);
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
      const byLang = await tokensForClinic(klinikId);
      if (byLang.size === 0) continue;

      const isLab = kind === 'lab';
      const summaryType = isLab ? 'lab_summary' : 'follow_up_summary';

      for (const [lang, list] of byLang) {
        const m = t(lang);
        if (group.length <= INDIVIDUAL_THRESHOLD) {
          for (const f of group) {
            // KVKK: tam ad yurt dışı sunucudan geçmesin, kilit ekranında görünmesin.
            const hasta = initials(
              (f.hastalar as { ad_soyad?: string } | null)?.ad_soyad,
              lang,
              m.patientFallback,
            );
            const r = await send({
              tokens: list,
              title: `${isLab ? m.labItem : m.controlItem}: ${hasta}`,
              body: f.baslik as string,
              data: {
                type: isLab ? 'lab' : 'follow_up',
                id: f.id as string,
              },
            });
            followSent += r.sent;
          }
        } else {
          const r = await send({
            tokens: list,
            title: isLab ? m.labSummaryTitle : m.controlSummaryTitle,
            body: isLab
              ? m.labSummaryBody(group.length)
              : m.controlSummaryBody(group.length),
            data: { type: summaryType, klinik_id: klinikId },
          });
          followSent += r.sent;
        }
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

      const byLang = await tokensForClinic(klinikId, assignedMemberId);
      if (byLang.size === 0) continue;

      for (const [lang, list] of byLang) {
        const m = t(lang);
        const title = assignedMemberId ? m.todosAssignedTitle : m.todosTitle;
        if (group.length <= INDIVIDUAL_THRESHOLD) {
          for (const todo of group) {
            const r = await send({
              tokens: list,
              title,
              body: (todo.icerik as string | null) ?? m.todoFallback,
              data: { type: 'clinic_todos', klinik_id: klinikId },
            });
            todoSent += r.sent;
          }
        } else {
          const r = await send({
            tokens: list,
            title,
            body: m.todosSummaryBody(group.length),
            data: { type: 'clinic_todos', klinik_id: klinikId },
          });
          todoSent += r.sent;
        }
      }

      await supabase
        .from('klinik_todolar')
        .update({ son_hatirlatma_tarihi: now.toISOString() })
        .in('id', group.map((t) => t.id as string));
    }
    summary.todos = { due: dueTodos.length, groups: groups.size, sent: todoSent };
    summary.prunedTokens = pruned;

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
