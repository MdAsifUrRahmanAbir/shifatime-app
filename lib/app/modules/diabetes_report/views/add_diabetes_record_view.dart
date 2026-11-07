import 'package:flutter/material.dart';
import '../../../core/services/ad_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../../../widgets/primary_dropdown.dart';
import '../../../widgets/primary_date_picker.dart';
import '../controllers/diabetes_report_controller.dart';

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

  String selectedUnit = 'mg/dL';
  String selectedType = 'Fasting';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    valueController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    controller.addRecord(
      value: double.tryParse(valueController.text.trim()) ?? 0,
      unit: selectedUnit,
      readingType: selectedType,
      recordDate: selectedDate,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );

    AppSnackBar.success('Blood sugar reading saved');
    Get.back();
    AdService.showInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Add Blood Sugar Reading', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                  children: [
                    Expanded(
                      flex: 3,
                      child: PrimaryInputField(
                        label: 'Blood Sugar Value',
                        hint: 'e.g. 110',
                        controller: valueController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
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
                const SizedBox(height: 18),
                PrimaryDropdown<String>(
                  label: 'Reading Type',
                  hint: 'Select reading type',
                  value: selectedType,
                  items: DiabetesReportController.readingTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.outfit())))
                      .toList(),
                  onChanged: (val) => setState(() => selectedType = val ?? 'Fasting'),
                ),
                const SizedBox(height: 18),
                PrimaryDatePicker(
                  label: 'Date',
                  selectedDate: selectedDate,
                  lastDate: DateTime.now(),
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
                const SizedBox(height: 18),
                PrimaryInputField(
                  label: 'Notes (Optional)',
                  hint: 'e.g. After breakfast, before medicine',
                  controller: notesController,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Save Reading', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
