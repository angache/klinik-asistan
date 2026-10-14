import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../l10n/l10n.dart';
import '../models/clinic_todo.dart';
import '../models/clinic.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../services/device_permissions.dart';
import '../theme/app_theme.dart';
import 'photo_preview.dart' show kPhotoMaxSide, kPhotoQuality;

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
        SnackBar(content: Text(context.l10n.previewPlayFailed(errorText(e)))),
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
      helpText: context.l10n.whenLabel,
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
      helpText: context.l10n.taskTime,
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        if (!await requestCamera()) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.cameraPermissionRequired)),
          );
          return;
        }
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: kPhotoQuality,
          maxWidth: kPhotoMaxSide,
          maxHeight: kPhotoMaxSide,
        );
        if (image != null && mounted) {
          setState(() => _images.add(File(image.path)));
        }
      } else {
        final images = await _picker.pickMultiImage(
          imageQuality: kPhotoQuality,
          maxWidth: kPhotoMaxSide,
          maxHeight: kPhotoMaxSide,
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
                ? context.l10n.cameraOpenFailed(errorText(e))
                : context.l10n.galleryOpenFailed(errorText(e)),
          ),
        ),
      );
    }
  }

  Future<bool> _ensureMic() async {
    if (await requestMicrophone()) return true;
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.micPermissionRequired)),
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
        SnackBar(content: Text(context.l10n.micPermissionMissing)),
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
        SnackBar(content: Text(context.l10n.recordingEmpty)),
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
        SnackBar(content: Text(context.l10n.errTextOrVoiceRequired)),
      );
      return;
    }
    if (_recording) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errFinishRecordingFirst)),
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
        SnackBar(content: Text(context.l10n.saveFailed(errorText(e)))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final fmt = DateFormat.yMd();
    final busy = _saving || _recording;

    return AlertDialog(
      title: Text(l10n.addTodo),
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
                decoration: InputDecoration(
                  labelText: l10n.noteOptionalLabel,
                  hintText: l10n.todoNoteHint,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.voiceOptional,
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
                        l10n.recordingInProgress,
                        style: TextStyle(color: scheme.error),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: _stopRecording,
                        icon: const Icon(Icons.stop),
                        label: Text(l10n.finish),
                      ),
                    ] else if (_hasVoice) ...[
                      Row(
                        children: [
                          Icon(Icons.mic, color: AppTheme.voiceAccentDark),
                          const SizedBox(width: 8),
                          Expanded(
                            child:
                                Text(l10n.voiceRecorded(_voiceDurationLabel)),
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
                            label: Text(_playing ? l10n.stop : l10n.listen),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    await _clearVoice();
                                  },
                            child: Text(l10n.delete),
                          ),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    await _clearVoice();
                                    await _startRecording();
                                  },
                            child: Text(l10n.reRecord),
                          ),
                        ],
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: busy ? null : _startRecording,
                        icon: const Icon(Icons.mic_outlined),
                        label: Text(l10n.recordVoice),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.whenLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.today),
                    selected: _presetDays == 0,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 0;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.tomorrow),
                    selected: _presetDays == 1,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 1;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.presetOneWeek),
                    selected: _presetDays == 7,
                    onSelected: busy
                        ? null
                        : (_) => setState(() {
                              _presetDays = 7;
                              _customDate = null;
                            }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.sectionUndated),
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
                          : l10n.pickDate,
                    ),
                    onPressed: busy ? null : _pickDate,
                  ),
                ],
              ),
              if (_effectiveDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.targetDate(fmt.format(_effectiveDate!)),
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
                      decoration: InputDecoration(labelText: l10n.priority),
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
                        _time == null ? l10n.addTime : _time!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _assignedMemberId,
                decoration: InputDecoration(
                  labelText: l10n.assignee,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.wholeClinic),
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
                decoration: InputDecoration(
                  labelText: l10n.patientLinkOptional,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.noPatientSelected),
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
                      decoration: InputDecoration(labelText: l10n.recurrence),
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
                        decoration: InputDecoration(labelText: l10n.reminder),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(l10n.remindOnTime),
                          ),
                          DropdownMenuItem(
                            value: 60,
                            child: Text(l10n.remindOneHourBefore),
                          ),
                          DropdownMenuItem(
                            value: 1440,
                            child: Text(l10n.remindOneDayBefore),
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
                l10n.images,
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
                  if (canTakePhoto)
                    OutlinedButton.icon(
                      onPressed:
                          busy ? null : () => _pickImages(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(l10n.camera),
                    ),
                  OutlinedButton.icon(
                    onPressed:
                        busy ? null : () => _pickImages(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l10n.gallery),
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
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
