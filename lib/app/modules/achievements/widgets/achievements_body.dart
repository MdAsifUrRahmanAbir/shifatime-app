import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/health_analytics.dart';
import '../../../widgets/health_widgets.dart';
import '../controllers/achievements_controller.dart';
import 'achievement_badge_tile.dart';
import 'achievement_streak_card.dart';

class AchievementsBody extends GetView<AchievementsController> {
  const AchievementsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final adherence = controller.adherence30.value;
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => controller.refreshStats(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: AchievementStreakCard(
                    isDark: isDark,
                    label: 'Medicine streak',
                    value: '${controller.medStreak.value} days',
                    caption: 'Best: ${controller.bestMedStreak.value} days',
                    icon: Icons.local_fire_department_rounded,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AchievementStreakCard(
                    isDark: isDark,
                    label: 'Water goal streak',
                    value: '${controller.waterStreak.value} days',
                    caption: 'Best: ${controller.bestWaterStreak.value} days',
                    icon: Icons.water_drop_rounded,
                    color: Colors.lightBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            HealthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: '30-day adherence',
                          value: adherence == null ? '-' : '$adherence%',
                          caption: 'doses taken on schedule',
                          valueColor: adherence == null
                              ? null
                              : (adherence >= 80 ? AppColors.primary : AppColors.warning),
                        ),
                      ),
                      Expanded(
                        child: StatTile(label: 'Doses taken', value: '${controller.dosesTaken.value}', caption: 'all time'),
                      ),
                      Expanded(
                        child: StatTile(
                          label: 'Water',
                          value: '${controller.waterLitres.value.toStringAsFixed(1)} L',
                          caption: '${controller.waterGoalDays.value} goal days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('This week', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [for (final d in controller.week) _dayBar(d, isDark)],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionTitle(
              'Badges',
              trailing: Text('${controller.unlockedCount}/${controller.badges.length} unlocked',
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
            ),
            for (final b in [...controller.badges]..sort((a, b) => b.progress.compareTo(a.progress)))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AchievementBadgeTile(isDark: isDark, badge: b),
              ),
          ],
        ),
      );
    });
  }

  Widget _dayBar(DayDoseSummary d, bool isDark) {
    final ratio = d.total == 0 ? 0.0 : d.taken / d.total;
    final color = d.total == 0
        ? Colors.grey.withValues(alpha: 0.3)
        : (ratio >= 1 ? AppColors.primary : (ratio >= 0.5 ? AppColors.warning : AppColors.error));
    return Column(
      children: [
        Container(
          width: 26,
          height: 60,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FractionallySizedBox(
            heightFactor: d.total == 0 ? 0.08 : ratio.clamp(0.08, 1.0),
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8))),
          ),
        ),
        const SizedBox(height: 4),
        Text(DateFormat('E').format(d.date).substring(0, 2),
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
        Text(d.total == 0 ? '-' : '${d.taken}/${d.total}',
            style: GoogleFonts.outfit(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
