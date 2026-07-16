-- İşlem şablonunda lab takibi: yeni işlem formunda yalnızca bu şablonlarda gösterilir

alter table klinik_islemleri
  add column if not exists lab_takip boolean not null default false;

-- Tipik lab'a giden protez adımlari (klinik isterse şablonda kapatabilir)
update klinik_islemleri
set lab_takip = true
where lower(baslik) in (
  'ölçü',
  'altyapı prova',
  'dentin prova',
  'gece plağı ölçüsü'
);

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
