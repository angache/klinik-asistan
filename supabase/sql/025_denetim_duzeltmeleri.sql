-- Denetim düzeltmeleri (Eylül 2026).
-- 023_session_photos.sql'den sonra çalıştırın. Tekrar çalıştırılabilir.

-- ── 1. Seans notu: atomik ekleme ve sürümleme ─────────────────────────
-- security invoker: RLS politikaları aynen uygulanır.

create or replace function public._seans_notu_insert(p jsonb)
returns seans_notlari
language plpgsql
security invoker
set search_path = public
as $$
declare
  v seans_notlari;
begin
  insert into seans_notlari (
    hasta_id, klinik_id, olusturan_user_id, kapsam, dis_no, islem_baslik,
    kanal_boyu, ege_sistemi, kanal_ilaci, not_icerik,
    fotograf_url, fotograf_urls, tarih,
    kok_id, onceki_id, versiyon, guncel, degisiklik_ozeti,
    planlandi, lab_gitti, lab_beklenen_tarih
  ) values (
    (p->>'hasta_id')::uuid,
    (p->>'klinik_id')::uuid,
    auth.uid(),
    coalesce(p->>'kapsam', 'tum_agiz'),
    p->>'dis_no',
    p->>'islem_baslik',
    p->>'kanal_boyu',
    p->>'ege_sistemi',
    p->>'kanal_ilaci',
    coalesce(p->>'not_icerik', ''),
    p->>'fotograf_url',
    case
      when jsonb_typeof(p->'fotograf_urls') = 'array'
        then array(select jsonb_array_elements_text(p->'fotograf_urls'))
      else '{}'::text[]
    end,
    coalesce((p->>'tarih')::timestamptz, timezone('utc', now())),
    (p->>'kok_id')::uuid,
    (p->>'onceki_id')::uuid,
    coalesce((p->>'versiyon')::int, 1),
    coalesce((p->>'guncel')::boolean, true),
    p->>'degisiklik_ozeti',
    coalesce((p->>'planlandi')::boolean, false),
    coalesce((p->>'lab_gitti')::boolean, false),
    (p->>'lab_beklenen_tarih')::date
  )
  returning * into v;
  return v;
end;
$$;

-- Birden fazla notu tek transaction'da ekler (çok dişli kanal kaydı).
create or replace function public.seans_notlari_ekle(p_rows jsonb)
returns setof seans_notlari
language plpgsql
security invoker
set search_path = public
as $$
declare
  r jsonb;
begin
  if jsonb_typeof(p_rows) <> 'array' or jsonb_array_length(p_rows) = 0 then
    raise exception 'Kaydedilecek not yok';
  end if;
  for r in select * from jsonb_array_elements(p_rows) loop
    return next public._seans_notu_insert(r);
  end loop;
end;
$$;

-- Düzenleme: eski sürümü kapatıp yenisini aynı transaction'da ekler.
-- Not bu arada başkası tarafından düzenlendiyse NOT_GUNCEL_DEGIL hatası verir.
create or replace function public.seans_notu_yeni_surum(
  p_onceki_id uuid,
  p_yeni jsonb
)
returns seans_notlari
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_onceki seans_notlari;
begin
  select * into v_onceki
  from seans_notlari
  where id = p_onceki_id
  for update;

  if not found then
    raise exception 'Not bulunamadı';
  end if;
  if not v_onceki.guncel then
    raise exception 'NOT_GUNCEL_DEGIL';
  end if;

  update seans_notlari set guncel = false where id = p_onceki_id;

  return public._seans_notu_insert(
    p_yeni || jsonb_build_object(
      'hasta_id', v_onceki.hasta_id,
      'klinik_id', v_onceki.klinik_id,
      'kok_id', coalesce(v_onceki.kok_id, v_onceki.id),
      'onceki_id', v_onceki.id,
      'versiyon', v_onceki.versiyon + 1,
      'guncel', true,
      'planlandi', v_onceki.planlandi,
      'lab_gitti', v_onceki.lab_gitti,
      'lab_beklenen_tarih', v_onceki.lab_beklenen_tarih
    )
  );
end;
$$;

revoke execute on function public._seans_notu_insert(jsonb) from public, anon;
revoke execute on function public.seans_notlari_ekle(jsonb) from public, anon;
revoke execute on function public.seans_notu_yeni_surum(uuid, jsonb) from public, anon;
grant execute on function public._seans_notu_insert(jsonb) to authenticated;
grant execute on function public.seans_notlari_ekle(jsonb) to authenticated;
grant execute on function public.seans_notu_yeni_surum(uuid, jsonb) to authenticated;

-- ── 2. Cihaz token'ı devri ────────────────────────────────────────────
-- Aynı cihazda başka kullanıcı oturum açınca token satırı eski kullanıcıda
-- kalıyordu (RLS başkasının satırını güncellemeye izin vermez) ve önceki
-- kullanıcının bildirimleri bu cihaza gitmeye devam ediyordu.
create or replace function public.register_device_token(
  p_token text,
  p_platform text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Oturum gerekli';
  end if;
  if coalesce(length(p_token), 0) < 20 then
    raise exception 'Geçersiz token';
  end if;

  insert into device_tokens (user_id, token, platform, guncelleme_tarihi)
  values (auth.uid(), p_token, p_platform, timezone('utc', now()))
  on conflict (token) do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        guncelleme_tarihi = excluded.guncelleme_tarihi;
end;
$$;

revoke execute on function public.register_device_token(text, text) from public, anon;
grant execute on function public.register_device_token(text, text) to authenticated;

-- ── 3. Klinik bilgisi: yalnızca admin güncelleyebilir ─────────────────
drop policy if exists "klinikler_update" on klinikler;
create policy "klinikler_update" on klinikler for update
  using (public.is_klinik_admin(id))
  with check (public.is_klinik_admin(id));

-- ── 4. Varsayılan işlem şablonları: yalnızca kendi kliniğine ───────────
-- Önceden herhangi bir oturum sahibi başka kliniğe satır ekleyebiliyordu.
-- auth.uid() null = SQL Editor / başka definer fonksiyon içinden çağrı.
create or replace function public.seed_klinik_islemleri(p_klinik_id uuid)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count int := 0;
  v_sira int;
begin
  if auth.uid() is not null
     and p_klinik_id not in (select public.kullanici_klinik_ids()) then
    raise exception 'Bu kliniğe üye değilsiniz';
  end if;

  select coalesce(max(sira), 0) into v_sira
  from klinik_islemleri where klinik_id = p_klinik_id;

  insert into klinik_islemleri
    (klinik_id, kategori, baslik, is_kanal, dis_zorunlu, lab_takip, sira)
  select
    p_klinik_id, d.kategori, d.baslik, d.is_kanal, d.dis_zorunlu, d.lab_takip,
    v_sira + d.ord
  from (values
    (1,  'Teşhis ve Planlama', 'Tedavi Planlaması', false, false, false),
    (2,  'Teşhis ve Planlama', 'İlk Muayene / Teşhis', false, false, false),
    (10, 'Tedavi', 'Kanal Başlangıç', true,  true,  false),
    (11, 'Tedavi', 'Kanal Bitim', true,  true,  false),
    (12, 'Tedavi', 'Kanal Yenileme', true,  true,  false),
    (13, 'Tedavi', 'Kompozit Dolgu', false, true,  false),
    (14, 'Tedavi', 'Kuafaj', false, true,  false),
    (15, 'Tedavi', 'Diş Çekimi', false, true,  false),
    (16, 'Tedavi', 'Komplikasyonlu Çekim', false, true,  false),
    (17, 'Tedavi', 'Cerrahi Çekim', false, true,  false),
    (18, 'Tedavi', 'Alveolit Tedavisi (Pansuman)', false, true,  false),
    (19, 'Tedavi', 'Küretaj', false, true,  false),
    (20, 'Tedavi', 'Beyazlatma', false, false, false),
    (30, 'Protez', 'Diş Kesimi', false, true,  false),
    (31, 'Protez', 'Ölçü', false, false, true),
    (32, 'Protez', 'Altyapı Prova', false, true,  true),
    (33, 'Protez', 'Dentin Prova', false, true,  true),
    (34, 'Protez', 'Geçici Simantasyon', false, true,  false),
    (35, 'Protez', 'Daimi Simantasyon', false, true,  false),
    (36, 'Protez', 'Gece Plağı Ölçüsü', false, false, true),
    (40, 'Genel',  'Detertraj (Temizlik)', false, false, false),
    (41, 'Genel',  'Kontrol', false, false, false)
  ) as d(ord, kategori, baslik, is_kanal, dis_zorunlu, lab_takip)
  where not exists (
    select 1 from klinik_islemleri k
    where k.klinik_id = p_klinik_id and lower(k.baslik) = lower(d.baslik)
  );

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

revoke execute on function public.seed_klinik_islemleri(uuid) from public, anon;
grant execute on function public.seed_klinik_islemleri(uuid) to authenticated;

-- ── 5. Storage: silme / üzerine yazma yalnızca yükleyen veya admin/doktor ──
-- Okuma ve yükleme tüm klinik üyelerine açık kalır.
-- Nesne yolundan kliniği çözer (storage_object_allowed ile aynı formatlar).
create or replace function public.storage_object_klinik_id(object_name text)
returns uuid
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  parts text[];
  as_uuid uuid;
  v_klinik uuid;
begin
  if object_name is null or length(trim(object_name)) = 0 then
    return null;
  end if;
  parts := string_to_array(object_name, '/');

  begin
    if parts[1] = 'ses' and parts[2] = 'todolar' then
      return parts[3]::uuid;               -- eski todo: ses/todolar/{klinik}/..
    elsif parts[1] = 'ses' then
      as_uuid := parts[2]::uuid;           -- eski ses: ses/{hasta}/..
    else
      as_uuid := parts[1]::uuid;           -- yeni: {klinik}/.. | eski foto: {hasta}/..
      if exists (select 1 from klinikler where id = as_uuid) then
        return as_uuid;
      end if;
    end if;
  exception when invalid_text_representation then
    return null;
  end;

  select klinik_id into v_klinik from hastalar where id = as_uuid;
  return v_klinik;
end;
$$;

revoke all on function public.storage_object_klinik_id(text) from public, anon;
grant execute on function public.storage_object_klinik_id(text) to authenticated;

drop policy if exists "seans_foto_auth_update" on storage.objects;
drop policy if exists "seans_foto_auth_delete" on storage.objects;

create policy "seans_foto_auth_update"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
    and (
      owner_id = auth.uid()::text
      or public.is_klinik_editor(public.storage_object_klinik_id(name))
    )
  )
  with check (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  );

create policy "seans_foto_auth_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
    and (
      owner_id = auth.uid()::text
      or public.is_klinik_editor(public.storage_object_klinik_id(name))
    )
  );

-- ── 6. Kullanıcı silinince kayıtlar kalsın, bağ kopsun ─────────────────
-- auth.users'a "no action" ile bağlı nullable sütunlar hesap silmeyi
-- engelliyordu. Bunları "on delete set null" yapar (klinik verisi korunur).
do $$
declare
  r record;
begin
  for r in
    select c.conname, c.conrelid::regclass as tbl, a.attname as col
    from pg_constraint c
    join pg_attribute a
      on a.attrelid = c.conrelid and a.attnum = c.conkey[1]
    join pg_namespace n on n.oid = (
      select relnamespace from pg_class where oid = c.conrelid
    )
    where c.contype = 'f'
      and c.confrelid = 'auth.users'::regclass
      and c.confdeltype = 'a'
      and n.nspname = 'public'
      and array_length(c.conkey, 1) = 1
      and not a.attnotnull
  loop
    execute format('alter table %s drop constraint %I', r.tbl, r.conname);
    execute format(
      'alter table %s add constraint %I foreign key (%I) '
      'references auth.users(id) on delete set null',
      r.tbl, r.conname, r.col
    );
    raise notice '%.% → on delete set null', r.tbl, r.col;
  end loop;
end $$;
