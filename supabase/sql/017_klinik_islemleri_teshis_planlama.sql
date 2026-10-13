-- Teşhis ve Planlama varsayılan işlemlerini mevcut kliniklere ekler.
-- migration_klinik_islemleri.sql zaten çalıştıysa bunu çalıştırmanız yeterli.

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

do $$
declare
  r record;
begin
  for r in select id from klinikler loop
    perform public.seed_klinik_islemleri(r.id);
  end loop;
end $$;
