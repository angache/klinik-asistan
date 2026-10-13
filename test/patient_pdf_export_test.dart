import 'package:flutter_test/flutter_test.dart';

import 'package:klinik_asistan/models/patient.dart';
import 'package:klinik_asistan/models/treatment_note.dart';
import 'package:klinik_asistan/services/patient_pdf_export.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TreatmentNote note(String baslik, {bool planlandi = false}) => TreatmentNote(
        id: baslik,
        hastaId: 'h1',
        kapsam: TreatmentScope.tekDis,
        disNo: '36',
        islemBaslik: baslik,
        kanalBoyu: 'MB: 19mm, MB 2: 19,5mm',
        notIcerik: 'Şişlik ığdır çöğüş',
        fotografUrls: const ['a.jpg'],
        tarih: DateTime(2026, 9, 1, 10),
        olusturmaTarihi: DateTime(2026, 9, 1, 10),
        planlandi: planlandi,
      );

  test('Türkçe içerikli PDF oluşturulur', () async {
    final bytes = await PatientPdfExport.build(
      patient: Patient(
        id: 'h1',
        adSoyad: 'Ayşe Yılmaz',
        telefon: '0555',
        olusturmaTarihi: DateTime(2026, 1, 2),
      ),
      notes: [
        note('Kanal Başlangıç'),
        note('Daimi Simantasyon', planlandi: true),
      ],
      clinicName: 'Güneş Diş Kliniği',
      preparedBy: 'Dr. Özgür',
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });
}
