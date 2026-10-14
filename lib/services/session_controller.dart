import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/l10n.dart';
import '../models/clinic.dart';
import 'notification_service.dart';
import 'push_service.dart';
import 'storage_media.dart';

class AccountDeletionPreview {
  const AccountDeletionPreview({
    required this.clinicsToDelete,
    required this.blockingClinics,
  });

  /// Tek üyesi bu kullanıcı olan klinikler: tüm hasta verisiyle silinir.
  final List<String> clinicsToDelete;

  /// Kullanıcının son admin olduğu ve başka üyesi olan klinikler.
  final List<String> blockingClinics;

  bool get canDelete => blockingClinics.isEmpty;

  factory AccountDeletionPreview.fromJson(Map<String, dynamic> json) {
    List<String> names(Object? v) =>
        (v as List? ?? const []).map((e) => e.toString()).toList();
    return AccountDeletionPreview(
      clinicsToDelete: names(json['clinicsToDelete']),
      blockingClinics: names(json['blockingClinics']),
    );
  }
}

/// Oturum + çoklu klinik üyeliği.
class SessionController extends ChangeNotifier {
  SessionController({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client {
    _authSub = _client.auth.onAuthStateChange.listen((data) {
      final previousId = _user?.id;
      _user = data.session?.user;
      if (_user == null) {
        _clearClinicState();
        _loading = false;
        notifyListeners();
      } else if (_user!.id != previousId) {
        // tokenRefreshed / initialSession aynı kullanıcı için tekrar gelir;
        // üyeliği yeniden yüklemek paneli sıfırlar.
        refreshMembership();
        PushService.instance.syncToken();
      }
    });
    _user = _client.auth.currentUser;
    if (_user != null) {
      refreshMembership();
      PushService.instance.syncToken();
    } else {
      _loading = false;
    }
  }

  static const _prefsKey = 'selected_klinik_id';

  final SupabaseClient _client;
  late final StreamSubscription<AuthState> _authSub;

  User? _user;
  final List<ClinicMembership> _memberships = [];
  final List<ClinicJoinRequest> _myPendingRequests = [];
  int _pendingJoinCountForActiveClinic = 0;
  Clinic? _clinic;
  ClinicMember? _member;
  bool _loading = true;
  String? _error;
  bool _membershipLoadFailed = false;

  User? get user => _user;
  Clinic? get clinic => _clinic;
  ClinicMember? get member => _member;
  List<ClinicMembership> get memberships => List.unmodifiable(_memberships);
  List<ClinicJoinRequest> get myPendingRequests =>
      List.unmodifiable(_myPendingRequests);
  int get pendingJoinCountForActiveClinic => _pendingJoinCountForActiveClinic;
  bool get loading => _loading;
  String? get error => _error;

  /// Klinik bilgisi sunucudan alınamadı (çoğunlukla bağlantı yok).
  bool get membershipLoadFailed => _membershipLoadFailed;
  bool get isLoggedIn => _user != null;
  bool get hasClinic => _clinic != null && _member != null;
  bool get hasMultipleClinics => _memberships.length > 1;
  bool get hasPendingJoinRequests => _myPendingRequests.isNotEmpty;
  bool get isActiveClinicAdmin => _member?.isAdmin == true;
  String? get klinikId => _clinic?.id;

  String get displayName {
    final fromMember = _member?.adSoyad.trim();
    if (fromMember != null && fromMember.isNotEmpty) return fromMember;
    final meta = _user?.userMetadata?['ad_soyad'];
    if (meta is String && meta.trim().isNotEmpty) return meta.trim();
    return _user?.email ?? currentL10n.userFallback;
  }

  void _clearClinicState() {
    _memberships.clear();
    _myPendingRequests.clear();
    _pendingJoinCountForActiveClinic = 0;
    _clinic = null;
    _member = null;
  }

  Future<void> refreshMembership({String? preferKlinikId}) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      _clearClinicState();
      _loading = false;
      notifyListeners();
      return;
    }

    // Klinik zaten yüklüyse arka planda yenile: tam ekran spinner paneli
    // (açık diyaloglar dahil) sıfırlar.
    final background = hasClinic;
    if (!background) _loading = true;
    _error = null;
    _membershipLoadFailed = false;
    notifyListeners();

    try {
      final rows = await _client
          .from('klinik_uyeleri')
          .select('*, klinikler(*)')
          .eq('user_id', uid)
          .order('olusturma_tarihi', ascending: true);

      final loaded = (rows as List).map((raw) {
        final map = Map<String, dynamic>.from(raw as Map);
        final member = ClinicMember.fromJson(map);
        final klinikJson = map['klinikler'];
        if (klinikJson is! Map) {
          throw StateError('Klinik bilgisi eksik');
        }
        final clinic = Clinic.fromJson(Map<String, dynamic>.from(klinikJson));
        return ClinicMembership(member: member, clinic: clinic);
      }).toList();

      _memberships
        ..clear()
        ..addAll(loaded);

      if (_memberships.isEmpty) {
        _clinic = null;
        _member = null;
      } else {
        await _applySelection(
          preferKlinikId: preferKlinikId ??
              (background ? _clinic?.id : null) ??
              await _readSavedKlinikId(),
        );
      }

      await _refreshJoinRequestCaches();
    } catch (e) {
      if (background) {
        debugPrint('refreshMembership (arka plan) hata: $e');
      } else {
        _error = e.toString();
        _membershipLoadFailed = true;
        _clearClinicState();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshJoinRequestCaches() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      _myPendingRequests.clear();
      _pendingJoinCountForActiveClinic = 0;
      return;
    }

    final mine = await _client
        .from('klinik_katilim_istekleri')
        .select('*, klinikler(*)')
        .eq('user_id', uid)
        .eq('durum', 'beklemede')
        .order('olusturma_tarihi', ascending: false);

    _myPendingRequests
      ..clear()
      ..addAll(
        (mine as List).map(
          (e) => ClinicJoinRequest.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        ),
      );

    final activeId = _clinic?.id;
    if (activeId != null && _member?.isAdmin == true) {
      final pending = await _client
          .from('klinik_katilim_istekleri')
          .select('id')
          .eq('klinik_id', activeId)
          .eq('durum', 'beklemede');
      _pendingJoinCountForActiveClinic = (pending as List).length;
    } else {
      _pendingJoinCountForActiveClinic = 0;
    }
  }

  Future<void> _applySelection({String? preferKlinikId}) async {
    ClinicMembership? chosen;
    if (preferKlinikId != null) {
      for (final m in _memberships) {
        if (m.klinikId == preferKlinikId) {
          chosen = m;
          break;
        }
      }
    }
    chosen ??= _memberships.first;
    _clinic = chosen.clinic;
    _member = chosen.member;
    await _saveKlinikId(chosen.klinikId);
  }

  Future<void> selectClinic(String klinikId) async {
    ClinicMembership? found;
    for (final m in _memberships) {
      if (m.klinikId == klinikId) {
        found = m;
        break;
      }
    }
    if (found == null) {
      throw Exception(currentL10n.errNotMember);
    }
    _clinic = found.clinic;
    _member = found.member;
    await _saveKlinikId(klinikId);
    await _refreshJoinRequestCaches();
    notifyListeners();
  }

  Future<String?> _readSavedKlinikId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey);
  }

  Future<void> _saveKlinikId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, id);
  }

  Future<void> _clearSavedKlinikId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      await refreshMembership();
    } catch (e) {
      _loading = false;
      _error = _friendlyAuthError(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUpCreateClinic({
    required String email,
    required String password,
    required String adSoyad,
    required String klinikAd,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'ad_soyad': adSoyad.trim()},
      );
      final uid = auth.user?.id ?? _client.auth.currentUser?.id;
      if (uid == null) {
        throw Exception(currentL10n.errSignupIncomplete);
      }

      final created = await _createClinicRpc(
        klinikAd: klinikAd,
        adSoyad: adSoyad,
      );
      await refreshMembership(preferKlinikId: created.id);
    } catch (e) {
      _loading = false;
      _error = _friendlyAuthError(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUpJoinClinic({
    required String email,
    required String password,
    required String adSoyad,
    required String klinikKod,
    required ClinicRole rol,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'ad_soyad': adSoyad.trim()},
      );
      final uid = auth.user?.id ?? _client.auth.currentUser?.id;
      if (uid == null) {
        throw Exception(currentL10n.errSignupIncomplete);
      }

      await _requestClinicJoin(
        klinikKod: klinikKod,
        adSoyad: adSoyad,
        rol: rol,
      );
      await refreshMembership();
    } catch (e) {
      _loading = false;
      _error = _friendlyAuthError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// Girişliyken yeni klinik oluştur (çoklu klinik).
  Future<Clinic> createAdditionalClinic({
    required String klinikAd,
    String? adSoyad,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception(currentL10n.errSessionRequired);

    final name = (adSoyad ?? displayName).trim();
    final created = await _createClinicRpc(
      klinikAd: klinikAd,
      adSoyad: name,
    );
    await refreshMembership(preferKlinikId: created.id);
    return created;
  }

  /// Girişliyken başka kliniğe katılım isteği gönder.
  Future<ClinicJoinRequest> joinAdditionalClinic({
    required String klinikKod,
    required ClinicRole rol,
    String? adSoyad,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception(currentL10n.errSessionRequired);

    final name = (adSoyad ?? displayName).trim();
    final request = await _requestClinicJoin(
      klinikKod: klinikKod,
      adSoyad: name,
      rol: rol,
    );
    await refreshMembership();
    return request;
  }

  Future<Clinic> _createClinicRpc({
    required String klinikAd,
    required String adSoyad,
  }) async {
    final kod = _generateClinicCode();
    final klinikRow = await _client.rpc(
      'create_clinic_with_admin',
      params: {
        'p_ad': klinikAd.trim(),
        'p_kod': kod,
        'p_ad_soyad': adSoyad.trim(),
      },
    );

    if (klinikRow == null) {
      throw Exception(currentL10n.errClinicCreateFailed);
    }
    return Clinic.fromJson(Map<String, dynamic>.from(klinikRow as Map));
  }

  Future<ClinicJoinRequest> _requestClinicJoin({
    required String klinikKod,
    required String adSoyad,
    required ClinicRole rol,
  }) async {
    final joinRole = rol == ClinicRole.admin ? ClinicRole.doktor : rol;
    if (joinRole != ClinicRole.doktor && joinRole != ClinicRole.asistan) {
      throw Exception(currentL10n.errRoleInvalid);
    }

    final row = await _client.rpc(
      'request_clinic_join',
      params: {
        'p_kod': klinikKod.trim(),
        'p_ad_soyad': adSoyad.trim(),
        'p_rol': joinRole.value,
      },
    );

    if (row == null) {
      throw Exception(currentL10n.errJoinRequestFailed);
    }
    return ClinicJoinRequest.fromJson(Map<String, dynamic>.from(row as Map));
  }

  Future<List<ClinicJoinRequest>>
      getPendingJoinRequestsForActiveClinic() async {
    final klinikId = _clinic?.id;
    if (klinikId == null || _member?.isAdmin != true) return [];

    final rows = await _client
        .from('klinik_katilim_istekleri')
        .select('*, klinikler(*)')
        .eq('klinik_id', klinikId)
        .eq('durum', 'beklemede')
        .order('olusturma_tarihi', ascending: true);

    return (rows as List)
        .map(
          (e) => ClinicJoinRequest.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  Future<void> approveJoinRequest(String istekId) async {
    await _client.rpc(
      'respond_clinic_join',
      params: {'p_istek_id': istekId, 'p_onay': true},
    );
    await refreshMembership(preferKlinikId: klinikId);
  }

  Future<void> rejectJoinRequest(String istekId) async {
    await _client.rpc(
      'respond_clinic_join',
      params: {'p_istek_id': istekId, 'p_onay': false},
    );
    await _refreshJoinRequestCaches();
    notifyListeners();
  }

  Future<void> signOut() async {
    await PushService.instance.clearToken();
    await NotificationService.instance.clearAll();
    await StorageMedia.clearCache();
    await _client.auth.signOut();
    await _clearSavedKlinikId();
    _user = null;
    _clearClinicState();
    notifyListeners();
  }

  /// Şifre sıfırlama kodu gönderir. E-posta şablonunda {{ .Token }} olmalı.
  Future<void> sendPasswordResetCode(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
    } catch (e) {
      throw Exception(_friendlyAuthError(e));
    }
  }

  /// E-postadaki kodla oturum açar ve yeni şifreyi kaydeder.
  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _client.auth.verifyOTP(
        type: OtpType.recovery,
        email: email.trim(),
        token: code.trim(),
      );
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception(_friendlyAuthError(e));
    }
  }

  /// Hesap silinirse ne olacağını sunucuya sorar (hiçbir şey silinmez).
  Future<AccountDeletionPreview> previewAccountDeletion() async {
    final res = await _client.functions.invoke(
      'delete-account',
      body: {'dryRun': true},
    );
    return AccountDeletionPreview.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }

  /// Hesabı kalıcı olarak siler. Tek üyesi olunan klinikler tüm verisiyle
  /// silinir; son admin olunan ve başka üyesi olan klinik varsa reddedilir.
  Future<void> deleteAccount() async {
    await _client.functions.invoke('delete-account', body: {'confirm': true});
    await NotificationService.instance.clearAll();
    await StorageMedia.clearCache();
    await PushService.instance.clearToken();
    try {
      await _client.auth.signOut();
    } catch (_) {
      // Kullanıcı sunucuda silindiği için oturum kapatma hata verebilir.
    }
    await _clearSavedKlinikId();
    _user = null;
    _clearClinicState();
    notifyListeners();
  }

  String _generateClinicCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }

  String _friendlyAuthError(Object e) {
    final s = e.toString();
    final l = currentL10n;
    if (s.contains('Invalid login credentials')) {
      return l.errInvalidCredentials;
    }
    if (s.contains('User already registered')) {
      return l.errAlreadyRegistered;
    }
    if (s.contains('Password should be')) {
      return l.errPasswordTooShort;
    }
    if (s.contains('over_email_send_rate_limit') || s.contains('429')) {
      return l.errTooManyAttempts;
    }
    if (s.contains('duplicate') || s.contains('unique')) {
      return l.errAlreadyMember;
    }
    // Aşağıdakiler veritabanı fonksiyonlarının Türkçe hata metinleridir.
    if (s.contains('Klinik kodu bulunamadı')) {
      return l.errClinicCodeNotFound;
    }
    if (s.contains('zaten üyesiniz')) {
      return l.errAlreadyMember;
    }
    if (s.contains('Sadece klinik yöneticisi')) {
      return l.errOnlyAdminCanApprove;
    }
    if (s.contains('otp_expired') ||
        s.contains('Token has expired or is invalid')) {
      return l.errResetCodeInvalid;
    }
    if (s.contains('same_password') ||
        s.contains('should be different from the old password')) {
      return l.errSamePassword;
    }
    return s.replaceFirst('Exception: ', '');
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
