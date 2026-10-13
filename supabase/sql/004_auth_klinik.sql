-- Auth + Klinik çoklu kiracılık
-- Supabase SQL Editor'de çalıştırın.
-- Dashboard → Authentication → Providers → Email açık olmalı.
-- Geliştirme için: Authentication → Providers → "Confirm email" kapalı önerilir.

-- ── Klinikler ──────────────────────────────────────────────
create table if not exists klinikler (
  id uuid default gen_random_uuid() primary key,
  ad text not null,
  kod text not null unique,
  olusturma_tarihi timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists klinikler_kod_idx on klinikler(kod);

-- ── Üyeler ───────────────────────────────────────────────
create table if not exists klinik_uyeleri (
  id uuid default gen_random_uuid() primary key,
  klinik_id uuid not null references klinikler(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  rol text not null check (rol in ('admin', 'doktor', 'asistan')),
  ad_soyad text not null,
  olusturma_tarihi timestamp with time zone default timezone('utc'::text, now()) not null,
  unique (klinik_id, user_id)
);

create index if not exists klinik_uyeleri_user_idx on klinik_uyeleri(user_id);
create index if not exists klinik_uyeleri_klinik_idx on klinik_uyeleri(klinik_id);

-- ── Mevcut tablolara klinik_id ───────────────────────────
alter table hastalar add column if not exists klinik_id uuid references klinikler(id);
alter table seans_notlari add column if not exists klinik_id uuid references klinikler(id);
alter table ses_kayitlari add column if not exists klinik_id uuid references klinikler(id);
alter table seans_notlari add column if not exists olusturan_user_id uuid references auth.users(id);

create index if not exists hastalar_klinik_id_idx on hastalar(klinik_id);
create index if not exists seans_notlari_klinik_id_idx on seans_notlari(klinik_id);
create index if not exists ses_kayitlari_klinik_id_idx on ses_kayitlari(klinik_id);

-- ── Yardımcı: kullanıcının klinik id'leri ────────────────
create or replace function public.kullanici_klinik_ids()
returns setof uuid
language sql
stable
security definer
set search_path = public
as $$
  select klinik_id from klinik_uyeleri where user_id = auth.uid();
$$;

revoke all on function public.kullanici_klinik_ids() from public;
grant execute on function public.kullanici_klinik_ids() to authenticated, anon;

-- Kod ile klinik bulma (katılım için)
create or replace function public.klinik_id_by_kod(p_kod text)
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from klinikler where upper(kod) = upper(trim(p_kod)) limit 1;
$$;

grant execute on function public.klinik_id_by_kod(text) to authenticated, anon;

-- Klinik oluştur + admin üyelik (INSERT RETURNING RLS sorununu önler)
create or replace function public.create_clinic_with_admin(
  p_ad text,
  p_kod text,
  p_ad_soyad text
)
returns klinikler
language plpgsql
security definer
set search_path = public
as $$
declare
  v_klinik klinikler;
begin
  if auth.uid() is null then
    raise exception 'Oturum gerekli';
  end if;

  insert into klinikler (ad, kod)
  values (trim(p_ad), upper(trim(p_kod)))
  returning * into v_klinik;

  insert into klinik_uyeleri (klinik_id, user_id, rol, ad_soyad)
  values (v_klinik.id, auth.uid(), 'admin', trim(p_ad_soyad));

  return v_klinik;
end;
$$;

grant execute on function public.create_clinic_with_admin(text, text, text) to authenticated;

-- ── RLS: klinikler / üyeler ──────────────────────────────
alter table klinikler enable row level security;
alter table klinik_uyeleri enable row level security;

drop policy if exists "klinikler_select" on klinikler;
drop policy if exists "klinikler_insert" on klinikler;
drop policy if exists "klinikler_update" on klinikler;

create policy "klinikler_select" on klinikler for select
  using (id in (select public.kullanici_klinik_ids()));

-- İlk kurulum: authenticated kullanıcı klinik oluşturabilir
create policy "klinikler_insert" on klinikler for insert
  to authenticated
  with check (true);

create policy "klinikler_update" on klinikler for update
  using (id in (select public.kullanici_klinik_ids()));

drop policy if exists "uyeler_select" on klinik_uyeleri;
drop policy if exists "uyeler_insert" on klinik_uyeleri;
drop policy if exists "uyeler_update" on klinik_uyeleri;
drop policy if exists "uyeler_delete" on klinik_uyeleri;

create policy "uyeler_select" on klinik_uyeleri for select
  using (
    user_id = auth.uid()
    or klinik_id in (select public.kullanici_klinik_ids())
  );

-- Kendi kaydını ekleyebilir (kayıt / katılım)
create policy "uyeler_insert" on klinik_uyeleri for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "uyeler_update" on klinik_uyeleri for update
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "uyeler_delete" on klinik_uyeleri for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));

-- ── RLS: hastalar / seans / ses — açık politikaları kaldır ─
drop policy if exists "hastalar_select" on hastalar;
drop policy if exists "hastalar_insert" on hastalar;
drop policy if exists "hastalar_update" on hastalar;
drop policy if exists "hastalar_delete" on hastalar;

create policy "hastalar_select" on hastalar for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "hastalar_insert" on hastalar for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));
create policy "hastalar_update" on hastalar for update
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "hastalar_delete" on hastalar for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));

drop policy if exists "seans_select" on seans_notlari;
drop policy if exists "seans_insert" on seans_notlari;
drop policy if exists "seans_update" on seans_notlari;
drop policy if exists "seans_delete" on seans_notlari;

create policy "seans_select" on seans_notlari for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "seans_insert" on seans_notlari for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));
create policy "seans_update" on seans_notlari for update
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "seans_delete" on seans_notlari for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));

drop policy if exists "ses_select" on ses_kayitlari;
drop policy if exists "ses_insert" on ses_kayitlari;
drop policy if exists "ses_update" on ses_kayitlari;
drop policy if exists "ses_delete" on ses_kayitlari;

create policy "ses_select" on ses_kayitlari for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "ses_insert" on ses_kayitlari for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));
create policy "ses_update" on ses_kayitlari for update
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "ses_delete" on ses_kayitlari for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));
