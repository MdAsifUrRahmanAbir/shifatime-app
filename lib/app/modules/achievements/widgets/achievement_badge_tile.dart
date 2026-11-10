import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/achievements_controller.dart';

class AchievementBadgeTile extends StatelessWidget {
  final bool isDark;
  final AchievementBadge badge;

  const AchievementBadgeTile({super.key, required this.isDark, required this.badge});

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.unlocked;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked ? Colors.amber.withValues(alpha: 0.5) : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? Colors.amber.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(unlocked ? badge.icon : Icons.lock_outline_rounded,
                color: unlocked ? Colors.amber[800] : Colors.grey, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        badge.name,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? (isDark ? Colors.white : AppColors.textPrimary) : Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      unlocked ? 'Unlocked' : '${badge.current.clamp(0, badge.target)}/${badge.target}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: unlocked ? Colors.amber[800] : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(badge.desc, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey, height: 1.3)),
                if (!unlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: badge.progress,
                      minHeight: 5,
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
