import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/services/health_analytics.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/lab_test_catalog.dart';
import '../../../data/models/test_parameter_model.dart';
import '../../../data/models/test_report_model.dart';
import '../../../widgets/health_widgets.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_date_picker.dart';
import '../../../widgets/primary_input_field.dart';
import '../controllers/test_report_controller.dart';

/// Editable row for one parameter of the report form.
class _ParamRow {
  final TextEditingController name;
  final TextEditingController value;
  final TextEditingController unit;
  final TextEditingController range;
  final bool fromCatalog;
  bool expanded = false;

  _ParamRow({String name = '', String value = '', String unit = '', String range = '', this.fromCatalog = false})
      : name = TextEditingController(text: name),
        value = TextEditingController(text: value),
        unit = TextEditingController(text: unit),
        range = TextEditingController(text: range);

  void dispose() {
    name.dispose();
    value.dispose();
    unit.dispose();
    range.dispose();
  }
}

/// Add or edit a lab report. Pick a test type and its standard parameters,
/// units and reference ranges are filled in; type the results from the
/// printed report. Pass a [TestReport] as Get.arguments to edit.
class AddTestReportView extends StatefulWidget {
  const AddTestReportView({super.key});

  @override
  State<AddTestReportView> createState() => _AddTestReportViewState();
}

class _AddTestReportViewState extends State<AddTestReportView> {
  final TestReportController controller = Get.find<TestReportController>();
  final _formKey = GlobalKey<FormState>();
  final String gender = LocalStorage.getGender();

  final titleController = TextEditingController();
  final labController = TextEditingController();
  final doctorController = TextEditingController();
  final notesController = TextEditingController();

  TestReport? editing;
  String category = LabTestCatalog.panels.first.name;
  DateTime selectedDate = DateTime.now();
  List<_ParamRow> rows = [];

  bool get isCustom => category == LabTestCatalog.custom;

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is TestReport) {
      editing = arg;
      category = arg.category ?? LabTestCatalog.custom;
      if (LabTestCatalog.byName(category) == null) category = LabTestCatalog.custom;
      titleController.text = arg.testName ?? '';
      labController.text = arg.labName ?? '';
      doctorController.text = arg.doctorName ?? '';
      notesController.text = arg.notes ?? '';
      selectedDate = arg.testDate ?? DateTime.now();
      _loadRows(existing: arg.allParameters);
    } else {
      _loadRows();
    }
  }

  /// Fills rows from the catalog for [category], keeping any typed values.
  void _loadRows({List<TestParameter> existing = const []}) {
    final previous = {
      for (final r in rows)
        if (r.value.text.trim().isNotEmpty) r.name.text.trim().toLowerCase(): r.value.text.trim(),
      for (final p in existing) (p.name ?? '').toLowerCase(): p.value ?? '',
    };
    final panel = LabTestCatalog.byName(category);
    final newRows = <_ParamRow>[];
    final used = <String>{};

    if (panel != null) {
      for (final d in panel.params) {
        final ex = existing.firstWhereOrNull((p) => (p.name ?? '').toLowerCase() == d.name.toLowerCase());
        newRows.add(_ParamRow(
          name: d.name,
          value: previous[d.name.toLowerCase()] ?? '',
          unit: ex?.unit ?? d.unit,
          range: ex?.refRange ?? d.rangeFor(gender),
          fromCatalog: true,
        ));
        used.add(d.name.toLowerCase());
      }
    }
    // Extra / custom parameters from an existing report
    for (final p in existing) {
      if (used.contains((p.name ?? '').toLowerCase())) continue;
      newRows.add(_ParamRow(name: p.name ?? '', value: p.value ?? '', unit: p.unit ?? '', range: p.refRange ?? ''));
    }
    if (newRows.isEmpty) newRows.add(_ParamRow());

    for (final r in rows) {
      r.dispose();
    }
    rows = newRows;
  }

  @override
  void dispose() {
    titleController.dispose();
    labController.dispose();
    doctorController.dispose();
    notesController.dispose();
    for (final r in rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final params = rows
        .where((r) => r.name.text.trim().isNotEmpty && r.value.text.trim().isNotEmpty)
        .map((r) => TestParameter(
              name: r.name.text.trim(),
              value: r.value.text.trim(),
              unit: r.unit.text.trim().isEmpty ? null : r.unit.text.trim(),
              refRange: r.range.text.trim().isEmpty ? null : r.range.text.trim(),
            ))
        .toList();
    if (params.isEmpty) {
      AppSnackBar.error('Enter at least one result value');
      return;
    }

    final title = isCustom ? titleController.text.trim() : category;
    String? opt(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

    controller.saveReport(
      editId: editing?.id,
      title: title,
      category: category,
      testDate: selectedDate,
      parameters: params,
      labName: opt(labController),
      doctorName: opt(doctorController),
      notes: opt(notesController),
    );

    Get.back();
    AppSnackBar.success(editing == null ? 'Test report saved' : 'Test report updated');
    if (editing == null) AdService.showInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filledCount = rows.where((r) => r.value.text.trim().isNotEmpty).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(editing == null ? 'Add Lab Report' : 'Edit Lab Report',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(
        mobile: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            physics: const BouncingScrollPhysics(),
            children: [
              const SectionTitle('1. Test type'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in LabTestCatalog.panels) _typeChip(p.short, p.name, p.icon, p.color, isDark),
                  _typeChip('Other', LabTestCatalog.custom, Icons.add_chart_rounded, AppColors.info, isDark),
                ],
              ),
              const SizedBox(height: 18),
              if (isCustom) ...[
                PrimaryInputField(
                  label: 'Test name',
                  hint: 'e.g. Dengue NS1, HBsAg, PSA',
                  controller: titleController,
                  validator: (v) => isCustom && (v == null || v.trim().isEmpty) ? 'Test name is required' : null,
                ),
                const SizedBox(height: 16),
              ],
              const SectionTitle('2. Report details'),
              PrimaryDatePicker(
                label: 'Sample / report date',
                selectedDate: selectedDate,
                lastDate: DateTime.now(),
                onDateSelected: (d) => setState(() => selectedDate = d),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: PrimaryInputField(label: 'Lab / hospital', hint: 'Optional', controller: labController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryInputField(label: 'Referred by', hint: 'Dr. (optional)', controller: doctorController),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SectionTitle(
                '3. Results',
                trailing: Text('$filledCount of ${rows.length} filled',
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
              ),
              Text(
                'Type values exactly as printed on your report. Leave blank any test that was not done. '
                'Reference ranges are typical adult values — tap a row to match your lab\'s range.',
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < rows.length; i++) ...[
                _paramCard(i, isDark),
                const SizedBox(height: 10),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => rows.add(_ParamRow()..expanded = true)),
                  icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                  label: Text('Add another result',
                      style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryInputField(
                label: 'Notes / doctor\'s comment (optional)',
                hint: 'e.g. Repeat after 3 months',
                controller: notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 26),
              PrimaryButton(text: editing == null ? 'Save Report' : 'Update Report', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String label, String value, IconData icon, Color color, bool isDark) {
    final selected = category == value;
    return GestureDetector(
      onTap: () {
        if (selected) return;
        setState(() {
          category = value;
          _loadRows();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : (isDark ? AppColors.darkCardBackground : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : (isDark ? Colors.white12 : Colors.black12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _paramCard(int i, bool isDark) {
    final row = rows[i];
    final status = HealthAnalytics.labFlag(row.value.text, row.range.text);
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    InputDecoration deco(String hint) => InputDecoration(
          hintText: hint,
          isDense: true,
          hintStyle: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
          ),
        );

    return HealthCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      borderColor: status.isAbnormal ? status.color.withValues(alpha: 0.5) : null,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: row.fromCatalog
                    ? GestureDetector(
                        onTap: () => setState(() => row.expanded = !row.expanded),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(row.name.text,
                                style: GoogleFonts.outfit(
                                    fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Ref: ${row.range.text.isEmpty ? '-' : row.range.text} ${row.unit.text}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.grey),
                                  ),
                                ),
                                if (status.label.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  StatusPill(status, fontSize: 9),
                                ],
                              ],
                            ),
                          ],
                        ),
                      )
                    : TextField(
                        controller: row.name,
                        style: GoogleFonts.outfit(fontSize: 13, color: textColor),
                        decoration: deco('Parameter name'),
                      ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 92,
                child: TextField(
                  controller: row.value,
                  onChanged: (_) => setState(() {}),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: status.isAbnormal ? status.color : textColor,
                  ),
                  decoration: deco('Result'),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  row.fromCatalog
                      ? (row.expanded ? Icons.expand_less_rounded : Icons.tune_rounded)
                      : Icons.close_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() {
                  if (row.fromCatalog) {
                    row.expanded = !row.expanded;
                  } else {
                    rows.removeAt(i).dispose();
                    if (rows.isEmpty) rows.add(_ParamRow()..expanded = true);
                  }
                }),
              ),
            ],
          ),
          if (status.label.isNotEmpty && !row.fromCatalog)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 6),
              child: Align(alignment: Alignment.centerRight, child: StatusPill(status)),
            ),
          if (row.expanded || !row.fromCatalog) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: row.unit,
                      style: GoogleFonts.outfit(fontSize: 12, color: textColor),
                      decoration: deco('Unit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: row.range,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.outfit(fontSize: 12, color: textColor),
                      decoration: deco('Ref range e.g. 4 - 11, < 200'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
