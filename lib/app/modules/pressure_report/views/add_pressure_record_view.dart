import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/services/app_snackbar.dart';
import '../../../core/services/health_analytics.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../data/models/pressure_record_model.dart';
import '../../../widgets/health_widgets.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../controllers/pressure_report_controller.dart';

/// Add or edit a blood pressure reading. Pass a [PressureRecord] as
/// Get.arguments to edit.
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
  final pulseController = TextEditingController();
  final notesController = TextEditingController();

  PressureRecord? editing;
  String? arm;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is PressureRecord) {
      editing = arg;
      systolicController.text = '${arg.systolic ?? ''}';
      diastolicController.text = '${arg.diastolic ?? ''}';
      pulseController.text = arg.pulse?.toString() ?? '';
      notesController.text = arg.notes ?? '';
      arm = arg.arm;
      selectedDate = arg.recordDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    pulseController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String? _range(String? v, int min, int max, {bool optional = false}) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return optional ? null : 'Required';
    final n = int.tryParse(t);
    if (n == null) return 'Invalid';
    if (n < min || n > max) return '$min-$max';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final sys = int.parse(systolicController.text.trim());
    final dia = int.parse(diastolicController.text.trim());
    if (dia >= sys) {
      AppSnackBar.error('Diastolic (lower number) must be less than systolic');
      return;
    }
    controller.saveRecord(
      editId: editing?.id,
      systolic: sys,
      diastolic: dia,
      pulse: int.tryParse(pulseController.text.trim()),
      arm: arm,
      recordDate: selectedDate,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );
    Get.back();
    AppSnackBar.success(editing == null ? 'Pressure reading saved' : 'Reading updated');
    if (editing == null) AdService.showInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sys = int.tryParse(systolicController.text.trim());
    final dia = int.tryParse(diastolicController.text.trim());
    final status = (sys != null && dia != null) ? HealthAnalytics.bpStatus(sys, dia) : HealthStatus.unknown;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(editing == null ? 'Add Blood Pressure' : 'Edit Reading',
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
                      child: PrimaryInputField(
                        label: 'Systolic (upper)',
                        hint: 'e.g. 120',
                        controller: systolicController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        validator: (v) => _range(v, 60, 260),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryInputField(
                        label: 'Diastolic (lower)',
                        hint: 'e.g. 80',
                        controller: diastolicController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        validator: (v) => _range(v, 30, 160),
                      ),
                    ),
                  ],
                ),
                if (status.label.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Category: ', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                      StatusPill(status, fontSize: 12),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                PrimaryInputField(
                  label: 'Pulse / heart rate (optional)',
                  hint: 'e.g. 72 bpm',
                  controller: pulseController,
                  keyboardType: TextInputType.number,
                  validator: (v) => _range(v, 30, 220, optional: true),
                ),
                const SizedBox(height: 18),
                Text('Arm (optional)',
                    style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary)),
                const SizedBox(height: 8),
                ChoiceChipsRow<String?>(
                  values: const [null, ...PressureReportController.arms],
                  selected: arm,
                  labelOf: (a) => a ?? 'Not set',
                  onSelected: (a) => setState(() => arm = a),
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
                  hint: 'e.g. After 5 min rest, sitting',
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
