-- Klinik işlem şablonları (varsayılanlar kopyalanır, klinik özelleştirir)

create table if not exists klinik_islemleri (
  id uuid primary key default gen_random_uuid(),
  klinik_id uuid not null references klinikler(id) on delete cascade,
  kategori text not null,
  baslik text not null,
  is_kanal boolean not null default false,
  dis_zorunlu boolean not null default true,
  aktif boolean not null default true,
  sira int not null default 0,
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null,
  constraint klinik_islemleri_baslik_unique unique (klinik_id, baslik)
);

create index if not exists klinik_islemleri_klinik_idx
  on klinik_islemleri (klinik_id, aktif, sira);

alter table klinik_islemleri enable row level security;

drop policy if exists "klinik_islemleri_select" on klinik_islemleri;
drop policy if exists "klinik_islemleri_insert" on klinik_islemleri;
drop policy if exists "klinik_islemleri_update" on klinik_islemleri;
drop policy if exists "klinik_islemleri_delete" on klinik_islemleri;

create policy "klinik_islemleri_select" on klinik_islemleri for select
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "klinik_islemleri_insert" on klinik_islemleri for insert
  with check (
    klinik_id in (select public.kullanici_klinik_ids())
    and exists (
      select 1 from klinik_uyeleri u
      where u.klinik_id = klinik_islemleri.klinik_id
        and u.user_id = auth.uid()
        and u.rol in ('admin', 'doktor')
    )
  );

create policy "klinik_islemleri_update" on klinik_islemleri for update
  using (
    exists (
      select 1 from klinik_uyeleri u
      where u.klinik_id = klinik_islemleri.klinik_id
        and u.user_id = auth.uid()
        and u.rol in ('admin', 'doktor')
    )
  )
  with check (
    exists (
      select 1 from klinik_uyeleri u
      where u.klinik_id = klinik_islemleri.klinik_id
        and u.user_id = auth.uid()
        and u.rol in ('admin', 'doktor')
    )
  );

create policy "klinik_islemleri_delete" on klinik_islemleri for delete
  using (
    exists (
      select 1 from klinik_uyeleri u
      where u.klinik_id = klinik_islemleri.klinik_id
        and u.user_id = auth.uid()
        and u.rol in ('admin', 'doktor')
    )
  );

-- Varsayılanları kliniğe bas (eksik başlıkları ekler; mevcutları ezmez)
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
  select coalesce(max(sira), 0) into v_sira
  from klinik_islemleri where klinik_id = p_klinik_id;

  -- Tedavi
  insert into klinik_islemleri (klinik_id, kategori, baslik, is_kanal, dis_zorunlu, sira)
  select p_klinik_id, d.kategori, d.baslik, d.is_kanal, d.dis_zorunlu, v_sira + d.ord
  from (values
    (1,  'Teşhis ve Planlama', 'Tedavi Planlaması', false, false),
    (2,  'Teşhis ve Planlama', 'İlk Muayene / Teşhis', false, false),
    (10, 'Tedavi', 'Kanal Başlangıç', true,  true),
    (11, 'Tedavi', 'Kanal Bitim', true,  true),
    (12, 'Tedavi', 'Kanal Yenileme', true,  true),
    (13, 'Tedavi', 'Kompozit Dolgu', false, true),
    (14, 'Tedavi', 'Kuafaj', false, true),
    (15, 'Tedavi', 'Diş Çekimi', false, true),
    (16, 'Tedavi', 'Komplikasyonlu Çekim', false, true),
    (17, 'Tedavi', 'Cerrahi Çekim', false, true),
    (18, 'Tedavi', 'Alveolit Tedavisi (Pansuman)', false, true),
    (19, 'Tedavi', 'Küretaj', false, true),
    (20, 'Tedavi', 'Beyazlatma', false, false),
    (30, 'Protez', 'Diş Kesimi', false, true),
    (31, 'Protez', 'Ölçü', false, false),
    (32, 'Protez', 'Altyapı Prova', false, true),
    (33, 'Protez', 'Dentin Prova', false, true),
    (34, 'Protez', 'Geçici Simantasyon', false, true),
    (35, 'Protez', 'Daimi Simantasyon', false, true),
    (36, 'Protez', 'Gece Plağı Ölçüsü', false, false),
    (40, 'Genel',  'Detertraj (Temizlik)', false, false),
    (41, 'Genel',  'Kontrol', false, false)
  ) as d(ord, kategori, baslik, is_kanal, dis_zorunlu)
  where not exists (
    select 1 from klinik_islemleri k
    where k.klinik_id = p_klinik_id and lower(k.baslik) = lower(d.baslik)
  );

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

grant execute on function public.seed_klinik_islemleri(uuid) to authenticated;

-- Üye için: sadece kendi klinikleri; admin değilse seed yine çalışır (eksikleri doldurur)
-- Ama insert policy admin-only — bu yüzden seed SECURITY DEFINER olmalı (above: ok)

create or replace function public.create_clinic_with_admin(
  p_ad text,
  p_kod text,
  p_ad_soyad text
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

  insert into klinikler (ad, kod)
  values (trim(p_ad), upper(trim(p_kod)))
  returning * into v_klinik;

  insert into klinik_uyeleri (klinik_id, user_id, rol, ad_soyad)
  values (v_klinik.id, auth.uid(), 'admin', trim(p_ad_soyad));

  perform public.seed_klinik_islemleri(v_klinik.id);

  return v_klinik;
end;
$$;

grant execute on function public.create_clinic_with_admin(text, text, text) to authenticated;

-- Mevcut kliniklere bir kerelik seed (migration çalıştırıldığında)
do $$
declare
  r record;
begin
  for r in select id from klinikler loop
    perform public.seed_klinik_islemleri(r.id);
  end loop;
end $$;
