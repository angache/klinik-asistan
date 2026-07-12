class FollowUp {
  final String id;
  final String klinikId;
  final String hastaId;
  final String? seansNotuId;
  final String baslik;
  final String? aciklama;
  final DateTime planlananTarih;
  final bool tamamlandi;
  final DateTime? tamamlanmaTarihi;
  final DateTime olusturmaTarihi;
  final String? hastaAdSoyad;

  const FollowUp({
    required this.id,
    required this.klinikId,
    required this.hastaId,
    this.seansNotuId,
    required this.baslik,
    this.aciklama,
    required this.planlananTarih,
    this.tamamlandi = false,
    this.tamamlanmaTarihi,
    required this.olusturmaTarihi,
    this.hastaAdSoyad,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    String? hastaAd;
    final hastaJson = json['hastalar'];
    if (hastaJson is Map) {
      hastaAd = hastaJson['ad_soyad'] as String?;
    }

    return FollowUp(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String,
      hastaId: json['hasta_id'] as String,
      seansNotuId: json['seans_notu_id'] as String?,
      baslik: json['baslik'] as String,
      aciklama: json['aciklama'] as String?,
      planlananTarih: DateTime.parse(json['planlanan_tarih'] as String),
      tamamlandi: json['tamamlandi'] as bool? ?? false,
      tamamlanmaTarihi: json['tamamlanma_tarihi'] != null
          ? DateTime.parse(json['tamamlanma_tarihi'] as String)
          : null,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
      hastaAdSoyad: hastaAd,
    );
  }

  DateTime get planDateOnly => DateTime(
        planlananTarih.year,
        planlananTarih.month,
        planlananTarih.day,
      );

  bool get isOverdue {
    if (tamamlandi) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly.isBefore(t);
  }

  bool get isDueToday {
    if (tamamlandi) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly == t;
  }

  bool get needsAttention => isOverdue || isDueToday;
}
