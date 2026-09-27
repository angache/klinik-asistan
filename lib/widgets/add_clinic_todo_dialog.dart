import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../models/clinic_todo.dart';
import '../models/clinic.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

Future<ClinicTodo?> showAddClinicTodoDialog({
  required BuildContext context,
  required DatabaseService db,
}) {
  return showDialog<ClinicTodo>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AddClinicTodoDialog(db: db),
  );
}

class _AddClinicTodoDialog extends StatefulWidget {
  const _AddClinicTodoDialog({required this.db});

  final DatabaseService db;

  @override
  State<_AddClinicTodoDialog> createState() => _AddClinicTodoDialogState();
}

class _AddClinicTodoDialogState extends State<_AddClinicTodoDialog> {
  final _icerik = TextEditingController();
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  final _picker = ImagePicker();
  int? _presetDays = 1;
  DateTime? _customDate;
  bool _saving = false;
  bool _recording = false;
  bool _playing = false;
  int _elapsedSec = 0;
  Timer? _timer;
  String? _voicePath;
  int? _voiceSeconds;
  List<ClinicMember> _members = const [];
  List<Patient> _patients = const [];
  final List<File> _images = [];
  String? _assignedMemberId;
  String? _patientId;
  TodoPriority _priority = TodoPriority.normal;
  TodoRecurrence _recurrence = TodoRecurrence.none;
  TimeOfDay? _time;
  int _reminderMinutes = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        setState(() => _playing = false);
      }
    });
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final results = await Future.wait([
        widget.db.getClinicMembers(),
        widget.db.getPatientsPage(limit: 200),
      ]);
      if (!mounted) return;
      setState(() {
        _members = results[0] as List<ClinicMember>;
        _patients = (results[1] as ({List<Patient> items, bool hasMore})).items;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _icerik.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  DateTime? get _effectiveDate {
    if (_presetDays == null && _customDate == null) return null;
    if (_presetDays != null) {
      final n = DateTime.now();
      return DateTime(n.year, n.month, n.day).add(Duration(days: _presetDays!));
    }
    final c = _customDate!;
    return DateTime(c.year, c.month, c.day);
  }

  DateTime? get _effectiveDateTime {
    final date = _effectiveDate;
    final time = _time;
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool get _hasVoice => _voicePath != null;

  String get _timeLabel {
    final m = _elapsedSec ~/ 60;
    final s = _elapsedSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get _voiceDurationLabel {
    final s = _voiceSeconds ?? 0;
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  Future<void> _togglePreview() async {
    if (_voicePath == null) return;
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
      return;
    }
    try {
      await _player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
      await _player.play(DeviceFileSource(_voicePath!));
      setState(() => _playing = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Önizleme çalınamadı: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _customDate ?? today.add(const Duration(days: 1)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 3)),
      helpText: 'Ne zaman?',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _customDate = picked;
      _presetDays = null;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Görev saati',
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final cam = await Permission.camera.request();
        if (!cam.isGranted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamera izni gerekli')),
          );
          return;
        }
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 82,
          maxWidth: 1800,
        );
        if (image != null && mounted) {
          setState(() => _images.add(File(image.path)));
        }
      } else {
        final images = await _picker.pickMultiImage(
          imageQuality: 82,
          maxWidth: 1800,
        );
        if (images.isNotEmpty && mounted) {
          setState(() => _images.addAll(images.map((e) => File(e.path))));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Kamera açılamadı: $e'
                : 'Galeri açılamadı: $e',
          ),
        ),
      );
    }
  }

  Future<bool> _ensureMic() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mikrofon izni gerekli')),
    );
    return false;
  }

  Future<void> _startRecording() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
    }
    if (!await _ensureMic()) return;
    if (!await _recorder.hasPermission()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon izni yok')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}${Platform.pathSeparator}todo_ses_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        numChannels: 1,
        sampleRate: 16000,
        bitRate: 256000,
      ),
      path: path,
    );

    setState(() {
      _recording = true;
      _elapsedSec = 0;
      _voicePath = null;
      _voiceSeconds = null;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSec++);
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    final filePath = path;
    if (filePath == null) {
      setState(() => _recording = false);
      return;
    }

    final file = File(filePath);
    if (!await file.exists() || await file.length() == 0) {
      if (!mounted) return;
      setState(() => _recording = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt boş veya oluşturulamadı')),
      );
      return;
    }

    setState(() {
      _recording = false;
      _voicePath = filePath;
      _voiceSeconds = _elapsedSec;
    });
  }

  Future<void> _clearVoice() async {
    if (_playing) await _player.stop();
    setState(() {
      _playing = false;
      _voicePath = null;
      _voiceSeconds = null;
      _elapsedSec = 0;
    });
  }

  Future<void> _cancel() async {
    _timer?.cancel();
    if (_playing) await _player.stop();
    if (_recording) await _recorder.stop();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _save() async {
    final text = _icerik.text.trim();
    if (text.isEmpty && !_hasVoice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not yazın veya ses kaydedin')),
      );
      return;
    }
    if (_recording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce ses kaydını bitirin')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      if (_playing) {
        await _player.stop();
        _playing = false;
      }
      final ClinicTodo todo;
      if (_hasVoice) {
        final url = await widget.db.uploadClinicTodoVoice(
          file: File(_voicePath!),
        );
        todo = await widget.db.createClinicTodo(
          icerik: text.isEmpty ? null : text,
          sesUrl: url,
          sureSaniye: _voiceSeconds,
          planlananTarih: _effectiveDate,
          planlananZaman: _effectiveDateTime,
          oncelik: _priority,
          tekrar: _recurrence,
          hatirlatmaDakikaOnce: _reminderMinutes,
          sorumluUyeId: _assignedMemberId,
          hastaId: _patientId,
          gorseller: _images,
        );
      } else {
        todo = await widget.db.createClinicTodo(
          icerik: text,
          planlananTarih: _effectiveDate,
          planlananZaman: _effectiveDateTime,
          oncelik: _priority,
          tekrar: _recurrence,
          hatirlatmaDakikaOnce: _reminderMinutes,
          sorumluUyeId: _assignedMemberId,
          hastaId: _patientId,
          gorseller: _images,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, todo);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydedilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd.MM.yyyy');
    final busy = _saving || _recording;

    return AlertDialog(
      title: const Text('Yapılacak ekle'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _icerik,
                autofocus: true,
                enabled: !_saving && !_recording,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Not (isteğe bağlı)',
                  hintText:
                      'örn. Yarın Fatih Bey’e randevu ver, hastaya dönüş yap…',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ses (isteğe bağlı)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_recording) ...[
                      Text(
                        _timeLabel,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kayıt sürüyor…',
                        style: TextStyle(color: scheme.error),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: _stopRecording,
                        icon: const Icon(Icons.stop),
                        label: const Text('Bitir'),
                      ),
                    ] else if (_hasVoice) ...[
                      Row(
                        children: [
                          Icon(Icons.mic, color: AppTheme.voiceAccentDark),
                          const SizedBox(width: 8),
                          Expanded(
                            child:
                                Text('Ses kaydedildi · $_voiceDurationLabel'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: _saving ? null : _togglePreview,
                            icon:
                                Icon(_playing ? Icons.stop : Icons.play_arrow),
                            label: Text(_playing ? 'Durdur' : 'Dinle'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    await _clearVoice();
                                  },
                            child: const Text('Sil'),
                          ),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    await _clearVoice();
                                    await _startRecording();
                                  },
                            child: const Text('Yeniden kaydet'),
                          ),
                        ],
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: busy ? null : _startRecording,
                        icon: const Icon(Icons.mic_outlined),
                        label: const Text('Ses kaydet'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ne zaman?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Bugün'),
                    selected: _presetDays == 0,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 0;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: const Text('Yarın'),
                    selected: _presetDays == 1,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 1;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: const Text('1 hafta'),
                    selected: _presetDays == 7,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 7;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: const Text('Tarihsiz'),
                    selected: _presetDays == null && _customDate == null,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = null;
                              _customDate = null;
                            }),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month, size: 16),
                    label: Text(
                      _customDate != null && _presetDays == null
                          ? fmt.format(_customDate!)
                          : 'Tarih seç',
                    ),
                    onPressed: busy ? null : _pickDate,
                  ),
                ],
              ),
              if (_effectiveDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Hedef: ${fmt.format(_effectiveDate!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TodoPriority>(
                      initialValue: _priority,
                      decoration: const InputDecoration(labelText: 'Öncelik'),
                      items: TodoPriority.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                      onChanged: busy
                          ? null
                          : (v) => setState(
                                () => _priority = v ?? TodoPriority.normal,
                              ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          busy || _effectiveDate == null ? null : _pickTime,
                      icon: const Icon(Icons.schedule),
                      label: Text(
                        _time == null ? 'Saat ekle' : _time!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _assignedMemberId,
                decoration: const InputDecoration(
                  labelText: 'Sorumlu',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tüm klinik'),
                  ),
                  ..._members.map(
                    (m) => DropdownMenuItem<String?>(
                      value: m.id,
                      child: Text(m.adSoyad),
                    ),
                  ),
                ],
                onChanged:
                    busy ? null : (v) => setState(() => _assignedMemberId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _patientId,
                decoration: const InputDecoration(
                  labelText: 'Hasta bağlantısı (isteğe bağlı)',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Hasta seçilmedi'),
                  ),
                  ..._patients.map(
                    (p) => DropdownMenuItem<String?>(
                      value: p.id,
                      child: Text(
                        p.adSoyad,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: busy ? null : (v) => setState(() => _patientId = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TodoRecurrence>(
                      initialValue: _recurrence,
                      decoration: const InputDecoration(labelText: 'Tekrar'),
                      items: TodoRecurrence.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                      onChanged: busy
                          ? null
                          : (v) => setState(
                                () => _recurrence = v ?? TodoRecurrence.none,
                              ),
                    ),
                  ),
                  if (_time != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _reminderMinutes,
                        decoration:
                            const InputDecoration(labelText: 'Hatırlatma'),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Zamanında')),
                          DropdownMenuItem(
                            value: 60,
                            child: Text('1 saat önce'),
                          ),
                          DropdownMenuItem(
                            value: 1440,
                            child: Text('1 gün önce'),
                          ),
                        ],
                        onChanged: busy
                            ? null
                            : (v) => setState(
                                  () => _reminderMinutes = v ?? 0,
                                ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Görseller',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 82,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _images[index],
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: InkWell(
                            onTap: busy
                                ? null
                                : () => setState(
                                      () => _images.removeAt(index),
                                    ),
                            child: const CircleAvatar(
                              radius: 11,
                              child: Icon(Icons.close, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed:
                        busy ? null : () => _pickImages(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Kamera'),
                  ),
                  OutlinedButton.icon(
                    onPressed:
                        busy ? null : () => _pickImages(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galeri'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : _cancel,
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: busy ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}
