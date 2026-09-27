-- Seans başına birden fazla fotoğraf.
-- fotograf_url geriye uyumluluk için ilk fotoğrafı tutmaya devam eder.

alter table seans_notlari
  add column if not exists fotograf_urls text[] not null default '{}';

update seans_notlari
set fotograf_urls = array[fotograf_url]
where fotograf_url is not null
  and fotograf_url <> ''
  and cardinality(fotograf_urls) = 0;

alter table seans_notlari
  drop constraint if exists seans_notlari_fotograf_urls_max;
alter table seans_notlari
  add constraint seans_notlari_fotograf_urls_max
  check (cardinality(fotograf_urls) <= 20);
