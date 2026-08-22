import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class BatteryCompatibilityCard extends StatelessWidget {
  final bool isDark;

  const BatteryCompatibilityCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Important for Android Users',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Aggressive battery savers on devices (Samsung, Xiaomi, Oppo, OnePlus, Vivo) may block reminders when the app is closed.',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600], height: 1.4),
          ),
          const SizedBox(height: 14),
          Text(
            '💡 Recommendation:',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please disable Battery Optimization for ShifaTime in your system settings to ensure alarms trigger reliably at the exact minute.',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ),
    );
  }
}
