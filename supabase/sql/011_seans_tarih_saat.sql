-- İşlem tarihi + saati (sıralama için); eski date kayıtları mümkünse olusturma saatiyle birleştirilir
-- Not: tarih kolonunu kullanan trigger önce kaldırılır, sonra yeniden kurulur.

drop trigger if exists seans_notlari_son_islem_tarihi on seans_notlari;

drop index if exists hastalar_klinik_son_islem_idx;

alter table seans_notlari
  alter column tarih drop default;

alter table seans_notlari
  alter column tarih type timestamptz
  using (
    case
      when olusturma_tarihi is not null
        and tarih = (olusturma_tarihi at time zone 'Europe/Istanbul')::date
        then olusturma_tarihi
      else (tarih::timestamp without time zone AT TIME ZONE 'Europe/Istanbul')
    end
  );

alter table seans_notlari
  alter column tarih set default timezone('utc'::text, now());

-- Hasta listesi son işlem sırası da saat hassasiyetinde olsun
alter table hastalar
  alter column son_islem_tarihi type timestamptz
  using (
    case
      when son_islem_tarihi is null then null
      else son_islem_tarihi::timestamp without time zone AT TIME ZONE 'Europe/Istanbul'
    end
  );

update hastalar h
set son_islem_tarihi = sub.son
from (
  select
    s.hasta_id,
    max(s.tarih) as son
  from seans_notlari s
  where coalesce(s.guncel, true) = true
    and coalesce(s.planlandi, false) = false
  group by s.hasta_id
) sub
where h.id = sub.hasta_id;

create or replace function refresh_hasta_son_islem_tarihi()
returns trigger
language plpgsql
as $$
declare
  hid uuid;
begin
  hid := coalesce(NEW.hasta_id, OLD.hasta_id);
  update hastalar
  set son_islem_tarihi = (
    select max(s.tarih)
    from seans_notlari s
    where s.hasta_id = hid
      and coalesce(s.guncel, true) = true
      and coalesce(s.planlandi, false) = false
  )
  where id = hid;
  return coalesce(NEW, OLD);
end;
$$;

create trigger seans_notlari_son_islem_tarihi
  after insert or update of tarih, guncel, planlandi, hasta_id or delete
  on seans_notlari
  for each row
  execute function refresh_hasta_son_islem_tarihi();

create index if not exists hastalar_klinik_son_islem_idx
  on hastalar (klinik_id, son_islem_tarihi desc nulls last);
