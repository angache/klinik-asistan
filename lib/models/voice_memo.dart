class VoiceMemo {
  final String id;
  final String hastaId;
  final String dosyaUrl;
  final int? sureSaniye;
  final DateTime olusturmaTarihi;
  final bool islenen;
  final String? seansNotuId;

  const VoiceMemo({
    required this.id,
    required this.hastaId,
    required this.dosyaUrl,
    this.sureSaniye,
    required this.olusturmaTarihi,
    this.islenen = false,
    this.seansNotuId,
  });

  factory VoiceMemo.fromJson(Map<String, dynamic> json) {
    return VoiceMemo(
      id: json['id'] as String,
      hastaId: json['hasta_id'] as String,
      dosyaUrl: json['dosya_url'] as String,
      sureSaniye: (json['sure_saniye'] as num?)?.toInt(),
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
      islenen: json['islenen'] as bool? ?? false,
      seansNotuId: json['seans_notu_id'] as String?,
    );
  }

  String get durationLabel {
    final s = sureSaniye ?? 0;
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }
}
