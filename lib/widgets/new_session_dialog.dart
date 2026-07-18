import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../data/tooth_canals.dart';
import '../data/treatment_templates.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'kanal_params_section.dart';
import 'cloud_upload_overlay.dart';
import 'photo_preview.dart';
import 'session_follow_up_sheet.dart';
import 'tooth_selector.dart';
import 'treatment_picker_sheet.dart';

Future<TreatmentNote?> showNewSessionDialog({
  required BuildContext context,
  required Patient patient,
  required DatabaseService db,
}) {
  return showDialog<TreatmentNote>(
    context: context,
    barrierDismissible: false,
    builder: (_) => NewSessionDialog(patient: patient, db: db),
  );
}

class _KanalDraft {
  final Map<String, String> boylar = {};
  final List<String> ekstraKanallar = [];
  String? egeSistemi;
  String? kanalIlaci;

  bool get hasAnyBoy => boylar.values.any((v) => v.trim().isNotEmpty);

  String buildBoyuText({List<String>? onlyCodes}) {
    final codes = onlyCodes ?? boylar.keys.toList();
    final parts = <String>[];
    for (final kod in codes) {
      final v = boylar[kod]?.trim() ?? '';
      if (v.isNotEmpty) parts.add('$kod: ${v}mm');
    }
    return parts.join(', ');
  }
}

class NewSessionDialog extends StatefulWidget {
  const NewSessionDialog({
    super.key,
    required this.patient,
    required this.db,
  });

  final Patient patient;
  final DatabaseService db;

  @override
  State<NewSessionDialog> createState() => _NewSessionDialogState();
}

class _NewSessionDialogState extends State<NewSessionDialog> {
  TreatmentScope? _kapsam;
  Set<String> _selectedTeeth = {};
  TreatmentTemplate? _selectedTemplate;
  bool _showKanal = false;

  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  final Map<String, TextEditingController> _kanalControllers = {
    for (final k in kAllKanalKodlari) k: TextEditingController(),
  };

  /// Diş numarası → o dişe ait kanal parametreleri
  final Map<String, _KanalDraft> _kanalByTooth = {};
  String? _activeKanalTooth;

  File? _photo;
  bool _saving = false;
  String _uploadMessage = 'Kaydediliyor…';
  late DateTime _sessionDate;
  List<TreatmentTemplate> _templates =
      List<TreatmentTemplate>.from(kDefaultTreatmentTemplates);
  bool _templatesLoading = true;
  bool _planForNext = false;
  bool _labSent = false;
  DateTime? _labReturnDate;
  SessionFollowUpDraft? _followUp;
  String? _validationError;

  final _picker = ImagePicker();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _sessionDate = DateTime(now.year, now.month, now.day);
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final list = await widget.db.ensureTreatmentTemplates();
      if (!mounted) return;
      setState(() {
        _templates = list;
        _templatesLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _templatesLoading = false);
    }
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get _isPastSession => _sessionDate.isBefore(_today);

  bool get _requiresTooth {
    if (_showKanal) return true;
    final fromSelection = _selectedTemplate;
    if (fromSelection != null) return fromSelection.requiresTooth;
    final fromTitle =
        findTreatmentTemplate(_titleController.text, inList: _templates);
    return fromTitle?.requiresTooth ?? false;
  }

  TreatmentTemplate? get _resolvedTemplate =>
      _selectedTemplate ??
      findTreatmentTemplate(_titleController.text, inList: _templates);

  /// Şablonda “Lab takibi” açık olan işlemlerde gösterilir.
  bool get _labEligible => _resolvedTemplate?.labTakip == true;

  List<TreatmentScope> get _availableScopes {
    if (_requiresTooth) return const [TreatmentScope.tekDis];
    return TreatmentScope.values;
  }

  Future<void> _pickSessionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sessionDate,
      firstDate: DateTime(2000),
      lastDate: _today,
      helpText: 'İşlem tarihi',
      cancelText: 'İptal',
      confirmText: 'Seç',
    );
    if (picked == null) return;
    setState(() {
      _sessionDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  DateTime get _sessionDateTimeForSave => sessionDateTimeForSave(_sessionDate);

  TextEditingController _controllerFor(String kod) {
    return _kanalControllers.putIfAbsent(kod, TextEditingController.new);
  }

  List<String> get _orderedTeeth {
    final order = ToothSelector.allInChartOrder;
    final selected = _selectedTeeth.toList();
    selected.sort((a, b) {
      final ia = order.indexOf(a);
      final ib = order.indexOf(b);
      if (ia < 0 && ib < 0) return a.compareTo(b);
      if (ia < 0) return 1;
      if (ib < 0) return -1;
      return ia.compareTo(ib);
    });
    return selected;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    for (final c in _kanalControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _showFormError(String message) {
    setState(() => _validationError = message);
    // Dialog üstündeki snackbar görünmez; formu hatalı alana kaydır.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _clearFormError() {
    if (_validationError == null) return;
    setState(() => _validationError = null);
  }

  void _persistActiveKanal() {
    final tooth = _activeKanalTooth;
    if (tooth == null) return;
    final draft = _kanalByTooth.putIfAbsent(tooth, _KanalDraft.new);
    final codes = visibleCanalsForTooth(tooth, extras: draft.ekstraKanallar);
    for (final kod in codes) {
      draft.boylar[kod] = _controllerFor(kod).text;
    }
  }

  void _loadKanalTooth(String tooth) {
    _persistActiveKanal();
    final draft = _kanalByTooth.putIfAbsent(tooth, _KanalDraft.new);
    final codes = visibleCanalsForTooth(tooth, extras: draft.ekstraKanallar);
    for (final c in _kanalControllers.values) {
      c.clear();
    }
    for (final kod in codes) {
      _controllerFor(kod).text = draft.boylar[kod] ?? '';
    }
    setState(() => _activeKanalTooth = tooth);
  }

  void _syncKanalDraftsWithSelection(Set<String> teeth) {
    _persistActiveKanal();
    _kanalByTooth.removeWhere((k, _) => !teeth.contains(k));
    for (final t in teeth) {
      _kanalByTooth.putIfAbsent(t, _KanalDraft.new);
    }

    if (!_showKanal || teeth.isEmpty) {
      _activeKanalTooth = null;
      for (final c in _kanalControllers.values) {
        c.clear();
      }
      return;
    }

    if (_activeKanalTooth == null || !teeth.contains(_activeKanalTooth)) {
      final next = _orderedTeethFrom(teeth).first;
      _activeKanalTooth = next;
      final draft = _kanalByTooth[next]!;
      for (final c in _kanalControllers.values) {
        c.clear();
      }
      for (final kod
          in visibleCanalsForTooth(next, extras: draft.ekstraKanallar)) {
        _controllerFor(kod).text = draft.boylar[kod] ?? '';
      }
    }
  }

  Future<void> _addExtraCanal() async {
    final tooth = _activeKanalTooth;
    if (tooth == null) return;
    _persistActiveKanal();
    final draft = _kanalByTooth.putIfAbsent(tooth, _KanalDraft.new);
    final available = availableExtraCanals(tooth, extras: draft.ekstraKanallar);

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final customCtrl = TextEditingController();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ekstra kanal ekle · Diş $tooth',
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tipik listede olmayan kanalı seçin veya özel ad yazın.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                if (available.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: available.map((kod) {
                      return ActionChip(
                        label: Text(kod),
                        onPressed: () => Navigator.pop(ctx, kod),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    'Standart kodların hepsi ekli. Özel ad kullanın.',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: customCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Özel kanal adı',
                    hintText: 'örn. MB3, DB2…',
                  ),
                  onSubmitted: (v) {
                    final t = v.trim();
                    if (t.isNotEmpty) Navigator.pop(ctx, t);
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    final t = customCtrl.text.trim();
                    if (t.isNotEmpty) Navigator.pop(ctx, t);
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || selected.trim().isEmpty) return;
    final kod = selected.trim();
    final typical = canalsForTooth(tooth);
    if (typical.contains(kod) || draft.ekstraKanallar.contains(kod)) return;

    setState(() {
      draft.ekstraKanallar.add(kod);
      _controllerFor(kod);
      draft.boylar[kod] = '';
    });
  }

  void _removeExtraCanal(String kod) {
    final tooth = _activeKanalTooth;
    if (tooth == null) return;
    _persistActiveKanal();
    final draft = _kanalByTooth[tooth];
    if (draft == null) return;
    setState(() {
      draft.ekstraKanallar.remove(kod);
      draft.boylar.remove(kod);
      _controllerFor(kod).clear();
    });
  }

  List<String> _orderedTeethFrom(Set<String> teeth) {
    final order = ToothSelector.allInChartOrder;
    final list = teeth.toList();
    list.sort((a, b) {
      final ia = order.indexOf(a);
      final ib = order.indexOf(b);
      if (ia < 0 && ib < 0) return a.compareTo(b);
      if (ia < 0) return 1;
      if (ib < 0) return -1;
      return ia.compareTo(ib);
    });
    return list;
  }

  Future<void> _openTreatmentPicker() async {
    final picked = await showTreatmentPickerSheet(
      context: context,
      templates: _templates,
      selected: _resolvedTemplate,
    );
    if (!mounted || picked == null) return;
    _applyTemplate(picked);
  }

  void _applyTemplate(TreatmentTemplate template) {
    setState(() {
      _validationError = null;
      _selectedTemplate = template;
      _titleController.text = template.baslik;
      _showKanal = template.isKanal;
      if (template.requiresTooth || template.isKanal) {
        _kapsam = TreatmentScope.tekDis;
      }
      if (!template.labTakip) {
        _labSent = false;
        _labReturnDate = null;
      }
      if (!template.isKanal) {
        _kanalByTooth.clear();
        _activeKanalTooth = null;
        for (final c in _kanalControllers.values) {
          c.clear();
        }
      } else {
        _syncKanalDraftsWithSelection(_selectedTeeth);
      }
    });
  }

  void _onTeethChanged(Set<String> teeth) {
    setState(() {
      _selectedTeeth = teeth;
      if (_showKanal) {
        _syncKanalDraftsWithSelection(teeth);
      }
    });
  }

  Future<void> _takePhoto() async {
    try {
      final xfile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (xfile == null) return;
      setState(() => _photo = File(xfile.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kamera açılamadı: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final xfile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (xfile == null) return;
      setState(() => _photo = File(xfile.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Galeri açılamadı: $e')),
      );
    }
  }

  Future<void> _pickLabReturnDate() async {
    final today = _today;
    final initial = _labReturnDate ?? today.add(const Duration(days: 7));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Beklenen lab dönüşü',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _labReturnDate = picked;
      _labSent = true;
      _planForNext = false;
    });
  }

  void _setPlanForNext(bool value) {
    setState(() {
      _planForNext = value;
      if (value) {
        _labSent = false;
        _labReturnDate = null;
        _followUp = null;
      }
    });
  }

  void _toggleLab() {
    if (_labSent) {
      setState(() {
        _labSent = false;
        _labReturnDate = null;
      });
      return;
    }
    setState(() {
      _labSent = true;
      _planForNext = false;
      _labReturnDate ??= _today.add(const Duration(days: 7));
    });
  }

  Future<void> _openFollowUpSheet() async {
    final draft = await showSessionFollowUpSheet(
      context: context,
      sessionDate: _sessionDate,
      initial: _followUp,
    );
    if (draft == null || !mounted) return;
    setState(() {
      _followUp = draft;
      _planForNext = false;
    });
  }

  Future<void> _pickPhotoSource() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Fotoğraf',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'Hasta yüzü görünmesin. Yalnızca işlem / ağız içi görüntü.',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Fotoğraf çek'),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeriden seç'),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            if (_photo != null)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error,
                ),
                title: Text(
                  'Fotoğrafı kaldır',
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'camera':
        await _takePhoto();
      case 'gallery':
        await _pickFromGallery();
      case 'remove':
        setState(() => _photo = null);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showFormError('İşlem seçin veya işlem başlığı yazın');
      return;
    }

    final kapsam = _kapsam;
    if (kapsam == null) {
      _showFormError('Kapsam seçin');
      return;
    }

    final needTeeth = _requiresTooth || kapsam == TreatmentScope.tekDis;
    if (needTeeth && _selectedTeeth.isEmpty) {
      _showFormError('En az bir diş seçin');
      return;
    }

    final labActive = !_planForNext && _labEligible && _labSent;
    if (labActive && _labReturnDate == null) {
      _showFormError('Lab beklenen dönüş tarihini seçin');
      return;
    }

    final followUp = _planForNext ? null : _followUp;

    setState(() => _validationError = null);
    final note = _noteController.text.trim();

    if (_showKanal && kapsam == TreatmentScope.tekDis) {
      _persistActiveKanal();
    }

    setState(() {
      _saving = true;
      _uploadMessage = _photo != null
          ? 'Fotoğraf buluta yükleniyor…'
          : 'İşlem kaydediliyor…';
    });

    try {
      String? sharedPhotoUrl;
      TreatmentNote? createdNote;
      if (_photo != null) {
        sharedPhotoUrl = await widget.db.uploadSessionPhoto(
          hastaId: widget.patient.id,
          file: _photo!,
        );
        if (!mounted) return;
        setState(() => _uploadMessage = 'İşlem kaydediliyor…');
      }

      if (_showKanal && kapsam == TreatmentScope.tekDis) {
        // Her diş ayrı seans notu (kanal boyları dişe özel)
        for (final tooth in _orderedTeeth) {
          final draft = _kanalByTooth[tooth] ?? _KanalDraft();
          final boyu = draft.buildBoyuText(
            onlyCodes: visibleCanalsForTooth(
              tooth,
              extras: draft.ekstraKanallar,
            ),
          );
          final savedNote = await widget.db.saveNoteWithOptionalPhoto(
            hastaId: widget.patient.id,
            kapsam: TreatmentScope.tekDis,
            disNo: tooth,
            islemBaslik: title,
            kanalBoyu: boyu.isEmpty ? null : boyu,
            egeSistemi: draft.egeSistemi,
            kanalIlaci: draft.kanalIlaci,
            notIcerik: note,
            fotografUrl: sharedPhotoUrl,
            tarih: _sessionDateTimeForSave,
            planlandi: _planForNext,
            labGitti: labActive,
            labBeklenenTarih: labActive ? _labReturnDate : null,
          );
          createdNote ??= savedNote;
        }
      } else {
        final disNo = kapsam == TreatmentScope.tekDis
            ? formatToothSelection(_selectedTeeth)
            : null;

        createdNote = await widget.db.saveNoteWithOptionalPhoto(
          hastaId: widget.patient.id,
          kapsam: kapsam,
          disNo: disNo,
          islemBaslik: title,
          notIcerik: note,
          fotografUrl: sharedPhotoUrl,
          tarih: _sessionDateTimeForSave,
          planlandi: _planForNext,
          labGitti: labActive,
          labBeklenenTarih: labActive ? _labReturnDate : null,
        );
      }

      final noteForFollowUp = createdNote;
      if (noteForFollowUp == null) {
        throw StateError('İşlem oluşturulamadı');
      }

      if (labActive && _labReturnDate != null) {
        if (!mounted) return;
        setState(() => _uploadMessage = 'Lab hatırlatması oluşturuluyor…');
        final labFollowUp = await widget.db.createLabReminder(
          hastaId: widget.patient.id,
          islemBaslik: title,
          beklenenDonus: _labReturnDate!,
          seansNotuId: noteForFollowUp.id,
          hastaAdSoyad: widget.patient.adSoyad,
        );
        await NotificationService.instance.scheduleFollowUp(labFollowUp);
      }

      if (followUp != null) {
        if (!mounted) return;
        setState(() => _uploadMessage = 'Kontrol hatırlatması oluşturuluyor…');
        final dis = _selectedTeeth.isEmpty
            ? null
            : formatToothSelection(_selectedTeeth);
        final aciklama = [
          followUp.note,
          if (dis != null) 'Diş: $dis',
        ].join('\n');
        final kontrolFollowUp = await widget.db.createFollowUp(
          hastaId: widget.patient.id,
          baslik: 'Kontrol: $title',
          planlananTarih: followUp.controlDate,
          aciklama: aciklama,
          seansNotuId: noteForFollowUp.id,
          tur: 'genel',
          hatirlatmaGunOnce: followUp.reminderDaysBefore,
        );
        await NotificationService.instance.scheduleFollowUp(kontrolFollowUp);
      }

      if (!mounted) return;
      Navigator.of(context).pop(noteForFollowUp);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showFormError('Kayıt başarısız: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final kanalMulti = _showKanal &&
        _kapsam == TreatmentScope.tekDis &&
        _selectedTeeth.isNotEmpty;
    final saveLabel = _saving
        ? _uploadMessage
        : _planForNext
            ? 'Sonraki seansa planla'
            : (kanalMulti && _selectedTeeth.length > 1)
                ? '${_selectedTeeth.length} diş kaydet'
                : 'Kaydet';
    final scopes = _availableScopes;
    final showToothSelector =
        _requiresTooth || _kapsam == TreatmentScope.tekDis;

    final activeDraft = _activeKanalTooth == null
        ? null
        : _kanalByTooth.putIfAbsent(_activeKanalTooth!, _KanalDraft.new);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yeni İşlem',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              widget.patient.adSoyad,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed:
                            _saving ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_validationError != null) ...[
                          Material(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: scheme.onErrorContainer,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _validationError!,
                                      style: TextStyle(
                                        color: scheme.onErrorContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Kapat',
                                    visualDensity: VisualDensity.compact,
                                    onPressed: _clearFormError,
                                    icon: Icon(
                                      Icons.close,
                                      color: scheme.onErrorContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: false,
                              label: Text('Yapılan işlem'),
                              icon: Icon(Icons.check_circle_outline),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text('Sonraki seansa planla'),
                              icon: Icon(Icons.event_available),
                            ),
                          ],
                          selected: {_planForNext},
                          onSelectionChanged: _saving
                              ? null
                              : (set) => _setPlanForNext(set.first),
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        if (_planForNext) ...[
                          const SizedBox(height: 6),
                          Text(
                            'İşlem bugün yapılmadı sayılır; hasta bir sonraki '
                            'gelişinde üstte hatırlatılır.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          'İşlem tarihi',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.event_outlined,
                            color: scheme.primary,
                          ),
                          title: Text(
                            DateFormat('dd.MM.yyyy').format(_sessionDate),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _isPastSession
                                ? 'Geçmiş kayıt (defterden aktarım)'
                                : 'Bugün',
                          ),
                          trailing: TextButton(
                            onPressed: _saving ? null : _pickSessionDate,
                            child: const Text('Değiştir'),
                          ),
                          onTap: _saving ? null : _pickSessionDate,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'İşlem',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        if (_templatesLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: LinearProgressIndicator(),
                          )
                        else
                          Card(
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              leading: Icon(
                                Icons.medical_services_outlined,
                                color: _titleController.text.trim().isEmpty
                                    ? scheme.onSurfaceVariant
                                    : scheme.primary,
                              ),
                              title: Text(
                                _titleController.text.trim().isEmpty
                                    ? 'İşlem seçin'
                                    : _titleController.text.trim(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _titleController.text.trim().isEmpty
                                      ? scheme.onSurfaceVariant
                                      : null,
                                ),
                              ),
                              subtitle: _resolvedTemplate == null
                                  ? null
                                  : Text(_resolvedTemplate!.kategori),
                              trailing: TextButton(
                                onPressed:
                                    _saving ? null : _openTreatmentPicker,
                                child: Text(
                                  _titleController.text.trim().isEmpty
                                      ? 'Seç'
                                      : 'Değiştir',
                                ),
                              ),
                              onTap: _saving ? null : _openTreatmentPicker,
                            ),
                          ),
                        const SizedBox(height: 18),
                        Text(
                          'Kapsam',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _requiresTooth
                              ? 'Bu işlem için diş seçimi zorunlu'
                              : _kapsam == null
                                  ? 'Kapsam seçimi zorunlu'
                                  : 'İşleme uygun kapsam',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<TreatmentScope>(
                          emptySelectionAllowed: !_requiresTooth,
                          segments: scopes
                              .map(
                                (s) => ButtonSegment(
                                  value: s,
                                  label: Text(s.label,
                                      textAlign: TextAlign.center),
                                ),
                              )
                              .toList(),
                          selected: {
                            if (_kapsam != null && scopes.contains(_kapsam))
                              _kapsam!,
                          },
                          onSelectionChanged: (set) {
                            setState(() {
                              if (_requiresTooth) {
                                _kapsam = TreatmentScope.tekDis;
                                return;
                              }
                              _kapsam = set.isEmpty ? null : set.first;
                              if (_kapsam != TreatmentScope.tekDis) {
                                _selectedTeeth = {};
                                if (_showKanal) {
                                  _syncKanalDraftsWithSelection({});
                                }
                              }
                            });
                          },
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        if (showToothSelector) ...[
                          const SizedBox(height: 14),
                          ToothSelector(
                            selected: _selectedTeeth,
                            onChanged: _onTeethChanged,
                          ),
                        ],
                        if (_showKanal) ...[
                          const SizedBox(height: 14),
                          if (_kapsam != TreatmentScope.tekDis ||
                              _selectedTeeth.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Kanal parametreleri için önce diş seçin. '
                                'Birden fazla dişte her diş ayrı kaydedilir.',
                                style:
                                    TextStyle(color: scheme.onSurfaceVariant),
                              ),
                            )
                          else ...[
                            if (_selectedTeeth.length > 1) ...[
                              Text(
                                'Her diş için kanal bilgisi',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dişe dokunun, parametreleri girin. Kayıtta her diş ayrı not olur.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _orderedTeeth.map((tooth) {
                                  final draft = _kanalByTooth[tooth];
                                  final isActive = tooth == _activeKanalTooth;
                                  final filled = draft?.hasAnyBoy == true ||
                                      draft?.egeSistemi != null ||
                                      draft?.kanalIlaci != null;
                                  return FilterChip(
                                    label: Text(tooth),
                                    selected: isActive,
                                    showCheckmark: filled && !isActive,
                                    avatar: filled
                                        ? Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: isActive
                                                ? scheme.onSecondaryContainer
                                                : scheme.primary,
                                          )
                                        : null,
                                    onSelected: (_) => _loadKanalTooth(tooth),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Diş $_activeKanalTooth',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (activeDraft != null)
                              KanalParamsSection(
                                canalCodes: visibleCanalsForTooth(
                                  _activeKanalTooth,
                                  extras: activeDraft.ekstraKanallar,
                                ),
                                typicalCodes: canalsForTooth(_activeKanalTooth),
                                toothLabel: _activeKanalTooth,
                                kanalControllers: _kanalControllers,
                                selectedEge: activeDraft.egeSistemi,
                                selectedIlac: activeDraft.kanalIlaci,
                                onEgeChanged: (v) {
                                  setState(() => activeDraft.egeSistemi = v);
                                },
                                onIlacChanged: (v) {
                                  setState(() => activeDraft.kanalIlaci = v);
                                },
                                onAddCanal: _addExtraCanal,
                                onRemoveExtraCanal: _removeExtraCanal,
                              ),
                          ],
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          controller: _noteController,
                          minLines: 2,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Not (isteğe bağlı)',
                            hintText: 'Gerekirse buraya yazın…',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Ek seçenekler',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              avatar: _photo == null
                                  ? const Icon(Icons.photo_camera_outlined,
                                      size: 18)
                                  : null,
                              label: const Text('Fotoğraf'),
                              selected: _photo != null,
                              onSelected:
                                  _saving ? null : (_) => _pickPhotoSource(),
                            ),
                            if (!_planForNext)
                              FilterChip(
                                avatar: _followUp == null
                                    ? const Icon(Icons.notifications_outlined,
                                        size: 18)
                                    : null,
                                label: const Text('Takip oluştur'),
                                selected: _followUp != null,
                                onSelected: _saving
                                    ? null
                                    : (selected) {
                                        if (selected) {
                                          _openFollowUpSheet();
                                        } else {
                                          setState(() => _followUp = null);
                                        }
                                      },
                              ),
                            if (!_planForNext && _labEligible)
                              FilterChip(
                                avatar: !_labSent
                                    ? const Icon(Icons.science_outlined,
                                        size: 18)
                                    : null,
                                label: const Text('Lab’a gönder'),
                                selected: _labSent,
                                onSelected:
                                    _saving ? null : (_) => _toggleLab(),
                              ),
                          ],
                        ),
                        if (_photo != null) ...[
                          const SizedBox(height: 12),
                          LocalPhotoPreview(
                            file: _photo!,
                            onRemove: () => setState(() => _photo = null),
                          ),
                        ],
                        if (_followUp != null) ...[
                          const SizedBox(height: 12),
                          Card(
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              leading: Icon(
                                Icons.notifications_active_outlined,
                                color: scheme.primary,
                              ),
                              title: Text(
                                _followUp!.summary,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(_followUp!.note),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Düzenle',
                                    onPressed:
                                        _saving ? null : _openFollowUpSheet,
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Kaldır',
                                    onPressed: _saving
                                        ? null
                                        : () =>
                                            setState(() => _followUp = null),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (_labSent) ...[
                          const SizedBox(height: 12),
                          Card(
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              leading: Icon(
                                Icons.science_outlined,
                                color: scheme.primary,
                              ),
                              title: Text(
                                _labReturnDate == null
                                    ? 'Lab dönüş tarihi seçin'
                                    : 'Lab dönüşü: ${DateFormat('dd.MM.yyyy').format(_labReturnDate!)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: const Text(
                                'Dönüş tarihinden önce hatırlatılır',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Tarihi değiştir',
                                    onPressed:
                                        _saving ? null : _pickLabReturnDate,
                                    icon: const Icon(Icons.edit_calendar),
                                  ),
                                  IconButton(
                                    tooltip: 'Kaldır',
                                    onPressed: _saving ? null : _toggleLab,
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                if (_validationError != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Material(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 20,
                              color: scheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _validationError!,
                                style: TextStyle(
                                  color: scheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _planForNext ? Icons.event_available : Icons.save),
                    label: Text(saveLabel),
                  ),
                ),
              ],
            ),
            CloudUploadOverlay(
              visible: _saving,
              message: _uploadMessage,
            ),
          ],
        ),
      ),
    );
  }
}
