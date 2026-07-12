import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/tooth_canals.dart';
import '../data/treatment_templates.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'follow_up_planner.dart';
import 'kanal_params_section.dart';
import 'photo_preview.dart';
import 'tooth_selector.dart';

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
  TreatmentScope _kapsam = TreatmentScope.tumAgiz;
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

  bool _planFollowUp = false;
  int? _followUpPresetDays = 30;
  DateTime? _followUpCustomDate;
  final _followUpNoteCtrl = TextEditingController();

  final _picker = ImagePicker();

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
    _noteController.dispose();
    _titleController.dispose();
    _followUpNoteCtrl.dispose();
    for (final c in _kanalControllers.values) {
      c.dispose();
    }
    super.dispose();
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

  void _applyTemplate(TreatmentTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _titleController.text = template.baslik;
      _showKanal = template.isKanal;
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

  Future<void> _save() async {
    if (_kapsam == TreatmentScope.tekDis && _selectedTeeth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir diş seçin')),
      );
      return;
    }

    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İşlem başlığı zorunludur')),
      );
      return;
    }

    if (_showKanal && _kapsam == TreatmentScope.tekDis) {
      _persistActiveKanal();
    }

    setState(() => _saving = true);

    try {
      String? sharedPhotoUrl;
      TreatmentNote? createdNote;
      if (_photo != null) {
        sharedPhotoUrl = await widget.db.uploadSessionPhoto(
          hastaId: widget.patient.id,
          file: _photo!,
        );
      }

      if (_showKanal && _kapsam == TreatmentScope.tekDis) {
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
          );
          createdNote ??= savedNote;
        }
      } else {
        final disNo = _kapsam == TreatmentScope.tekDis
            ? formatToothSelection(_selectedTeeth)
            : null;

        createdNote = await widget.db.saveNoteWithOptionalPhoto(
          hastaId: widget.patient.id,
          kapsam: _kapsam,
          disNo: disNo,
          islemBaslik: title,
          notIcerik: note,
          fotografUrl: sharedPhotoUrl,
        );
      }

      final noteForFollowUp = createdNote;
      if (noteForFollowUp == null) {
        throw StateError('Seans notu oluşturulamadı');
      }

      if (_planFollowUp) {
        final when = _followUpPresetDays != null
            ? FollowUpPlanner.dateFromPreset(_followUpPresetDays!)
            : _followUpCustomDate;
        if (when == null) {
          throw Exception('Takip tarihi seçin');
        }
        final followNote = _followUpNoteCtrl.text.trim();
        final followUp = await widget.db.createFollowUp(
          hastaId: widget.patient.id,
          baslik: followNote.isNotEmpty ? followNote : '$title — kontrol',
          planlananTarih: when,
          aciklama: followNote.isEmpty ? null : followNote,
          seansNotuId: noteForFollowUp.id,
        );
        await NotificationService.instance.scheduleFollowUp(followUp);
      }

      if (!mounted) return;
      Navigator.of(context).pop(noteForFollowUp);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categories = <String>{
      for (final t in kTreatmentTemplates) t.kategori,
    }.toList();

    final kanalMulti = _showKanal &&
        _kapsam == TreatmentScope.tekDis &&
        _selectedTeeth.isNotEmpty;
    final saveLabel = _saving
        ? 'Kaydediliyor…'
        : (kanalMulti && _selectedTeeth.length > 1)
            ? '${_selectedTeeth.length} diş kaydet'
            : 'Kaydet';

    final activeDraft = _activeKanalTooth == null
        ? null
        : _kanalByTooth.putIfAbsent(_activeKanalTooth!, _KanalDraft.new);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: Column(
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
                          'Yeni Seans Notu',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.patient.adSoyad,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kapsam',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<TreatmentScope>(
                      segments: TreatmentScope.values
                          .map(
                            (s) => ButtonSegment(
                              value: s,
                              label: Text(s.label, textAlign: TextAlign.center),
                            ),
                          )
                          .toList(),
                      selected: {_kapsam},
                      onSelectionChanged: (set) {
                        setState(() {
                          _kapsam = set.first;
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
                    if (_kapsam == TreatmentScope.tekDis) ...[
                      const SizedBox(height: 14),
                      ToothSelector(
                        selected: _selectedTeeth,
                        onChanged: _onTeethChanged,
                      ),
                    ],
                    const SizedBox(height: 18),
                    Text(
                      'İşlem',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...categories.map((cat) {
                      final items = kTreatmentTemplates
                          .where((t) => t.kategori == cat)
                          .toList();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: scheme.primary),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: items.map((t) {
                                final selected = _selectedTemplate == t;
                                return FilterChip(
                                  label: Text(t.baslik),
                                  selected: selected,
                                  onSelected: (_) => _applyTemplate(t),
                                  showCheckmark: false,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'İşlem Başlığı',
                      ),
                    ),
                    const SizedBox(height: 12),
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
                            style: TextStyle(color: scheme.onSurfaceVariant),
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
                    Text(
                      'Fotoğraf',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hasta yüzü görünmesin. Yalnızca işlem / ağız içi görüntü.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (_photo != null)
                      LocalPhotoPreview(
                        file: _photo!,
                        onRemove: () => setState(() => _photo = null),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saving ? null : _takePhoto,
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Fotoğraf Çek'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saving ? null : _pickFromGallery,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Galeriden'),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    FollowUpPlanner(
                      enabled: _planFollowUp,
                      onEnabledChanged: (v) =>
                          setState(() => _planFollowUp = v),
                      presetDays: _followUpPresetDays,
                      onPresetChanged: (d) => setState(() {
                        _followUpPresetDays = d;
                        _followUpCustomDate = null;
                      }),
                      customDate: _followUpCustomDate,
                      onPickDate: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now.add(const Duration(days: 30)),
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 365 * 3)),
                        );
                        if (picked == null) return;
                        setState(() {
                          _followUpCustomDate = picked;
                          _followUpPresetDays = null;
                        });
                      },
                      noteController: _followUpNoteCtrl,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(saveLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
