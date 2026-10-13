/// Rapor dönemi ve karşılaştırılan önceki dönem. Başlangıçlar dahil,
/// bitişler hariç (yerel gün başları).
///
/// Süren dönemler (bu hafta / bu ay) bugünle biter ve önceki dönemin aynı
/// uzunluktaki kısmıyla karşılaştırılır; yarım hafta tam haftayla kıyaslanmaz.
class ReportPeriod {
  const ReportPeriod({
    required this.start,
    required this.end,
    required this.previousStart,
    required this.previousEnd,
  });

  final DateTime start;
  final DateTime end;
  final DateTime previousStart;
  final DateTime previousEnd;

  int get dayCount => _days(start, end);

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _addDays(DateTime d, int n) =>
      DateTime(d.year, d.month, d.day + n);
  static int _days(DateTime a, DateTime b) =>
      DateTime.utc(b.year, b.month, b.day)
          .difference(DateTime.utc(a.year, a.month, a.day))
          .inDays;

  /// Ay sonuna sıkıştırarak [months] ay kaydırır (31 Mart − 1 ay = 28/29 Şubat).
  static DateTime _addMonths(DateTime d, int months) {
    final first = DateTime(d.year, d.month + months);
    final lastDay = DateTime(first.year, first.month + 1, 0).day;
    return DateTime(first.year, first.month, d.day > lastDay ? lastDay : d.day);
  }

  /// Pazartesi başlayan bu hafta, bugün dahil.
  factory ReportPeriod.thisWeek(DateTime now) {
    final today = _day(now);
    final start = _addDays(today, -(now.weekday - 1));
    final end = _addDays(today, 1);
    return ReportPeriod(
      start: start,
      end: end,
      previousStart: _addDays(start, -7),
      previousEnd: _addDays(end, -7),
    );
  }

  factory ReportPeriod.lastWeek(DateTime now) {
    final thisWeek = ReportPeriod.thisWeek(now).start;
    final start = _addDays(thisWeek, -7);
    return ReportPeriod(
      start: start,
      end: thisWeek,
      previousStart: _addDays(start, -7),
      previousEnd: start,
    );
  }

  /// Ayın başından bugüne; geçen ayın aynı günlerine kadarla karşılaştırılır.
  factory ReportPeriod.thisMonth(DateTime now) {
    final start = DateTime(now.year, now.month);
    final end = _addDays(_day(now), 1);
    final previousStart = DateTime(now.year, now.month - 1);
    var previousEnd = _addDays(_addMonths(_day(now), -1), 1);
    if (previousEnd.isAfter(start)) previousEnd = start;
    return ReportPeriod(
      start: start,
      end: end,
      previousStart: previousStart,
      previousEnd: previousEnd,
    );
  }

  factory ReportPeriod.lastMonth(DateTime now) => ReportPeriod(
        start: DateTime(now.year, now.month - 1),
        end: DateTime(now.year, now.month),
        previousStart: DateTime(now.year, now.month - 2),
        previousEnd: DateTime(now.year, now.month - 1),
      );

  /// [first] ve [last] günleri dahil; hemen önceki aynı uzunlukla kıyaslanır.
  factory ReportPeriod.custom(DateTime first, DateTime last) {
    final start = _day(first);
    final end = _addDays(_day(last), 1);
    final days = _days(start, end);
    return ReportPeriod(
      start: start,
      end: end,
      previousStart: _addDays(start, -days),
      previousEnd: start,
    );
  }
}

class ReportCount {
  const ReportCount(this.label, this.count);

  final String label;
  final int count;

  static List<ReportCount> listFrom(Object? raw, String labelKey) => [
        for (final e in (raw as List?) ?? const [])
          if (e is Map)
            ReportCount('${e[labelKey]}', (e['adet'] as num?)?.toInt() ?? 0),
      ];
}

class StalledPatient {
  const StalledPatient({
    required this.id,
    required this.adSoyad,
    this.telefon,
    this.sonIslemTarihi,
    this.planlanan = const [],
  });

  final String id;
  final String adSoyad;
  final String? telefon;
  final DateTime? sonIslemTarihi;
  final List<String> planlanan;

  factory StalledPatient.fromJson(Map<String, dynamic> json) {
    final son = json['son_islem_tarihi'] as String?;
    return StalledPatient(
      id: json['id'] as String,
      adSoyad: json['ad_soyad'] as String? ?? '',
      telefon: json['telefon'] as String?,
      sonIslemTarihi: son == null ? null : DateTime.tryParse(son)?.toLocal(),
      planlanan: [
        for (final p in (json['planlanan'] as List?) ?? const [])
          if (p is String) p,
      ],
    );
  }
}

enum RecallCallResult {
  randevu('randevu', 'Randevu verildi'),
  ulasilamadi('ulasilamadi', 'Ulaşılamadı'),
  istemiyor('istemiyor', 'İstemiyor');

  const RecallCallResult(this.value, this.label);
  final String value;
  final String label;

  static RecallCallResult? tryParse(String? value) {
    for (final r in values) {
      if (r.value == value) return r;
    }
    return null;
  }
}

class RecallPatient {
  const RecallPatient({
    required this.id,
    required this.adSoyad,
    required this.kontrolTarihi,
    required this.kontrolIslem,
    required this.kontrolIslemTarihi,
    this.telefon,
    this.lastCallResult,
    this.lastCallAt,
    this.lastCallBy,
  });

  final String id;
  final String adSoyad;
  final String? telefon;

  /// Kontrolün yapılması gereken tarih (işlem tarihi + şablondaki süre).
  final DateTime kontrolTarihi;

  /// Kontrolü gerektiren işlem ve yapıldığı tarih.
  final String kontrolIslem;
  final DateTime kontrolIslemTarihi;

  final RecallCallResult? lastCallResult;
  final DateTime? lastCallAt;
  final String? lastCallBy;

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v)?.toLocal() : null;

  factory RecallPatient.fromJson(Map<String, dynamic> json) => RecallPatient(
        id: json['id'] as String,
        adSoyad: json['ad_soyad'] as String? ?? '',
        telefon: json['telefon'] as String?,
        kontrolTarihi: _date(json['kontrol_tarihi'])!,
        kontrolIslem: json['kontrol_islem'] as String? ?? '',
        kontrolIslemTarihi: _date(json['kontrol_islem_tarihi'])!,
        lastCallResult:
            RecallCallResult.tryParse(json['son_arama_sonuc'] as String?),
        lastCallAt: _date(json['son_arama_tarihi']),
        lastCallBy: json['son_arama_kisi'] as String?,
      );

  /// Kontrol tarihinin üzerinden geçen tam ay sayısı.
  int monthsOverdue(DateTime now) {
    final d = kontrolTarihi;
    final months = (now.year - d.year) * 12 +
        now.month -
        d.month -
        (now.day < d.day ? 1 : 0);
    return months < 0 ? 0 : months;
  }
}

class RecallList {
  const RecallList({
    required this.total,
    required this.oldTotal,
    required this.patients,
  });

  /// Kontrol tarihi son 12 ay içinde olan hastalar.
  final int total;

  /// Kontrol tarihi 12 aydan eski olan hastalar.
  final int oldTotal;

  /// İstenen gruptaki hastalar; sunucu sınırı nedeniyle sayıdan az olabilir.
  final List<RecallPatient> patients;

  factory RecallList.fromJson(Map<String, dynamic> json) => RecallList(
        total: (json['toplam'] as num?)?.toInt() ?? 0,
        oldTotal: (json['eski_toplam'] as num?)?.toInt() ?? 0,
        patients: [
          for (final e in (json['hastalar'] as List?) ?? const [])
            if (e is Map) RecallPatient.fromJson(Map<String, dynamic>.from(e)),
        ],
      );
}

class ClinicReport {
  const ClinicReport({
    required this.summary,
    required this.followUps,
    required this.topProcedures,
    required this.categories,
    required this.dailyCounts,
    required this.stalledPatients,
  });

  /// ozet: toplam_hasta, yeni_hasta(_onceki), tedavi_goren_hasta(_onceki),
  /// hasta_ziyareti(_onceki), yapilan_islem(_onceki), planlanan_bekleyen
  final Map<String, int> summary;

  /// takip: lab_bekleyen, lab_geciken, kontrol_bekleyen, kontrol_geciken,
  /// lab_tamamlanan, kontrol_tamamlanan, gorev_acik, gorev_geciken,
  /// gorev_tamamlanan
  final Map<String, int> followUps;

  final List<ReportCount> topProcedures;
  final List<ReportCount> categories;

  /// Yerel gün → yapılan işlem sayısı (yalnızca işlem olan günler).
  final Map<DateTime, int> dailyCounts;

  final List<StalledPatient> stalledPatients;

  int count(String key) => summary[key] ?? 0;
  int followUp(String key) => followUps[key] ?? 0;

  static Map<String, int> _ints(Object? raw) => {
        if (raw is Map)
          for (final e in raw.entries)
            '${e.key}': (e.value as num?)?.toInt() ?? 0,
      };

  factory ClinicReport.fromJson(Map<String, dynamic> json) {
    final daily = <DateTime, int>{};
    for (final e in (json['gunler'] as List?) ?? const []) {
      if (e is! Map) continue;
      final d = DateTime.tryParse('${e['gun']}');
      if (d == null) continue;
      daily[DateTime(d.year, d.month, d.day)] =
          (e['adet'] as num?)?.toInt() ?? 0;
    }
    return ClinicReport(
      summary: _ints(json['ozet']),
      followUps: _ints(json['takip']),
      topProcedures: ReportCount.listFrom(json['islemler'], 'baslik'),
      categories: ReportCount.listFrom(json['kategoriler'], 'kategori'),
      dailyCounts: daily,
      stalledPatients: [
        for (final e in (json['yarim_kalan'] as List?) ?? const [])
          if (e is Map) StalledPatient.fromJson(Map<String, dynamic>.from(e)),
      ],
    );
  }

  /// Dönemdeki her gün için sayı (işlem olmayan günler 0).
  List<(DateTime, int)> dailySeries(ReportPeriod period) => [
        for (var d = period.start;
            d.isBefore(period.end);
            d = DateTime(d.year, d.month, d.day + 1))
          (d, dailyCounts[d] ?? 0),
      ];

  /// Haftanın günlerine göre toplam (1 = Pazartesi … 7 = Pazar).
  Map<int, int> weekdayTotals() {
    final totals = {for (var i = 1; i <= 7; i++) i: 0};
    dailyCounts.forEach((d, c) => totals[d.weekday] = totals[d.weekday]! + c);
    return totals;
  }
}
