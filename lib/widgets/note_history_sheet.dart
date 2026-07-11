import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/treatment_note.dart';
import '../services/database_service.dart';
import 'full_screen_image.dart';
import 'photo_preview.dart';

Future<void> showNoteHistorySheet({
  required BuildContext context,
  required DatabaseService db,
  required TreatmentNote note,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _NoteHistorySheet(db: db, note: note),
  );
}

class _NoteHistorySheet extends StatefulWidget {
  const _NoteHistorySheet({required this.db, required this.note});

  final DatabaseService db;
  final TreatmentNote note;

  @override
  State<_NoteHistorySheet> createState() => _NoteHistorySheetState();
}

class _NoteHistorySheetState extends State<_NoteHistorySheet> {
  late Future<List<TreatmentNote>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.db.getNoteVersions(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = MediaQuery.sizeOf(context).height * 0.75;

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Sürüm geçmişi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.note.islemBaslik,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<TreatmentNote>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Geçmiş yüklenemedi: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.error),
                      ),
                    ),
                  );
                }
                final versions = snapshot.data ?? [];
                if (versions.isEmpty) {
                  return const Center(child: Text('Sürüm bulunamadı'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    final v = versions[versions.length - 1 - index]; // yeni üstte
                    final prev = index < versions.length - 1
                        ? versions[versions.length - 2 - index]
                        : null;
                    return _VersionCard(note: v, previous: prev);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({required this.note, this.previous});

  final TreatmentNote note;
  final TreatmentNote? previous;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dt = DateFormat('dd.MM.yyyy HH:mm').format(note.olusturmaTarihi.toLocal());
    final changes = note.degisiklikOzeti?.split('\n').where((e) => e.trim().isNotEmpty).toList() ??
        (previous != null ? diffTreatmentNotes(previous!, note) : <String>[]);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: note.guncel
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: note.guncel ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'v${note.versiyon}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              if (note.guncel)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Güncel',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimary,
                    ),
                  ),
                )
              else
                Text(
                  'Eski sürüm',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              const Spacer(),
              Text(
                dt,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.islemBaslik,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            note.kapsam.badgeLabel(disNo: note.disNo),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (note.notIcerik.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(note.notIcerik),
          ],
          if (note.kanalBoyu?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              'Kanal: ${note.kanalBoyu}',
              style: TextStyle(color: scheme.primary, fontSize: 13),
            ),
          ],
          if (changes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Bu sürümde değişenler',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            ...changes.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: scheme.primary)),
                    Expanded(child: Text(c, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),
          ] else if (note.versiyon == 1) ...[
            const SizedBox(height: 8),
            Text(
              'İlk kayıt',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (note.hasPhoto) ...[
            const SizedBox(height: 10),
            NetworkPhotoThumbnail(
              url: note.fotografUrl!,
              onTap: () => FullScreenImage.open(context, note.fotografUrl!),
            ),
          ],
        ],
      ),
    );
  }
}
