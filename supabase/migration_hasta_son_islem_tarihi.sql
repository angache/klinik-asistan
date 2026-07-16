-- Hasta listesinde "son işlem tarihine göre" sıralama için denormalize alan

alter table hastalar
  add column if not exists son_islem_tarihi date;

-- Mevcut veriyi doldur (güncel + yapılmış işlemler)
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

drop trigger if exists seans_notlari_son_islem_tarihi on seans_notlari;
create trigger seans_notlari_son_islem_tarihi
  after insert or update of tarih, guncel, planlandi, hasta_id or delete
  on seans_notlari
  for each row
  execute function refresh_hasta_son_islem_tarihi();

create index if not exists hastalar_klinik_son_islem_idx
  on hastalar (klinik_id, son_islem_tarihi desc nulls last);
