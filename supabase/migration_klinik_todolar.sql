-- Klinik genel yapılacaklar (hastaya bağlı değil; yazı veya ses)

create table if not exists klinik_todolar (
  id uuid default gen_random_uuid() primary key,
  klinik_id uuid not null references klinikler(id) on delete cascade,
  icerik text,
  ses_url text,
  sure_saniye int,
  planlanan_tarih date,
  tamamlandi boolean not null default false,
  tamamlanma_tarihi timestamp with time zone,
  olusturan_user_id uuid references auth.users(id),
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null,
  constraint klinik_todolar_icerik_or_ses check (
    (icerik is not null and trim(icerik) <> '')
    or (ses_url is not null and trim(ses_url) <> '')
  )
);

create index if not exists klinik_todolar_klinik_acik_idx
  on klinik_todolar (klinik_id, planlanan_tarih)
  where tamamlandi = false;

alter table klinik_todolar enable row level security;

drop policy if exists "klinik_todo_select" on klinik_todolar;
drop policy if exists "klinik_todo_insert" on klinik_todolar;
drop policy if exists "klinik_todo_update" on klinik_todolar;
drop policy if exists "klinik_todo_delete" on klinik_todolar;

create policy "klinik_todo_select" on klinik_todolar for select
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "klinik_todo_insert" on klinik_todolar for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));

create policy "klinik_todo_update" on klinik_todolar for update
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "klinik_todo_delete" on klinik_todolar for delete
  using (klinik_id in (select public.kullanici_klinik_ids()));
