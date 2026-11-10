import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/lab_test_catalog.dart';
import '../../data/models/diabetes_record_model.dart';
import '../../data/models/medicine_model.dart';
import '../../data/models/pressure_record_model.dart';
import '../../data/models/test_report_model.dart';
import 'health_analytics.dart';
import 'health_report_data.dart';

/// Builds organized, doctor-ready PDF reports and hands them to the native
/// share sheet. Uses the PDF built-in fonts (no network) to stay offline.
class PdfExportService {
  PdfExportService._();

  static final _date = DateFormat('dd MMM yyyy');
  static final _time = DateFormat('hh:mm a');

  static const _brand = PdfColor.fromInt(0xFF1E7D4A);
  static const _border = PdfColor.fromInt(0xFFDDDDDD);
  static const _headBg = PdfColor.fromInt(0xFFF1F5F3);

  // ── Public API ────────────────────────────────────────────────────────────

  /// Full doctor report (Health Summary screen).
  static Future<void> shareHealthReport(HealthReportData data) async {
    final doc = _document('Patient Health Report', data, (d) => [
          _findingsSection(d),
          if (d.sections.medicines) _medicineSection(d),
          if (d.sections.pressure) _pressureSection(d.pressure),
          if (d.sections.sugar) _sugarSection(d.sugar),
          if (d.sections.labs) _labsSection(d.labs),
          _disclaimer(),
        ]);
    await _share(doc, 'health_report');
  }

  /// Kept for older callers: full report for the last 90 days.
  static Future<void> shareFullHealthSummary() => shareHealthReport(HealthReportData.collect());

  static Future<void> shareTestReports(List<TestReport> reports) async {
    final data = HealthReportData.collect(periodDays: null, sections: const ReportSections(
      medicines: false, pressure: false, sugar: false, labs: false));
    final doc = _document('Lab Test Reports', data, (_) => [_labsSection(reports), _disclaimer()],
        periodOverride: _rangeOf(reports.map((r) => r.testDate)));
    await _share(doc, 'lab_reports');
  }

  static Future<void> shareSingleTestReport(TestReport report) => shareTestReports([report]);

  static Future<void> shareDiabetesRecords(List<DiabetesRecord> records) async {
    final data = HealthReportData.collect(periodDays: null, sections: const ReportSections(
      medicines: false, pressure: false, sugar: false, labs: false));
    final doc = _document('Blood Sugar Report', data, (_) => [_sugarSection(records), _disclaimer()],
        periodOverride: _rangeOf(records.map((r) => r.recordDate)));
    await _share(doc, 'blood_sugar');
  }

  static Future<void> sharePressureRecords(List<PressureRecord> records) async {
    final data = HealthReportData.collect(periodDays: null, sections: const ReportSections(
      medicines: false, pressure: false, sugar: false, labs: false));
    final doc = _document('Blood Pressure Report', data, (_) => [_pressureSection(records), _disclaimer()],
        periodOverride: _rangeOf(records.map((r) => r.recordDate)));
    await _share(doc, 'blood_pressure');
  }

  static Future<void> shareSingleDiabetesRecord(DiabetesRecord r) => shareDiabetesRecords([r]);
  static Future<void> shareSinglePressureRecord(PressureRecord r) => sharePressureRecords([r]);

  // ── Document shell ────────────────────────────────────────────────────────

  static Future<void> _share(pw.Document doc, String name) async {
    final stamp = DateFormat('yyyyMMdd').format(DateTime.now());
    await Printing.sharePdf(bytes: await doc.save(), filename: 'shifatime_${name}_$stamp.pdf');
  }

  static String? _rangeOf(Iterable<DateTime?> dates) {
    final list = dates.whereType<DateTime>().toList()..sort();
    if (list.isEmpty) return null;
    return list.first == list.last
        ? _date.format(list.first)
        : '${_date.format(list.first)} - ${_date.format(list.last)}';
  }

  static pw.Document _document(
    String title,
    HealthReportData d,
    List<pw.Widget> Function(HealthReportData) body, {
    String? periodOverride,
  }) {
    final doc = pw.Document(title: title, author: 'ShifaTime');
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 28),
        header: (ctx) => ctx.pageNumber == 1
            ? pw.SizedBox()
            : pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 6),
                margin: const pw.EdgeInsets.only(bottom: 10),
                decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _border))),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(_t('$title - ${d.name}'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                    pw.Text('ShifaTime', style: pw.TextStyle(fontSize: 8, color: _brand, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
        footer: (ctx) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Self-recorded by the patient with the ShifaTime app',
                style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
            pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
          ],
        ),
        build: (ctx) => [
          _titleBlock(title, d, periodOverride ?? d.periodLabel),
          ...body(d),
        ],
      ),
    );
    return doc;
  }

  static pw.Widget _titleBlock(String title, HealthReportData d, String period) {
    pw.Widget cell(String label, String value) => pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
              pw.SizedBox(height: 2),
              pw.Text(_t(value), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        );

    final bmiText = d.bmi == null
        ? '-'
        : '${d.bmi!.toStringAsFixed(1)} (${HealthAnalytics.bmiStatus(d.bmi!).label})';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('ShifaTime', style: pw.TextStyle(fontSize: 11, color: _brand, fontWeight: pw.FontWeight.bold)),
                pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Generated ${_date.format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                pw.Text(_t('Period: $period'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: _headBg, borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Row(
            children: [
              cell('Patient', d.name.isEmpty ? '-' : d.name),
              cell('Age', d.age > 0 ? '${d.age} years' : '-'),
              cell('Gender', d.gender.isEmpty ? '-' : d.gender),
              cell('Height', d.heightCm > 0 ? '${d.heightCm.toStringAsFixed(0)} cm' : '-'),
              cell('Weight', d.weightKg > 0 ? '${d.weightKg.toStringAsFixed(1)} kg' : '-'),
              cell('BMI', bmiText),
            ],
          ),
        ),
        pw.SizedBox(height: 14),
      ],
    );
  }

  // ── Shared pieces ─────────────────────────────────────────────────────────

  static PdfColor _levelColor(HealthLevel l) {
    switch (l) {
      case HealthLevel.low:
        return PdfColors.blue700;
      case HealthLevel.normal:
        return PdfColors.green700;
      case HealthLevel.elevated:
        return PdfColors.orange800;
      case HealthLevel.high:
        return PdfColors.red700;
      case HealthLevel.critical:
        return PdfColors.red900;
      case HealthLevel.unknown:
        return PdfColors.grey700;
    }
  }

  static pw.Widget _heading(String text, {String? sub}) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 14, bottom: 6),
        padding: const pw.EdgeInsets.only(bottom: 3),
        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _brand, width: 1.2))),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(text, style: pw.TextStyle(fontSize: 12.5, fontWeight: pw.FontWeight.bold, color: _brand)),
            if (sub != null) ...[
              pw.SizedBox(width: 8),
              pw.Text(_t(sub), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            ],
          ],
        ),
      );

  static pw.Widget _empty(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
      );

  /// Table where each cell can have its own color / weight.
  static pw.Widget _table(List<String> headers, List<List<_Cell>> rows, Map<int, double> flex) {
    return pw.Table(
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: _border, width: 0.5),
        bottom: pw.BorderSide(color: _border, width: 0.5),
      ),
      columnWidths: flex.map((k, v) => MapEntry(k, pw.FlexColumnWidth(v))),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _headBg),
          children: [
            for (final h in headers)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: pw.Text(h, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
              ),
          ],
        ),
        for (final row in rows)
          pw.TableRow(
            children: [
              for (final c in row)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: pw.Text(
                    _t(c.text),
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      color: c.color,
                      fontWeight: c.bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _statRow(List<(String, String)> stats) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          children: [
            for (final s in stats)
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(s.$1, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
                    pw.Text(_t(s.$2), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      );

  static pw.Widget _disclaimer() => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 18),
        child: pw.Text(
          'Note: Values were entered by the patient. Lab flags compare results with the reference range '
          'recorded for each test (typical adult ranges unless changed to match the lab). Blood pressure '
          'categories follow AHA/ACC 2017; glucose targets follow ADA. Estimated HbA1c is derived from logged '
          'glucose readings and is not a laboratory value. This report is not a diagnosis.',
          style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
        ),
      );

  // ── Sections ──────────────────────────────────────────────────────────────

  static pw.Widget _findingsSection(HealthReportData d) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading('Key Findings'),
        if (d.findings.isEmpty) _empty('No health data recorded in this period.'),
        for (final f in d.findings)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 7,
                  height: 7,
                  margin: const pw.EdgeInsets.only(top: 2.5, right: 7),
                  decoration: pw.BoxDecoration(color: _levelColor(f.level), shape: pw.BoxShape.circle),
                ),
                pw.Expanded(
                  child: pw.RichText(
                    text: pw.TextSpan(children: [
                      pw.TextSpan(
                          text: _t('${f.title}. '),
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _levelColor(f.level))),
                      pw.TextSpan(text: _t(f.detail), style: const pw.TextStyle(fontSize: 9)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static const _slotTimes = {'Sokal': '08:00', 'Dupur': '14:00', 'Bikal': '17:00', 'Rat': '22:00'};

  static String _schedule(Medicine m) {
    final times = (m.reminderTimes ?? []).map((t) {
      final hhmm = _slotTimes[t] ?? t;
      final p = hhmm.split(':');
      final h = int.tryParse(p.first), min = p.length > 1 ? int.tryParse(p[1]) : 0;
      if (h == null) return t;
      return DateFormat('h:mm a').format(DateTime(2000, 1, 1, h, min ?? 0));
    }).join(', ');
    final days = m.durationType == 'Specific Days' ? ' (${m.durationValue})' : '';
    return '${(m.reminderTimes ?? []).length}x daily: $times$days';
  }

  static pw.Widget _medicineSection(HealthReportData d) {
    final a = d.adherence;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading('Current Medications',
            sub: a.percent == null ? null : 'Adherence ${a.percent}% (${a.taken}/${a.total} doses taken)'),
        if (d.medicines.isEmpty)
          _empty('No active medicines.')
        else
          _table(
            ['Medicine', 'Type', 'Dose', 'Schedule', 'With food', 'Since'],
            d.medicines
                .map((m) => [
                      _Cell(m.name ?? '-', bold: true),
                      _Cell(m.type ?? '-'),
                      _Cell(m.customDosage ?? '${m.dosage ?? 1} ${m.type ?? ''}'),
                      _Cell(_schedule(m)),
                      _Cell(m.mealRelation ?? '-'),
                      _Cell(m.startDate != null ? _date.format(m.startDate!) : '-'),
                    ])
                .toList(),
            const {0: 2.2, 1: 1.1, 2: 1.4, 3: 3, 4: 1.4, 5: 1.4},
          ),
      ],
    );
  }

  static pw.Widget _pressureSection(List<PressureRecord> records) {
    final avgS = HealthAnalytics.average(records.map((r) => r.systolic ?? 0));
    final avgD = HealthAnalytics.average(records.map((r) => r.diastolic ?? 0));
    final avgP = HealthAnalytics.average(records.where((r) => r.pulse != null).map((r) => r.pulse!));
    final max = records.isEmpty ? null : records.reduce((a, b) => (a.systolic ?? 0) >= (b.systolic ?? 0) ? a : b);
    final min = records.isEmpty ? null : records.reduce((a, b) => (a.systolic ?? 0) <= (b.systolic ?? 0) ? a : b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading('Blood Pressure', sub: '${records.length} readings, mmHg'),
        if (records.isEmpty)
          _empty('No readings recorded.')
        else ...[
          _statRow([
            ('Average', '${avgS!.round()}/${avgD!.round()}'),
            ('Category (avg)', HealthAnalytics.bpStatus(avgS.round(), avgD.round()).label),
            ('Highest', '${max!.systolic}/${max.diastolic}'),
            ('Lowest', '${min!.systolic}/${min.diastolic}'),
            ('Avg pulse', avgP == null ? '-' : '${avgP.round()} bpm'),
          ]),
          _table(
            ['Date', 'Time', 'BP (mmHg)', 'Pulse', 'Arm', 'Category', 'Notes'],
            records.map((r) {
              final st = HealthAnalytics.bpStatus(r.systolic ?? 0, r.diastolic ?? 0);
              final c = st.isAbnormal ? _levelColor(st.level) : null;
              return [
                _Cell(r.recordDate != null ? _date.format(r.recordDate!) : '-'),
                _Cell(r.recordDate != null ? _time.format(r.recordDate!) : '-'),
                _Cell('${r.systolic}/${r.diastolic}', bold: true, color: c),
                _Cell(r.pulse?.toString() ?? '-'),
                _Cell(r.arm ?? '-'),
                _Cell(st.label, color: c),
                _Cell(r.notes ?? ''),
              ];
            }).toList(),
            const {0: 1.5, 1: 1.1, 2: 1.2, 3: 0.8, 4: 0.8, 5: 2, 6: 2.2},
          ),
        ],
      ],
    );
  }

  static pw.Widget _sugarSection(List<DiabetesRecord> records) {
    final mg = records.map((r) => HealthAnalytics.toMgdl(r.value ?? 0, r.unit)).toList();
    final avg = HealthAnalytics.average(mg);
    final fasting = records.where((r) => r.readingType == 'Fasting').map((r) => HealthAnalytics.toMgdl(r.value ?? 0, r.unit));
    final pp = records
        .where((r) => r.readingType == 'Post Prandial (PP)')
        .map((r) => HealthAnalytics.toMgdl(r.value ?? 0, r.unit));
    final avgF = HealthAnalytics.average(fasting);
    final avgPP = HealthAnalytics.average(pp);
    final a1c = records.length >= 5 && avg != null ? HealthAnalytics.estimatedHbA1c(avg) : null;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading('Blood Sugar (Glucose)', sub: '${records.length} readings'),
        if (records.isEmpty)
          _empty('No readings recorded.')
        else ...[
          _statRow([
            ('Average (all)', avg == null ? '-' : '${avg.round()} mg/dL'),
            ('Avg fasting', avgF == null ? '-' : '${avgF.round()} mg/dL'),
            ('Avg after meal', avgPP == null ? '-' : '${avgPP.round()} mg/dL'),
            ('Estimated HbA1c', a1c == null ? '-' : '${a1c.toStringAsFixed(1)}%'),
            ('Lowest / Highest', mg.isEmpty ? '-' : '${mg.reduce((a, b) => a < b ? a : b).round()} / ${mg.reduce((a, b) => a > b ? a : b).round()}'),
          ]),
          _table(
            ['Date', 'Time', 'Type', 'Result', 'mg/dL', 'Status', 'Notes'],
            records.map((r) {
              final st = HealthAnalytics.sugarStatus(r.value ?? 0, r.unit, r.readingType);
              final c = st.isAbnormal ? _levelColor(st.level) : null;
              final v = r.value ?? 0;
              return [
                _Cell(r.recordDate != null ? _date.format(r.recordDate!) : '-'),
                _Cell(r.recordDate != null ? _time.format(r.recordDate!) : '-'),
                _Cell(HealthAnalytics.sugarTypeLabel(r.readingType)),
                _Cell('${r.unit == 'mmol/L' ? v.toStringAsFixed(1) : v.toStringAsFixed(0)} ${r.unit ?? ''}',
                    bold: true, color: c),
                _Cell(HealthAnalytics.toMgdl(v, r.unit).round().toString()),
                _Cell(st.label, color: c),
                _Cell(r.notes ?? ''),
              ];
            }).toList(),
            const {0: 1.5, 1: 1.1, 2: 1.6, 3: 1.4, 4: 0.8, 5: 1.6, 6: 2.2},
          ),
        ],
      ],
    );
  }

  static pw.Widget _labsSection(List<TestReport> reports) {
    final children = <pw.Widget>[_heading('Laboratory Reports', sub: '${reports.length} reports')];
    if (reports.isEmpty) {
      children.add(_empty('No lab reports recorded.'));
      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: children);
    }

    for (final r in reports) {
      final meta = [
        if (r.testDate != null) _date.format(r.testDate!),
        if ((r.labName ?? '').isNotEmpty) r.labName!,
        if ((r.doctorName ?? '').isNotEmpty) 'Ref: ${r.doctorName}',
      ].join('  |  ');
      final params = r.allParameters;
      final abnormal = params.where((p) => HealthAnalytics.labFlag(p.value, p.refRange).isAbnormal).length;

      children.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 8, bottom: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(children: [
                    pw.TextSpan(
                      text: _t(r.category == LabTestCatalog.custom || r.category == null
                          ? (r.testName ?? 'Lab Test')
                          : r.category!),
                      style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: _t('   $meta'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  ]),
                ),
              ),
              pw.Text(
                abnormal == 0 ? 'All within range' : '$abnormal outside range',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: abnormal == 0 ? PdfColors.green700 : PdfColors.red700,
                ),
              ),
            ],
          ),
        ),
      );
      children.add(
        _table(
          ['Test', 'Result', 'Unit', 'Reference range', 'Flag'],
          params.map((p) {
            final st = HealthAnalytics.labFlag(p.value, p.refRange);
            final c = st.isAbnormal ? _levelColor(st.level) : null;
            final flag = st.level == HealthLevel.low ? 'L' : (st.isAbnormal ? (st.label == 'High' ? 'H' : '*') : '');
            return [
              _Cell(p.name ?? '-'),
              _Cell(p.value ?? '-', bold: true, color: c),
              _Cell(p.unit ?? ''),
              _Cell(p.refRange ?? '-'),
              _Cell(flag, bold: true, color: c),
            ];
          }).toList(),
          const {0: 3, 1: 1.3, 2: 1.3, 3: 1.8, 4: 0.6},
        ),
      );
      if ((r.notes ?? '').isNotEmpty) {
        children.add(pw.Padding(
          padding: const pw.EdgeInsets.only(top: 3),
          child: pw.Text(_t('Notes: ${r.notes}'), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        ));
      }
    }
    children.add(pw.Padding(
      padding: const pw.EdgeInsets.only(top: 4),
      child: pw.Text('H = above range, L = below range, * = abnormal finding',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
    ));
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: children);
  }

  // ── Text safety ───────────────────────────────────────────────────────────

  static const _allowedExtra = {0x2022, 0x2013, 0x2014, 0x2018, 0x2019, 0x201C, 0x201D, 0x2026};

  /// The built-in PDF fonts only cover Latin-1. Replace other characters
  /// (e.g. Bangla text in notes) so export never fails.
  static String _t(String s) {
    final b = StringBuffer();
    for (final r in s.runes) {
      if (r <= 0xFF || _allowedExtra.contains(r)) {
        b.writeCharCode(r);
      } else if (r == 0x2265) {
        b.write('>=');
      } else if (r == 0x2264) {
        b.write('<=');
      } else if (r == 0x25B2) {
        b.write('^');
      } else if (r == 0x25BC) {
        b.write('v');
      } else {
        b.write('?');
      }
    }
    return b.toString();
  }
}

class _Cell {
  final String text;
  final bool bold;
  final PdfColor? color;
  const _Cell(this.text, {this.bold = false, this.color});
}
