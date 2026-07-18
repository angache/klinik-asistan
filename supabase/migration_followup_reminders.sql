-- Takip tarihinden önce uyarı desteği.
-- Supabase SQL Editor'de bir kez çalıştırın.

alter table takipler
  add column if not exists hatirlatma_gun_once integer not null default 0;

alter table takipler
  drop constraint if exists takipler_hatirlatma_gun_once_check;

alter table takipler
  add constraint takipler_hatirlatma_gun_once_check
  check (hatirlatma_gun_once between 0 and 365);
