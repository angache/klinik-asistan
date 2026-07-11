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
    baslik: 'Kompozit Dolgu',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Diş Kesimi / Ölçü',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Altyapı Provası',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Dent Provası',
  ),
  TreatmentTemplate(
    kategori: 'Protez',
    baslik: 'Simantasyon',
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Detertraj (Temizlik)',
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
