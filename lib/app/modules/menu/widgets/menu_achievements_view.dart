import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

class MenuAchievementsView extends StatelessWidget {
  final bool isDark;

  const MenuAchievementsView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
                child: _buildStreakCard(isDark, 'Water Streak', '$waterStr Days', Icons.local_fire_department_rounded, Colors.orangeAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildStreakCard(isDark, 'Pill Streak', '$medStr Days', Icons.star_border_purple500_rounded, Colors.purpleAccent),
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

          _buildBadgeTile(
            isDark,
            'First Dose Taken',
            'Take your medicine reminder for the first time.',
            Icons.check_circle_rounded,
            takenCount >= 1,
          ),
          const SizedBox(height: 12),
          _buildBadgeTile(
            isDark,
            'Consistency Novice',
            'Maintain a medicine streak of 7 consecutive days.',
            Icons.military_tech_rounded,
            medStr >= 7,
          ),
          const SizedBox(height: 12),
          _buildBadgeTile(
            isDark,
            'Hydration Master',
            'Drink water and log streak for 30 consecutive days.',
            Icons.opacity_rounded,
            waterStr >= 30,
          ),
          const SizedBox(height: 12),
          _buildBadgeTile(
            isDark,
            'Centurion Patient',
            'Successfully logged 100 medicine dosages.',
            Icons.workspace_premium_rounded,
            takenCount >= 100,
          ),
          const SizedBox(height: 12),
          _buildBadgeTile(
            isDark,
            'Super Hydrator',
            'Drink 100 glasses of water total.',
            Icons.wine_bar_rounded,
            waterGlasses >= 100,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStreakCard(bool isDark, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(bool isDark, String name, String desc, IconData icon, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.amber.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlocked ? icon : Icons.lock_outline_rounded,
              color: isUnlocked ? Colors.amber[800] : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? (isDark ? Colors.white : AppColors.textPrimary) : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
