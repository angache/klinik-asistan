-- Hasta takip / kontrol randevuları
-- Supabase SQL Editor'de çalıştırın.

create table if not exists takipler (
  id uuid default gen_random_uuid() primary key,
  klinik_id uuid not null references klinikler(id) on delete cascade,
  hasta_id uuid not null references hastalar(id) on delete cascade,
  seans_notu_id uuid references seans_notlari(id) on delete set null,
  baslik text not null,
  aciklama text,
  planlanan_tarih date not null,
  tamamlandi boolean not null default false,
  tamamlanma_tarihi timestamp with time zone,
  olusturan_user_id uuid references auth.users(id),
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null
);

create index if not exists takipler_klinik_tarih_idx
  on takipler(klinik_id, planlanan_tarih)
  where tamamlandi = false;
create index if not exists takipler_hasta_idx on takipler(hasta_id);

alter table takipler enable row level security;

drop policy if exists "takip_select" on takipler;
drop policy if exists "takip_insert" on takipler;
drop policy if exists "takip_update" on takipler;
drop policy if exists "takip_delete" on takipler;

create policy "takip_select" on takipler for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "takip_insert" on takipler for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));
create policy "takip_update" on takipler for update
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "takip_delete" on takipler for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));
