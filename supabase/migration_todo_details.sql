-- Klinik todo geliştirmeleri:
-- görseller, sorumlu, öncelik, saat, hasta bağlantısı, tekrar, yorum ve geçmiş.
-- Supabase SQL Editor'de bir kez çalıştırın.

alter table public.klinik_todolar
  add column if not exists planlanan_zaman timestamptz,
  add column if not exists oncelik text not null default 'normal',
  add column if not exists tekrar text not null default 'yok',
  add column if not exists hatirlatma_dakika_once integer not null default 0,
  add column if not exists son_hatirlatma_tarihi timestamptz,
  add column if not exists sorumlu_uye_id uuid
    references public.klinik_uyeleri(id) on delete set null,
  add column if not exists hasta_id uuid
    references public.hastalar(id) on delete set null,
  add column if not exists olusturan_ad_soyad text;

alter table public.klinik_todolar
  drop constraint if exists klinik_todolar_oncelik_check;
alter table public.klinik_todolar
  add constraint klinik_todolar_oncelik_check
  check (oncelik in ('normal', 'onemli', 'acil'));

alter table public.klinik_todolar
  drop constraint if exists klinik_todolar_tekrar_check;
alter table public.klinik_todolar
  add constraint klinik_todolar_tekrar_check
  check (tekrar in ('yok', 'gunluk', 'haftalik', 'aylik'));

alter table public.klinik_todolar
  drop constraint if exists klinik_todolar_hatirlatma_check;
alter table public.klinik_todolar
  add constraint klinik_todolar_hatirlatma_check
  check (hatirlatma_dakika_once between 0 and 43200);

create index if not exists klinik_todolar_sorumlu_idx
  on public.klinik_todolar (sorumlu_uye_id)
  where tamamlandi = false;
create index if not exists klinik_todolar_hasta_idx
  on public.klinik_todolar (hasta_id);

alter table public.takipler
  add column if not exists son_push_tarihi date;

create or replace function public.validate_klinik_todo_links()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.sorumlu_uye_id is not null and not exists (
    select 1 from public.klinik_uyeleri u
    where u.id = new.sorumlu_uye_id and u.klinik_id = new.klinik_id
  ) then
    raise exception 'Sorumlu üye görevle aynı klinikte olmalı';
  end if;
  if new.hasta_id is not null and not exists (
    select 1 from public.hastalar h
    where h.id = new.hasta_id and h.klinik_id = new.klinik_id
  ) then
    raise exception 'Hasta görevle aynı klinikte olmalı';
  end if;
  return new;
end;
$$;

drop trigger if exists validate_klinik_todo_links_trigger
  on public.klinik_todolar;
create trigger validate_klinik_todo_links_trigger
before insert or update of klinik_id, sorumlu_uye_id, hasta_id
on public.klinik_todolar
for each row execute function public.validate_klinik_todo_links();

create table if not exists public.klinik_todo_gorselleri (
  id uuid default gen_random_uuid() primary key,
  todo_id uuid not null references public.klinik_todolar(id) on delete cascade,
  klinik_id uuid not null references public.klinikler(id) on delete cascade,
  storage_path text not null,
  olusturan_user_id uuid references auth.users(id),
  olusturma_tarihi timestamptz not null default timezone('utc', now())
);

create index if not exists klinik_todo_gorselleri_todo_idx
  on public.klinik_todo_gorselleri(todo_id, olusturma_tarihi);
alter table public.klinik_todo_gorselleri enable row level security;

drop policy if exists "todo_gorsel_select" on public.klinik_todo_gorselleri;
drop policy if exists "todo_gorsel_insert" on public.klinik_todo_gorselleri;
drop policy if exists "todo_gorsel_delete" on public.klinik_todo_gorselleri;
create policy "todo_gorsel_select" on public.klinik_todo_gorselleri for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "todo_gorsel_insert" on public.klinik_todo_gorselleri for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));
create policy "todo_gorsel_delete" on public.klinik_todo_gorselleri for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));

create table if not exists public.klinik_todo_yorumlari (
  id uuid default gen_random_uuid() primary key,
  todo_id uuid not null references public.klinik_todolar(id) on delete cascade,
  klinik_id uuid not null references public.klinikler(id) on delete cascade,
  icerik text not null check (length(trim(icerik)) between 1 and 2000),
  yazan_user_id uuid references auth.users(id),
  yazan_ad_soyad text,
  olusturma_tarihi timestamptz not null default timezone('utc', now())
);

create index if not exists klinik_todo_yorumlari_todo_idx
  on public.klinik_todo_yorumlari(todo_id, olusturma_tarihi);
alter table public.klinik_todo_yorumlari enable row level security;

drop policy if exists "todo_yorum_select" on public.klinik_todo_yorumlari;
drop policy if exists "todo_yorum_insert" on public.klinik_todo_yorumlari;
drop policy if exists "todo_yorum_delete" on public.klinik_todo_yorumlari;
create policy "todo_yorum_select" on public.klinik_todo_yorumlari for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "todo_yorum_insert" on public.klinik_todo_yorumlari for insert
  with check (
    klinik_id in (select public.kullanici_klinik_ids())
    and yazan_user_id = auth.uid()
  );
create policy "todo_yorum_delete" on public.klinik_todo_yorumlari for delete
  using (
    klinik_id in (select public.kullanici_klinik_ids())
    and (
      yazan_user_id = auth.uid()
      or public.is_klinik_editor(klinik_id)
    )
  );

create table if not exists public.klinik_todo_gecmisi (
  id uuid default gen_random_uuid() primary key,
  todo_id uuid not null references public.klinik_todolar(id) on delete cascade,
  klinik_id uuid not null references public.klinikler(id) on delete cascade,
  olay_turu text not null,
  aciklama text,
  yapan_user_id uuid references auth.users(id),
  yapan_ad_soyad text,
  olusturma_tarihi timestamptz not null default timezone('utc', now())
);

create index if not exists klinik_todo_gecmisi_todo_idx
  on public.klinik_todo_gecmisi(todo_id, olusturma_tarihi);
alter table public.klinik_todo_gecmisi enable row level security;

drop policy if exists "todo_gecmis_select" on public.klinik_todo_gecmisi;
drop policy if exists "todo_gecmis_insert" on public.klinik_todo_gecmisi;
create policy "todo_gecmis_select" on public.klinik_todo_gecmisi for select
  using (klinik_id in (select public.kullanici_klinik_ids()));
create policy "todo_gecmis_insert" on public.klinik_todo_gecmisi for insert
  with check (
    klinik_id in (select public.kullanici_klinik_ids())
    and yapan_user_id = auth.uid()
  );

-- Alt kayıtların todo ile aynı klinikte olmasını veritabanında garanti et.
create unique index if not exists klinik_todolar_id_klinik_key
  on public.klinik_todolar(id, klinik_id);

alter table public.klinik_todo_gorselleri
  drop constraint if exists klinik_todo_gorselleri_todo_id_fkey;
alter table public.klinik_todo_gorselleri
  drop constraint if exists todo_gorsel_same_clinic_fk;
alter table public.klinik_todo_gorselleri
  add constraint todo_gorsel_same_clinic_fk
  foreign key (todo_id, klinik_id)
  references public.klinik_todolar(id, klinik_id) on delete cascade;

alter table public.klinik_todo_yorumlari
  drop constraint if exists klinik_todo_yorumlari_todo_id_fkey;
alter table public.klinik_todo_yorumlari
  drop constraint if exists todo_yorum_same_clinic_fk;
alter table public.klinik_todo_yorumlari
  add constraint todo_yorum_same_clinic_fk
  foreign key (todo_id, klinik_id)
  references public.klinik_todolar(id, klinik_id) on delete cascade;

alter table public.klinik_todo_gecmisi
  drop constraint if exists klinik_todo_gecmisi_todo_id_fkey;
alter table public.klinik_todo_gecmisi
  drop constraint if exists todo_gecmis_same_clinic_fk;
alter table public.klinik_todo_gecmisi
  add constraint todo_gecmis_same_clinic_fk
  foreign key (todo_id, klinik_id)
  references public.klinik_todolar(id, klinik_id) on delete cascade;
