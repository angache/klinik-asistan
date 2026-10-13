-- Push bildirimleri için cihaz token'ları (FCM).
-- Supabase SQL Editor'de çalıştırın.

create table if not exists device_tokens (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  token text not null,
  platform text not null default 'android'
    check (platform in ('android', 'ios', 'web', 'windows', 'macos', 'linux')),
  olusturma_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null,
  guncelleme_tarihi timestamp with time zone
    default timezone('utc'::text, now()) not null
);

create unique index if not exists device_tokens_token_key on device_tokens(token);
create index if not exists device_tokens_user_idx on device_tokens(user_id);

alter table device_tokens enable row level security;

drop policy if exists "device_tokens_select" on device_tokens;
drop policy if exists "device_tokens_insert" on device_tokens;
drop policy if exists "device_tokens_update" on device_tokens;
drop policy if exists "device_tokens_delete" on device_tokens;

-- Kullanıcı yalnızca kendi token'larını yönetir.
create policy "device_tokens_select" on device_tokens for select
  using (user_id = auth.uid());
create policy "device_tokens_insert" on device_tokens for insert
  with check (user_id = auth.uid());
create policy "device_tokens_update" on device_tokens for update
  using (user_id = auth.uid());
create policy "device_tokens_delete" on device_tokens for delete
  using (user_id = auth.uid());

-- Aynı kullanıcının bir klinikteki diğer üyelerinin token'larına
-- push göndermek Edge Function (service role) ile yapılır; RLS'i baypas eder.
