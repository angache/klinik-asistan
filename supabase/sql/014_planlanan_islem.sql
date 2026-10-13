-- Sonraki seansa planlanan işlemler (henüz yapılmadı)

alter table seans_notlari
  add column if not exists planlandi boolean not null default false;

create index if not exists seans_notlari_planlandi_idx
  on seans_notlari (hasta_id, planlandi)
  where planlandi = true and guncel = true;
