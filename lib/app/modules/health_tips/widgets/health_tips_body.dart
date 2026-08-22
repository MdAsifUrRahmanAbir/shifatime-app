import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'health_category_grid.dart';
import 'health_tip_hero_card.dart';

/// Body content of the Health Library screen: hero tip card + category grid.
class HealthTipsBody extends StatelessWidget {
  const HealthTipsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allTips = HealthCategoryGrid.allTips;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final tipOfTheDay = allTips[dayOfYear % allTips.length];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthTipHeroCard(tipOfTheDay: tipOfTheDay),
          const SizedBox(height: 32),
          Text(
            'Browse Categories',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const HealthCategoryGrid(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
