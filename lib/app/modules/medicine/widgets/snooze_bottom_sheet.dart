import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/dose_record_model.dart';
import '../controllers/medicine_controller.dart';

void showSnoozeBottomSheet(
  BuildContext context, {
  required DoseRecord dose,
  required MedicineController controller,
}) {
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
          _snoozeTile(dose, controller, 5, '5 Minutes'),
          _snoozeTile(dose, controller, 10, '10 Minutes'),
          _snoozeTile(dose, controller, 15, '15 Minutes'),
          _snoozeTile(dose, controller, 30, '30 Minutes'),
          _snoozeTile(dose, controller, 60, '1 Hour'),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

Widget _snoozeTile(DoseRecord dose, MedicineController controller, int minutes, String label) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.access_time_rounded, color: AppColors.limeAccent),
    title: Text(
      label,
      style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
    ),
    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
    onTap: () {
      controller.snoozeDose(dose, minutes);
      Get.back(); // close bottomsheet
      Get.back(); // close alarm screen
      Get.snackbar(
        'Snoozed ⏰',
        '${dose.medicineName} snoozed for $label.',
        snackPosition: SnackPosition.BOTTOM,
      );
    },
  );
}
