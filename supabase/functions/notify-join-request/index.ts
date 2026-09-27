import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { sendFcmToTokens } from '../_shared/fcm.ts';

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
    // Webhook secret koruması (verify_jwt kapalıyken zorunlu)
    const secret = Deno.env.get('CRON_SECRET');
    if (secret) {
      const auth = req.headers.get('Authorization') ?? '';
      if (auth !== `Bearer ${secret}`) {
        return new Response('Unauthorized', { status: 401, headers: cors });
      }
    }

    const payload = await req.json();
    // Database Webhook: { type, table, record, ... }
    const record = payload.record ?? payload;
    const klinikId = record.klinik_id as string | undefined;
    const adSoyad = (record.ad_soyad as string | undefined) ?? 'Bir kullanıcı';
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
      .select('token')
      .in('user_id', adminIds);

    const list = (tokens ?? []).map((t) => t.token as string);
    if (list.length === 0) {
      return new Response(JSON.stringify({ tokens: 0 }), {
        headers: { ...cors, 'Content-Type': 'application/json' },
      });
    }

    const result = await sendFcmToTokens({
      tokens: list,
      title: 'Yeni katılım isteği',
      body: `${adSoyad} kliniğe katılmak istiyor`,
      data: { type: 'join_request', klinik_id: klinikId },
    });

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
