-- Onaylı klinik katılım istekleri
-- Supabase SQL Editor'de çalıştırın (migration_auth_klinik.sql'den SONRA).

-- ── Tablo ────────────────────────────────────────────────
create table if not exists klinik_katilim_istekleri (
  id uuid default gen_random_uuid() primary key,
  klinik_id uuid not null references klinikler(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  ad_soyad text not null,
  rol text not null check (rol in ('doktor', 'asistan')),
  durum text not null default 'beklemede'
    check (durum in ('beklemede', 'onaylandi', 'reddedildi')),
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null,
  yanit_tarihi timestamp with time zone,
  unique (klinik_id, user_id)
);

create index if not exists katilim_istek_klinik_durum_idx
  on klinik_katilim_istekleri(klinik_id, durum);
create index if not exists katilim_istek_user_idx
  on klinik_katilim_istekleri(user_id);

-- ── Admin kontrolü ───────────────────────────────────────
create or replace function public.is_klinik_admin(p_klinik_id uuid)
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
      and rol = 'admin'
  );
$$;

grant execute on function public.is_klinik_admin(uuid) to authenticated;

-- ── Katılım isteği oluştur ───────────────────────────────
create or replace function public.request_clinic_join(
  p_kod text,
  p_ad_soyad text,
  p_rol text
)
returns klinik_katilim_istekleri
language plpgsql
security definer
set search_path = public
as $$
declare
  v_klinik_id uuid;
  v_rol text;
  v_row klinik_katilim_istekleri;
begin
  if auth.uid() is null then
    raise exception 'Oturum gerekli';
  end if;

  v_rol := lower(trim(p_rol));
  if v_rol not in ('doktor', 'asistan') then
    raise exception 'Rol doktor veya asistan olmalı';
  end if;

  select id into v_klinik_id
  from klinikler
  where upper(kod) = upper(trim(p_kod))
  limit 1;

  if v_klinik_id is null then
    raise exception 'Klinik kodu bulunamadı';
  end if;

  if exists (
    select 1 from klinik_uyeleri
    where klinik_id = v_klinik_id and user_id = auth.uid()
  ) then
    raise exception 'Bu kliniğe zaten üyesiniz';
  end if;

  insert into klinik_katilim_istekleri (
    klinik_id, user_id, ad_soyad, rol, durum
  ) values (
    v_klinik_id, auth.uid(), trim(p_ad_soyad), v_rol, 'beklemede'
  )
  on conflict (klinik_id, user_id) do update
    set ad_soyad = excluded.ad_soyad,
        rol = excluded.rol,
        durum = case
          when klinik_katilim_istekleri.durum = 'onaylandi' then 'onaylandi'
          else 'beklemede'
        end,
        yanit_tarihi = case
          when klinik_katilim_istekleri.durum = 'onaylandi'
            then klinik_katilim_istekleri.yanit_tarihi
          else null
        end,
        olusturma_tarihi = case
          when klinik_katilim_istekleri.durum = 'beklemede'
            then klinik_katilim_istekleri.olusturma_tarihi
          when klinik_katilim_istekleri.durum = 'onaylandi'
            then klinik_katilim_istekleri.olusturma_tarihi
          else timezone('utc'::text, now())
        end
  returning * into v_row;

  if v_row.durum = 'onaylandi' then
    raise exception 'Bu kliniğe zaten üyesiniz';
  end if;

  return v_row;
end;
$$;

grant execute on function public.request_clinic_join(text, text, text) to authenticated;

-- ── Onay / red ───────────────────────────────────────────
create or replace function public.respond_clinic_join(
  p_istek_id uuid,
  p_onay boolean
)
returns klinik_katilim_istekleri
language plpgsql
security definer
set search_path = public
as $$
declare
  v_row klinik_katilim_istekleri;
begin
  if auth.uid() is null then
    raise exception 'Oturum gerekli';
  end if;

  select * into v_row
  from klinik_katilim_istekleri
  where id = p_istek_id
  for update;

  if v_row.id is null then
    raise exception 'İstek bulunamadı';
  end if;

  if not public.is_klinik_admin(v_row.klinik_id) then
    raise exception 'Sadece klinik yöneticisi onaylayabilir';
  end if;

  if v_row.durum <> 'beklemede' then
    raise exception 'Bu istek zaten yanıtlanmış';
  end if;

  if p_onay then
    insert into klinik_uyeleri (klinik_id, user_id, rol, ad_soyad)
    values (v_row.klinik_id, v_row.user_id, v_row.rol, v_row.ad_soyad)
    on conflict (klinik_id, user_id) do nothing;

    update klinik_katilim_istekleri
    set durum = 'onaylandi',
        yanit_tarihi = timezone('utc'::text, now())
    where id = p_istek_id
    returning * into v_row;
  else
    update klinik_katilim_istekleri
    set durum = 'reddedildi',
        yanit_tarihi = timezone('utc'::text, now())
    where id = p_istek_id
    returning * into v_row;
  end if;

  return v_row;
end;
$$;

grant execute on function public.respond_clinic_join(uuid, boolean) to authenticated;

-- ── RLS ──────────────────────────────────────────────────
alter table klinik_katilim_istekleri enable row level security;

drop policy if exists "istek_select" on klinik_katilim_istekleri;
drop policy if exists "istek_insert" on klinik_katilim_istekleri;
drop policy if exists "istek_update" on klinik_katilim_istekleri;
drop policy if exists "istek_delete" on klinik_katilim_istekleri;

create policy "istek_select" on klinik_katilim_istekleri for select
  using (
    user_id = auth.uid()
    or public.is_klinik_admin(klinik_id)
  );

-- Insert/update RPC üzerinden (security definer); doğrudan insert kapalı
create policy "istek_insert" on klinik_katilim_istekleri for insert
  to authenticated
  with check (false);

create policy "istek_update" on klinik_katilim_istekleri for update
  using (false);

-- Doğrudan üye eklemeyi kapat (sadece create_clinic / onay RPC)
drop policy if exists "uyeler_insert" on klinik_uyeleri;
create policy "uyeler_insert" on klinik_uyeleri for insert
  to authenticated
  with check (false);

-- Bekleyen istek sahibi klinik adını görebilir
drop policy if exists "klinikler_select" on klinikler;
create policy "klinikler_select" on klinikler for select
  using (
    id in (select public.kullanici_klinik_ids())
    or id in (
      select klinik_id from klinik_katilim_istekleri
      where user_id = auth.uid()
    )
  );
