class Patient {
  final String id;
  final String? klinikId;
  final String adSoyad;
  final String? telefon;
  final DateTime olusturmaTarihi;
  final String? sonIslemBaslik;
  final DateTime? sonIslemTarih;

  /// Eski serbest sonraki-seans notu (geçiş için; yeni akış planlanan işlemler).
  final String? sonrakiPlan;

  /// Planlanan (henüz yapılmamış) işlem başlıkları — liste kartı için.
  final List<String> planlananBasliklar;

  const Patient({
    required this.id,
    this.klinikId,
    required this.adSoyad,
    this.telefon,
    required this.olusturmaTarihi,
    this.sonIslemBaslik,
    this.sonIslemTarih,
    this.sonrakiPlan,
    this.planlananBasliklar = const [],
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    String? sonBaslik;
    DateTime? sonTarih;
    final planlanan = <String>[];
    final notes = json['seans_notlari'];
    if (notes is List && notes.isNotEmpty) {
      final maps = notes
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) => e['guncel'] == true)
          .toList();

      final yapilan = maps.where((e) => e['planlandi'] != true).toList();
      yapilan.sort((a, b) {
        final ta = DateTime.tryParse('${a['tarih']}') ?? DateTime(1970);
        final tb = DateTime.tryParse('${b['tarih']}') ?? DateTime(1970);
        final byWhen = tb.compareTo(ta);
        if (byWhen != 0) return byWhen;
        final oa = DateTime.tryParse('${a['olusturma_tarihi']}') ?? ta;
        final ob = DateTime.tryParse('${b['olusturma_tarihi']}') ?? tb;
        return ob.compareTo(oa);
      });
      if (yapilan.isNotEmpty) {
        sonBaslik = yapilan.first['islem_baslik'] as String?;
        final t = yapilan.first['tarih'] as String?;
        if (t != null) sonTarih = DateTime.tryParse(t)?.toLocal();
      }

      for (final e in maps.where((e) => e['planlandi'] == true)) {
        final b = (e['islem_baslik'] as String?)?.trim();
        if (b != null && b.isNotEmpty) planlanan.add(b);
      }
    }

    final plan = json['sonraki_plan'] as String?;
    return Patient(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String?,
      adSoyad: json['ad_soyad'] as String,
      telefon: json['telefon'] as String?,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
      sonIslemBaslik: sonBaslik,
      sonIslemTarih: sonTarih,
      sonrakiPlan: (plan == null || plan.trim().isEmpty) ? null : plan.trim(),
      planlananBasliklar: planlanan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'klinik_id': klinikId,
      'ad_soyad': adSoyad,
      'telefon': telefon,
      'olusturma_tarihi': olusturmaTarihi.toIso8601String(),
      'sonraki_plan': sonrakiPlan,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      if (klinikId != null) 'klinik_id': klinikId,
      'ad_soyad': adSoyad,
      if (telefon != null && telefon!.isNotEmpty) 'telefon': telefon,
    };
  }

  Patient copyWith({
    String? id,
    String? klinikId,
    String? adSoyad,
    String? telefon,
    DateTime? olusturmaTarihi,
    String? sonIslemBaslik,
    DateTime? sonIslemTarih,
    String? sonrakiPlan,
    bool clearSonrakiPlan = false,
    List<String>? planlananBasliklar,
  }) {
    return Patient(
      id: id ?? this.id,
      klinikId: klinikId ?? this.klinikId,
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
      sonIslemBaslik: sonIslemBaslik ?? this.sonIslemBaslik,
      sonIslemTarih: sonIslemTarih ?? this.sonIslemTarih,
      sonrakiPlan:
          clearSonrakiPlan ? null : (sonrakiPlan ?? this.sonrakiPlan),
      planlananBasliklar: planlananBasliklar ?? this.planlananBasliklar,
    );
  }
}
