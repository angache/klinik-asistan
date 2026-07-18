import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/treatment_templates.dart';

const _kRecentPrefsKey = 'recent_islem_basliklari';
const _kRecentLimit = 6;

/// Son seçilen işlem başlığını hatırla (sık kullanılanlar için).
Future<void> rememberTreatmentPick(String baslik) async {
  final title = baslik.trim();
  if (title.isEmpty) return;
  try {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kRecentPrefsKey) ?? <String>[];
    list.removeWhere((e) => e.toLowerCase() == title.toLowerCase());
    list.insert(0, title);
    await prefs.setStringList(
      _kRecentPrefsKey,
      list.take(_kRecentLimit).toList(),
    );
  } catch (_) {}
}

/// İşlem seçme modalı — arama, sık kullanılanlar ve kategoriler.
/// Yeni işlem oluşturma burada yok; şablon yönetimi ayrı ekrandadır.
Future<TreatmentTemplate?> showTreatmentPickerSheet({
  required BuildContext context,
  required List<TreatmentTemplate> templates,
  TreatmentTemplate? selected,
}) {
  final size = MediaQuery.sizeOf(context);
  final isWide = size.width >= 700;

  if (isWide) {
    return showDialog<TreatmentTemplate>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
          child: _TreatmentPicker(
            templates: templates,
            selected: selected,
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<TreatmentTemplate>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.85,
      child: _TreatmentPicker(
        templates: templates,
        selected: selected,
      ),
    ),
  );
}

class _TreatmentPicker extends StatefulWidget {
  const _TreatmentPicker({
    required this.templates,
    this.selected,
  });

  final List<TreatmentTemplate> templates;
  final TreatmentTemplate? selected;

  @override
  State<_TreatmentPicker> createState() => _TreatmentPickerState();
}

class _TreatmentPickerState extends State<_TreatmentPicker> {
  final _search = TextEditingController();
  TreatmentTemplate? _selected;
  List<String> _recent = const [];

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kRecentPrefsKey) ?? const [];
      if (!mounted) return;
      setState(() => _recent = list);
    } catch (_) {}
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String get _query => _search.text.trim().toLowerCase();

  List<TreatmentTemplate> get _filtered {
    final q = _query;
    if (q.isEmpty) return widget.templates;
    return widget.templates
        .where((t) =>
            t.baslik.toLowerCase().contains(q) ||
            t.kategori.toLowerCase().contains(q))
        .toList();
  }

  List<TreatmentTemplate> get _recentTemplates {
    final byTitle = {
      for (final t in widget.templates) t.baslik.toLowerCase(): t,
    };
    return [
      for (final title in _recent)
        if (byTitle[title.toLowerCase()] != null) byTitle[title.toLowerCase()]!,
    ];
  }

  void _pick(TreatmentTemplate t) {
    setState(() => _selected = t);
  }

  void _apply() {
    final t = _selected;
    if (t == null) return;
    rememberTreatmentPick(t.baslik);
    Navigator.pop(context, t);
  }

  Widget _chip(TreatmentTemplate t) {
    final isSelected = _selected == t ||
        (_selected?.baslik.toLowerCase() == t.baslik.toLowerCase());
    return FilterChip(
      label: Text(t.baslik),
      selected: isSelected,
      showCheckmark: false,
      avatar: isSelected ? const Icon(Icons.check, size: 16) : null,
      onSelected: (_) => _pick(t),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filtered = _filtered;
    final recents =
        _query.isEmpty ? _recentTemplates : const <TreatmentTemplate>[];
    final categories = <String>[];
    for (final t in filtered) {
      if (!categories.contains(t.kategori)) categories.add(t.kategori);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'İşlem seç',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _search,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'İşlem ara…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Eşleşen işlem yok',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    )
                  : ListView(
                      children: [
                        if (recents.isNotEmpty) ...[
                          Text(
                            'Sık kullanılanlar',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: scheme.primary),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: recents.map(_chip).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],
                        for (final cat in categories) ...[
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
                            children: filtered
                                .where((t) => t.kategori == cat)
                                .map(_chip)
                                .toList(),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _selected == null ? null : _apply,
                  child: const Text('Uygula'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
