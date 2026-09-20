import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../../../widgets/primary_date_picker.dart';
import '../controllers/pressure_report_controller.dart';

class AddPressureRecordView extends StatefulWidget {
  const AddPressureRecordView({super.key});

  @override
  State<AddPressureRecordView> createState() => _AddPressureRecordViewState();
}

class _AddPressureRecordViewState extends State<AddPressureRecordView> {
  final PressureReportController controller = Get.find<PressureReportController>();
  final _formKey = GlobalKey<FormState>();

  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    controller.addRecord(
      systolic: int.tryParse(systolicController.text.trim()) ?? 0,
      diastolic: int.tryParse(diastolicController.text.trim()) ?? 0,
      recordDate: selectedDate,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );

    AppSnackBar.success('Pressure reading saved');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Add Pressure Reading', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                      child: PrimaryInputField(
                        label: 'Systolic (mmHg)',
                        hint: 'e.g. 120',
                        controller: systolicController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryInputField(
                        label: 'Diastolic (mmHg)',
                        hint: 'e.g. 80',
                        controller: diastolicController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
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
                  hint: 'e.g. Measured after rest, left arm',
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
