import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';

class WaterCustomInputButton extends StatelessWidget {
  const WaterCustomInputButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WaterIntakeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textController = TextEditingController();

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Custom Amount',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(),
                  decoration: InputDecoration(
                    hintText: 'Enter amount in ml (e.g. 350)',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final int? amount = int.tryParse(textController.text);
                      if (amount != null && amount > 0) {
                        controller.logWater(amount);
                        Get.back();
                        Get.snackbar(
                          'Water Logged 💧',
                          'Successfully added $amount ml!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue.withValues(alpha: 0.8),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 1),
                        );
                      } else {
                        Get.snackbar('Error', 'Please enter a valid amount');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Log Water',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            child: const Icon(Icons.add_rounded, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            'Custom',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            'Log target',
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
