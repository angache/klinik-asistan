enum ClinicRole {
  admin('admin', 'Yönetici'),
  doktor('doktor', 'Doktor'),
  asistan('asistan', 'Asistan');

  const ClinicRole(this.value, this.label);
  final String value;
  final String label;

  static ClinicRole fromValue(String value) {
    return ClinicRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ClinicRole.asistan,
    );
  }
}

class Clinic {
  final String id;
  final String ad;
  final String kod;
  final DateTime olusturmaTarihi;

  const Clinic({
    required this.id,
    required this.ad,
    required this.kod,
    required this.olusturmaTarihi,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as String,
      ad: json['ad'] as String,
      kod: json['kod'] as String,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
    );
  }
}

class ClinicMember {
  final String id;
  final String klinikId;
  final String userId;
  final ClinicRole rol;
  final String adSoyad;
  final DateTime olusturmaTarihi;

  const ClinicMember({
    required this.id,
    required this.klinikId,
    required this.userId,
    required this.rol,
    required this.adSoyad,
    required this.olusturmaTarihi,
  });

  factory ClinicMember.fromJson(Map<String, dynamic> json) {
    return ClinicMember(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String,
      userId: json['user_id'] as String,
      rol: ClinicRole.fromValue(json['rol'] as String? ?? 'asistan'),
      adSoyad: json['ad_soyad'] as String,
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
    );
  }

  bool get isAdmin => rol == ClinicRole.admin;
  bool get isDoctor => rol == ClinicRole.doktor || rol == ClinicRole.admin;
}

/// Üyelik + klinik bilgisi (çoklu klinik listesi için).
class ClinicMembership {
  final ClinicMember member;
  final Clinic clinic;

  const ClinicMembership({
    required this.member,
    required this.clinic,
  });

  String get klinikId => clinic.id;
}

enum JoinRequestStatus {
  beklemede('beklemede', 'Onay bekliyor'),
  onaylandi('onaylandi', 'Onaylandı'),
  reddedildi('reddedildi', 'Reddedildi');

  const JoinRequestStatus(this.value, this.label);
  final String value;
  final String label;

  static JoinRequestStatus fromValue(String value) {
    return JoinRequestStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JoinRequestStatus.beklemede,
    );
  }
}

class ClinicJoinRequest {
  final String id;
  final String klinikId;
  final String userId;
  final String adSoyad;
  final ClinicRole rol;
  final JoinRequestStatus durum;
  final DateTime olusturmaTarihi;
  final DateTime? yanitTarihi;
  final Clinic? clinic;

  const ClinicJoinRequest({
    required this.id,
    required this.klinikId,
    required this.userId,
    required this.adSoyad,
    required this.rol,
    required this.durum,
    required this.olusturmaTarihi,
    this.yanitTarihi,
    this.clinic,
  });

  factory ClinicJoinRequest.fromJson(Map<String, dynamic> json) {
    Clinic? clinic;
    final klinikJson = json['klinikler'];
    if (klinikJson is Map) {
      clinic = Clinic.fromJson(Map<String, dynamic>.from(klinikJson));
    }

    return ClinicJoinRequest(
      id: json['id'] as String,
      klinikId: json['klinik_id'] as String,
      userId: json['user_id'] as String,
      adSoyad: json['ad_soyad'] as String,
      rol: ClinicRole.fromValue(json['rol'] as String? ?? 'asistan'),
      durum: JoinRequestStatus.fromValue(
        json['durum'] as String? ?? 'beklemede',
      ),
      olusturmaTarihi: DateTime.parse(json['olusturma_tarihi'] as String),
      yanitTarihi: json['yanit_tarihi'] != null
          ? DateTime.parse(json['yanit_tarihi'] as String)
          : null,
      clinic: clinic,
    );
  }

  bool get isPending => durum == JoinRequestStatus.beklemede;
}
