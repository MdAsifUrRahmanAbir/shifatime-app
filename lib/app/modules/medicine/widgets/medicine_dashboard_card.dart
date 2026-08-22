import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/medicine_model.dart';
import '../controllers/medicine_controller.dart';
import 'medicine_delete_dialog.dart';

class MedicineDashboardCard extends GetView<MedicineController> {
  final Medicine medicine;

  const MedicineDashboardCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doses = controller.todayDoses.where((d) => d.medicineId == medicine.id).toList();
    final nextPending = doses.firstWhereOrNull((d) => d.status == 'pending' || d.status == 'snoozed' || d.status == 'missed');

    final bool isCompletedToday = doses.isNotEmpty && doses.every((d) => d.status == 'taken');
    final bool isSkippedToday = doses.isNotEmpty && doses.every((d) => d.status == 'skipped');

    String timeStr = 'N/A';
    if (nextPending != null) {
      timeStr = _formatTimeString(nextPending.timeStr);
    } else if (doses.isNotEmpty) {
      timeStr = _formatTimeString(doses.last.timeStr);
    }

    return Dismissible(
      key: Key(medicine.id ?? UniqueKey().toString()),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteMedicine(medicine.id!);
        Get.snackbar(
          'Deleted 🗑️',
          '${medicine.name} removed successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.medicineDetails, arguments: medicine),
        onLongPress: () => showMedicineDeleteDialog(medicine, () => controller.deleteMedicine(medicine.id!)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isCompletedToday
                  ? Colors.green.withValues(alpha: 0.3)
                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.02)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with custom circular container depending on medicine type
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _getIconBgColor(medicine.type),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    _getIconForType(medicine.type),
                    color: _getIconColor(medicine.type),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name ?? 'Unknown Pill',
                      style: GoogleFonts.outfit(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange.withValues(alpha: 0.8),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${medicine.customDosage ?? "${medicine.dosage} ${medicine.type}"} • ${medicine.mealRelation}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Reminder Time Text + Actions button
              Row(
                children: [
                  if (isCompletedToday) ...[
                    Text(
                      'Done',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ] else if (isSkippedToday) ...[
                    Text(
                      'Skipped',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    Text(
                      timeStr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (nextPending != null)
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.fullScreenAlarm, arguments: nextPending.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : AppColors.greyLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : AppColors.greyLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeString(String? time24) {
    if (time24 == null || time24.isEmpty) return '';
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final date = DateTime(2026, 1, 1, hour, minute);
      return DateFormat('hh:mm a').format(date);
    } catch (_) {
      return time24;
    }
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

  Color _getIconBgColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Colors.green.withValues(alpha: 0.1);
      case 'capsule':
        return Colors.teal.withValues(alpha: 0.1);
      case 'syrup':
        return Colors.blue.withValues(alpha: 0.1);
      case 'injection':
        return Colors.red.withValues(alpha: 0.1);
      case 'cream':
        return Colors.orange.withValues(alpha: 0.1);
      case 'eye drop':
        return Colors.indigo.withValues(alpha: 0.1);
      case 'ear drop':
        return Colors.cyan.withValues(alpha: 0.1);
      case 'nasal spray':
        return Colors.purple.withValues(alpha: 0.1);
      case 'inhaler':
        return Colors.pink.withValues(alpha: 0.1);
      case 'patch':
        return Colors.amber.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Colors.green;
      case 'capsule':
        return Colors.teal;
      case 'syrup':
        return Colors.blue;
      case 'injection':
        return Colors.red;
      case 'cream':
        return Colors.orange;
      case 'eye drop':
        return Colors.indigo;
      case 'ear drop':
        return Colors.cyan;
      case 'nasal spray':
        return Colors.purple;
      case 'inhaler':
        return Colors.pink;
      case 'patch':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
