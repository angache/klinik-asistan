-- Klinik Asistan — Supabase şema
-- SQL Editor'de çalıştırın.

-- Hastalar
create table if not exists hastalar (
  id uuid default gen_random_uuid() primary key,
  ad_soyad text not null,
  telefon text,
  olusturma_tarihi timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Seans Notları (sürümleme: eski kayıtlar korunur, guncel=true olan gösterilir)
create table if not exists seans_notlari (
  id uuid default gen_random_uuid() primary key,
  hasta_id uuid references hastalar(id) on delete cascade not null,
  kapsam text not null default 'tum_agiz', -- 'tek_dis', 'ust_cene', 'alt_cene', 'tum_agiz'
  dis_no text,
  islem_baslik text not null,
  kanal_boyu text,
  ege_sistemi text,
  kanal_ilaci text,
  not_icerik text not null,
  fotograf_url text,
  tarih date default current_date not null,
  olusturma_tarihi timestamp with time zone default timezone('utc'::text, now()) not null,
  -- Sürüm alanları
  kok_id uuid,              -- ilk kaydın id'si; null ise bu kayıt köktür
  onceki_id uuid,           -- bir önceki sürüm
  versiyon int not null default 1,
  guncel boolean not null default true,
  degisiklik_ozeti text     -- bu sürümde ne değişti
);

create index if not exists seans_notlari_hasta_id_idx on seans_notlari(hasta_id);
create index if not exists seans_notlari_tarih_idx on seans_notlari(tarih desc);
create index if not exists seans_notlari_guncel_idx on seans_notlari(hasta_id, guncel);
create index if not exists seans_notlari_kok_id_idx on seans_notlari(kok_id);
create index if not exists hastalar_ad_soyad_idx on hastalar(ad_soyad);

-- Hızlı ses kayıtları (sonradan dinleyip seans notuna dönüştürülür)
create table if not exists ses_kayitlari (
  id uuid default gen_random_uuid() primary key,
  hasta_id uuid references hastalar(id) on delete cascade not null,
  dosya_url text not null,
  sure_saniye int,
  olusturma_tarihi timestamp with time zone default timezone('utc'::text, now()) not null,
  islenen boolean not null default false,
  seans_notu_id uuid
);

create index if not exists ses_kayitlari_hasta_id_idx on ses_kayitlari(hasta_id);
create index if not exists ses_kayitlari_islenen_idx on ses_kayitlari(hasta_id, islenen);

-- Realtime (Dashboard canlı liste için)
alter publication supabase_realtime add table hastalar;
alter publication supabase_realtime add table seans_notlari;
alter publication supabase_realtime add table ses_kayitlari;

-- Geliştirme: anon erişim (klinik içi kullanım).
-- Üretimde Auth + RLS politikalarını sıkılaştırın.
alter table hastalar enable row level security;
alter table seans_notlari enable row level security;

create policy "hastalar_select" on hastalar for select using (true);
create policy "hastalar_insert" on hastalar for insert with check (true);
create policy "hastalar_update" on hastalar for update using (true);
create policy "hastalar_delete" on hastalar for delete using (true);

create policy "seans_select" on seans_notlari for select using (true);
create policy "seans_insert" on seans_notlari for insert with check (true);
create policy "seans_update" on seans_notlari for update using (true);
create policy "seans_delete" on seans_notlari for delete using (true);

alter table ses_kayitlari enable row level security;
create policy "ses_select" on ses_kayitlari for select using (true);
create policy "ses_insert" on ses_kayitlari for insert with check (true);
create policy "ses_update" on ses_kayitlari for update using (true);
create policy "ses_delete" on ses_kayitlari for delete using (true);

-- Storage bucket: Panelden 'seans-fotograflari' public bucket oluşturun
-- veya aşağıdaki SQL ile (Supabase Storage):
insert into storage.buckets (id, name, public)
values ('seans-fotograflari', 'seans-fotograflari', true)
on conflict (id) do nothing;

create policy "seans_foto_public_read"
  on storage.objects for select
  using (bucket_id = 'seans-fotograflari');

create policy "seans_foto_anon_upload"
  on storage.objects for insert
  with check (bucket_id = 'seans-fotograflari');

create policy "seans_foto_anon_update"
  on storage.objects for update
  using (bucket_id = 'seans-fotograflari');

create policy "seans_foto_anon_delete"
  on storage.objects for delete
  using (bucket_id = 'seans-fotograflari');
