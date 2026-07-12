class TreatmentTemplate {
  final String kategori;
  final String baslik;
  final bool isKanal;

  const TreatmentTemplate({
    required this.kategori,
    required this.baslik,
    this.isKanal = false,
  });
}

/// Sadece işlem adı — not kullanıcı isterse kendisi yazar.
const List<TreatmentTemplate> kTreatmentTemplates = [
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Başlangıç',
    isKanal: true,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Bitim',
    isKanal: true,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Yenileme',
    isKanal: true,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kompozit Dolgu',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Diş Çekimi',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Komplikasyonlu Çekim',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Cerrahi Çekim',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Alveolit Tedavisi (Pansuman)',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Küretaj',
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Beyazlatma',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Diş Kesimi / Ölçü',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Altyapı Prova',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Dentin Prova',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Geçici Simantasyon',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Daimi Simantasyon',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Gece Plağı Ölçüsü',
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Detertraj (Temizlik)',
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Kontrol',
  ),
];

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
