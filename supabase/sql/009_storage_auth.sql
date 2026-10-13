-- Storage: anon açık politikaları kaldır, sadece authenticated
-- Supabase SQL Editor'de çalıştırın.

drop policy if exists "seans_foto_public_read" on storage.objects;
drop policy if exists "seans_foto_anon_upload" on storage.objects;
drop policy if exists "seans_foto_anon_update" on storage.objects;
drop policy if exists "seans_foto_anon_delete" on storage.objects;
drop policy if exists "seans_foto_auth_read" on storage.objects;
drop policy if exists "seans_foto_auth_insert" on storage.objects;
drop policy if exists "seans_foto_auth_update" on storage.objects;
drop policy if exists "seans_foto_auth_delete" on storage.objects;

-- Public URL yerine imzalı URL / Storage API kullanılacak
update storage.buckets
set public = false
where id = 'seans-fotograflari';

create policy "seans_foto_auth_read"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'seans-fotograflari');

create policy "seans_foto_auth_insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'seans-fotograflari');

create policy "seans_foto_auth_update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'seans-fotograflari');

create policy "seans_foto_auth_delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'seans-fotograflari');
