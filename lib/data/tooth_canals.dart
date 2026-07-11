// FDI diş numarasına göre tipik kanal kodları.
// Kaynak: Universal (#1–32) anatomi tablosu → FDI dönüşümü.

/// Standart + sık görülen ekstra kanal etiketleri.
const List<String> kAllKanalKodlari = [
  'Ana',
  'B',
  'L',
  'P',
  'MB',
  'MB1',
  'MB2',
  'MB3',
  'DB',
  'DB2',
  'DL',
  'ML',
  'D',
  'MM', // middle mesial (alt molar)
];

/// Geriye dönük uyumluluk — varsayılan molar seti.
const List<String> kKanalKodlari = ['MB', 'ML', 'D', 'P', 'L'];

const _ustTek = ['Ana'];
const _ustPremolar = ['B', 'P'];
const _ustMolar1 = ['MB1', 'MB2', 'DB', 'P'];
const _ustMolar2 = ['MB', 'DB', 'P'];
const _ustYirmi = ['MB', 'DB', 'P'];

const _altTek = ['Ana'];
const _altPremolar = ['Ana', 'B', 'L']; // bazen ikiye ayrılır
const _altKesici = ['B', 'L']; // 1–2 kanal
const _altMolar = ['MB', 'ML', 'DB', 'DL'];
const _altYirmi = ['MB', 'ML', 'D'];

/// FDI → tipik kanal listesi.
const Map<String, List<String>> kToothCanals = {
  // Üst sağ
  '18': _ustYirmi,
  '17': _ustMolar2,
  '16': _ustMolar1,
  '15': _ustPremolar,
  '14': _ustPremolar,
  '13': _ustTek,
  '12': _ustTek,
  '11': _ustTek,
  // Üst sol
  '21': _ustTek,
  '22': _ustTek,
  '23': _ustTek,
  '24': _ustPremolar,
  '25': _ustPremolar,
  '26': _ustMolar1,
  '27': _ustMolar2,
  '28': _ustYirmi,
  // Alt sol
  '38': _altYirmi,
  '37': _altMolar,
  '36': _altMolar,
  '35': _altPremolar,
  '34': _altPremolar,
  '33': _altTek,
  '32': _altKesici,
  '31': _altKesici,
  // Alt sağ
  '41': _altKesici,
  '42': _altKesici,
  '43': _altTek,
  '44': _altPremolar,
  '45': _altPremolar,
  '46': _altMolar,
  '47': _altMolar,
  '48': _altYirmi,
};

/// Diş için tipik kanal kodları.
List<String> canalsForTooth(String? disNo) {
  if (disNo == null || disNo.isEmpty) return kKanalKodlari;
  return List<String>.from(kToothCanals[disNo] ?? kKanalKodlari);
}

/// Tipik + kullanıcının eklediği ekstra kanallar (sıra korunur).
List<String> visibleCanalsForTooth(
  String? disNo, {
  List<String> extras = const [],
}) {
  final typical = canalsForTooth(disNo);
  final seen = typical.toSet();
  final out = [...typical];
  for (final e in extras) {
    final kod = e.trim();
    if (kod.isEmpty || seen.contains(kod)) continue;
    seen.add(kod);
    out.add(kod);
  }
  return out;
}

/// Henüz görünmeyen, eklenebilir standart kodlar.
List<String> availableExtraCanals(
  String? disNo, {
  List<String> extras = const [],
}) {
  final visible = visibleCanalsForTooth(disNo, extras: extras).toSet();
  return kAllKanalKodlari.where((k) => !visible.contains(k)).toList();
}

String toothCanalHint(String? disNo) {
  final canals = canalsForTooth(disNo);
  if (disNo == null) return '';
  return 'Diş $disNo · tipik: ${canals.join(", ")} — gerekirse ekstra ekleyin';
}
