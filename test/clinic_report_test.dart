import 'package:flutter_test/flutter_test.dart';
import 'package:klinik_asistan/models/clinic_report.dart';

void main() {
  group('ReportPeriod', () {
    test('bu hafta: pazartesiden bugüne, geçen haftanın aynı günleriyle', () {
      // 14 Ekim 2026 Çarşamba
      final p = ReportPeriod.thisWeek(DateTime(2026, 10, 14, 15, 30));
      expect(p.start, DateTime(2026, 10, 12));
      expect(p.end, DateTime(2026, 10, 15));
      expect(p.previousStart, DateTime(2026, 10, 5));
      expect(p.previousEnd, DateTime(2026, 10, 8));
    });

    test('geçen hafta tam hafta', () {
      final p = ReportPeriod.lastWeek(DateTime(2026, 10, 14));
      expect(p.start, DateTime(2026, 10, 5));
      expect(p.end, DateTime(2026, 10, 12));
      expect(p.previousStart, DateTime(2026, 9, 28));
      expect(p.dayCount, 7);
    });

    test('bu ay: geçen ayın aynı gününe kadarla kıyaslanır', () {
      final p = ReportPeriod.thisMonth(DateTime(2026, 10, 14));
      expect(p.start, DateTime(2026, 10, 1));
      expect(p.end, DateTime(2026, 10, 15));
      expect(p.previousStart, DateTime(2026, 9, 1));
      expect(p.previousEnd, DateTime(2026, 9, 15));
    });

    test('bu ay 31 Mart: önceki dönem şubat sonunu aşmaz', () {
      final p = ReportPeriod.thisMonth(DateTime(2026, 3, 31));
      expect(p.previousStart, DateTime(2026, 2, 1));
      expect(p.previousEnd, DateTime(2026, 3, 1));
    });

    test('geçen ay ocakta yıl değişir', () {
      final p = ReportPeriod.lastMonth(DateTime(2026, 1, 10));
      expect(p.start, DateTime(2025, 12, 1));
      expect(p.end, DateTime(2026, 1, 1));
      expect(p.previousStart, DateTime(2025, 11, 1));
      expect(p.previousEnd, DateTime(2025, 12, 1));
    });

    test('özel aralık: iki uç dahil, hemen önceki aynı uzunluk', () {
      final p =
          ReportPeriod.custom(DateTime(2026, 10, 1), DateTime(2026, 10, 10));
      expect(p.dayCount, 10);
      expect(p.end, DateTime(2026, 10, 11));
      expect(p.previousStart, DateTime(2026, 9, 21));
      expect(p.previousEnd, DateTime(2026, 10, 1));
    });
  });

  test('RecallList.fromJson, son arama ve gecikme', () {
    final list = RecallList.fromJson({
      'toplam': 140,
      'eski_toplam': 12,
      'hastalar': [
        {
          'id': 'h1',
          'ad_soyad': 'Ali Veli',
          'telefon': '0555 111 22 33',
          'son_islem_tarihi': '2026-03-20T09:00:00+00:00',
          'kontrol_tarihi': '2026-03-20T09:00:00+00:00',
          'kontrol_islem': 'Detertraj (Temizlik)',
          'kontrol_islem_tarihi': '2025-09-20T09:00:00+00:00',
          'son_arama_sonuc': 'ulasilamadi',
          'son_arama_tarihi': '2026-09-01T10:00:00+00:00',
          'son_arama_kisi': 'Ayşe',
        },
        {
          'id': 'h2',
          'ad_soyad': 'Veli Can',
          'kontrol_tarihi': '2026-09-20T09:00:00+00:00',
          'kontrol_islem': 'Kontrol',
          'kontrol_islem_tarihi': '2026-03-20T09:00:00+00:00',
          'son_arama_sonuc': null,
        },
      ],
    });
    expect(list.total, 140);
    expect(list.oldTotal, 12);
    final p = list.patients.first;
    expect(p.kontrolIslem, 'Detertraj (Temizlik)');
    expect(p.lastCallResult, RecallCallResult.ulasilamadi);
    expect(p.lastCallBy, 'Ayşe');
    expect(p.monthsOverdue(DateTime(2026, 9, 14)), 5);
    expect(p.monthsOverdue(DateTime(2026, 9, 25)), 6);
    final q = list.patients.last;
    expect(q.lastCallResult, isNull);
    expect(q.lastCallAt, isNull);
    expect(q.monthsOverdue(DateTime(2026, 9, 1)), 0);
  });

  test('ClinicReport.fromJson ve günlük seri', () {
    final r = ClinicReport.fromJson({
      'ozet': {'yapilan_islem': 5, 'yapilan_islem_onceki': 3},
      'islemler': [
        {'baslik': 'Dolgu', 'adet': 3},
        {'baslik': 'Kanal', 'adet': 2},
      ],
      'kategoriler': [],
      'gunler': [
        {'gun': '2026-10-12', 'adet': 2},
        {'gun': '2026-10-14', 'adet': 3},
      ],
      'takip': {'lab_bekleyen': 4},
      'yarim_kalan': [
        {
          'id': 'h1',
          'ad_soyad': 'Ayşe Yılmaz',
          'telefon': null,
          'son_islem_tarihi': '2026-08-01T10:00:00+00:00',
          'planlanan': ['Kron'],
        },
      ],
    });
    expect(r.count('yapilan_islem'), 5);
    expect(r.count('yok'), 0);
    expect(r.followUp('lab_bekleyen'), 4);
    expect(r.topProcedures.first.label, 'Dolgu');
    expect(r.stalledPatients.single.planlanan, ['Kron']);

    final period = ReportPeriod.thisWeek(DateTime(2026, 10, 14));
    final series = r.dailySeries(period);
    expect(series.map((e) => e.$2), [2, 0, 3]);
    expect(r.weekdayTotals()[DateTime.wednesday], 3);
  });
}
