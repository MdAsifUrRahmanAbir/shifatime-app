import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/profile_controller.dart';

class BmiCard extends StatelessWidget {
  final ProfileController controller;
  final bool isDark;

  const BmiCard({super.key, required this.controller, required this.isDark});

  Color _getBmiColor(String category) {
    switch (category.toLowerCase()) {
      case 'normal weight':
        return Colors.green;
      case 'underweight':
        return Colors.orange;
      case 'overweight':
        return Colors.amber[800]!;
      case 'obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBmiBadge(String category) {
    final color = _getBmiColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category,
        style: GoogleFonts.outfit(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BMI (Body Mass Index)',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Obx(() => _buildBmiBadge(controller.bmiCategory.value)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Obx(() => Text(
                    '${controller.bmi.value}',
                    style: GoogleFonts.outfit(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: _getBmiColor(controller.bmiCategory.value),
                    ),
                  )),
              const SizedBox(width: 8),
              Text(
                'kg/m²',
                style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Health Suggestion:',
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 6),
          Obx(() => Text(
                controller.healthAdvice.value,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                  height: 1.4,
                ),
              )),
        ],
      ),
    );
  }
}
