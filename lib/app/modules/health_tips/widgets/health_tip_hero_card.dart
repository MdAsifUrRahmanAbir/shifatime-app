import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// "TODAY'S HEALTH TIP" hero card shown at the top of the Health Library.
class HealthTipHeroCard extends StatelessWidget {
  final String tipOfTheDay;

  const HealthTipHeroCard({super.key, required this.tipOfTheDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.limeAccent,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.limeAccent.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_incandescent_rounded, color: AppColors.limeDarkText, size: 22),
              const SizedBox(width: 8),
              Text(
                'TODAY\'S HEALTH TIP',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.limeDarkText.withValues(alpha: 0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tipOfTheDay,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.limeDarkText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
