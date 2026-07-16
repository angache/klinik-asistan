enum TreatmentScope {
  tekDis('tek_dis', 'Diş'),
  ustCene('ust_cene', 'Üst Çene'),
  altCene('alt_cene', 'Alt Çene'),
  tumAgiz('tum_agiz', 'Tüm Ağız');

  const TreatmentScope(this.value, this.label);
  final String value;
  final String label;

  static TreatmentScope fromValue(String value) {
    return TreatmentScope.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TreatmentScope.tumAgiz,
    );
  }

  String badgeLabel({String? disNo}) {
    switch (this) {
      case TreatmentScope.tekDis:
        return disNo != null && disNo.isNotEmpty ? 'Diş: $disNo' : 'Diş';
      case TreatmentScope.ustCene:
        return 'Üst Çene';
      case TreatmentScope.altCene:
        return 'Alt Çene';
      case TreatmentScope.tumAgiz:
        return 'Tüm Ağız';
    }
  }
}

class TreatmentNote {
  final String id;
  final String hastaId;
  final TreatmentScope kapsam;
  final String? disNo;
  final String islemBaslik;
  final String? kanalBoyu;
  final String? egeSistemi;
  final String? kanalIlaci;
  final String notIcerik;
  final String? fotografUrl;
  final DateTime tarih;
  final DateTime olusturmaTarihi;
  final String? kokId;
  final String? oncekiId;
  final int versiyon;
  final bool guncel;
  final String? degisiklikOzeti;
  final bool planlandi;
  final bool labGitti;
  final DateTime? labBeklenenTarih;

  const TreatmentNote({
    required this.id,
    required this.hastaId,
    required this.kapsam,
    this.disNo,
    required this.islemBaslik,
    this.kanalBoyu,
    this.egeSistemi,
    this.kanalIlaci,
    required this.notIcerik,
    this.fotografUrl,
    required this.tarih,
    required this.olusturmaTarihi,
    this.kokId,
    this.oncekiId,
    this.versiyon = 1,
    this.guncel = true,
    this.degisiklikOzeti,
    this.planlandi = false,
    this.labGitti = false,
    this.labBeklenenTarih,
  });

  /// Zincirin kök id'si (ilk sürüm).
  String get rootId => kokId ?? id;

  bool get isEdited => versiyon > 1;

  factory TreatmentNote.fromJson(Map<String, dynamic> json) {
    DateTime? labDate;
    final rawLab = json['lab_beklenen_tarih'];
    if (rawLab is String && rawLab.isNotEmpty) {
      labDate = DateTime.tryParse(rawLab);
    }
    return TreatmentNote(
      id: json['id'] as String,
      hastaId: json['hasta_id'] as String,
      kapsam: TreatmentScope.fromValue(json['kapsam'] as String? ?? 'tum_agiz'),
      disNo: json['dis_no'] as String?,
      islemBaslik: json['islem_baslik'] as String,
      kanalBoyu: json['kanal_boyu'] as String?,
      egeSistemi: json['ege_sistemi'] as String?,
      kanalIlaci: json['kanal_ilaci'] as String?,
      notIcerik: json['not_icerik'] as String? ?? '',
      fotografUrl: json['fotograf_url'] as String?,
      tarih: DateTime.parse(json['tarih'] as String).toLocal(),
      olusturmaTarihi:
          DateTime.parse(json['olusturma_tarihi'] as String).toLocal(),
      kokId: json['kok_id'] as String?,
      oncekiId: json['onceki_id'] as String?,
      versiyon: (json['versiyon'] as num?)?.toInt() ?? 1,
      guncel: json['guncel'] as bool? ?? true,
      degisiklikOzeti: json['degisiklik_ozeti'] as String?,
      planlandi: json['planlandi'] as bool? ?? false,
      labGitti: json['lab_gitti'] as bool? ?? false,
      labBeklenenTarih: labDate,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'hasta_id': hastaId,
      'kapsam': kapsam.value,
      'dis_no': disNo,
      'islem_baslik': islemBaslik,
      'kanal_boyu': kanalBoyu,
      'ege_sistemi': egeSistemi,
      'kanal_ilaci': kanalIlaci,
      'not_icerik': notIcerik,
      'fotograf_url': fotografUrl,
      'tarih': tarih.toUtc().toIso8601String(),
      'kok_id': kokId,
      'onceki_id': oncekiId,
      'versiyon': versiyon,
      'guncel': guncel,
      'degisiklik_ozeti': degisiklikOzeti,
      'planlandi': planlandi,
      'lab_gitti': labGitti,
      if (labBeklenenTarih != null)
        'lab_beklenen_tarih':
            '${labBeklenenTarih!.year.toString().padLeft(4, '0')}-'
            '${labBeklenenTarih!.month.toString().padLeft(2, '0')}-'
            '${labBeklenenTarih!.day.toString().padLeft(2, '0')}',
    };
  }

  bool get hasPhoto => fotografUrl != null && fotografUrl!.isNotEmpty;
}

/// İki sürüm arasındaki alan farklarını insan okunur satırlara çevirir.
List<String> diffTreatmentNotes(TreatmentNote onceki, TreatmentNote yeni) {
  String n(String? v) => (v == null || v.trim().isEmpty) ? '—' : v.trim();
  final changes = <String>[];

  void add(String label, String? a, String? b) {
    final aa = n(a);
    final bb = n(b);
    if (aa != bb) changes.add('$label: $aa → $bb');
  }

  if (onceki.kapsam != yeni.kapsam) {
    changes.add('Kapsam: ${onceki.kapsam.label} → ${yeni.kapsam.label}');
  }
  add('Diş', onceki.disNo, yeni.disNo);
  add('Başlık', onceki.islemBaslik, yeni.islemBaslik);
  add('Not', onceki.notIcerik, yeni.notIcerik);
  add('Kanal boyu', onceki.kanalBoyu, yeni.kanalBoyu);
  add('Eğe', onceki.egeSistemi, yeni.egeSistemi);
  add('İlaç', onceki.kanalIlaci, yeni.kanalIlaci);
  if (n(onceki.fotografUrl) != n(yeni.fotografUrl)) {
    changes.add(
      onceki.hasPhoto && !yeni.hasPhoto
          ? 'Fotoğraf kaldırıldı'
          : !onceki.hasPhoto && yeni.hasPhoto
              ? 'Fotoğraf eklendi'
              : 'Fotoğraf değiştirildi',
    );
  }
  final oncekiLocal = onceki.tarih.toLocal();
  final yeniLocal = yeni.tarih.toLocal();
  if (oncekiLocal.year != yeniLocal.year ||
      oncekiLocal.month != yeniLocal.month ||
      oncekiLocal.day != yeniLocal.day ||
      oncekiLocal.hour != yeniLocal.hour ||
      oncekiLocal.minute != yeniLocal.minute) {
    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    changes.add('Tarih: ${fmt(oncekiLocal)} → ${fmt(yeniLocal)}');
  }

  return changes;
}
