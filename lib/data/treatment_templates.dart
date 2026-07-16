class TreatmentTemplate {
  final String? id;
  final String kategori;
  final String baslik;
  final bool isKanal;

  /// true ise yalnızca diş kapsamı geçerli; alt/üst çene / tüm ağız yok.
  final bool requiresTooth;

  /// true ise yeni işlem formunda “Lab’a gitti” seçeneği görünür.
  final bool labTakip;
  final bool aktif;
  final int sira;

  const TreatmentTemplate({
    this.id,
    required this.kategori,
    required this.baslik,
    this.isKanal = false,
    this.requiresTooth = true,
    this.labTakip = false,
    this.aktif = true,
    this.sira = 0,
  });

  factory TreatmentTemplate.fromJson(Map<String, dynamic> json) {
    return TreatmentTemplate(
      id: json['id'] as String?,
      kategori: json['kategori'] as String? ?? 'Genel',
      baslik: json['baslik'] as String? ?? '',
      isKanal: json['is_kanal'] as bool? ?? false,
      requiresTooth: json['dis_zorunlu'] as bool? ?? true,
      labTakip: json['lab_takip'] as bool? ?? false,
      aktif: json['aktif'] as bool? ?? true,
      sira: (json['sira'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toInsertJson({required String klinikId}) => {
        'klinik_id': klinikId,
        'kategori': kategori.trim(),
        'baslik': baslik.trim(),
        'is_kanal': isKanal,
        'dis_zorunlu': requiresTooth,
        'lab_takip': labTakip,
        'aktif': aktif,
        'sira': sira,
      };
}

TreatmentTemplate? findTreatmentTemplate(
  String baslik, {
  List<TreatmentTemplate>? inList,
}) {
  final q = baslik.trim().toLowerCase();
  if (q.isEmpty) return null;
  final source = inList ?? kDefaultTreatmentTemplates;
  for (final t in source) {
    if (t.baslik.toLowerCase() == q) return t;
  }
  return null;
}

/// Uygulama çekirdek listesi — klinikler buna kopyalanır / eksikler buradan gelir.
const List<TreatmentTemplate> kDefaultTreatmentTemplates = [
  TreatmentTemplate(
    kategori: 'Teşhis ve Planlama',
    baslik: 'Tedavi Planlaması',
    requiresTooth: false,
    sira: 1,
  ),
  TreatmentTemplate(
    kategori: 'Teşhis ve Planlama',
    baslik: 'İlk Muayene / Teşhis',
    requiresTooth: false,
    sira: 2,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Başlangıç',
    isKanal: true,
    sira: 10,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Bitim',
    isKanal: true,
    sira: 11,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Yenileme',
    isKanal: true,
    sira: 12,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kompozit Dolgu',
    sira: 13,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kuafaj',
    sira: 14,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Diş Çekimi',
    sira: 15,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Komplikasyonlu Çekim',
    sira: 16,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Cerrahi Çekim',
    sira: 17,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Alveolit Tedavisi (Pansuman)',
    sira: 18,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Küretaj',
    sira: 19,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Beyazlatma',
    requiresTooth: false,
    sira: 20,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Diş Kesimi',
    sira: 30,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Ölçü',
    requiresTooth: false,
    labTakip: true,
    sira: 31,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Altyapı Prova',
    labTakip: true,
    sira: 32,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Dentin Prova',
    labTakip: true,
    sira: 33,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Geçici Simantasyon',
    sira: 34,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Daimi Simantasyon',
    sira: 35,
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Gece Plağı Ölçüsü',
    requiresTooth: false,
    labTakip: true,
    sira: 36,
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Detertraj (Temizlik)',
    requiresTooth: false,
    sira: 40,
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Kontrol',
    requiresTooth: false,
    sira: 41,
  ),
];

/// Geriye dönük alias — yeni kod kDefault kullanmalı.
const List<TreatmentTemplate> kTreatmentTemplates = kDefaultTreatmentTemplates;

const List<String> kEgeSistemleri = [
  'Protaper',
  'Reciproc',
  'WaveOne',
  'El Eğesi',
];

const List<String> kKanalIlaclari = [
  'Ca(OH)₂',
  'Ledermix',
  'İlaçsız',
];

const List<String> kIslemKategorileri = [
  'Teşhis ve Planlama',
  'Tedavi',
  'Protez',
  'Genel',
];
