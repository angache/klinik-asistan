import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/tooth_canals.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../services/database_service.dart';
import 'kanal_params_section.dart';
import 'photo_preview.dart';
import 'tooth_selector.dart';

Future<bool?> showEditSessionDialog({
  required BuildContext context,
  required Patient patient,
  required DatabaseService db,
  required TreatmentNote note,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EditSessionDialog(patient: patient, db: db, note: note),
  );
}

/// "MB: 19mm, P: 21mm" → map
Map<String, String> parseKanalBoyu(String? raw) {
  final out = <String, String>{};
  if (raw == null || raw.trim().isEmpty) return out;
  for (final part in raw.split(',')) {
    final p = part.trim();
    final m = RegExp(r'^([A-Za-z0-9]+)\s*:\s*([\d.]+)\s*mm$', caseSensitive: false)
        .firstMatch(p);
    if (m != null) {
      out[m.group(1)!] = m.group(2)!;
    }
  }
  return out;
}

class EditSessionDialog extends StatefulWidget {
  const EditSessionDialog({
    super.key,
    required this.patient,
    required this.db,
    required this.note,
  });

  final Patient patient;
  final DatabaseService db;
  final TreatmentNote note;

  @override
  State<EditSessionDialog> createState() => _EditSessionDialogState();
}

class _EditSessionDialogState extends State<EditSessionDialog> {
  late TreatmentScope _kapsam;
  late Set<String> _selectedTeeth;
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final Map<String, TextEditingController> _kanalControllers;
  late List<String> _ekstraKanallar;
  String? _egeSistemi;
  String? _kanalIlaci;
  String? _existingPhotoUrl;
  File? _newPhoto;
  bool _removePhoto = false;
  bool _saving = false;

  bool get _showKanal {
    final t = _titleController.text.toLowerCase();
    return t.contains('kanal') ||
        (widget.note.kanalBoyu?.isNotEmpty == true) ||
        widget.note.egeSistemi != null ||
        widget.note.kanalIlaci != null;
  }

  String? get _activeTooth {
    if (_selectedTeeth.isEmpty) return null;
    return _selectedTeeth.length == 1
        ? _selectedTeeth.first
        : _selectedTeeth.first;
  }

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _kapsam = n.kapsam;
    _selectedTeeth = parseToothSelection(n.disNo);
    _titleController = TextEditingController(text: n.islemBaslik);
    _noteController = TextEditingController(text: n.notIcerik);
    _egeSistemi = n.egeSistemi;
    _kanalIlaci = n.kanalIlaci;
    _existingPhotoUrl = n.fotografUrl;

    final parsed = parseKanalBoyu(n.kanalBoyu);
    final typical = canalsForTooth(
      _selectedTeeth.length == 1 ? _selectedTeeth.first : null,
    );
    _ekstraKanallar = parsed.keys.where((k) => !typical.contains(k)).toList();
    _kanalControllers = {
      for (final k in {...kAllKanalKodlari, ...parsed.keys})
        k: TextEditingController(text: parsed[k] ?? ''),
    };
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    for (final c in _kanalControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final xfile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (xfile == null) return;
      setState(() {
        _newPhoto = File(xfile.path);
        _removePhoto = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf açılamadı: $e')),
      );
    }
  }

  Future<void> _addExtraCanal() async {
    final tooth = _activeTooth;
    final available = availableExtraCanals(tooth, extras: _ekstraKanallar);
    final customCtrl = TextEditingController();
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ekstra kanal ekle',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: available
                    .map(
                      (kod) => ActionChip(
                        label: Text(kod),
                        onPressed: () => Navigator.pop(ctx, kod),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: customCtrl,
                decoration: const InputDecoration(
                  labelText: 'Özel kanal adı',
                ),
              ),
              const SizedBox(height: 8),
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
      ),
    );
    if (selected == null || selected.trim().isEmpty) return;
    final kod = selected.trim();
    setState(() {
      if (!_ekstraKanallar.contains(kod) &&
          !canalsForTooth(tooth).contains(kod)) {
        _ekstraKanallar.add(kod);
        _kanalControllers.putIfAbsent(kod, TextEditingController.new);
      }
    });
  }

  Future<void> _save() async {
    if (_kapsam == TreatmentScope.tekDis && _selectedTeeth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir diş seçin')),
      );
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İşlem başlığı zorunludur')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      String? photoUrl = _removePhoto ? null : _existingPhotoUrl;
      if (_newPhoto != null) {
        photoUrl = await widget.db.uploadSessionPhoto(
          hastaId: widget.patient.id,
          file: _newPhoto!,
        );
      }

      final tooth = _selectedTeeth.length == 1 ? _selectedTeeth.first : null;
      final codes = _showKanal
          ? visibleCanalsForTooth(tooth, extras: _ekstraKanallar)
          : <String>[];
      final kanalBoyu = _showKanal
          ? buildKanalBoyuText(_kanalControllers, onlyCodes: codes)
          : null;

      final disNo = _kapsam == TreatmentScope.tekDis
          ? formatToothSelection(_selectedTeeth)
          : null;

      final result = await widget.db.saveEditedNoteAsNewVersion(
        previous: widget.note,
        kapsam: _kapsam,
        disNo: disNo,
        islemBaslik: title,
        kanalBoyu: (kanalBoyu == null || kanalBoyu.isEmpty) ? null : kanalBoyu,
        egeSistemi: _showKanal ? _egeSistemi : null,
        kanalIlaci: _showKanal ? _kanalIlaci : null,
        notIcerik: _noteController.text.trim(),
        fotografUrl: photoUrl,
        tarih: widget.note.tarih,
      );

      if (!mounted) return;
      if (result.id == widget.note.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Değişiklik yok')),
        );
        Navigator.pop(context, false);
        return;
      }
      Navigator.pop(context, true);
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
    final tooth = _selectedTeeth.length == 1 ? _selectedTeeth.first : null;
    final canalCodes =
        visibleCanalsForTooth(tooth, extras: _ekstraKanallar);

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
                          'Seansı düzenle',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'v${widget.note.versiyon} → yeni sürüm kaydedilir; eski korunur',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
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
                        onChanged: (t) => setState(() => _selectedTeeth = t),
                      ),
                    ],
                    const SizedBox(height: 14),
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
                        alignLabelWithHint: true,
                      ),
                    ),
                    if (_showKanal) ...[
                      const SizedBox(height: 14),
                      KanalParamsSection(
                        canalCodes: canalCodes,
                        typicalCodes: canalsForTooth(tooth),
                        toothLabel: tooth,
                        kanalControllers: _kanalControllers,
                        selectedEge: _egeSistemi,
                        selectedIlac: _kanalIlaci,
                        onEgeChanged: (v) => setState(() => _egeSistemi = v),
                        onIlacChanged: (v) => setState(() => _kanalIlaci = v),
                        onAddCanal: _addExtraCanal,
                        onRemoveExtraCanal: (kod) {
                          setState(() {
                            _ekstraKanallar.remove(kod);
                            _kanalControllers[kod]?.clear();
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      'Fotoğraf',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (_newPhoto != null)
                      LocalPhotoPreview(
                        file: _newPhoto!,
                        onRemove: () => setState(() => _newPhoto = null),
                      )
                    else if (_existingPhotoUrl != null && !_removePhoto)
                      Column(
                        children: [
                          NetworkPhotoThumbnail(
                            url: _existingPhotoUrl!,
                            onTap: () {},
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _removePhoto = true;
                              _existingPhotoUrl = null;
                            }),
                            child: const Text('Fotoğrafı kaldır'),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saving
                                  ? null
                                  : () => _pickPhoto(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Çek'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saving
                                  ? null
                                  : () => _pickPhoto(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Galeri'),
                            ),
                          ),
                        ],
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
                label: Text(
                  _saving ? 'Kaydediliyor…' : 'Yeni sürüm olarak kaydet',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
