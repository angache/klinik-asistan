-- Klinik raporları (özet, en çok yapılan işlemler, günlük yoğunluk, takip
-- durumu, yarım kalan tedaviler). 025_denetim_duzeltmeleri.sql'den sonra
-- SQL Editor'de çalıştırın.
--
-- security invoker: RLS geçerli; kullanıcı yalnızca üyesi olduğu kliniği görür.

create index if not exists seans_notlari_klinik_yapilan_tarih_idx
  on seans_notlari (klinik_id, tarih)
  where guncel = true and planlandi = false;

create index if not exists hastalar_klinik_olusturma_idx
  on hastalar (klinik_id, olusturma_tarihi);

create or replace function public.klinik_rapor(
  p_klinik_id uuid,
  p_baslangic timestamptz,
  p_bitis timestamptz,
  p_onceki_baslangic timestamptz,
  p_onceki_bitis timestamptz,
  p_yarim_gun integer default 30
)
returns jsonb
language plpgsql
stable
security invoker
set search_path = public
as $$
declare
  v_tz constant text := 'Europe/Istanbul';
  v_bugun date := (now() at time zone v_tz)::date;
  v_sonuc jsonb;
begin
  if p_klinik_id not in (select public.kullanici_klinik_ids()) then
    raise exception 'Bu kliniğin raporlarını görme yetkiniz yok';
  end if;
  if p_bitis <= p_baslangic
     or p_onceki_bitis <= p_onceki_baslangic
     or p_onceki_bitis > p_baslangic then
    raise exception 'Geçersiz tarih aralığı';
  end if;

  with yapilan as (
    select s.hasta_id, s.islem_baslik, s.tarih,
           (s.tarih at time zone v_tz)::date as gun
    from seans_notlari s
    where s.klinik_id = p_klinik_id
      and s.guncel = true
      and s.planlandi = false
      and s.tarih >= p_onceki_baslangic
      and s.tarih < p_bitis
  ),
  donem as (
    select * from yapilan where tarih >= p_baslangic
  ),
  onceki as (
    select * from yapilan where tarih < p_onceki_bitis
  )
  select jsonb_build_object(
    'ozet', jsonb_build_object(
      'toplam_hasta',
        (select count(*) from hastalar where klinik_id = p_klinik_id),
      'yeni_hasta',
        (select count(*) from hastalar
         where klinik_id = p_klinik_id
           and olusturma_tarihi >= p_baslangic
           and olusturma_tarihi < p_bitis),
      'yeni_hasta_onceki',
        (select count(*) from hastalar
         where klinik_id = p_klinik_id
           and olusturma_tarihi >= p_onceki_baslangic
           and olusturma_tarihi < p_onceki_bitis),
      'tedavi_goren_hasta', (select count(distinct hasta_id) from donem),
      'tedavi_goren_hasta_onceki', (select count(distinct hasta_id) from onceki),
      'hasta_ziyareti',
        (select count(*) from (select distinct hasta_id, gun from donem) z),
      'hasta_ziyareti_onceki',
        (select count(*) from (select distinct hasta_id, gun from onceki) z),
      'yapilan_islem', (select count(*) from donem),
      'yapilan_islem_onceki', (select count(*) from onceki),
      'planlanan_bekleyen',
        (select count(*) from seans_notlari
         where klinik_id = p_klinik_id and guncel = true and planlandi = true)
    ),
    'islemler', coalesce((
      select jsonb_agg(jsonb_build_object('baslik', baslik, 'adet', adet)
                       order by adet desc, baslik)
      from (
        select islem_baslik as baslik, count(*) as adet
        from donem
        group by islem_baslik
        order by count(*) desc, islem_baslik
        limit 10
      ) t
    ), '[]'::jsonb),
    'kategoriler', coalesce((
      select jsonb_agg(jsonb_build_object('kategori', kategori, 'adet', adet)
                       order by adet desc, kategori)
      from (
        select coalesce(k.kategori, 'Diğer') as kategori, count(*) as adet
        from donem d
        left join klinik_islemleri k
          on k.klinik_id = p_klinik_id and k.baslik = d.islem_baslik
        group by 1
      ) t
    ), '[]'::jsonb),
    'gunler', coalesce((
      select jsonb_agg(jsonb_build_object('gun', gun, 'adet', adet) order by gun)
      from (select gun, count(*) as adet from donem group by gun) t
    ), '[]'::jsonb),
    'takip', jsonb_build_object(
      'lab_bekleyen',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur = 'lab' and not tamamlandi),
      'lab_geciken',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur = 'lab' and not tamamlandi
           and planlanan_tarih < v_bugun),
      'kontrol_bekleyen',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur <> 'lab' and not tamamlandi),
      'kontrol_geciken',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur <> 'lab' and not tamamlandi
           and planlanan_tarih < v_bugun),
      'lab_tamamlanan',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur = 'lab' and tamamlandi
           and tamamlanma_tarihi >= p_baslangic
           and tamamlanma_tarihi < p_bitis),
      'kontrol_tamamlanan',
        (select count(*) from takipler
         where klinik_id = p_klinik_id and tur <> 'lab' and tamamlandi
           and tamamlanma_tarihi >= p_baslangic
           and tamamlanma_tarihi < p_bitis),
      'gorev_acik',
        (select count(*) from klinik_todolar
         where klinik_id = p_klinik_id and not tamamlandi),
      'gorev_geciken',
        (select count(*) from klinik_todolar
         where klinik_id = p_klinik_id and not tamamlandi
           and (planlanan_zaman < now()
                or (planlanan_zaman is null and planlanan_tarih < v_bugun))),
      'gorev_tamamlanan',
        (select count(*) from klinik_todolar
         where klinik_id = p_klinik_id and tamamlandi
           and tamamlanma_tarihi >= p_baslangic
           and tamamlanma_tarihi < p_bitis)
    ),
    -- Planlanmış işlemi olup p_yarim_gun gündür işlem yapılmamış (hiç işlemi
    -- yoksa o kadar gün önce kaydedilmiş) ve ileri tarihli açık kontrolü
    -- olmayan hastalar (geri çağırma listesi).
    'yarim_kalan', coalesce((
      select jsonb_agg(to_jsonb(t) order by t.son_islem_tarihi nulls first)
      from (
        select h.id, h.ad_soyad, h.telefon, h.son_islem_tarihi,
               array_agg(distinct p.islem_baslik order by p.islem_baslik)
                 as planlanan
        from hastalar h
        join seans_notlari p
          on p.hasta_id = h.id and p.guncel = true and p.planlandi = true
        where h.klinik_id = p_klinik_id
          and coalesce(h.son_islem_tarihi, h.olusturma_tarihi)
                < now() - make_interval(days => p_yarim_gun)
          and not exists (
            select 1 from takipler tk
            where tk.hasta_id = h.id and not tk.tamamlandi
              and tk.planlanan_tarih >= v_bugun
          )
        group by h.id
        order by h.son_islem_tarihi nulls first
        limit 100
      ) t
    ), '[]'::jsonb)
  )
  into v_sonuc;

  return v_sonuc;
end;
$$;

revoke all on function public.klinik_rapor(
  uuid, timestamptz, timestamptz, timestamptz, timestamptz, integer
) from public, anon;
grant execute on function public.klinik_rapor(
  uuid, timestamptz, timestamptz, timestamptz, timestamptz, integer
) to authenticated;
