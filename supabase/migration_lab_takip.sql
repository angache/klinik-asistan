-- Lab'a gönderilen işler: beklenen dönüş + takip için alanlar

alter table seans_notlari
  add column if not exists lab_gitti boolean not null default false;

alter table seans_notlari
  add column if not exists lab_beklenen_tarih date;

alter table takipler
  add column if not exists tur text not null default 'genel';
-- tur: 'genel' | 'lab'

create index if not exists seans_notlari_lab_beklenen_idx
  on seans_notlari (klinik_id, lab_beklenen_tarih)
  where lab_gitti = true and lab_beklenen_tarih is not null;
