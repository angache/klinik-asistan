-- Mevcut projeye sürümleme alanlarını ekler.
-- Supabase → SQL Editor'de bir kez çalıştırın.

alter table seans_notlari
  add column if not exists kok_id uuid,
  add column if not exists onceki_id uuid,
  add column if not exists versiyon int not null default 1,
  add column if not exists guncel boolean not null default true,
  add column if not exists degisiklik_ozeti text;

create index if not exists seans_notlari_guncel_idx on seans_notlari(hasta_id, guncel);
create index if not exists seans_notlari_kok_id_idx on seans_notlari(kok_id);

-- Eski kayıtlar güncel kabul edilir
update seans_notlari set guncel = true where guncel is null;
update seans_notlari set versiyon = 1 where versiyon is null;
