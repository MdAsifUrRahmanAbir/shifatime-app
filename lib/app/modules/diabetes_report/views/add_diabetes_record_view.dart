import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/services/health_analytics.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/models/diabetes_record_model.dart';
import '../../../widgets/health_widgets.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_dropdown.dart';
import '../../../widgets/primary_input_field.dart';
import '../controllers/diabetes_report_controller.dart';

/// Add or edit a blood sugar reading. Pass a [DiabetesRecord] as
/// Get.arguments to edit.
class AddDiabetesRecordView extends StatefulWidget {
  const AddDiabetesRecordView({super.key});

  @override
  State<AddDiabetesRecordView> createState() => _AddDiabetesRecordViewState();
}

class _AddDiabetesRecordViewState extends State<AddDiabetesRecordView> {
  final DiabetesReportController controller = Get.find<DiabetesReportController>();
  final _formKey = GlobalKey<FormState>();

  final valueController = TextEditingController();
  final notesController = TextEditingController();

  DiabetesRecord? editing;
  String selectedUnit = 'mg/dL';
  String selectedType = 'Fasting';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is DiabetesRecord) {
      editing = arg;
      final v = arg.value ?? 0;
      valueController.text = arg.unit == 'mmol/L' ? v.toStringAsFixed(1) : v.toStringAsFixed(0);
      notesController.text = arg.notes ?? '';
      selectedUnit = arg.unit ?? 'mg/dL';
      selectedType = DiabetesReportController.readingTypes.contains(arg.readingType) ? arg.readingType! : 'Random';
      selectedDate = arg.recordDate ?? DateTime.now();
    } else {
      // Sensible default type from time of day.
      final h = DateTime.now().hour;
      selectedType = h < 10 ? 'Fasting' : (h >= 21 ? 'Bedtime' : 'Post Prandial (PP)');
    }
  }

  @override
  void dispose() {
    valueController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    controller.saveRecord(
      editId: editing?.id,
      value: double.parse(valueController.text.trim()),
      unit: selectedUnit,
      readingType: selectedType,
      recordDate: selectedDate,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );
    Get.back();
    AppSnackBar.success(editing == null ? 'Blood sugar reading saved' : 'Reading updated');
    if (editing == null) AdService.showInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final v = double.tryParse(valueController.text.trim());
    final status = v == null ? HealthStatus.unknown : HealthAnalytics.sugarStatus(v, selectedUnit, selectedType);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(editing == null ? 'Add Blood Sugar' : 'Edit Reading',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(
        mobile: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: PrimaryInputField(
                        label: 'Blood sugar',
                        hint: selectedUnit == 'mg/dL' ? 'e.g. 110' : 'e.g. 6.1',
                        controller: valueController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        validator: (val) {
                          final n = double.tryParse(val?.trim() ?? '');
                          if (n == null) return 'Enter a valid number';
                          final mg = HealthAnalytics.toMgdl(n, selectedUnit);
                          if (mg < 10 || mg > 900) return 'Value looks wrong';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: PrimaryDropdown<String>(
                        label: 'Unit',
                        hint: 'Unit',
                        value: selectedUnit,
                        items: DiabetesReportController.units
                            .map((u) => DropdownMenuItem(value: u, child: Text(u, style: GoogleFonts.outfit())))
                            .toList(),
                        onChanged: (val) => setState(() => selectedUnit = val ?? 'mg/dL'),
                      ),
                    ),
                  ],
                ),
                if (status.label.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Status: ', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                      StatusPill(status, fontSize: 12),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                Text('When was it measured?',
                    style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary)),
                const SizedBox(height: 8),
                ChoiceChipsRow<String>(
                  values: DiabetesReportController.readingTypes,
                  selected: selectedType,
                  labelOf: (t) => t == 'Post Prandial (PP)' ? 'After Meal (2 hrs)' : t,
                  onSelected: (t) => setState(() => selectedType = t),
                ),
                const SizedBox(height: 18),
                DateTimePickerRow(
                  label: 'Date & time',
                  value: selectedDate,
                  onChanged: (d) => setState(() => selectedDate = d),
                ),
                const SizedBox(height: 18),
                PrimaryInputField(
                  label: 'Notes (optional)',
                  hint: 'e.g. After rice lunch, before insulin',
                  controller: notesController,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: editing == null ? 'Save Reading' : 'Update Reading', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
