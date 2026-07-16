-- Hasta kartında sonraki randevu notu (tarihsiz)

alter table hastalar
  add column if not exists sonraki_plan text;
