class CompletedNextPlan {
  final String id;
  final String hastaId;
  final String icerik;
  final DateTime tamamlanmaTarihi;

  const CompletedNextPlan({
    required this.id,
    required this.hastaId,
    required this.icerik,
    required this.tamamlanmaTarihi,
  });

  factory CompletedNextPlan.fromJson(Map<String, dynamic> json) {
    return CompletedNextPlan(
      id: json['id'] as String,
      hastaId: json['hasta_id'] as String,
      icerik: json['icerik'] as String,
      tamamlanmaTarihi: DateTime.parse(json['tamamlanma_tarihi'] as String),
    );
  }
}
