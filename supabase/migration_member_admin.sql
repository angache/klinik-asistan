-- Üye yönetimini admin ile sınırla
-- Supabase SQL Editor'de çalıştırın.

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

drop policy if exists "uyeler_update" on klinik_uyeleri;
drop policy if exists "uyeler_delete" on klinik_uyeleri;

create policy "uyeler_update" on klinik_uyeleri for update
  using (public.is_klinik_admin(klinik_id));

create policy "uyeler_delete" on klinik_uyeleri for delete
  using (
    public.is_klinik_admin(klinik_id)
    or user_id = auth.uid()
  );
