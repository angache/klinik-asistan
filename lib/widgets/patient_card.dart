import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../screens/patient_detail_screen.dart';
import '../services/database_service.dart';

/// Dashboard satırı — tıklanınca hasta detay sayfasına gider.
class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.patient,
    required this.db,
  });

  final Patient patient;
  final DatabaseService db;

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientDetailScreen(patient: patient, db: db),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final phone = patient.telefon?.trim();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => _openDetail(context),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text(
            patient.adSoyad.isNotEmpty
                ? patient.adSoyad[0].toUpperCase()
                : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.adSoyad,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          (phone != null && phone.isNotEmpty) ? phone : 'Telefon yok',
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
