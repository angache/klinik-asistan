import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/patient.dart';
import '../models/treatment_note.dart';

/// Hastanın tedavi geçmişini PDF'e döker (fotoğraflar hariç, yalnızca sayısı).
class PatientPdfExport {
  PatientPdfExport._();

  static final _date = DateFormat('dd.MM.yyyy');
  static final _dateTime = DateFormat('dd.MM.yyyy HH:mm');

  static Future<Uint8List> build({
    required Patient patient,
    required List<TreatmentNote> notes,
    required String clinicName,
    String? preparedBy,
  }) async {
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
      ),
      bold:
          pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
    );

    final done = notes.where((n) => !n.planlandi).toList()
      ..sort((a, b) => a.tarih.compareTo(b.tarih));
    final planned = notes.where((n) => n.planlandi).toList();
    final now = DateTime.now();

    final doc = pw.Document(
      title: 'Tedavi geçmişi - ${patient.adSoyad}',
      author: clinicName,
      creator: 'Klinik Asistan',
    );

    doc.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 40),
        header: (ctx) => ctx.pageNumber == 1
            ? pw.SizedBox()
            : pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  '${patient.adSoyad} · Tedavi geçmişi',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
        footer: (ctx) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Gizli: özel nitelikli kişisel veri içerir (KVKK md. 6).',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.Text(
              'Sayfa ${ctx.pageNumber} / ${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
        build: (ctx) => [
          pw.Text(
            clinicName,
            style: const pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Hasta tedavi geçmişi',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          _infoRow('Hasta', patient.adSoyad),
          if (patient.telefon?.trim().isNotEmpty == true)
            _infoRow('Telefon', patient.telefon!.trim()),
          _infoRow('Kayıt tarihi', _date.format(patient.olusturmaTarihi)),
          _infoRow(
            'Rapor tarihi',
            '${_dateTime.format(now)}'
                '${preparedBy == null ? '' : ' · Hazırlayan: $preparedBy'}',
          ),
          pw.SizedBox(height: 16),
          _sectionTitle('Yapılan işlemler (${done.length})'),
          if (done.isEmpty)
            pw.Text('Kayıtlı işlem yok.')
          else
            _notesTable(done, showDate: true),
          if (planned.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            _sectionTitle('Planlanan işlemler (${planned.length})'),
            _notesTable(planned, showDate: false),
          ],
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _infoRow(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 80,
              child: pw.Text(
                label,
                style: const pw.TextStyle(color: PdfColors.grey700),
              ),
            ),
            pw.Expanded(child: pw.Text(value)),
          ],
        ),
      );

  static pw.Widget _sectionTitle(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Text(
          text,
          style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
      );

  static pw.Widget _notesTable(
    List<TreatmentNote> notes, {
    required bool showDate,
  }) {
    const headerStyle = pw.TextStyle(fontSize: 9, color: PdfColors.white);
    const cellStyle = pw.TextStyle(fontSize: 9);
    return pw.TableHelper.fromTextArray(
      headerStyle: headerStyle,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
      cellStyle: cellStyle,
      cellPadding: const pw.EdgeInsets.all(4),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      columnWidths: {
        0: const pw.FixedColumnWidth(58),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FixedColumnWidth(62),
        3: const pw.FlexColumnWidth(4),
      },
      headers: [showDate ? 'Tarih' : 'Eklenme', 'İşlem', 'Kapsam', 'Detay'],
      data: [
        for (final n in notes)
          [
            _date.format(showDate ? n.tarih.toLocal() : n.olusturmaTarihi),
            n.islemBaslik,
            _scope(n),
            _details(n),
          ],
      ],
    );
  }

  static String _scope(TreatmentNote n) =>
      n.kapsam == TreatmentScope.tekDis && (n.disNo?.isNotEmpty ?? false)
          ? 'Diş ${n.disNo}'
          : n.kapsam.label;

  static String _details(TreatmentNote n) {
    final lines = <String>[
      if (n.kanalBoyu?.isNotEmpty ?? false) 'Kanal boyu: ${n.kanalBoyu}',
      if (n.egeSistemi?.isNotEmpty ?? false) 'Eğe: ${n.egeSistemi}',
      if (n.kanalIlaci?.isNotEmpty ?? false) 'İlaç: ${n.kanalIlaci}',
      if (n.labGitti)
        'Lab${n.labBeklenenTarih == null ? '' : ' · dönüş ${_date.format(n.labBeklenenTarih!)}'}',
      if (n.notIcerik.trim().isNotEmpty) n.notIcerik.trim(),
      if (n.fotografUrls.isNotEmpty) '${n.fotografUrls.length} fotoğraf',
    ];
    return lines.isEmpty ? '-' : lines.join('\n');
  }

  /// PDF'i oluşturup sistem paylaşım menüsünü açar.
  static Future<void> share(
    BuildContext context, {
    required Patient patient,
    required List<TreatmentNote> notes,
    required String clinicName,
    String? preparedBy,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    messenger.showSnackBar(
      const SnackBar(
        content: Text('PDF hazırlanıyor…'),
        duration: Duration(seconds: 30),
      ),
    );
    try {
      final bytes = await build(
        patient: patient,
        notes: notes,
        clinicName: clinicName,
        preparedBy: preparedBy,
      );
      final dir = await Directory(
        '${(await getTemporaryDirectory()).path}/paylasim',
      ).create(recursive: true);
      final safeName = patient.adSoyad
          .replaceAll(RegExp(r'[^\wçğıöşüÇĞİÖŞÜ ]'), '')
          .trim()
          .replaceAll(RegExp(r'\s+'), '_');
      final file = File(
        '${dir.path}/tedavi_gecmisi_${safeName.isEmpty ? 'hasta' : safeName}'
        '_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);
      messenger.hideCurrentSnackBar();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'Tedavi geçmişi',
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('PDF oluşturulamadı: $e')));
    }
  }
}
