import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/models/diabetes_record_model.dart';
import '../../data/models/medicine_model.dart';
import '../../data/models/pressure_record_model.dart';
import '../../data/models/test_report_model.dart';
import 'local_storage_service.dart';

/// PdfExportService — centralized PDF generation + native share-sheet handoff
/// for all Health Report modules. Uses base14 PDF fonts (no network fetch)
/// to stay consistent with the app's 100% offline architecture.
class PdfExportService {
  PdfExportService._();

  static final _dateFmt = DateFormat('dd MMM, yyyy');
  static final _dateTimeFmt = DateFormat('dd MMM, yyyy • hh:mm a');

  // ── Public: single-type share (used by "Share All" appbar action) ────────

  static Future<void> shareTestReports(List<TestReport> reports) async {
    final doc = await _buildDocument(
      title: 'Test Report History',
      builder: (context) => [_testReportSection(reports)],
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: 'shifatime_test_reports.pdf');
  }

  static Future<void> shareDiabetesRecords(List<DiabetesRecord> records) async {
    final doc = await _buildDocument(
      title: 'Diabetes Report History',
      builder: (context) => [_diabetesSection(records)],
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: 'shifatime_diabetes_report.pdf');
  }

  static Future<void> sharePressureRecords(List<PressureRecord> records) async {
    final doc = await _buildDocument(
      title: 'Pressure Report History',
      builder: (context) => [_pressureSection(records)],
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: 'shifatime_pressure_report.pdf');
  }

  // ── Public: single-entry share (used by the share icon on each card) ─────

  static Future<void> shareSingleTestReport(TestReport report) => shareTestReports([report]);

  static Future<void> shareSingleDiabetesRecord(DiabetesRecord record) => shareDiabetesRecords([record]);

  static Future<void> shareSinglePressureRecord(PressureRecord record) => sharePressureRecords([record]);

  // ── Public: combined summary (Menu → "Health Summary") ───────────────────

  /// Pulls straight from the already-open Hive boxes — no controller
  /// dependency needed, so this can be called directly from the Menu grid.
  static Future<void> shareFullHealthSummary() async {
    final testBox = Hive.box<TestReport>('test_reports');
    final diabetesBox = Hive.box<DiabetesRecord>('diabetes_records');
    final pressureBox = Hive.box<PressureRecord>('pressure_records');
    final medicineBox = Hive.box<Medicine>('medicines');

    final tests = testBox.values.toList()
      ..sort((a, b) => (b.testDate ?? DateTime(2000)).compareTo(a.testDate ?? DateTime(2000)));
    final diabetes = diabetesBox.values.toList()
      ..sort((a, b) => (b.recordDate ?? DateTime(2000)).compareTo(a.recordDate ?? DateTime(2000)));
    final pressure = pressureBox.values.toList()
      ..sort((a, b) => (b.recordDate ?? DateTime(2000)).compareTo(a.recordDate ?? DateTime(2000)));
    final activeMedicines = medicineBox.values.where((m) => m.isActive ?? false).toList();

    final doc = await _buildDocument(
      title: 'Full Health Summary',
      builder: (context) => [
        _medicineSection(activeMedicines),
        pw.SizedBox(height: 20),
        _testReportSection(tests),
        pw.SizedBox(height: 20),
        _diabetesSection(diabetes),
        pw.SizedBox(height: 20),
        _pressureSection(pressure),
      ],
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: 'shifatime_health_summary.pdf');
  }

  // ── Document shell (shared header/footer across every export) ────────────

  static Future<pw.Document> _buildDocument({
    required String title,
    required List<pw.Widget> Function(pw.Context context) builder,
  }) async {
    final doc = pw.Document();
    final name = LocalStorage.getName();
    final age = LocalStorage.getAge();
    final gender = LocalStorage.getGender();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('ShifaTime', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  'Generated: ${_dateFmt.format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text(title, style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
            if (name.isNotEmpty)
              pw.Text(
                '$name${age > 0 ? ' • $age yrs' : ''}${gender.isNotEmpty ? ' • $gender' : ''}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            pw.Divider(thickness: 1, height: 16),
          ],
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount} — Generated by ShifaTime app',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
        build: builder,
      ),
    );
    return doc;
  }

  // ── Section builders ──────────────────────────────────────────────────────

  static pw.Widget _sectionHeading(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(text, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
      );

  static pw.Widget _emptyNote(String text) =>
      pw.Text(text, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600));

  static pw.Widget _medicineSection(List<Medicine> medicines) {
    if (medicines.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [_sectionHeading('Current Medicines'), _emptyNote('No active medicines.')],
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('Current Medicines'),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(2.2),
            1: pw.FlexColumnWidth(1.3),
            2: pw.FlexColumnWidth(1.8),
            3: pw.FlexColumnWidth(2),
          },
          headers: ['Name', 'Type', 'Dosage', 'Meal Relation'],
          data: medicines
              .map((m) => [
                    m.name ?? '-',
                    m.type ?? '-',
                    m.customDosage ?? '${m.dosage ?? '-'} ${m.type ?? ''}',
                    m.mealRelation ?? '-',
                  ])
              .toList(),
        ),
      ],
    );
  }

  static pw.Widget _testReportSection(List<TestReport> reports) {
    if (reports.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [_sectionHeading('Test Reports'), _emptyNote('No test reports recorded.')],
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('Test Reports'),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo700),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1.5),
            2: pw.FlexColumnWidth(1.8),
            3: pw.FlexColumnWidth(1.5),
            4: pw.FlexColumnWidth(2.5),
          },
          headers: ['Test Name', 'Result', 'Normal Range', 'Date', 'Notes'],
          data: reports
              .map((r) => [
                    r.testName ?? '-',
                    '${r.resultValue ?? '-'}${r.unit != null ? ' ${r.unit}' : ''}',
                    r.normalRange ?? '-',
                    r.testDate != null ? _dateFmt.format(r.testDate!) : '-',
                    r.notes ?? '-',
                  ])
              .toList(),
        ),
      ],
    );
  }

  static pw.Widget _diabetesSection(List<DiabetesRecord> records) {
    if (records.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [_sectionHeading('Diabetes Report (Blood Sugar)'), _emptyNote('No readings recorded.')],
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('Diabetes Report (Blood Sugar)'),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.red700),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(1.6),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(2.5),
            3: pw.FlexColumnWidth(2.5),
          },
          headers: ['Value', 'Type', 'Date', 'Notes'],
          data: records
              .map((r) => [
                    '${r.value?.toStringAsFixed(1) ?? '-'} ${r.unit ?? ''}',
                    r.readingType ?? '-',
                    r.recordDate != null ? _dateTimeFmt.format(r.recordDate!) : '-',
                    r.notes ?? '-',
                  ])
              .toList(),
        ),
      ],
    );
  }

  static pw.Widget _pressureSection(List<PressureRecord> records) {
    if (records.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [_sectionHeading('Pressure Report'), _emptyNote('No readings recorded.')],
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('Pressure Report'),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.pink700),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(1.6),
            1: pw.FlexColumnWidth(2.5),
            2: pw.FlexColumnWidth(2.5),
          },
          headers: ['Systolic/Diastolic', 'Date', 'Notes'],
          data: records
              .map((r) => [
                    '${r.systolic ?? '-'}/${r.diastolic ?? '-'} mmHg',
                    r.recordDate != null ? _dateTimeFmt.format(r.recordDate!) : '-',
                    r.notes ?? '-',
                  ])
              .toList(),
        ),
      ],
    );
  }
}
