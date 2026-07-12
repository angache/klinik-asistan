-- Storage okuma düzeltmesi
-- Supabase → SQL Editor'de bir kez çalıştırın.
-- Yükleme çalışıyor ama foto/ses görünmüyorsa bu genelde eksiktir.

-- Bucket herkese açık olsun (public URL için)
update storage.buckets
set public = true
where id = 'seans-fotograflari';

-- Yoksa oluştur
insert into storage.buckets (id, name, public)
values ('seans-fotograflari', 'seans-fotograflari', true)
on conflict (id) do update set public = excluded.public;

-- Eski politikaları temizle / yeniden ekle
drop policy if exists "seans_foto_public_read" on storage.objects;
drop policy if exists "seans_foto_anon_upload" on storage.objects;
drop policy if exists "seans_foto_anon_update" on storage.objects;
drop policy if exists "seans_foto_anon_delete" on storage.objects;

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
