-- Tamamlanan sonraki seans notları (silinmez, arşivlenir)

create table if not exists hasta_plan_gecmisi (
  id uuid primary key default gen_random_uuid(),
  hasta_id uuid not null references hastalar(id) on delete cascade,
  klinik_id uuid not null references klinikler(id) on delete cascade,
  icerik text not null,
  tamamlanma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null,
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null
);

create index if not exists hasta_plan_gecmisi_hasta_idx
  on hasta_plan_gecmisi (hasta_id, tamamlanma_tarihi desc);

alter table hasta_plan_gecmisi enable row level security;

drop policy if exists "plan_gecmisi_select" on hasta_plan_gecmisi;
drop policy if exists "plan_gecmisi_insert" on hasta_plan_gecmisi;
drop policy if exists "plan_gecmisi_delete" on hasta_plan_gecmisi;

create policy "plan_gecmisi_select" on hasta_plan_gecmisi for select
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "plan_gecmisi_insert" on hasta_plan_gecmisi for insert
  with check (klinik_id in (select public.kullanici_klinik_ids()));

create policy "plan_gecmisi_delete" on hasta_plan_gecmisi for delete
  using (
    exists (
      select 1 from klinik_uyeleri u
      where u.klinik_id = hasta_plan_gecmisi.klinik_id
        and u.user_id = auth.uid()
        and u.rol in ('admin', 'doktor')
    )
  );
