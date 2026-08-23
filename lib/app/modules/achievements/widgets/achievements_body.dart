import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import 'achievement_streak_card.dart';
import 'achievement_badge_tile.dart';

class AchievementsBody extends StatelessWidget {
  const AchievementsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final waterStr = LocalStorage.getWaterStreak();
    final medStr = LocalStorage.getMedicineStreak();
    final takenCount = LocalStorage.getMedicinesTakenCount();
    final waterGlasses = LocalStorage.getWaterGlassesCount();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AchievementStreakCard(
                  isDark: isDark,
                  label: 'Water Streak',
                  value: '$waterStr Days',
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AchievementStreakCard(
                  isDark: isDark,
                  label: 'Pill Streak',
                  value: '$medStr Days',
                  icon: Icons.star_border_purple500_rounded,
                  color: Colors.purpleAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          Text(
            'Achievements Badges',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          AchievementBadgeTile(
            isDark: isDark,
            name: 'First Dose Taken',
            desc: 'Take your medicine reminder for the first time.',
            icon: Icons.check_circle_rounded,
            isUnlocked: takenCount >= 1,
          ),
          const SizedBox(height: 12),
          AchievementBadgeTile(
            isDark: isDark,
            name: 'Consistency Novice',
            desc: 'Maintain a medicine streak of 7 consecutive days.',
            icon: Icons.military_tech_rounded,
            isUnlocked: medStr >= 7,
          ),
          const SizedBox(height: 12),
          AchievementBadgeTile(
            isDark: isDark,
            name: 'Hydration Master',
            desc: 'Drink water and log streak for 30 consecutive days.',
            icon: Icons.opacity_rounded,
            isUnlocked: waterStr >= 30,
          ),
          const SizedBox(height: 12),
          AchievementBadgeTile(
            isDark: isDark,
            name: 'Centurion Patient',
            desc: 'Successfully logged 100 medicine dosages.',
            icon: Icons.workspace_premium_rounded,
            isUnlocked: takenCount >= 100,
          ),
          const SizedBox(height: 12),
          AchievementBadgeTile(
            isDark: isDark,
            name: 'Super Hydrator',
            desc: 'Drink 100 glasses of water total.',
            icon: Icons.wine_bar_rounded,
            isUnlocked: waterGlasses >= 100,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
