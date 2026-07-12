class Patient {
  final String id;
  final String? klinikId;
  final String adSoyad;
  final String? telefon;
  final DateTime olusturmaTarihi;
  final String? sonIslemBaslik;
  final DateTime? sonIslemTarih;

  const Patient({
    required this.id,
    this.klinikId,
    required this.adSoyad,
    this.telefon,
    required this.olusturmaTarihi,
    this.sonIslemBaslik,
    this.sonIslemTarih,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    String? sonBaslik;
    DateTime? sonTarih;
    final notes = json['seans_notlari'];
    if (notes is List && notes.isNotEmpty) {
      final guncel = notes
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) => e['guncel'] == true)
          .toList();
      guncel.sort((a, b) {
        final ta = DateTime.tryParse('${a['tarih']}') ?? DateTime(1970);
        final tb = DateTime.tryParse('${b['tarih']}') ?? DateTime(1970);
        return tb.compareTo(ta);
      });
      if (guncel.isNotEmpty) {
        sonBaslik = guncel.first['islem_baslik'] as String?;
        final t = guncel.first['tarih'] as String?;
        if (t != null) sonTarih = DateTime.tryParse(t);
      }
    }

    return Patient(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String?,
      adSoyad: json['ad_soyad'] as String,
      telefon: json['telefon'] as String?,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
      sonIslemBaslik: sonBaslik,
      sonIslemTarih: sonTarih,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'klinik_id': klinikId,
      'ad_soyad': adSoyad,
      'telefon': telefon,
      'olusturma_tarihi': olusturmaTarihi.toIso8601String(),
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
  }) {
    return Patient(
      id: id ?? this.id,
      klinikId: klinikId ?? this.klinikId,
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
      sonIslemBaslik: sonIslemBaslik ?? this.sonIslemBaslik,
      sonIslemTarih: sonIslemTarih ?? this.sonIslemTarih,
    );
  }
}
