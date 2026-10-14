import 'package:flutter/widgets.dart' show Locale;

import '../l10n/l10n.dart';

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

  /// Bu işlemden kaç ay sonra hasta periyodik kontrole çağrılır; null = yok.
  final int? kontrolAy;

  const TreatmentTemplate({
    this.id,
    required this.kategori,
    required this.baslik,
    this.isKanal = false,
    this.requiresTooth = true,
    this.labTakip = false,
    this.aktif = true,
    this.sira = 0,
    this.kontrolAy,
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
      kontrolAy: (json['kontrol_ay'] as num?)?.toInt(),
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
        'kontrol_ay': kontrolAy,
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
  for (final t in source) {
    if (procedureLabel(t.baslik).toLowerCase() == q) return t;
  }
  return null;
}

/// Ekranda yazılan adı kayıtta kullanılacak ada çevirir: şablonun çevrilmiş
/// adı yazıldıysa şablonun kliniğe kayıtlı adı döner.
String storedProcedureName(String typed, List<TreatmentTemplate> inList) =>
    findTreatmentTemplate(typed, inList: inList)?.baslik ?? typed.trim();

Map<String, String>? _defaultNameIndex;

/// Hazır işlem adı (herhangi bir dilde) etkin dilde gösterilir; kliniğin
/// kendi yazdığı ya da değiştirdiği adlar olduğu gibi kalır.
String procedureLabel(String stored) {
  final index = _defaultNameIndex ??= () {
    final m = <String, String>{};
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      for (final t in kDefaultTreatmentTemplates) {
        m[_defaultName(l, t.baslik).toLowerCase()] = t.baslik;
      }
    }
    return m;
  }();
  final tr = index[stored.trim().toLowerCase()];
  return tr == null ? stored : _defaultName(currentL10n, tr);
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
    kontrolAy: 6,
  ),
  TreatmentTemplate(
    kategori: 'Tedavi',
    baslik: 'Kanal Yenileme',
    isKanal: true,
    sira: 12,
    kontrolAy: 6,
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
    kontrolAy: 3,
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
    kontrolAy: 6,
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
    kontrolAy: 6,
  ),
  TreatmentTemplate(
    kategori: 'Genel',
    baslik: 'Kontrol',
    requiresTooth: false,
    sira: 41,
    kontrolAy: 6,
  ),
];

/// Geriye dönük alias — yeni kod kDefault kullanmalı.
const List<TreatmentTemplate> kTreatmentTemplates = kDefaultTreatmentTemplates;

/// Klinik dilindeki varsayılan şablonlar. Türkçe adlar sunucudaki
/// seed_klinik_islemleri ile aynı kalmalı; yoksa kopyalar oluşur.
List<TreatmentTemplate> defaultTreatmentTemplatesFor(String dil) {
  final supported =
      AppLocalizations.supportedLocales.any((l) => l.languageCode == dil);
  final l = lookupAppLocalizations(Locale(supported ? dil : 'en'));
  return [
    for (final t in kDefaultTreatmentTemplates)
      TreatmentTemplate(
        kategori: t.kategori,
        baslik: _defaultName(l, t.baslik),
        isKanal: t.isKanal,
        requiresTooth: t.requiresTooth,
        labTakip: t.labTakip,
        sira: t.sira,
        kontrolAy: t.kontrolAy,
      ),
  ];
}

String _defaultName(AppLocalizations l, String tr) => switch (tr) {
      'Tedavi Planlaması' => l.tplTreatmentPlanning,
      'İlk Muayene / Teşhis' => l.tplInitialExam,
      'Kanal Başlangıç' => l.tplCanalStart,
      'Kanal Bitim' => l.tplCanalFinish,
      'Kanal Yenileme' => l.tplCanalRetreatment,
      'Kompozit Dolgu' => l.tplCompositeFilling,
      'Kuafaj' => l.tplPulpCapping,
      'Diş Çekimi' => l.tplExtraction,
      'Komplikasyonlu Çekim' => l.tplComplicatedExtraction,
      'Cerrahi Çekim' => l.tplSurgicalExtraction,
      'Alveolit Tedavisi (Pansuman)' => l.tplAlveolitis,
      'Küretaj' => l.tplCurettage,
      'Beyazlatma' => l.tplWhitening,
      'Diş Kesimi' => l.tplToothPreparation,
      'Ölçü' => l.tplImpression,
      'Altyapı Prova' => l.tplFrameworkTryIn,
      'Dentin Prova' => l.tplBisqueTryIn,
      'Geçici Simantasyon' => l.tplTempCementation,
      'Daimi Simantasyon' => l.tplPermCementation,
      'Gece Plağı Ölçüsü' => l.tplNightGuardImpression,
      'Detertraj (Temizlik)' => l.tplScaling,
      'Kontrol' => l.tplCheckup,
      _ => tr,
    };

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

/// Veritabanında saklanan kategori adları; dil değişse de aynı kalmalı.
const List<String> kIslemKategorileri = [
  'Teşhis ve Planlama',
  'Tedavi',
  'Protez',
  'Genel',
];

String categoryLabel(String kod) => switch (kod) {
      'Teşhis ve Planlama' => currentL10n.catDiagnosis,
      'Tedavi' => currentL10n.catTreatment,
      'Protez' => currentL10n.catProsthetics,
      'Genel' => currentL10n.catGeneral,
      _ => kod,
    };
