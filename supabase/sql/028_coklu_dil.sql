-- Çoklu dil
--   1. Klinik dili: varsayılan işlem şablonları bu dilde eklenir
--   2. Cihaz dili: push bildirimleri bu dilde gönderilir
--   3. Klinik oluşturma kurucunun dilini kaydeder
--   4. Sunucu şablon yüklemesi yalnızca Türkçe kliniklerde çalışır;
--      diğer dillerde şablonları uygulama kendi dilinde ekler
-- 027_kontrol_cagrilari.sql'den sonra SQL Editor'de çalıştırın. Tekrar çalıştırılabilir.

-- ── 1–2. Dil kolonları ────────────────────────────────────────────────
-- Mevcut klinikler ve cihazlar Türkçe kabul edilir.
alter table public.klinikler
  add column if not exists dil text not null default 'tr';

alter table public.device_tokens
  add column if not exists dil text not null default 'tr';

-- ── 3. Klinik oluşturma ───────────────────────────────────────────────
drop function if exists public.create_clinic_with_admin(text, text, text);

create or replace function public.create_clinic_with_admin(
  p_ad text,
  p_kod text,
  p_ad_soyad text,
  p_dil text default 'tr'
)
returns klinikler
language plpgsql
security definer
set search_path = public
as $$
declare
  v_klinik klinikler;
begin
  if auth.uid() is null then
    raise exception 'Oturum gerekli';
  end if;

  insert into klinikler (ad, kod, dil)
  values (
    trim(p_ad),
    upper(trim(p_kod)),
    coalesce(nullif(lower(trim(p_dil)), ''), 'tr')
  )
  returning * into v_klinik;

  insert into klinik_uyeleri (klinik_id, user_id, rol, ad_soyad)
  values (v_klinik.id, auth.uid(), 'admin', trim(p_ad_soyad));

  perform public.seed_klinik_islemleri(v_klinik.id);

  return v_klinik;
end;
$$;

revoke execute on function public.create_clinic_with_admin(text, text, text, text)
  from public, anon;
grant execute on function public.create_clinic_with_admin(text, text, text, text)
  to authenticated;

-- ── 4. Varsayılan şablonlar (027 sürümü + dil kontrolü) ───────────────
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

  if coalesce((select dil from klinikler where id = p_klinik_id), 'tr') <> 'tr' then
    return 0;
  end if;

  select coalesce(max(sira), 0) into v_sira
  from klinik_islemleri where klinik_id = p_klinik_id;

  insert into klinik_islemleri
    (klinik_id, kategori, baslik, is_kanal, dis_zorunlu, lab_takip,
     kontrol_ay, sira)
  select
    p_klinik_id, d.kategori, d.baslik, d.is_kanal, d.dis_zorunlu, d.lab_takip,
    d.kontrol_ay, v_sira + d.ord
  from (values
    (1,  'Teşhis ve Planlama', 'Tedavi Planlaması', false, false, false, null::int),
    (2,  'Teşhis ve Planlama', 'İlk Muayene / Teşhis', false, false, false, null),
    (10, 'Tedavi', 'Kanal Başlangıç', true,  true,  false, null),
    (11, 'Tedavi', 'Kanal Bitim', true,  true,  false, 6),
    (12, 'Tedavi', 'Kanal Yenileme', true,  true,  false, 6),
    (13, 'Tedavi', 'Kompozit Dolgu', false, true,  false, null),
    (14, 'Tedavi', 'Kuafaj', false, true,  false, null),
    (15, 'Tedavi', 'Diş Çekimi', false, true,  false, null),
    (16, 'Tedavi', 'Komplikasyonlu Çekim', false, true,  false, null),
    (17, 'Tedavi', 'Cerrahi Çekim', false, true,  false, null),
    (18, 'Tedavi', 'Alveolit Tedavisi (Pansuman)', false, true,  false, null),
    (19, 'Tedavi', 'Küretaj', false, true,  false, 3),
    (20, 'Tedavi', 'Beyazlatma', false, false, false, null),
    (30, 'Protez', 'Diş Kesimi', false, true,  false, null),
    (31, 'Protez', 'Ölçü', false, false, true, null),
    (32, 'Protez', 'Altyapı Prova', false, true,  true, null),
    (33, 'Protez', 'Dentin Prova', false, true,  true, null),
    (34, 'Protez', 'Geçici Simantasyon', false, true,  false, null),
    (35, 'Protez', 'Daimi Simantasyon', false, true,  false, 6),
    (36, 'Protez', 'Gece Plağı Ölçüsü', false, false, true, null),
    (40, 'Genel',  'Detertraj (Temizlik)', false, false, false, 6),
    (41, 'Genel',  'Kontrol', false, false, false, 6)
  ) as d(ord, kategori, baslik, is_kanal, dis_zorunlu, lab_takip, kontrol_ay)
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
