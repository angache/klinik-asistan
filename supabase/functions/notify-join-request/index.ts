import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { sendFcmToTokens, unauthorizedResponse } from '../_shared/fcm.ts';
import { groupByLang, type LangToken, t } from '../_shared/i18n.ts';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: cors });
  }

  try {
    const denied = unauthorizedResponse(req, cors);
    if (denied) return denied;

    const payload = await req.json();
    // Database Webhook: { type, table, record, ... }
    const record = payload.record ?? payload;
    const klinikId = record.klinik_id as string | undefined;
    const adSoyad = (record.ad_soyad as string | undefined)?.trim();
    const durum = (record.durum as string | undefined) ?? 'beklemede';

    if (!klinikId || durum !== 'beklemede') {
      return new Response(JSON.stringify({ skipped: true }), {
        headers: { ...cors, 'Content-Type': 'application/json' },
      });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const { data: admins } = await supabase
      .from('klinik_uyeleri')
      .select('user_id')
      .eq('klinik_id', klinikId)
      .eq('rol', 'admin');

    const adminIds = (admins ?? []).map((a) => a.user_id as string);
    if (adminIds.length === 0) {
      return new Response(JSON.stringify({ admins: 0 }), {
        headers: { ...cors, 'Content-Type': 'application/json' },
      });
    }

    const { data: tokens } = await supabase
      .from('device_tokens')
      .select('token, dil')
      .in('user_id', adminIds);

    const byLang = groupByLang((tokens ?? []) as LangToken[]);
    if (byLang.size === 0) {
      return new Response(JSON.stringify({ tokens: 0 }), {
        headers: { ...cors, 'Content-Type': 'application/json' },
      });
    }

    const result = { sent: 0, failed: 0, invalid: [] as string[] };
    for (const [lang, list] of byLang) {
      const m = t(lang);
      const r = await sendFcmToTokens({
        tokens: list,
        title: m.joinRequestTitle,
        body: m.joinRequestBody(adSoyad || m.someone),
        data: { type: 'join_request', klinik_id: klinikId },
      });
      result.sent += r.sent;
      result.failed += r.failed;
      result.invalid.push(...r.invalid);
    }
    if (result.invalid.length > 0) {
      await supabase.from('device_tokens').delete().in('token', result.invalid);
    }

    return new Response(JSON.stringify(result), {
      headers: { ...cors, 'Content-Type': 'application/json' },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, 'Content-Type': 'application/json' },
    });
  }
});
