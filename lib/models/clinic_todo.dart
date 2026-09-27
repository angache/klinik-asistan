enum TodoPriority {
  normal('normal', 'Normal'),
  important('onemli', 'Önemli'),
  urgent('acil', 'Acil');

  const TodoPriority(this.value, this.label);
  final String value;
  final String label;

  static TodoPriority fromValue(String? value) {
    final key = value?.trim().toLowerCase();
    if (key == null || key.isEmpty) return TodoPriority.normal;
    for (final item in TodoPriority.values) {
      if (item.value == key) return item;
    }
    return TodoPriority.normal;
  }
}

enum TodoRecurrence {
  none('yok', 'Tekrarlanmaz'),
  daily('gunluk', 'Her gün'),
  weekly('haftalik', 'Her hafta'),
  monthly('aylik', 'Her ay');

  const TodoRecurrence(this.value, this.label);
  final String value;
  final String label;

  static TodoRecurrence fromValue(String? value) {
    final key = value?.trim().toLowerCase();
    if (key == null || key.isEmpty) return TodoRecurrence.none;
    for (final item in TodoRecurrence.values) {
      if (item.value == key) return item;
    }
    return TodoRecurrence.none;
  }
}

class TodoImage {
  const TodoImage({
    required this.id,
    required this.todoId,
    required this.path,
    required this.createdAt,
  });

  final String id;
  final String todoId;
  final String path;
  final DateTime createdAt;

  factory TodoImage.fromJson(Map<String, dynamic> json) => TodoImage(
        id: json['id'] as String,
        todoId: json['todo_id'] as String,
        path: json['storage_path'] as String,
        createdAt: DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
      );
}

class TodoComment {
  const TodoComment({
    required this.id,
    required this.todoId,
    required this.text,
    required this.authorName,
    required this.createdAt,
  });

  final String id;
  final String todoId;
  final String text;
  final String authorName;
  final DateTime createdAt;

  factory TodoComment.fromJson(Map<String, dynamic> json) => TodoComment(
        id: json['id'] as String,
        todoId: json['todo_id'] as String,
        text: json['icerik'] as String,
        authorName: json['yazan_ad_soyad'] as String? ?? 'Klinik üyesi',
        createdAt: DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
      );
}

class TodoEvent {
  const TodoEvent({
    required this.id,
    required this.todoId,
    required this.type,
    required this.actorName,
    required this.createdAt,
    this.description,
  });

  final String id;
  final String todoId;
  final String type;
  final String actorName;
  final String? description;
  final DateTime createdAt;

  factory TodoEvent.fromJson(Map<String, dynamic> json) => TodoEvent(
        id: json['id'] as String,
        todoId: json['todo_id'] as String,
        type: json['olay_turu'] as String,
        actorName: json['yapan_ad_soyad'] as String? ?? 'Klinik üyesi',
        description: json['aciklama'] as String?,
        createdAt: DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
      );
}

class ClinicTodo {
  final String id;
  final String klinikId;
  final String? icerik;
  final String? sesUrl;
  final int? sureSaniye;
  final DateTime? planlananTarih;
  final DateTime? planlananZaman;
  final TodoPriority oncelik;
  final TodoRecurrence tekrar;
  final int hatirlatmaDakikaOnce;
  final String? sorumluUyeId;
  final String? sorumluAdSoyad;
  final String? hastaId;
  final String? hastaAdSoyad;
  final String? olusturanAdSoyad;
  final int gorselSayisi;
  final int yorumSayisi;
  final bool tamamlandi;
  final DateTime? tamamlanmaTarihi;
  final DateTime olusturmaTarihi;

  const ClinicTodo({
    required this.id,
    required this.klinikId,
    this.icerik,
    this.sesUrl,
    this.sureSaniye,
    this.planlananTarih,
    this.planlananZaman,
    this.oncelik = TodoPriority.normal,
    this.tekrar = TodoRecurrence.none,
    this.hatirlatmaDakikaOnce = 0,
    this.sorumluUyeId,
    this.sorumluAdSoyad,
    this.hastaId,
    this.hastaAdSoyad,
    this.olusturanAdSoyad,
    this.gorselSayisi = 0,
    this.yorumSayisi = 0,
    this.tamamlandi = false,
    this.tamamlanmaTarihi,
    required this.olusturmaTarihi,
  });

  factory ClinicTodo.fromJson(Map<String, dynamic> json) {
    DateTime? plan;
    final rawPlan = json['planlanan_tarih'];
    if (rawPlan is String && rawPlan.isNotEmpty) {
      plan = DateTime.tryParse(rawPlan);
    }

    final rawTime = json['planlanan_zaman'];
    final assigned = json['sorumlu'];
    final patient = json['hasta'];
    final images = json['klinik_todo_gorselleri'];
    final comments = json['klinik_todo_yorumlari'];

    return ClinicTodo(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String,
      icerik: json['icerik'] as String?,
      sesUrl: json['ses_url'] as String?,
      sureSaniye: (json['sure_saniye'] as num?)?.toInt(),
      planlananTarih: plan,
      planlananZaman:
          rawTime is String ? DateTime.tryParse(rawTime)?.toLocal() : null,
      oncelik: TodoPriority.fromValue(json['oncelik']?.toString()),
      tekrar: TodoRecurrence.fromValue(json['tekrar']?.toString()),
      hatirlatmaDakikaOnce:
          (json['hatirlatma_dakika_once'] as num?)?.toInt() ?? 0,
      sorumluUyeId: json['sorumlu_uye_id'] as String?,
      sorumluAdSoyad: assigned is Map
          ? assigned['ad_soyad'] as String?
          : json['sorumlu_ad_soyad'] as String?,
      hastaId: json['hasta_id'] as String?,
      hastaAdSoyad: patient is Map
          ? patient['ad_soyad'] as String?
          : json['hasta_ad_soyad'] as String?,
      olusturanAdSoyad: json['olusturan_ad_soyad'] as String?,
      gorselSayisi:
          images is List ? images.length : (json['gorsel_sayisi'] as int? ?? 0),
      yorumSayisi: comments is List
          ? comments.length
          : (json['yorum_sayisi'] as int? ?? 0),
      tamamlandi: json['tamamlandi'] as bool? ?? false,
      tamamlanmaTarihi: json['tamamlanma_tarihi'] != null
          ? DateTime.parse(json['tamamlanma_tarihi'] as String).toLocal()
          : null,
      olusturmaTarihi:
          DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
    );
  }

  bool get hasVoice => sesUrl != null && sesUrl!.trim().isNotEmpty;
  bool get hasImages => gorselSayisi > 0;

  String get displayText {
    final t = icerik?.trim();
    if (t != null && t.isNotEmpty) return t;
    if (hasVoice) return 'Sesli yapılacak';
    return 'Yapılacak';
  }

  String get durationLabel {
    final s = sureSaniye ?? 0;
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  DateTime? get planDateOnly {
    final p = planlananTarih;
    if (p == null) return null;
    return DateTime(p.year, p.month, p.day);
  }

  bool get isOverdue {
    if (tamamlandi || planDateOnly == null) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly!.isBefore(t);
  }

  bool get isDueToday {
    if (tamamlandi || planDateOnly == null) return false;
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    return planDateOnly == t;
  }

  bool get needsAttention => isOverdue || isDueToday;

  String get scheduleLabel {
    final value = planlananZaman ?? planlananTarih;
    if (value == null) return 'Tarihsiz';
    final date =
        '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';
    if (planlananZaman == null) return date;
    return '$date ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}
