import 'package:flutter/material.dart';

import '../data/treatment_templates.dart';
import '../l10n/l10n.dart';
import '../services/database_service.dart';

class TreatmentTemplatesScreen extends StatefulWidget {
  const TreatmentTemplatesScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<TreatmentTemplatesScreen> createState() =>
      _TreatmentTemplatesScreenState();
}

class _TreatmentTemplatesScreenState extends State<TreatmentTemplatesScreen> {
  List<TreatmentTemplate> _items = [];
  bool _loading = true;
  bool _busy = false;
  Object? _error;
  bool _showInactive = false;

  bool get _canEdit => widget.db.canManageRecords;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.db.ensureTreatmentTemplates();
      final list = await widget.db.getTreatmentTemplates(onlyActive: false);
      if (!mounted) return;
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  List<TreatmentTemplate> get _visible {
    if (_showInactive) return _items;
    return _items.where((e) => e.aktif).toList();
  }

  Future<void> _seedMissing() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final n = await widget.db.seedMissingTreatmentDefaults();
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            n == 0
                ? l10n.noMissingDefaults
                : l10n.defaultsAdded(n),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addFailed(errorText(e)))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openEditor({TreatmentTemplate? existing}) async {
    if (!_canEdit) return;
    final result = await showDialog<_TemplateEditResult>(
      context: context,
      builder: (_) => _TemplateEditDialog(existing: existing),
    );
    if (result == null) return;

    setState(() => _busy = true);
    try {
      if (existing?.id == null) {
        await widget.db.createTreatmentTemplate(
          kategori: result.kategori,
          baslik: result.baslik,
          isKanal: result.isKanal,
          requiresTooth: result.requiresTooth,
          labTakip: result.labTakip,
          kontrolAy: result.kontrolAy,
        );
      } else {
        await widget.db.updateTreatmentTemplate(
          id: existing!.id!,
          kategori: result.kategori,
          baslik: result.baslik,
          isKanal: result.isKanal,
          requiresTooth: result.requiresTooth,
          labTakip: result.labTakip,
          aktif: result.aktif,
          kontrolAy: result.kontrolAy,
        );
      }
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.saveFailed(errorText(e)))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleActive(TreatmentTemplate t) async {
    if (!_canEdit || t.id == null) return;
    setState(() => _busy = true);
    try {
      await widget.db.updateTreatmentTemplate(
        id: t.id!,
        kategori: t.kategori,
        baslik: t.baslik,
        isKanal: t.isKanal,
        requiresTooth: t.requiresTooth,
        labTakip: t.labTakip,
        aktif: !t.aktif,
        kontrolAy: t.kontrolAy,
        sira: t.sira,
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.updateFailed(errorText(e)))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete(TreatmentTemplate t) async {
    if (!_canEdit || t.id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.deleteProcedureTitle),
        content: Text(ctx.l10n.deleteTemplateConfirm(t.baslik)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await widget.db.deleteTreatmentTemplate(t.id!);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.deleteFailed(errorText(e)))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.treatmentTemplates),
        actions: [
          if (_canEdit)
            IconButton(
              tooltip: l10n.seedMissingTooltip,
              onPressed: _busy ? null : _seedMissing,
              icon: const Icon(Icons.playlist_add_check),
            ),
          IconButton(
            tooltip: _showInactive ? l10n.hideInactive : l10n.showInactive,
            onPressed: () => setState(() => _showInactive = !_showInactive),
            icon: Icon(
              _showInactive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: _canEdit
          ? FloatingActionButton.extended(
              onPressed: _busy ? null : () => _openEditor(),
              icon: const Icon(Icons.add),
              label: Text(l10n.addProcedure),
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.loadFailed(errorText(_error)),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.error),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _load,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    children: [
                      Text(
                        l10n.templatesIntro,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      if (!_canEdit) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.templatesEditRestricted,
                          style: TextStyle(color: scheme.tertiary),
                        ),
                      ],
                      const SizedBox(height: 16),
                      for (final cat in [
                        ...{for (final t in _visible) t.kategori},
                      ]) ...[
                        Text(
                          categoryLabel(cat),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ..._visible.where((t) => t.kategori == cat).map((t) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                t.baslik,
                                style: TextStyle(
                                  decoration: t.aktif
                                      ? null
                                      : TextDecoration.lineThrough,
                                  color: t.aktif
                                      ? null
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                              subtitle: Text(
                                [
                                  if (t.isKanal) l10n.tagCanal,
                                  if (t.requiresTooth) l10n.tagToothRequired else l10n.tagJawOk,
                                  if (t.labTakip) l10n.tagLabTracking,
                                  if (t.kontrolAy != null)
                                    l10n.tagCheckupMonths(t.kontrolAy!),
                                  if (!t.aktif) l10n.tagInactive,
                                ].join(' · '),
                              ),
                              onTap: _canEdit ? () => _openEditor(existing: t) : null,
                              trailing: _canEdit
                                  ? PopupMenuButton<String>(
                                      onSelected: (v) {
                                        if (v == 'edit') {
                                          _openEditor(existing: t);
                                        } else if (v == 'toggle') {
                                          _toggleActive(t);
                                        } else if (v == 'delete') {
                                          _confirmDelete(t);
                                        }
                                      },
                                      itemBuilder: (_) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text(l10n.edit),
                                        ),
                                        PopupMenuItem(
                                          value: 'toggle',
                                          child: Text(
                                            t.aktif ? l10n.deactivate : l10n.activate,
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text(l10n.delete),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                      if (_visible.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              l10n.noTemplatesYet,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _TemplateEditResult {
  const _TemplateEditResult({
    required this.kategori,
    required this.baslik,
    required this.isKanal,
    required this.requiresTooth,
    required this.labTakip,
    required this.aktif,
    required this.kontrolAy,
  });

  final String kategori;
  final String baslik;
  final bool isKanal;
  final bool requiresTooth;
  final bool labTakip;
  final bool aktif;
  final int? kontrolAy;
}

class _TemplateEditDialog extends StatefulWidget {
  const _TemplateEditDialog({this.existing});

  final TreatmentTemplate? existing;

  @override
  State<_TemplateEditDialog> createState() => _TemplateEditDialogState();
}

class _TemplateEditDialogState extends State<_TemplateEditDialog> {
  late final TextEditingController _baslik;
  late String _kategori;
  late bool _isKanal;
  late bool _requiresTooth;
  late bool _labTakip;
  late bool _aktif;
  int? _kontrolAy;
  final _formKey = GlobalKey<FormState>();

  static const _kontrolOptions = [3, 6, 12];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _baslik = TextEditingController(text: e?.baslik ?? '');
    _kategori = e?.kategori ?? kIslemKategorileri.first;
    if (!kIslemKategorileri.contains(_kategori)) {
      _kategori = kIslemKategorileri.first;
    }
    _isKanal = e?.isKanal ?? false;
    _requiresTooth = e?.requiresTooth ?? true;
    _labTakip = e?.labTakip ?? (_kategori == 'Protez');
    _aktif = e?.aktif ?? true;
    _kontrolAy = e?.kontrolAy;
  }

  @override
  void dispose() {
    _baslik.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(editing ? l10n.editProcedureTitle : l10n.newProcedure),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: InputDecoration(labelText: l10n.category),
                items: kIslemKategorileri
                    .map((c) => DropdownMenuItem(value: c, child: Text(categoryLabel(c))))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _kategori = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _baslik,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.procedureName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.canalProcedure),
                subtitle: Text(l10n.canalProcedureHint),
                value: _isKanal,
                onChanged: (v) => setState(() {
                  _isKanal = v;
                  if (v) _requiresTooth = true;
                }),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.toothRequired),
                subtitle: Text(l10n.toothRequiredHint),
                value: _requiresTooth,
                onChanged: _isKanal
                    ? null
                    : (v) => setState(() => _requiresTooth = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.labTracking),
                subtitle: Text(l10n.labTrackingHint),
                value: _labTakip,
                onChanged: (v) => setState(() => _labTakip = v),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<int?>(
                initialValue: _kontrolAy,
                decoration: InputDecoration(
                  labelText: l10n.periodicCheckup,
                  helperText: l10n.periodicCheckupHelper,
                  helperMaxLines: 2,
                ),
                items: [
                  DropdownMenuItem<int?>(child: Text(l10n.none)),
                  for (final m in {
                    ..._kontrolOptions,
                    if (_kontrolAy != null) _kontrolAy!,
                  })
                    DropdownMenuItem<int?>(value: m, child: Text(l10n.monthsAfter(m))),
                ],
                onChanged: (v) => setState(() => _kontrolAy = v),
              ),
              if (editing)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.active),
                  value: _aktif,
                  onChanged: (v) => setState(() => _aktif = v),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              _TemplateEditResult(
                kategori: _kategori,
                baslik: _baslik.text.trim(),
                isKanal: _isKanal,
                requiresTooth: _isKanal ? true : _requiresTooth,
                labTakip: _labTakip,
                aktif: _aktif,
                kontrolAy: _kontrolAy,
              ),
            );
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
