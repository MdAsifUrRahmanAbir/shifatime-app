import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../../../data/models/dose_record_model.dart';
import '../controllers/medicine_controller.dart';

class FullScreenAlarmView extends StatefulWidget {
  const FullScreenAlarmView({super.key});

  @override
  State<FullScreenAlarmView> createState() => _FullScreenAlarmViewState();
}

class _FullScreenAlarmViewState extends State<FullScreenAlarmView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final MedicineController controller = Get.find<MedicineController>();
  late String doseId;
  DoseRecord? dose;
  Medicine? medicine;

  @override
  void initState() {
    super.initState();
    doseId = Get.arguments ?? '';
    dose = controller.doseBox.get(doseId);
    if (dose != null) {
      medicine = controller.medicines.firstWhereOrNull((m) => m.id == dose!.medicineId);
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dose == null) {
      return Scaffold(
        backgroundColor: AppColors.darkScaffoldBackground,
        body: Center(
          child: Text(
            'Dose details not found.',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header Ringing status
              Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.alarm_on_rounded, color: AppColors.limeAccent, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'MEDICINE ALARM ACTIVE',
                        style: GoogleFonts.outfit(
                          color: AppColors.limeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 2. Pulsing Medicine Illustration and Details
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.limeAccent.withValues(alpha: 0.15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.limeAccent.withValues(alpha: 0.2),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _getIconForType(dose!.medicineType),
                              size: 64,
                              color: AppColors.limeAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),

                  // Medicine Name
                  Text(
                    dose!.medicineName ?? 'Pill Due',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dosage & Type
                  Text(
                    dose!.customDosage ?? '1 Dose',
                    style: GoogleFonts.outfit(
                      color: AppColors.limeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meal relation details
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      dose!.mealRelation ?? 'Meal instruction',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  if (medicine != null && medicine!.usageInstruction != null && medicine!.usageInstruction!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Note: ${medicine!.usageInstruction}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // 3. Action Buttons Section
              Column(
                children: [
                  // Taken Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.takeDose(dose!);
                        Get.back();
                        Get.snackbar(
                          'Done! 👍',
                          '${dose!.medicineName} recorded as taken!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primary,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 24, color: AppColors.limeDarkText),
                      label: Text(
                        'Taken',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.limeDarkText,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Row for Snooze & Skip
                  Row(
                    children: [
                      // Snooze Button
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () => _showSnoozeBottomSheet(context),
                            icon: const Icon(Icons.snooze_rounded, color: Colors.white),
                            label: Text(
                              'Snooze',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white30, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Skip Button
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              controller.skipDose(dose!);
                              Get.back();
                              Get.snackbar(
                                'Skipped ❌',
                                '${dose!.medicineName} marked as skipped.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                            label: Text(
                              'Skip',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnoozeBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.darkCardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Snooze Duration',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how long to delay the alarm.',
              style: GoogleFonts.outfit(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            _buildSnoozeTile(5, '5 Minutes'),
            _buildSnoozeTile(10, '10 Minutes'),
            _buildSnoozeTile(15, '15 Minutes'),
            _buildSnoozeTile(30, '30 Minutes'),
            _buildSnoozeTile(60, '1 Hour'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSnoozeTile(int minutes, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.access_time_rounded, color: AppColors.limeAccent),
      title: Text(
        label,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
      onTap: () {
        controller.snoozeDose(dose!, minutes);
        Get.back(); // close bottomsheet
        Get.back(); // close alarm screen
        Get.snackbar(
          'Snoozed ⏰',
          '${dose!.medicineName} snoozed for $label.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  IconData _getIconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Icons.medication_rounded;
      case 'capsule':
        return Icons.medication_liquid_rounded;
      case 'syrup':
        return Icons.water_drop_rounded;
      case 'injection':
        return Icons.vaccines_rounded;
      case 'cream':
        return Icons.healing_rounded;
      case 'eye drop':
        return Icons.remove_red_eye_rounded;
      case 'ear drop':
        return Icons.hearing_rounded;
      case 'nasal spray':
        return Icons.air_rounded;
      case 'inhaler':
        return Icons.bubble_chart_rounded;
      case 'patch':
        return Icons.crop_landscape_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
