import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';

class WaterQuickCupButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;

  const WaterQuickCupButton({
    super.key,
    required this.amount,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WaterIntakeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        controller.logWater(amount);
        Get.snackbar(
          'Water Logged 💧',
          'Successfully added $amount ml!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            '$amount ml',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
