import {
  createClient,
  type SupabaseClient,
} from 'https://esm.sh/@supabase/supabase-js@2.49.1';

// Uygulama içi hesap silme (App Store / Google Play zorunluluğu).
// verify_jwt açık deploy edilir: yalnızca oturum sahibi kendi hesabını siler.
//
// Body: { dryRun: true }  → ne silineceğini döner, hiçbir şey silmez.
//       { confirm: true } → siler.
//
// Kurallar:
// - Tek üyesi bu kullanıcı olan klinik: hasta, seans, dosya dahil silinir.
// - Son admin olduğu ve başka üyesi olan klinik varsa silme reddedilir
//   (önce başka bir üyeyi admin yapmalı).
// - Diğer kliniklerde yalnızca üyelik silinir; kayıtlar klinikte kalır.

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

const BUCKET = 'seans-fotograflari';

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, 'Content-Type': 'application/json' },
  });
}

async function listRecursive(
  admin: SupabaseClient,
  prefix: string,
): Promise<string[]> {
  const out: string[] = [];
  for (let offset = 0;; offset += 1000) {
    const { data, error } = await admin.storage
      .from(BUCKET)
      .list(prefix, { limit: 1000, offset });
    if (error || !data || data.length === 0) break;
    for (const item of data) {
      const path = `${prefix}/${item.name}`;
      // Klasörlerin id'si yoktur.
      if (item.id) out.push(path);
      else out.push(...await listRecursive(admin, path));
    }
    if (data.length < 1000) break;
  }
  return out;
}

async function removePaths(admin: SupabaseClient, paths: string[]) {
  for (let i = 0; i < paths.length; i += 1000) {
    await admin.storage.from(BUCKET).remove(paths.slice(i, i + 1000));
  }
}

// DB'de hem ham path hem eski public URL tutulabiliyor.
function toPath(stored: string | null | undefined): string | null {
  if (!stored) return null;
  const s = stored.trim();
  if (!s) return null;
  if (!s.includes('://')) return s;
  const marker = `/${BUCKET}/`;
  const i = s.indexOf(marker);
  return i < 0 ? null : decodeURIComponent(s.slice(i + marker.length));
}

async function deleteClinic(admin: SupabaseClient, klinikId: string) {
  // Eski formatlı ({hasta_id}/..., ses/{hasta_id}/...) dosyalar klinik
  // klasöründe değil; DB'deki referanslardan toplanır.
  const paths = new Set<string>(await listRecursive(admin, klinikId));
  const { data: notes } = await admin
    .from('seans_notlari')
    .select('fotograf_url, fotograf_urls')
    .eq('klinik_id', klinikId);
  for (const n of notes ?? []) {
    for (const u of [n.fotograf_url, ...(n.fotograf_urls ?? [])]) {
      const p = toPath(u);
      if (p) paths.add(p);
    }
  }
  const { data: voices } = await admin
    .from('ses_kayitlari')
    .select('dosya_url')
    .eq('klinik_id', klinikId);
  for (const v of voices ?? []) {
    const p = toPath(v.dosya_url);
    if (p) paths.add(p);
  }

  // hastalar / seans_notlari / ses_kayitlari kliniğe "no action" ile bağlı.
  for (const table of ['seans_notlari', 'ses_kayitlari', 'hastalar']) {
    const { error } = await admin.from(table).delete().eq('klinik_id', klinikId);
    if (error) throw new Error(`${table}: ${error.message}`);
  }
  const { error } = await admin.from('klinikler').delete().eq('id', klinikId);
  if (error) throw new Error(`klinikler: ${error.message}`);

  await removePaths(admin, [...paths]);
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: cors });
  }

  try {
    const admin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const jwt = (req.headers.get('Authorization') ?? '').replace(
      /^Bearer\s+/i,
      '',
    );
    const { data: auth, error: authError } = await admin.auth.getUser(jwt);
    const user = auth?.user;
    if (authError || !user) return json({ error: 'Oturum gerekli' }, 401);

    const body = await req.json().catch(() => ({}));

    const { data: memberships, error: mErr } = await admin
      .from('klinik_uyeleri')
      .select('klinik_id, rol, klinikler(ad)')
      .eq('user_id', user.id);
    if (mErr) throw new Error(mErr.message);

    const clinicsToDelete: { id: string; ad: string }[] = [];
    const blockingClinics: string[] = [];
    for (const m of memberships ?? []) {
      const ad = (m.klinikler as { ad?: string } | null)?.ad ?? 'Klinik';
      const { data: members } = await admin
        .from('klinik_uyeleri')
        .select('user_id, rol')
        .eq('klinik_id', m.klinik_id);
      const others = (members ?? []).filter((x) => x.user_id !== user.id);
      if (others.length === 0) {
        clinicsToDelete.push({ id: m.klinik_id as string, ad });
      } else if (m.rol === 'admin' && !others.some((o) => o.rol === 'admin')) {
        blockingClinics.push(ad);
      }
    }

    const preview = {
      clinicsToDelete: clinicsToDelete.map((c) => c.ad),
      blockingClinics,
    };
    if (body.dryRun === true) return json(preview);
    if (body.confirm !== true) return json({ error: 'Onay gerekli' }, 400);
    if (blockingClinics.length > 0) {
      return json({ error: 'LAST_ADMIN', ...preview }, 409);
    }

    for (const c of clinicsToDelete) {
      await deleteClinic(admin, c.id);
    }

    // Üyelik, token ve katılım istekleri auth.users silinince cascade olur;
    // oluşturulan kayıtlardaki kullanıcı bağı "set null" olur.
    const { error: delErr } = await admin.auth.admin.deleteUser(user.id);
    if (delErr) throw new Error(delErr.message);

    return json({ deleted: true, ...preview });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});
