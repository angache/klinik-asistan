import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../services/database_service.dart';
import 'edit_session_dialog.dart';
import 'full_screen_image.dart';
import 'note_history_sheet.dart';
import 'photo_preview.dart';

class TreatmentNoteTile extends StatelessWidget {
  const TreatmentNoteTile({
    super.key,
    required this.note,
    required this.patient,
    required this.db,
    this.onChanged,
  });

  final TreatmentNote note;
  final Patient patient;
  final DatabaseService db;
  final Future<void> Function()? onChanged;

  Future<void> _edit(BuildContext context) async {
    final ok = await showEditSessionDialog(
      context: context,
      patient: patient,
      db: db,
      note: note,
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yeni sürüm kaydedildi')),
      );
      await onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateStr = DateFormat('dd.MM.yyyy').format(note.tarih);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ScopeBadge(
                label: note.kapsam.badgeLabel(disNo: note.disNo),
              ),
              if (note.isEdited) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: scheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'v${note.versiyon}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                dateStr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.islemBaslik,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (note.notIcerik.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              note.notIcerik,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (note.kanalBoyu != null && note.kanalBoyu!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Kanal boyu: ${note.kanalBoyu}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
          if (note.egeSistemi != null || note.kanalIlaci != null) ...[
            const SizedBox(height: 2),
            Text(
              [
                if (note.egeSistemi != null) 'Eğe: ${note.egeSistemi}',
                if (note.kanalIlaci != null) 'İlaç: ${note.kanalIlaci}',
              ].join(' · '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
          if (note.degisiklikOzeti != null &&
              note.degisiklikOzeti!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              note.degisiklikOzeti!.split('\n').first,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.tertiary,
                    fontStyle: FontStyle.italic,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (note.hasPhoto) ...[
            const SizedBox(height: 10),
            NetworkPhotoThumbnail(
              url: note.fotografUrl!,
              onTap: () => FullScreenImage.open(context, note.fotografUrl!),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _edit(context),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Düzenle'),
              ),
              TextButton.icon(
                onPressed: () => showNoteHistorySheet(
                  context: context,
                  db: db,
                  note: note,
                ),
                icon: const Icon(Icons.history, size: 18),
                label: const Text('Geçmiş'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScopeBadge extends StatelessWidget {
  const _ScopeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
