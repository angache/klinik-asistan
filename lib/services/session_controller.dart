import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/clinic.dart';

/// Oturum + çoklu klinik üyeliği.
class SessionController extends ChangeNotifier {
  SessionController({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client {
    _authSub = _client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      if (_user == null) {
        _clearClinicState();
        _loading = false;
        notifyListeners();
      } else {
        refreshMembership();
      }
    });
    _user = _client.auth.currentUser;
    if (_user != null) {
      refreshMembership();
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

  User? get user => _user;
  Clinic? get clinic => _clinic;
  ClinicMember? get member => _member;
  List<ClinicMembership> get memberships =>
      List.unmodifiable(_memberships);
  List<ClinicJoinRequest> get myPendingRequests =>
      List.unmodifiable(_myPendingRequests);
  int get pendingJoinCountForActiveClinic => _pendingJoinCountForActiveClinic;
  bool get loading => _loading;
  String? get error => _error;
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
    return _user?.email ?? 'Kullanıcı';
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

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final rows = await _client
          .from('klinik_uyeleri')
          .select('*, klinikler(*)')
          .eq('user_id', uid)
          .order('olusturma_tarihi', ascending: true);

      _memberships
        ..clear()
        ..addAll(
          (rows as List).map((raw) {
            final map = Map<String, dynamic>.from(raw as Map);
            final member = ClinicMember.fromJson(map);
            final klinikJson = map['klinikler'];
            if (klinikJson is! Map) {
              throw StateError('Klinik bilgisi eksik');
            }
            final clinic =
                Clinic.fromJson(Map<String, dynamic>.from(klinikJson));
            return ClinicMembership(member: member, clinic: clinic);
          }),
        );

      if (_memberships.isEmpty) {
        _clinic = null;
        _member = null;
      } else {
        await _applySelection(
          preferKlinikId: preferKlinikId ?? await _readSavedKlinikId(),
        );
      }

      await _refreshJoinRequestCaches();
    } catch (e) {
      _error = e.toString();
      _clearClinicState();
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
      throw Exception('Bu kliniğe üye değilsiniz');
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
        throw Exception(
          'Kayıt tamamlanamadı. Supabase Auth → Confirm email kapalı olsun veya e-postayı doğrulayın.',
        );
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
        throw Exception(
          'Kayıt tamamlanamadı. E-posta doğrulamasını kontrol edin.',
        );
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
    if (uid == null) throw Exception('Oturum gerekli');

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
    if (uid == null) throw Exception('Oturum gerekli');

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
      throw Exception('Klinik oluşturulamadı');
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
      throw Exception('Rol doktor veya asistan olmalı');
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
      throw Exception('Katılım isteği oluşturulamadı');
    }
    return ClinicJoinRequest.fromJson(Map<String, dynamic>.from(row as Map));
  }

  Future<List<ClinicJoinRequest>> getPendingJoinRequestsForActiveClinic() async {
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
    await _client.auth.signOut();
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
    if (s.contains('Invalid login credentials')) {
      return 'E-posta veya şifre hatalı';
    }
    if (s.contains('User already registered')) {
      return 'Bu e-posta zaten kayıtlı. Giriş yapın.';
    }
    if (s.contains('Password should be')) {
      return 'Şifre en az 6 karakter olmalı';
    }
    if (s.contains('over_email_send_rate_limit') || s.contains('429')) {
      return 'Çok sık deneme. Biraz bekleyip tekrar deneyin.';
    }
    if (s.contains('duplicate') || s.contains('unique')) {
      return 'Bu kliniğe zaten üyesiniz';
    }
    if (s.contains('Klinik kodu bulunamadı')) {
      return 'Klinik kodu bulunamadı';
    }
    if (s.contains('zaten üyesiniz')) {
      return 'Bu kliniğe zaten üyesiniz';
    }
    if (s.contains('Sadece klinik yöneticisi')) {
      return 'Sadece klinik yöneticisi onaylayabilir';
    }
    return s;
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
