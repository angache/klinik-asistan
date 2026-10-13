-- Güvenlik sıkılaştırma:
-- 1) Storage: nesne yolu klinik üyeliğine bağlı (eski path formatları da desteklenir)
-- 2) Hasta / seans silme: sadece admin + doktor
-- Supabase SQL Editor'de çalıştırın.

-- ── Rol yardımcıları ─────────────────────────────────────
create or replace function public.is_klinik_editor(p_klinik_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from klinik_uyeleri
    where klinik_id = p_klinik_id
      and user_id = auth.uid()
      and rol in ('admin', 'doktor')
  );
$$;

revoke all on function public.is_klinik_editor(uuid) from public;
grant execute on function public.is_klinik_editor(uuid) to authenticated;

-- Storage object path erişim kontrolü
-- Yeni:  {klinik_id}/foto|ses|todolar/...
-- Eski foto: {hasta_id}/dosya
-- Eski ses:  ses/{hasta_id}/dosya
-- Eski todo: ses/todolar/{klinik_id}/dosya
create or replace function public.storage_object_allowed(object_name text)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  parts text[];
  first text;
  second text;
  third text;
  as_uuid uuid;
  hasta_klinik uuid;
begin
  if auth.uid() is null then
    return false;
  end if;
  if object_name is null or length(trim(object_name)) = 0 then
    return false;
  end if;

  parts := string_to_array(object_name, '/');
  if coalesce(array_length(parts, 1), 0) < 1 then
    return false;
  end if;

  first := parts[1];
  second := case when array_length(parts, 1) >= 2 then parts[2] else null end;
  third := case when array_length(parts, 1) >= 3 then parts[3] else null end;

  -- Eski todo: ses/todolar/{klinik_id}/...
  if first = 'ses' and second = 'todolar' and third is not null then
    begin
      as_uuid := third::uuid;
    exception when invalid_text_representation then
      return false;
    end;
    return as_uuid in (select public.kullanici_klinik_ids());
  end if;

  -- Eski ses: ses/{hasta_id}/...
  if first = 'ses' and second is not null then
    begin
      as_uuid := second::uuid;
    exception when invalid_text_representation then
      return false;
    end;
    select h.klinik_id into hasta_klinik from hastalar h where h.id = as_uuid;
    if hasta_klinik is null then
      return false;
    end if;
    return hasta_klinik in (select public.kullanici_klinik_ids());
  end if;

  -- UUID segment: klinik_id (yeni) veya hasta_id (eski foto)
  begin
    as_uuid := first::uuid;
  exception when invalid_text_representation then
    return false;
  end;

  if exists (select 1 from klinikler k where k.id = as_uuid) then
    return as_uuid in (select public.kullanici_klinik_ids());
  end if;

  select h.klinik_id into hasta_klinik from hastalar h where h.id = as_uuid;
  if hasta_klinik is null then
    return false;
  end if;
  return hasta_klinik in (select public.kullanici_klinik_ids());
end;
$$;

revoke all on function public.storage_object_allowed(text) from public;
grant execute on function public.storage_object_allowed(text) to authenticated;

-- ── Storage politikaları ─────────────────────────────────
drop policy if exists "seans_foto_public_read" on storage.objects;
drop policy if exists "seans_foto_anon_upload" on storage.objects;
drop policy if exists "seans_foto_anon_update" on storage.objects;
drop policy if exists "seans_foto_anon_delete" on storage.objects;
drop policy if exists "seans_foto_auth_read" on storage.objects;
drop policy if exists "seans_foto_auth_insert" on storage.objects;
drop policy if exists "seans_foto_auth_update" on storage.objects;
drop policy if exists "seans_foto_auth_delete" on storage.objects;

update storage.buckets
set public = false
where id = 'seans-fotograflari';

create policy "seans_foto_auth_read"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  );

create policy "seans_foto_auth_insert"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  );

create policy "seans_foto_auth_update"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  )
  with check (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  );

create policy "seans_foto_auth_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'seans-fotograflari'
    and public.storage_object_allowed(name)
  );

-- ── Hasta / seans silme: admin + doktor ───────────────────
drop policy if exists "hastalar_delete" on hastalar;
create policy "hastalar_delete" on hastalar for delete
  using (public.is_klinik_editor(klinik_id));

drop policy if exists "seans_delete" on seans_notlari;
create policy "seans_delete" on seans_notlari for delete
  using (public.is_klinik_editor(klinik_id));
