-- Ses kayıtları tablosu — Supabase SQL Editor'de bir kez çalıştırın.

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

alter table ses_kayitlari enable row level security;

drop policy if exists "ses_select" on ses_kayitlari;
drop policy if exists "ses_insert" on ses_kayitlari;
drop policy if exists "ses_update" on ses_kayitlari;
drop policy if exists "ses_delete" on ses_kayitlari;

create policy "ses_select" on ses_kayitlari for select using (true);
create policy "ses_insert" on ses_kayitlari for insert with check (true);
create policy "ses_update" on ses_kayitlari for update using (true);
create policy "ses_delete" on ses_kayitlari for delete using (true);

-- Realtime (yoksa ekler; varsa hata verebilir — o satırı atlayın)
alter publication supabase_realtime add table ses_kayitlari;
