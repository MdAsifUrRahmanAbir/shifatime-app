import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../../../widgets/primary_date_picker.dart';
import '../controllers/test_report_controller.dart';

class AddTestReportView extends StatefulWidget {
  const AddTestReportView({super.key});

  @override
  State<AddTestReportView> createState() => _AddTestReportViewState();
}

class _AddTestReportViewState extends State<AddTestReportView> {
  final TestReportController controller = Get.find<TestReportController>();
  final _formKey = GlobalKey<FormState>();

  final testNameController = TextEditingController();
  final resultController = TextEditingController();
  final unitController = TextEditingController();
  final normalRangeController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    testNameController.dispose();
    resultController.dispose();
    unitController.dispose();
    normalRangeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    controller.addReport(
      testName: testNameController.text.trim(),
      resultValue: resultController.text.trim(),
      unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
      normalRange: normalRangeController.text.trim().isEmpty ? null : normalRangeController.text.trim(),
      testDate: selectedDate,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );

    AppSnackBar.success('Test report saved');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Add Test Report', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                PrimaryInputField(
                  label: 'Test Name',
                  hint: 'e.g. CBC, Lipid Profile, Creatinine',
                  controller: testNameController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Test name is required' : null,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PrimaryInputField(
                        label: 'Result',
                        hint: 'e.g. 13.5',
                        controller: resultController,
                        keyboardType: TextInputType.text,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: PrimaryInputField(
                        label: 'Unit',
                        hint: 'g/dL',
                        controller: unitController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                PrimaryInputField(
                  label: 'Normal Range (Optional)',
                  hint: 'e.g. 12.0 - 16.0',
                  controller: normalRangeController,
                ),
                const SizedBox(height: 18),
                PrimaryDatePicker(
                  label: 'Test Date',
                  selectedDate: selectedDate,
                  lastDate: DateTime.now(),
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
                const SizedBox(height: 18),
                PrimaryInputField(
                  label: 'Notes (Optional)',
                  hint: 'Any additional remarks from the report',
                  controller: notesController,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Save Report', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
