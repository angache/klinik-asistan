-- Periyodik kontrol çağrıları
--   1. İşlem şablonlarına kontrol süresi (ay)
--   2. Varsayılan şablon yüklemesine kontrol süreleri
--   3. Arama sonucu kayıtları (randevu verildi / ulaşılamadı / istemiyor)
--   4. Kontrol çağrısı listesi fonksiyonu
-- 026_raporlar.sql'den sonra SQL Editor'de çalıştırın. Tekrar çalıştırılabilir.

drop function if exists public.kontrol_zamani_gelenler(uuid, integer);

-- ── 1. Kontrol süresi ────────────────────────────────────────────────
-- Varsayılanlar yalnızca kolon ilk eklendiğinde yazılır; sonradan kliniğin
-- "yok" olarak değiştirdiği değerler tekrar çalıştırmada ezilmez.
do $$
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'klinik_islemleri'
      and column_name = 'kontrol_ay'
  ) then
    alter table public.klinik_islemleri
      add column kontrol_ay integer
      check (kontrol_ay is null or kontrol_ay between 1 and 36);

    update public.klinik_islemleri
    set kontrol_ay = case lower(baslik)
      when lower('Küretaj') then 3
      else 6
    end
    where lower(baslik) in (
      lower('Detertraj (Temizlik)'),
      lower('Kontrol'),
      lower('Kanal Bitim'),
      lower('Kanal Yenileme'),
      lower('Daimi Simantasyon'),
      lower('Küretaj')
    );
  end if;
end $$;

-- ── 2. Varsayılan şablonlar (025 sürümü + kontrol_ay) ───────────────────
create or replace function public.seed_klinik_islemleri(p_klinik_id uuid)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count int := 0;
  v_sira int;
begin
  if auth.uid() is not null
     and p_klinik_id not in (select public.kullanici_klinik_ids()) then
    raise exception 'Bu kliniğe üye değilsiniz';
  end if;

  select coalesce(max(sira), 0) into v_sira
  from klinik_islemleri where klinik_id = p_klinik_id;

  insert into klinik_islemleri
    (klinik_id, kategori, baslik, is_kanal, dis_zorunlu, lab_takip,
     kontrol_ay, sira)
  select
    p_klinik_id, d.kategori, d.baslik, d.is_kanal, d.dis_zorunlu, d.lab_takip,
    d.kontrol_ay, v_sira + d.ord
  from (values
    (1,  'Teşhis ve Planlama', 'Tedavi Planlaması', false, false, false, null::int),
    (2,  'Teşhis ve Planlama', 'İlk Muayene / Teşhis', false, false, false, null),
    (10, 'Tedavi', 'Kanal Başlangıç', true,  true,  false, null),
    (11, 'Tedavi', 'Kanal Bitim', true,  true,  false, 6),
    (12, 'Tedavi', 'Kanal Yenileme', true,  true,  false, 6),
    (13, 'Tedavi', 'Kompozit Dolgu', false, true,  false, null),
    (14, 'Tedavi', 'Kuafaj', false, true,  false, null),
    (15, 'Tedavi', 'Diş Çekimi', false, true,  false, null),
    (16, 'Tedavi', 'Komplikasyonlu Çekim', false, true,  false, null),
    (17, 'Tedavi', 'Cerrahi Çekim', false, true,  false, null),
    (18, 'Tedavi', 'Alveolit Tedavisi (Pansuman)', false, true,  false, null),
    (19, 'Tedavi', 'Küretaj', false, true,  false, 3),
    (20, 'Tedavi', 'Beyazlatma', false, false, false, null),
    (30, 'Protez', 'Diş Kesimi', false, true,  false, null),
    (31, 'Protez', 'Ölçü', false, false, true, null),
    (32, 'Protez', 'Altyapı Prova', false, true,  true, null),
    (33, 'Protez', 'Dentin Prova', false, true,  true, null),
    (34, 'Protez', 'Geçici Simantasyon', false, true,  false, null),
    (35, 'Protez', 'Daimi Simantasyon', false, true,  false, 6),
    (36, 'Protez', 'Gece Plağı Ölçüsü', false, false, true, null),
    (40, 'Genel',  'Detertraj (Temizlik)', false, false, false, 6),
    (41, 'Genel',  'Kontrol', false, false, false, 6)
  ) as d(ord, kategori, baslik, is_kanal, dis_zorunlu, lab_takip, kontrol_ay)
  where not exists (
    select 1 from klinik_islemleri k
    where k.klinik_id = p_klinik_id and lower(k.baslik) = lower(d.baslik)
  );

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

revoke execute on function public.seed_klinik_islemleri(uuid) from public, anon;
grant execute on function public.seed_klinik_islemleri(uuid) to authenticated;

-- ── 3. Arama kayıtları ───────────────────────────────────────────────
create table if not exists public.kontrol_cagrilari (
  id uuid primary key default gen_random_uuid(),
  klinik_id uuid not null references public.klinikler(id) on delete cascade,
  hasta_id uuid not null references public.hastalar(id) on delete cascade,
  sonuc text not null
    check (sonuc in ('randevu', 'ulasilamadi', 'istemiyor')),
  aciklama text,
  arayan_user_id uuid default auth.uid()
    references auth.users(id) on delete set null,
  arayan_ad_soyad text,
  olusturma_tarihi timestamptz not null default now()
);

create index if not exists kontrol_cagrilari_hasta_idx
  on public.kontrol_cagrilari (klinik_id, hasta_id, olusturma_tarihi desc);

alter table public.kontrol_cagrilari enable row level security;

drop policy if exists "kontrol_cagrilari_select" on public.kontrol_cagrilari;
drop policy if exists "kontrol_cagrilari_insert" on public.kontrol_cagrilari;
drop policy if exists "kontrol_cagrilari_delete" on public.kontrol_cagrilari;

create policy "kontrol_cagrilari_select" on public.kontrol_cagrilari
  for select to authenticated
  using (klinik_id in (select public.kullanici_klinik_ids()));

create policy "kontrol_cagrilari_insert" on public.kontrol_cagrilari
  for insert to authenticated
  with check (
    klinik_id in (select public.kullanici_klinik_ids())
    and arayan_user_id = auth.uid()
    and exists (
      select 1 from public.hastalar h
      where h.id = kontrol_cagrilari.hasta_id
        and h.klinik_id = kontrol_cagrilari.klinik_id
    )
  );

create policy "kontrol_cagrilari_delete" on public.kontrol_cagrilari
  for delete to authenticated
  using (arayan_user_id = auth.uid() or public.is_klinik_admin(klinik_id));

-- ── 4. Kontrol çağrısı listesi ──────────────────────────────────────
-- Hasta listeye girer: kontrol süresi olan son işlemin tarihi + süre geçmiş,
-- o tarihten beri hiç işlem yapılmamış, bekleyen planlı işlemi ve ileri
-- tarihli açık takibi yok. Son arama "ulaşılamadı" ise 7 gün, "istemiyor"
-- ise yeni bir işlem yapılana kadar gizlenir. Kontrol tarihi 12 aydan eski
-- olanlar "eski hastalar" olarak ayrı döner. p_limit = 0 yalnızca sayılar.
create or replace function public.kontrol_cagrilari_listesi(
  p_klinik_id uuid,
  p_eski boolean default false,
  p_limit integer default 200
)
returns jsonb
language plpgsql
stable
security invoker
set search_path = public
as $$
declare
  v_bugun date := (now() at time zone 'Europe/Istanbul')::date;
  v_esik timestamptz := now() - interval '12 months';
  v_sonuc jsonb;
begin
  if p_klinik_id not in (select public.kullanici_klinik_ids()) then
    raise exception 'Bu kliniğin listesini görme yetkiniz yok';
  end if;

  with kontrol as (
    select distinct on (s.hasta_id)
           s.hasta_id,
           s.tarih + make_interval(months => k.kontrol_ay) as kontrol_tarihi,
           s.islem_baslik as kontrol_islem,
           s.tarih as kontrol_islem_tarihi
    from seans_notlari s
    join klinik_islemleri k
      on k.klinik_id = s.klinik_id and lower(k.baslik) = lower(s.islem_baslik)
    where s.klinik_id = p_klinik_id
      and s.guncel = true
      and s.planlandi = false
      and k.kontrol_ay is not null
    order by s.hasta_id,
             s.tarih + make_interval(months => k.kontrol_ay) desc
  ),
  son_arama as (
    select distinct on (c.hasta_id)
           c.hasta_id, c.sonuc, c.olusturma_tarihi, c.arayan_ad_soyad
    from kontrol_cagrilari c
    where c.klinik_id = p_klinik_id
    order by c.hasta_id, c.olusturma_tarihi desc
  ),
  aday as (
    select h.id, h.ad_soyad, h.telefon, h.son_islem_tarihi,
           k.kontrol_tarihi, k.kontrol_islem, k.kontrol_islem_tarihi,
           sa.sonuc as son_arama_sonuc,
           sa.olusturma_tarihi as son_arama_tarihi,
           sa.arayan_ad_soyad as son_arama_kisi
    from kontrol k
    join hastalar h on h.id = k.hasta_id
    left join son_arama sa on sa.hasta_id = h.id
    where h.klinik_id = p_klinik_id
      and k.kontrol_tarihi <= now()
      and coalesce(h.son_islem_tarihi, k.kontrol_islem_tarihi) < k.kontrol_tarihi
      and not exists (
        select 1 from seans_notlari p
        where p.hasta_id = h.id and p.guncel = true and p.planlandi = true
      )
      and not exists (
        select 1 from takipler tk
        where tk.hasta_id = h.id and not tk.tamamlandi
          and tk.planlanan_tarih >= v_bugun
      )
      and not coalesce(
        sa.sonuc = 'ulasilamadi'
          and sa.olusturma_tarihi > now() - interval '7 days',
        false
      )
      and not coalesce(
        sa.sonuc = 'istemiyor'
          and sa.olusturma_tarihi
            > coalesce(h.son_islem_tarihi, '-infinity'::timestamptz),
        false
      )
  )
  select jsonb_build_object(
    'toplam', (select count(*) from aday where kontrol_tarihi >= v_esik),
    'eski_toplam', (select count(*) from aday where kontrol_tarihi < v_esik),
    'hastalar', coalesce((
      select jsonb_agg(to_jsonb(a) - 'sira' order by a.sira)
      from (
        -- Güncel: en çok geciken önce. Eski: en yakın tarihli önce.
        select aday.*,
               row_number() over (
                 order by case when p_eski then null else kontrol_tarihi end asc,
                          case when p_eski then kontrol_tarihi end desc
               ) as sira
        from aday
        where case when p_eski then kontrol_tarihi < v_esik
                   else kontrol_tarihi >= v_esik end
        order by sira
        limit greatest(coalesce(p_limit, 0), 0)
      ) a
    ), '[]'::jsonb)
  )
  into v_sonuc;

  return v_sonuc;
end;
$$;

revoke all on function public.kontrol_cagrilari_listesi(uuid, boolean, integer)
  from public, anon;
grant execute on function public.kontrol_cagrilari_listesi(uuid, boolean, integer)
  to authenticated;
