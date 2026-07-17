import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/medicine_model.dart';
import '../controllers/medicine_controller.dart';

class MedicineDetailsView extends GetView<MedicineController> {
  const MedicineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Medicine medicine = Get.arguments;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Medicine Details',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill Image and Basic Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pill Illustration
                  Container(
                    width: 110,
                    height: 150,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/capsule_medicine.png',
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoLabel('PILL NAME'),
                        const SizedBox(height: 4),
                        Text(
                          medicine.name ?? 'Unknown',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoLabel('DOSAGE'),
                        const SizedBox(height: 4),
                        Text(
                          medicine.customDosage ?? '${medicine.dosage} ${medicine.type}(s)',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoLabel('FIRST DOSE'),
                        const SizedBox(height: 4),
                        Text(
                          _calculateNextDose(medicine.reminderTimes),
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detailed Parameters Block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    Icons.schedule_rounded,
                    'Dose Schedule',
                    '${medicine.reminderTimes?.length ?? 0} times • ${medicine.reminderTimes?.join(', ') ?? 'N/A'}',
                  ),
                  const Divider(height: 32),
                  _buildDetailRow(
                    context,
                    Icons.calendar_today_rounded,
                    'Program Duration',
                    _formatProgram(medicine),
                  ),
                  const Divider(height: 32),
                  _buildDetailRow(
                    context,
                    Icons.restaurant_menu_rounded,
                    'Meal Relation',
                    medicine.mealRelation ?? 'Not specified',
                  ),
                  if (medicine.applicationArea != null && medicine.applicationArea!.isNotEmpty) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      context,
                      Icons.location_on_rounded,
                      'Application Area',
                      'Apply on ${medicine.applicationArea}',
                    ),
                  ],
                  if (medicine.usageInstruction != null && medicine.usageInstruction!.isNotEmpty) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      context,
                      Icons.info_rounded,
                      'Instructions / Notes',
                      medicine.usageInstruction!,
                    ),
                  ],
                ],
              ),
            ),

            // Today's Dose Tracker checklist
            Obx(() {
              final todayDoses = controller.todayDoses.where((d) => d.medicineId == medicine.id).toList();
              if (todayDoses.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Today's Intake Status",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBackground : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todayDoses.length,
                      separatorBuilder: (context, index) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final dose = todayDoses[index];
                        final isTaken = dose.status == 'taken';
                        final isSkipped = dose.status == 'skipped';

                        return Row(
                          children: [
                            Icon(
                              isTaken
                                  ? Icons.check_circle_rounded
                                  : (isSkipped ? Icons.cancel_rounded : Icons.radio_button_off_rounded),
                              color: isTaken
                                  ? Colors.green
                                  : (isSkipped ? Colors.redAccent : Colors.grey),
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dose.timeStr ?? '',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isTaken
                                        ? 'Taken at ${dose.takenTime != null ? TimeOfDay.fromDateTime(dose.takenTime!).format(context) : ""}'
                                        : (isSkipped ? 'Skipped' : 'Pending'),
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 48),

            // Back / Close Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close Details',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        color: Colors.grey[500],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateNextDose(List<String>? times) {
    if (times == null || times.isEmpty) return 'N/A';
    return times.first;
  }

  String _formatProgram(Medicine med) {
    if (med.durationType == 'Nonstop') return 'Nonstop / Regular';
    if (med.durationType == 'Specific Days') {
      return 'Specified Days: ${med.durationValue}';
    }
    return '${med.durationValue} ${med.durationUnit} total';
  }
}
