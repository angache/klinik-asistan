class ClinicTodo {
  final String id;
  final String klinikId;
  final String? icerik;
  final String? sesUrl;
  final int? sureSaniye;
  final DateTime? planlananTarih;
  final bool tamamlandi;
  final DateTime? tamamlanmaTarihi;
  final DateTime olusturmaTarihi;

  const ClinicTodo({
    required this.id,
    required this.klinikId,
    this.icerik,
    this.sesUrl,
    this.sureSaniye,
    this.planlananTarih,
    this.tamamlandi = false,
    this.tamamlanmaTarihi,
    required this.olusturmaTarihi,
  });

  factory ClinicTodo.fromJson(Map<String, dynamic> json) {
    DateTime? plan;
    final rawPlan = json['planlanan_tarih'];
    if (rawPlan is String && rawPlan.isNotEmpty) {
      plan = DateTime.tryParse(rawPlan);
    }

    return ClinicTodo(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String,
      icerik: json['icerik'] as String?,
      sesUrl: json['ses_url'] as String?,
      sureSaniye: (json['sure_saniye'] as num?)?.toInt(),
      planlananTarih: plan,
      tamamlandi: json['tamamlandi'] as bool? ?? false,
      tamamlanmaTarihi: json['tamamlanma_tarihi'] != null
          ? DateTime.parse(json['tamamlanma_tarihi'] as String).toLocal()
          : null,
      olusturmaTarihi:
          DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
    );
  }

  bool get hasVoice => sesUrl != null && sesUrl!.trim().isNotEmpty;

  String get displayText {
    final t = icerik?.trim();
    if (t != null && t.isNotEmpty) return t;
    if (hasVoice) return 'Sesli yapılacak';
    return 'Yapılacak';
  }

  String get durationLabel {
    final s = sureSaniye ?? 0;
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  DateTime? get planDateOnly {
    final p = planlananTarih;
    if (p == null) return null;
    return DateTime(p.year, p.month, p.day);
  }

  bool get isOverdue {
    if (tamamlandi || planDateOnly == null) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly!.isBefore(t);
  }

  bool get isDueToday {
    if (tamamlandi || planDateOnly == null) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly == t;
  }

  bool get needsAttention => isOverdue || isDueToday;
}
