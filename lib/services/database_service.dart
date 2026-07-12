import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/supabase_config.dart';
import '../models/follow_up.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../models/voice_memo.dart';
import 'session_controller.dart';

class DatabaseService {
  DatabaseService({
    required SessionController session,
    SupabaseClient? client,
  })  : _session = session,
        _client = client ?? Supabase.instance.client;

  final SessionController _session;
  final SupabaseClient _client;
  final _uuid = const Uuid();

  String get _requireKlinikId {
    final id = _session.klinikId;
    if (id == null || id.isEmpty) {
      throw StateError('Klinik seçili değil — önce giriş yapın.');
    }
    return id;
  }

  String? get _userId => _session.user?.id;

  // ── Hastalar ──────────────────────────────────────────────

  static const int defaultPatientPageSize = 30;

  /// Sayfalı hasta listesi — sunucu tarafı arama (tüm tabloyu çekmez).
  Future<({List<Patient> items, bool hasMore})> getPatientsPage({
    String? query,
    int offset = 0,
    int limit = defaultPatientPageSize,
  }) async {
    final klinikId = _requireKlinikId;
    final from = offset < 0 ? 0 : offset;
    final to = from + limit - 1;

    var builder = _client.from('hastalar').select().eq('klinik_id', klinikId);

    final q = query?.trim();
    if (q != null && q.isNotEmpty) {
      final escaped = q.replaceAll('%', r'\%').replaceAll(',', ' ');
      builder = builder.or(
        'ad_soyad.ilike.%$escaped%,telefon.ilike.%$escaped%',
      );
    }

    final rows = await builder
        .order('ad_soyad', ascending: true)
        .range(from, to);

    final items = (rows as List)
        .map((e) => Patient.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return (items: items, hasMore: items.length >= limit);
  }

  @Deprecated('Trafik için getPatientsPage kullanın')
  Future<List<Patient>> getPatients({String? query}) async {
    final page = await getPatientsPage(query: query, offset: 0, limit: 500);
    return page.items;
  }

  Future<Patient> createPatient({
    required String adSoyad,
    String? telefon,
  }) async {
    final row = await _client
        .from('hastalar')
        .insert({
          'klinik_id': _requireKlinikId,
          'ad_soyad': adSoyad.trim(),
          if (telefon != null && telefon.trim().isNotEmpty)
            'telefon': telefon.trim(),
        })
        .select()
        .single();

    return Patient.fromJson(Map<String, dynamic>.from(row));
  }

  // ── Seans Notları ─────────────────────────────────────────

  List<TreatmentNote> _parseNotes(List<Map<String, dynamic>> rows) {
    final notes = rows
        .map((e) => TreatmentNote.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    notes.sort((a, b) {
      final byDate = b.tarih.compareTo(a.tarih);
      if (byDate != 0) return byDate;
      return b.olusturmaTarihi.compareTo(a.olusturmaTarihi);
    });
    return notes;
  }

  Future<List<TreatmentNote>> getNotesForPatient(String hastaId) async {
    final rows = await _client
        .from('seans_notlari')
        .select()
        .eq('hasta_id', hastaId)
        .eq('guncel', true)
        .order('tarih', ascending: false)
        .order('olusturma_tarihi', ascending: false);

    return _parseNotes(
      (rows as List).map((e) => Map<String, dynamic>.from(e as Map)).toList(),
    );
  }

  /// Canlı liste — yalnızca güncel sürümler.
  /// Not: realtime tüm tablo değişikliklerini dinleyebilir; tercih getNotesForPatient.
  Stream<List<TreatmentNote>> watchNotesForPatient(String hastaId) {
    return _client
        .from('seans_notlari')
        .stream(primaryKey: ['id'])
        .eq('hasta_id', hastaId)
        .order('tarih', ascending: false)
        .map((rows) {
          final current = rows
              .map((e) => TreatmentNote.fromJson(Map<String, dynamic>.from(e)))
              .where((n) => n.guncel)
              .toList();
          current.sort((a, b) {
            final byDate = b.tarih.compareTo(a.tarih);
            if (byDate != 0) return byDate;
            return b.olusturmaTarihi.compareTo(a.olusturmaTarihi);
          });
          return current;
        });
  }

  Future<List<VoiceMemo>> getVoiceMemosForPatient(String hastaId) async {
    final rows = await _client
        .from('ses_kayitlari')
        .select()
        .eq('hasta_id', hastaId)
        .order('olusturma_tarihi', ascending: false);

    return (rows as List)
        .map((e) => VoiceMemo.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Bir notun tüm sürümleri (eskiden yeniye).
  Future<List<TreatmentNote>> getNoteVersions(TreatmentNote note) async {
    final root = note.rootId;
    final rows = await _client
        .from('seans_notlari')
        .select()
        .eq('hasta_id', note.hastaId)
        .or('id.eq.$root,kok_id.eq.$root')
        .order('versiyon', ascending: true);

    final notes = (rows as List)
        .map(
          (e) => TreatmentNote.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .where((n) => n.rootId == root)
        .toList();
    notes.sort((a, b) => a.versiyon.compareTo(b.versiyon));
    return notes;
  }

  Future<TreatmentNote> createNote({
    required String hastaId,
    required TreatmentScope kapsam,
    String? disNo,
    required String islemBaslik,
    String? kanalBoyu,
    String? egeSistemi,
    String? kanalIlaci,
    required String notIcerik,
    String? fotografUrl,
    DateTime? tarih,
    String? kokId,
    String? oncekiId,
    int versiyon = 1,
    bool guncel = true,
    String? degisiklikOzeti,
  }) async {
    final payload = {
      'hasta_id': hastaId,
      'klinik_id': _requireKlinikId,
      if (_userId != null) 'olusturan_user_id': _userId,
      'kapsam': kapsam.value,
      'dis_no': kapsam == TreatmentScope.tekDis ? disNo : null,
      'islem_baslik': islemBaslik,
      'kanal_boyu': kanalBoyu,
      'ege_sistemi': egeSistemi,
      'kanal_ilaci': kanalIlaci,
      'not_icerik': notIcerik,
      'fotograf_url': fotografUrl,
      'versiyon': versiyon,
      'guncel': guncel,
      if (kokId != null) 'kok_id': kokId,
      if (oncekiId != null) 'onceki_id': oncekiId,
      if (degisiklikOzeti != null) 'degisiklik_ozeti': degisiklikOzeti,
      if (tarih != null)
        'tarih':
            '${tarih.year.toString().padLeft(4, '0')}-${tarih.month.toString().padLeft(2, '0')}-${tarih.day.toString().padLeft(2, '0')}',
    };

    final row = await _client
        .from('seans_notlari')
        .insert(payload)
        .select()
        .single();

    return TreatmentNote.fromJson(Map<String, dynamic>.from(row));
  }

  /// Düzenleme: eski sürüm kalır (guncel=false), yeni sürüm eklenir.
  Future<TreatmentNote> saveEditedNoteAsNewVersion({
    required TreatmentNote previous,
    required TreatmentScope kapsam,
    String? disNo,
    required String islemBaslik,
    String? kanalBoyu,
    String? egeSistemi,
    String? kanalIlaci,
    required String notIcerik,
    String? fotografUrl,
    DateTime? tarih,
  }) async {
    final draft = TreatmentNote(
      id: previous.id,
      hastaId: previous.hastaId,
      kapsam: kapsam,
      disNo: disNo,
      islemBaslik: islemBaslik,
      kanalBoyu: kanalBoyu,
      egeSistemi: egeSistemi,
      kanalIlaci: kanalIlaci,
      notIcerik: notIcerik,
      fotografUrl: fotografUrl,
      tarih: tarih ?? previous.tarih,
      olusturmaTarihi: DateTime.now(),
    );
    final changes = diffTreatmentNotes(previous, draft);
    if (changes.isEmpty) {
      return previous; // değişiklik yok
    }

    await _client
        .from('seans_notlari')
        .update({'guncel': false})
        .eq('id', previous.id);

    return createNote(
      hastaId: previous.hastaId,
      kapsam: kapsam,
      disNo: disNo,
      islemBaslik: islemBaslik,
      kanalBoyu: kanalBoyu,
      egeSistemi: egeSistemi,
      kanalIlaci: kanalIlaci,
      notIcerik: notIcerik,
      fotografUrl: fotografUrl,
      tarih: tarih ?? previous.tarih,
      kokId: previous.rootId,
      oncekiId: previous.id,
      versiyon: previous.versiyon + 1,
      guncel: true,
      degisiklikOzeti: changes.join('\n'),
    );
  }

  // ── Storage ───────────────────────────────────────────────

  Future<String> uploadSessionPhoto({
    required String hastaId,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final safeExt =
        (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp')
            ? ext
            : 'jpg';
    final path = '$hastaId/${_uuid.v4()}.$safeExt';

    await _client.storage.from(SupabaseConfig.storageBucket).upload(
          path,
          file,
          fileOptions: FileOptions(
            contentType: 'image/$safeExt',
            upsert: false,
          ),
        );

    return _client.storage
        .from(SupabaseConfig.storageBucket)
        .getPublicUrl(path);
  }

  Future<TreatmentNote> saveNoteWithOptionalPhoto({
    required String hastaId,
    required TreatmentScope kapsam,
    String? disNo,
    required String islemBaslik,
    String? kanalBoyu,
    String? egeSistemi,
    String? kanalIlaci,
    required String notIcerik,
    File? photoFile,
    String? fotografUrl,
  }) async {
    String? photoUrl = fotografUrl;
    if (photoFile != null) {
      photoUrl = await uploadSessionPhoto(hastaId: hastaId, file: photoFile);
    }

    return createNote(
      hastaId: hastaId,
      kapsam: kapsam,
      disNo: disNo,
      islemBaslik: islemBaslik,
      kanalBoyu: kanalBoyu,
      egeSistemi: egeSistemi,
      kanalIlaci: kanalIlaci,
      notIcerik: notIcerik,
      fotografUrl: photoUrl,
    );
  }

  // ── Ses kayıtları ─────────────────────────────────────────

  Stream<List<VoiceMemo>> watchVoiceMemosForPatient(String hastaId) {
    return _client
        .from('ses_kayitlari')
        .stream(primaryKey: ['id'])
        .eq('hasta_id', hastaId)
        .order('olusturma_tarihi', ascending: false)
        .map((rows) {
          final list = rows
              .map((e) => VoiceMemo.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          list.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
          return list;
        });
  }

  Future<String> uploadVoiceMemo({
    required String hastaId,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final safeExt = (ext == 'm4a' ||
            ext == 'aac' ||
            ext == 'mp3' ||
            ext == 'wav' ||
            ext == 'ogg')
        ? ext
        : 'm4a';
    final path =
        '${SupabaseConfig.voicePathPrefix}/$hastaId/${_uuid.v4()}.$safeExt';

    final contentType = switch (safeExt) {
      'mp3' => 'audio/mpeg',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      _ => 'audio/mp4',
    };

    await _client.storage.from(SupabaseConfig.storageBucket).upload(
          path,
          file,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: false,
          ),
        );

    return _client.storage
        .from(SupabaseConfig.storageBucket)
        .getPublicUrl(path);
  }

  Future<VoiceMemo> createVoiceMemo({
    required String hastaId,
    required File file,
    int? sureSaniye,
  }) async {
    final url = await uploadVoiceMemo(hastaId: hastaId, file: file);
    final row = await _client
        .from('ses_kayitlari')
        .insert({
          'hasta_id': hastaId,
          'klinik_id': _requireKlinikId,
          'dosya_url': url,
          if (sureSaniye != null) 'sure_saniye': sureSaniye,
        })
        .select()
        .single();
    return VoiceMemo.fromJson(Map<String, dynamic>.from(row));
  }

  Future<void> markVoiceMemoProcessed({
    required String memoId,
    String? seansNotuId,
  }) async {
    await _client.from('ses_kayitlari').update({
      'islenen': true,
      if (seansNotuId != null) 'seans_notu_id': seansNotuId,
    }).eq('id', memoId);
  }

  Future<void> deleteVoiceMemo(VoiceMemo memo) async {
    await _client.from('ses_kayitlari').delete().eq('id', memo.id);
  }

  // ── Takipler / kontroller ─────────────────────────────────

  Future<FollowUp> createFollowUp({
    required String hastaId,
    required String baslik,
    required DateTime planlananTarih,
    String? aciklama,
    String? seansNotuId,
  }) async {
    final d = planlananTarih;
    final row = await _client
        .from('takipler')
        .insert({
          'klinik_id': _requireKlinikId,
          'hasta_id': hastaId,
          'baslik': baslik.trim(),
          'planlanan_tarih':
              '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
          if (aciklama != null && aciklama.trim().isNotEmpty)
            'aciklama': aciklama.trim(),
          if (seansNotuId != null) 'seans_notu_id': seansNotuId,
          if (_userId != null) 'olusturan_user_id': _userId,
        })
        .select()
        .single();
    return FollowUp.fromJson(Map<String, dynamic>.from(row));
  }

  /// Açık takipler — gecikenler önce, sonra tarihe göre.
  Future<List<FollowUp>> getOpenFollowUps({int limit = 100}) async {
    final rows = await _client
        .from('takipler')
        .select('*, hastalar(ad_soyad)')
        .eq('klinik_id', _requireKlinikId)
        .eq('tamamlandi', false)
        .order('planlanan_tarih', ascending: true)
        .limit(limit);

    return (rows as List)
        .map((e) => FollowUp.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<FollowUp>> getFollowUpsForPatient(String hastaId) async {
    final rows = await _client
        .from('takipler')
        .select('*, hastalar(ad_soyad)')
        .eq('hasta_id', hastaId)
        .order('planlanan_tarih', ascending: true);

    return (rows as List)
        .map((e) => FollowUp.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<int> countAttentionFollowUps() async {
    final today = DateTime.now();
    final todayStr =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final rows = await _client
        .from('takipler')
        .select('id')
        .eq('klinik_id', _requireKlinikId)
        .eq('tamamlandi', false)
        .lte('planlanan_tarih', todayStr);

    return (rows as List).length;
  }

  Future<void> completeFollowUp(String id) async {
    await _client.from('takipler').update({
      'tamamlandi': true,
      'tamamlanma_tarihi': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteFollowUp(String id) async {
    await _client.from('takipler').delete().eq('id', id);
  }
}
