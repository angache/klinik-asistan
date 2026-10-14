import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/treatment_templates.dart';
import '../l10n/l10n.dart';
import '../models/patient.dart';
import '../screens/patient_detail_screen.dart';
import '../services/database_service.dart';
import 'new_session_dialog.dart';

/// Dashboard satırı — tıklanınca hasta detayına gider (veya onOpen).
class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.patient,
    required this.db,
    this.onOpen,
    this.selected = false,
  });

  final Patient patient;
  final DatabaseService db;
  final VoidCallback? onOpen;
  final bool selected;

  void _openDetail(BuildContext context) {
    if (onOpen != null) {
      onOpen!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientDetailScreen(patient: patient, db: db),
      ),
    );
  }

  Future<void> _openNewSession(BuildContext context) async {
    final note = await showNewSessionDialog(
      context: context,
      patient: patient,
      db: db,
    );
    if (note == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.procedureSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final phone = patient.telefon?.trim();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.45) : null,
      child: ListTile(
        selected: selected,
        onTap: () => _openDetail(context),
        leading: CircleAvatar(
          backgroundColor: selected ? scheme.primary : scheme.primaryContainer,
          foregroundColor:
              selected ? scheme.onPrimary : scheme.onPrimaryContainer,
          child: Text(
            patient.adSoyad.isNotEmpty ? patient.adSoyad[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.adSoyad,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            (phone != null && phone.isNotEmpty) ? phone : context.l10n.noPhone,
            if (patient.planlananBasliklar.isNotEmpty)
              '→ ${patient.planlananBasliklar.join(', ')}',
            if (patient.sonIslemBaslik?.trim().isNotEmpty == true)
              patient.sonIslemTarih != null
                  ? '${DateFormat.yMd().add_Hm().format(patient.sonIslemTarih!.toLocal())} · ${procedureLabel(patient.sonIslemBaslik!.trim())}'
                  : procedureLabel(patient.sonIslemBaslik!.trim()),
          ].join('\n'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: context.l10n.newProcedure,
              onPressed: () => _openNewSession(context),
              icon: const Icon(Icons.add_circle_outline),
            ),
            if (onOpen == null)
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
