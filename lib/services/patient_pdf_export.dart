import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../data/tooth_canals.dart';
import '../data/treatment_templates.dart';
import '../l10n/l10n.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';

/// Hastanın tedavi geçmişini PDF'e döker (fotoğraflar hariç, yalnızca sayısı).
class PatientPdfExport {
  PatientPdfExport._();

  static DateFormat get _date => DateFormat.yMd();
  static DateFormat get _dateTime => DateFormat.yMd().add_Hm();

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
    final l10n = currentL10n;

    final doc = pw.Document(
      title: l10n.pdfDocTitle(patient.adSoyad),
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
                  l10n.pdfHeader(patient.adSoyad),
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
              l10n.pdfConfidential,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.Text(
              l10n.pdfPage(ctx.pageNumber, ctx.pagesCount),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
        build: (ctx) => [
          pw.Text(
            clinicName,
            style: const pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            l10n.pdfSubtitle,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          _infoRow(l10n.patientFallback, patient.adSoyad),
          if (patient.telefon?.trim().isNotEmpty == true)
            _infoRow(l10n.phoneLabel, patient.telefon!.trim()),
          _infoRow(l10n.pdfRegistered, _date.format(patient.olusturmaTarihi)),
          _infoRow(
            l10n.pdfReportDate,
            '${_dateTime.format(now)}'
            '${preparedBy == null ? '' : ' · ${l10n.pdfPreparedBy(preparedBy)}'}',
          ),
          pw.SizedBox(height: 16),
          _sectionTitle(l10n.pdfDoneProcedures(done.length)),
          if (done.isEmpty)
            pw.Text(l10n.pdfNoProcedures)
          else
            _notesTable(done, showDate: true),
          if (planned.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            _sectionTitle(l10n.pdfPlannedProcedures(planned.length)),
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
          style:
              const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
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
      headers: [
        showDate ? currentL10n.fieldDate : currentL10n.pdfColAdded,
        currentL10n.procedureSection,
        currentL10n.fieldScope,
        currentL10n.pdfColDetails,
      ],
      data: [
        for (final n in notes)
          [
            _date.format(showDate ? n.tarih.toLocal() : n.olusturmaTarihi),
            procedureLabel(n.islemBaslik),
            _scope(n),
            _details(n),
          ],
      ],
    );
  }

  static String _scope(TreatmentNote n) =>
      n.kapsam == TreatmentScope.tekDis && (n.disNo?.isNotEmpty ?? false)
          ? currentL10n.toothNumber(n.disNo!)
          : n.kapsam.label;

  static String _details(TreatmentNote n) {
    final l10n = currentL10n;
    final lines = <String>[
      if (n.kanalBoyu?.isNotEmpty ?? false)
        '${l10n.fieldCanalLength}: ${localizeKanalBoyu(n.kanalBoyu!)}',
      if (n.egeSistemi?.isNotEmpty ?? false)
        '${l10n.fieldFile}: ${egeLabel(n.egeSistemi)}',
      if (n.kanalIlaci?.isNotEmpty ?? false)
        '${l10n.fieldMedicament}: ${ilacLabel(n.kanalIlaci)}',
      if (n.labGitti)
        n.labBeklenenTarih == null
            ? l10n.labShort
            : l10n.pdfLabReturn(_date.format(n.labBeklenenTarih!)),
      if (n.notIcerik.trim().isNotEmpty) n.notIcerik.trim(),
      if (n.fotografUrls.isNotEmpty)
        l10n.photoCountShort(n.fotografUrls.length),
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
    final l10n = context.l10n;
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.preparingPdf),
        duration: const Duration(seconds: 30),
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
          .replaceAll(RegExp(r'[^\p{L}\p{N}_ ]', unicode: true), '')
          .trim()
          .replaceAll(RegExp(r'\s+'), '_');
      final file = File(
        '${dir.path}/${l10n.pdfFilePrefix}_'
        '${safeName.isEmpty ? l10n.patientFallback.toLowerCase() : safeName}'
        '_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);
      messenger.hideCurrentSnackBar();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: l10n.pdfTreatmentHistory,
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(l10n.pdfCreateFailed(errorText(e)))));
    }
  }
}
