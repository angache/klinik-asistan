class Patient {
  final String id;
  final String adSoyad;
  final String? telefon;
  final DateTime olusturmaTarihi;

  const Patient({
    required this.id,
    required this.adSoyad,
    this.telefon,
    required this.olusturmaTarihi,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      adSoyad: json['ad_soyad'] as String,
      telefon: json['telefon'] as String?,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_soyad': adSoyad,
      'telefon': telefon,
      'olusturma_tarihi': olusturmaTarihi.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'ad_soyad': adSoyad,
      if (telefon != null && telefon!.isNotEmpty) 'telefon': telefon,
    };
  }

  Patient copyWith({
    String? id,
    String? adSoyad,
    String? telefon,
    DateTime? olusturmaTarihi,
  }) {
    return Patient(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
    );
  }
}
