import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/supabase_config.dart';
import '../data/treatment_templates.dart';
import '../models/clinic.dart';
import '../models/clinic_todo.dart';
import '../models/completed_next_plan.dart';
import '../models/follow_up.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../models/voice_memo.dart';
import 'session_controller.dart';
import 'storage_media.dart';

enum PatientListSort {
  name,
  lastVisit,
}

String _formatTimestamp(DateTime value) => value.toUtc().toIso8601String();

/// Seçilen güne kayıt anının saatini ekler (bugün = tam şimdi).
DateTime sessionDateTimeForSave(DateTime selectedDay, {DateTime? at}) {
  final now = at ?? DateTime.now();
  final day = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  final today = DateTime(now.year, now.month, now.day);
  if (day == today) return now;
  return DateTime(
    day.year,
    day.month,
    day.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
  );
}

class DatabaseService {
  DatabaseService({
    required SessionController session,
    SupabaseClient? client,
  })  : _session = session,
        _client = client ?? Supabase.instance.client;

  final SessionController _session;
  final SupabaseClient _client;
  final _uuid = const Uuid();

  SessionController get session => _session;

  bool get canManageRecords {
    final m = _session.member;
    return m != null && (m.isAdmin || m.isDoctor);
  }

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
    PatientListSort sort = PatientListSort.lastVisit,
  }) async {
    final klinikId = _requireKlinikId;
    final from = offset < 0 ? 0 : offset;
    final to = from + limit - 1;

    var builder = _client
        .from('hastalar')
        .select(
          '*, seans_notlari(islem_baslik, tarih, olusturma_tarihi, guncel, planlandi)',
        )
        .eq('klinik_id', klinikId);

    final q = query?.trim();
    if (q != null && q.isNotEmpty) {
      final escaped = q.replaceAll('%', r'\%').replaceAll(',', ' ');
      builder = builder.or(
        'ad_soyad.ilike.%$escaped%,telefon.ilike.%$escaped%',
      );
    }

    final List rows;
    if (sort == PatientListSort.lastVisit) {
      rows = await builder
          .order('son_islem_tarihi', ascending: false, nullsFirst: false)
          .order('ad_soyad', ascending: true)
          .range(from, to);
    } else {
      rows = await builder.order('ad_soyad', ascending: true).range(from, to);
    }

    final items = rows
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

  Future<Patient> updatePatient({
    required String id,
    required String adSoyad,
    String? telefon,
  }) async {
    final phone = telefon?.trim();
    final row = await _client
        .from('hastalar')
        .update({
          'ad_soyad': adSoyad.trim(),
          'telefon': (phone == null || phone.isEmpty) ? null : phone,
        })
        .eq('id', id)
        .select()
        .single();
    return Patient.fromJson(Map<String, dynamic>.from(row));
  }

  Future<Patient> updatePatientNextPlan({
    required String id,
    String? sonrakiPlan,
  }) async {
    final plan = sonrakiPlan?.trim();
    final row = await _client
        .from('hastalar')
        .update({
          'sonraki_plan': (plan == null || plan.isEmpty) ? null : plan,
        })
        .eq('id', id)
        .select(
          '*, seans_notlari(islem_baslik, tarih, olusturma_tarihi, guncel, planlandi)',
        )
        .single();
    return Patient.fromJson(Map<String, dynamic>.from(row));
  }

  /// Açık planı "yapıldı" olarak arşive alır; silmez.
  Future<Patient> completePatientNextPlan(String id) async {
    final current = await getPatient(id);
    final plan = current.sonrakiPlan?.trim();
    if (plan == null || plan.isEmpty) return current;

    await _client.from('hasta_plan_gecmisi').insert({
      'hasta_id': id,
      'klinik_id': _requireKlinikId,
      'icerik': plan,
      'tamamlanma_tarihi': DateTime.now().toUtc().toIso8601String(),
    });

    return updatePatientNextPlan(id: id, sonrakiPlan: null);
  }

  Future<List<CompletedNextPlan>> getCompletedNextPlans(String hastaId) async {
    final rows = await _client
        .from('hasta_plan_gecmisi')
        .select()
        .eq('hasta_id', hastaId)
        .order('tamamlanma_tarihi', ascending: false);
    return (rows as List)
        .map(
          (e) => CompletedNextPlan.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<void> deletePatient(String id) async {
    await _client.from('hastalar').delete().eq('id', id);
  }

  Future<Patient> getPatient(String id) async {
    final row = await _client
        .from('hastalar')
        .select(
          '*, seans_notlari(islem_baslik, tarih, olusturma_tarihi, guncel, planlandi)',
        )
        .eq('id', id)
        .single();
    return Patient.fromJson(Map<String, dynamic>.from(row));
  }

  // ── Seans Notları ─────────────────────────────────────────

  List<TreatmentNote> _parseNotes(List<Map<String, dynamic>> rows) {
    final notes = rows
        .map((e) => TreatmentNote.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    notes.sort((a, b) {
      final byWhen = b.tarih.compareTo(a.tarih);
      if (byWhen != 0) return byWhen;
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
            final byWhen = b.tarih.compareTo(a.tarih);
            if (byWhen != 0) return byWhen;
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
    bool planlandi = false,
    bool labGitti = false,
    DateTime? labBeklenenTarih,
  }) async {
    String? labDateStr;
    if (labBeklenenTarih != null) {
      final d = labBeklenenTarih;
      labDateStr =
          '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
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
      'planlandi': planlandi,
      'lab_gitti': labGitti,
      if (labDateStr != null) 'lab_beklenen_tarih': labDateStr,
      if (kokId != null) 'kok_id': kokId,
      if (oncekiId != null) 'onceki_id': oncekiId,
      if (degisiklikOzeti != null) 'degisiklik_ozeti': degisiklikOzeti,
      if (tarih != null) 'tarih': _formatTimestamp(tarih),
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
      planlandi: previous.planlandi,
      labGitti: previous.labGitti,
      labBeklenenTarih: previous.labBeklenenTarih,
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
    DateTime? tarih,
    bool planlandi = false,
    bool labGitti = false,
    DateTime? labBeklenenTarih,
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
      tarih: tarih,
      planlandi: planlandi,
      labGitti: labGitti,
      labBeklenenTarih: labBeklenenTarih,
    );
  }

  /// Planlanan işlemi bugün yapılmış sayar (geçmişe düşer).
  Future<TreatmentNote> completePlannedNote(String id) async {
    final row = await _client
        .from('seans_notlari')
        .update({
          'planlandi': false,
          'tarih': _formatTimestamp(DateTime.now()),
        })
        .eq('id', id)
        .select()
        .single();
    return TreatmentNote.fromJson(Map<String, dynamic>.from(row));
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
    final path = StorageMedia.pathFromUrl(memo.dosyaUrl);
    await _client.from('ses_kayitlari').delete().eq('id', memo.id);
    if (path != null && path.isNotEmpty) {
      try {
        await _client.storage.from(SupabaseConfig.storageBucket).remove([path]);
      } catch (_) {}
    }
  }

  Future<void> deleteNote(TreatmentNote note) async {
    // Zincirin tüm sürümlerini sil (kök + kok_id)
    final root = note.rootId;
    final rows = await _client
        .from('seans_notlari')
        .select('id, fotograf_url')
        .eq('hasta_id', note.hastaId)
        .or('id.eq.$root,kok_id.eq.$root');

    final list = (rows as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final ids = list.map((e) => e['id'] as String).toList();
    if (ids.isEmpty) return;

    for (final row in list) {
      final url = row['fotograf_url'] as String?;
      if (url == null || url.isEmpty) continue;
      final path = StorageMedia.pathFromUrl(url);
      if (path == null) continue;
      try {
        await _client.storage.from(SupabaseConfig.storageBucket).remove([path]);
      } catch (_) {}
    }

    await _client.from('seans_notlari').delete().inFilter('id', ids);
  }

  Future<List<ClinicMember>> getClinicMembers() async {
    final klinikId = _requireKlinikId;
    final rows = await _client
        .from('klinik_uyeleri')
        .select()
        .eq('klinik_id', klinikId)
        .order('olusturma_tarihi', ascending: true);
    return (rows as List)
        .map((e) => ClinicMember.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> updateMemberRole({
    required String memberId,
    required ClinicRole rol,
  }) async {
    await _client.from('klinik_uyeleri').update({
      'rol': rol.value,
    }).eq('id', memberId);
  }

  Future<void> removeMember(String memberId) async {
    await _client.from('klinik_uyeleri').delete().eq('id', memberId);
  }

  // ── Takipler / kontroller ─────────────────────────────────

  Future<FollowUp> createFollowUp({
    required String hastaId,
    required String baslik,
    required DateTime planlananTarih,
    String? aciklama,
    String? seansNotuId,
    String tur = 'genel',
  }) async {
    final d = planlananTarih;
    final row = await _client
        .from('takipler')
        .insert({
          'klinik_id': _requireKlinikId,
          'hasta_id': hastaId,
          'baslik': baslik.trim(),
          'tur': tur,
          'planlanan_tarih':
              '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
          if (aciklama != null && aciklama.trim().isNotEmpty)
            'aciklama': aciklama.trim(),
          if (seansNotuId != null) 'seans_notu_id': seansNotuId,
          if (_userId != null) 'olusturan_user_id': _userId,
        })
        .select('*, hastalar(ad_soyad)')
        .single();
    return FollowUp.fromJson(Map<String, dynamic>.from(row));
  }

  /// Lab dönüşünden 1 gün önce hatırlatma oluşturur.
  Future<FollowUp> createLabReminder({
    required String hastaId,
    required String islemBaslik,
    required DateTime beklenenDonus,
    String? seansNotuId,
    String? hastaAdSoyad,
  }) async {
    final donus = DateTime(
      beklenenDonus.year,
      beklenenDonus.month,
      beklenenDonus.day,
    );
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    var remind = donus.subtract(const Duration(days: 1));
    if (remind.isBefore(todayOnly)) remind = todayOnly;

    final fmt =
        '${donus.day.toString().padLeft(2, '0')}.${donus.month.toString().padLeft(2, '0')}.${donus.year}';
    final who = (hastaAdSoyad != null && hastaAdSoyad.trim().isNotEmpty)
        ? hastaAdSoyad.trim()
        : null;

    return createFollowUp(
      hastaId: hastaId,
      baslik: 'Lab: $islemBaslik',
      planlananTarih: remind,
      aciklama: who == null
          ? 'Beklenen lab dönüşü: $fmt'
          : 'Beklenen lab dönüşü: $fmt · $who',
      seansNotuId: seansNotuId,
      tur: 'lab',
    );
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

  // ── Klinik işlem şablonları ───────────────────────────────

  Future<List<TreatmentTemplate>> getTreatmentTemplates({
    bool onlyActive = true,
  }) async {
    final klinikId = _requireKlinikId;
    var query = _client.from('klinik_islemleri').select().eq('klinik_id', klinikId);
    if (onlyActive) {
      query = query.eq('aktif', true);
    }
    final rows = await query.order('sira', ascending: true).order('baslik');
    return (rows as List)
        .map((e) => TreatmentTemplate.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Liste boşsa / eksikse varsayılanları basar; aktif işlemleri döner.
  Future<List<TreatmentTemplate>> ensureTreatmentTemplates() async {
    final klinikId = _requireKlinikId;
    try {
      await _client.rpc('seed_klinik_islemleri', params: {
        'p_klinik_id': klinikId,
      });
    } catch (_) {
      // Migration henüz yoksa istemci tarafı doldurur.
    }

    if (canManageRecords) {
      await _insertMissingDefaultsFromApp();
      // Ölçü: diş zorunlu olmamalı (eskiden yanlış işaretlenmiş kayıtlar)
      try {
        await _client
            .from('klinik_islemleri')
            .update({'dis_zorunlu': false})
            .eq('klinik_id', klinikId)
            .eq('baslik', 'Ölçü');
      } catch (_) {}
    }

    try {
      final list = await getTreatmentTemplates(onlyActive: true);
      if (list.isNotEmpty) return list;
    } catch (_) {}
    return List<TreatmentTemplate>.from(kDefaultTreatmentTemplates);
  }

  Future<int> seedMissingTreatmentDefaults() async {
    var added = 0;
    try {
      final n = await _client.rpc('seed_klinik_islemleri', params: {
        'p_klinik_id': _requireKlinikId,
      });
      if (n is int) {
        added += n;
      } else if (n is num) {
        added += n.toInt();
      }
    } catch (_) {}
    added += await _insertMissingDefaultsFromApp();
    return added;
  }

  /// Uygulama çekirdeğindeki yeni şablonları (örn. Teşhis ve Planlama) DB'ye ekler.
  Future<int> _insertMissingDefaultsFromApp() async {
    if (!canManageRecords) return 0;
    List<TreatmentTemplate> existing;
    try {
      existing = await getTreatmentTemplates(onlyActive: false);
    } catch (_) {
      return 0;
    }
    final known = {
      for (final t in existing) t.baslik.trim().toLowerCase(),
    };
    var added = 0;
    final maxSira = existing.isEmpty
        ? 0
        : existing.map((e) => e.sira).reduce((a, b) => a > b ? a : b);
    var nextSira = maxSira;
    final klinikId = _requireKlinikId;

    final toInsert = <Map<String, dynamic>>[];
    for (final d in kDefaultTreatmentTemplates) {
      final key = d.baslik.trim().toLowerCase();
      if (known.contains(key)) continue;
      nextSira += 1;
      known.add(key);
      toInsert.add({
        'klinik_id': klinikId,
        'kategori': d.kategori,
        'baslik': d.baslik,
        'is_kanal': d.isKanal,
        'dis_zorunlu': d.requiresTooth,
        'lab_takip': d.labTakip,
        'aktif': true,
        'sira': d.sira > 0 ? d.sira : nextSira,
      });
    }
    if (toInsert.isEmpty) return 0;
    try {
      await _client.from('klinik_islemleri').insert(toInsert);
      added = toInsert.length;
    } catch (_) {
      // Tek tek dene (unique çakışması vs.)
      for (final row in toInsert) {
        try {
          await _client.from('klinik_islemleri').insert(row);
          added++;
        } catch (_) {}
      }
    }
    return added;
  }

  Future<TreatmentTemplate> createTreatmentTemplate({
    required String kategori,
    required String baslik,
    bool isKanal = false,
    bool requiresTooth = true,
    bool labTakip = false,
  }) async {
    final klinikId = _requireKlinikId;
    final existing = await getTreatmentTemplates(onlyActive: false);
    final maxSira = existing.isEmpty
        ? 0
        : existing.map((e) => e.sira).reduce((a, b) => a > b ? a : b);

    final row = await _client
        .from('klinik_islemleri')
        .insert({
          'klinik_id': klinikId,
          'kategori': kategori.trim(),
          'baslik': baslik.trim(),
          'is_kanal': isKanal,
          'dis_zorunlu': requiresTooth,
          'lab_takip': labTakip,
          'aktif': true,
          'sira': maxSira + 1,
        })
        .select()
        .single();
    return TreatmentTemplate.fromJson(Map<String, dynamic>.from(row));
  }

  Future<TreatmentTemplate> updateTreatmentTemplate({
    required String id,
    required String kategori,
    required String baslik,
    required bool isKanal,
    required bool requiresTooth,
    required bool labTakip,
    required bool aktif,
    int? sira,
  }) async {
    final payload = <String, dynamic>{
      'kategori': kategori.trim(),
      'baslik': baslik.trim(),
      'is_kanal': isKanal,
      'dis_zorunlu': requiresTooth,
      'lab_takip': labTakip,
      'aktif': aktif,
      if (sira != null) 'sira': sira,
    };
    final row = await _client
        .from('klinik_islemleri')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return TreatmentTemplate.fromJson(Map<String, dynamic>.from(row));
  }

  Future<void> deleteTreatmentTemplate(String id) async {
    await _client.from('klinik_islemleri').delete().eq('id', id);
  }

  // ── Klinik yapılacaklar (genel todo) ─────────────────────

  String _formatDateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<List<ClinicTodo>> getOpenClinicTodos({int limit = 200}) async {
    final rows = await _client
        .from('klinik_todolar')
        .select()
        .eq('klinik_id', _requireKlinikId)
        .eq('tamamlandi', false)
        .order('planlanan_tarih', ascending: true, nullsFirst: false)
        .order('olusturma_tarihi', ascending: false)
        .limit(limit);

    return (rows as List)
        .map((e) => ClinicTodo.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<int> countAttentionClinicTodos() async {
    final today = DateTime.now();
    final todayStr = _formatDateOnly(
      DateTime(today.year, today.month, today.day),
    );
    final rows = await _client
        .from('klinik_todolar')
        .select('id')
        .eq('klinik_id', _requireKlinikId)
        .eq('tamamlandi', false)
        .lte('planlanan_tarih', todayStr);
    return (rows as List).length;
  }

  Future<String> uploadClinicTodoVoice({required File file}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final safeExt = (ext == 'm4a' ||
            ext == 'aac' ||
            ext == 'mp3' ||
            ext == 'wav' ||
            ext == 'ogg')
        ? ext
        : 'wav';
    final path =
        '${SupabaseConfig.voicePathPrefix}/todolar/$_requireKlinikId/${_uuid.v4()}.$safeExt';

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

  Future<ClinicTodo> createClinicTodo({
    String? icerik,
    String? sesUrl,
    int? sureSaniye,
    DateTime? planlananTarih,
  }) async {
    final text = icerik?.trim();
    final voice = sesUrl?.trim();
    if ((text == null || text.isEmpty) && (voice == null || voice.isEmpty)) {
      throw ArgumentError('Yazı veya ses gerekli');
    }

    final row = await _client
        .from('klinik_todolar')
        .insert({
          'klinik_id': _requireKlinikId,
          if (text != null && text.isNotEmpty) 'icerik': text,
          if (voice != null && voice.isNotEmpty) 'ses_url': voice,
          if (sureSaniye != null) 'sure_saniye': sureSaniye,
          if (planlananTarih != null)
            'planlanan_tarih': _formatDateOnly(planlananTarih),
          if (_userId != null) 'olusturan_user_id': _userId,
        })
        .select()
        .single();
    return ClinicTodo.fromJson(Map<String, dynamic>.from(row));
  }

  Future<ClinicTodo> createClinicTodoVoice({
    required File file,
    int? sureSaniye,
    DateTime? planlananTarih,
  }) async {
    final url = await uploadClinicTodoVoice(file: file);
    return createClinicTodo(
      sesUrl: url,
      sureSaniye: sureSaniye,
      planlananTarih: planlananTarih,
    );
  }

  Future<void> completeClinicTodo(String id) async {
    await _client.from('klinik_todolar').update({
      'tamamlandi': true,
      'tamamlanma_tarihi': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteClinicTodo(ClinicTodo todo) async {
    await _client.from('klinik_todolar').delete().eq('id', todo.id);
    if (todo.hasVoice) {
      final path = StorageMedia.pathFromUrl(todo.sesUrl!);
      if (path != null && path.isNotEmpty) {
        try {
          await _client.storage
              .from(SupabaseConfig.storageBucket)
              .remove([path]);
        } catch (_) {}
      }
    }
  }
}
