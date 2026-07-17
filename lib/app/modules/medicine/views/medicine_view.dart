import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/medicine_model.dart';
import '../controllers/medicine_controller.dart';
import '../../water_intake/controllers/water_intake_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import 'package:intl/intl.dart';

class MedicineView extends GetView<MedicineController> {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    final WaterIntakeController waterCtrl = Get.put(WaterIntakeController());
    final ProfileController profileCtrl = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Premium Header (Profile + 2 circular buttons)
              _buildHeader(context, profileCtrl, isDark),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // 2. Lime Green Progress Card
                      _buildProgressCard(context, waterCtrl),

                      const SizedBox(height: 16),
                      // 3. Grid Row (Active Medicines + Water Log)
                      _buildSummaryGrid(context, waterCtrl),

                      const SizedBox(height: 16),
                      // Health Tip of the Day
                      _buildTipCard(context, isDark),

                      const SizedBox(height: 24),
                      // 4. Calendar Strip Row
                      _buildCalendarBar(isDark),

                      const SizedBox(height: 16),
                      // 5. Today's Medicine Reminders Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Schedule",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "Swipe/Hold to Delete",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 6. Medicine Reminders List (One Card Per Medicine)
                      Obx(() {
                        if (controller.medicines.isEmpty) {
                          return _buildEmptyState(isDark);
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.medicines.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final medicine = controller.medicines[index];
                            return _buildMedicineDashboardCard(context, medicine, isDark);
                          },
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileController profileCtrl, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: User Avatar + Greeter
          GestureDetector(
            onTap: () => Get.toNamed(Routes.profile),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.limeAccent, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=shifatime_user',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning!',
                      style: GoogleFonts.outfit(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(() => Text(
                          profileCtrl.name.value.isNotEmpty
                              ? profileCtrl.name.value
                              : 'Sajibur Rahman',
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),

          // Right side: Calendar & Notification icons
          Row(
            children: [
              _buildHeaderIconButton(
                context,
                Icons.calendar_today_outlined,
                onTap: () => Get.toNamed(Routes.waterIntake), // Statistics Screen
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(
                context,
                Icons.notifications_none_outlined,
                hasDot: true,
                onTap: () {
                  Get.snackbar(
                    'Notifications 🔔',
                    'All scheduled medicine reminders are active!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton(BuildContext context, IconData icon, {bool hasDot = false, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          if (hasDot)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, WaterIntakeController waterCtrl) {
    return Obx(() {
      final double progress = waterCtrl.targetMl.value > 0
          ? (waterCtrl.consumedMl.value / waterCtrl.targetMl.value).clamp(0.0, 1.0)
          : 0.0;
      final int percent = (progress * 100).toInt();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.limeAccent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.limeDarkText, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Daily intake',
                        style: GoogleFonts.outfit(
                          color: AppColors.limeDarkText.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Weekly\nProgress',
                    style: GoogleFonts.outfit(
                      color: AppColors.limeDarkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Right side circular progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    backgroundColor: Colors.white.withValues(alpha: 0.35),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Text(
                  '$percent%',
                  style: GoogleFonts.outfit(
                    color: AppColors.limeDarkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryGrid(BuildContext context, WaterIntakeController waterCtrl) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Left Card: Medicines
        Expanded(
          child: Obx(() {
            final activeCount = controller.medicines.length;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                        'Medicines',
                        style: GoogleFonts.outfit(
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.limeAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medication_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$activeCount scheduled',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 14),

        // Right Card: Water Logged
        Expanded(
          child: Obx(() {
            final glasses = (waterCtrl.consumedMl.value / 250).toStringAsFixed(1);
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.waterIntake),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                          'Water Log',
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white70 : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_drink_outlined,
                          color: Colors.blueAccent,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$glasses glasses',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ],
  );
}

  Widget _buildTipCard(BuildContext context, bool isDark) {
    final allTips = [
      "Drink one glass of water after waking up to help rehydrate your body after sleep.",
      "Always complete the prescribed course of antibiotics, even if you start feeling better.",
      "Drinking water regularly supports digestion and maintains body temperature.",
      "A balanced meal should include vegetables, protein, and whole grains to support overall health.",
      "Avoid using mobile screens in bed to significantly improve your sleep quality.",
      "Try to walk at least 30 minutes daily to keep your heart healthy and lower stress.",
      "Limit added sugar intake to reduce risk of diabetes and maintain stable energy levels.",
      "Standing up and stretching for 2 minutes every hour boosts blood circulation."
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final tip = allTips[dayOfYear % allTips.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.limeAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_incandescent_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Tip of the Day",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarBar(bool isDark) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final dates = ['07', '08', '09', '10', '11', '12', '13'];
    final selectedIdx = 3; // "W 10" highlighted like in mockup

    // Month header
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'August 2025',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                _buildCalArrow(isDark, Icons.arrow_back_ios_new_rounded),
                const SizedBox(width: 8),
                _buildCalArrow(isDark, Icons.arrow_forward_ios_rounded),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Date row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(days.length, (index) {
            final isSelected = index == selectedIdx;
            return isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.limeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: GoogleFonts.outfit(
                            color: AppColors.limeDarkText,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dates[index],
                          style: GoogleFonts.outfit(
                            color: AppColors.limeDarkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dates[index],
                          style: GoogleFonts.outfit(
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ],
    );
  }

  Widget _buildCalArrow(bool isDark, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 10,
        color: isDark ? Colors.white70 : AppColors.textPrimary,
      ),
    );
  }



  Widget _buildMedicineDashboardCard(BuildContext context, Medicine medicine, bool isDark) {
    final doses = controller.todayDoses.where((d) => d.medicineId == medicine.id).toList();
    final nextPending = doses.firstWhereOrNull((d) => d.status == 'pending' || d.status == 'snoozed' || d.status == 'missed');
    
    final bool isCompletedToday = doses.isNotEmpty && doses.every((d) => d.status == 'taken');
    final bool isSkippedToday = doses.isNotEmpty && doses.every((d) => d.status == 'skipped');
    
    String timeStr = 'N/A';
    if (nextPending != null) {
      timeStr = _formatTimeString(nextPending.timeStr);
    } else if (doses.isNotEmpty) {
      timeStr = _formatTimeString(doses.last.timeStr);
    }

    return Dismissible(
      key: Key(medicine.id ?? UniqueKey().toString()),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteMedicine(medicine.id!);
        Get.snackbar(
          'Deleted 🗑️',
          '${medicine.name} removed successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.medicineDetails, arguments: medicine),
        onLongPress: () => _showDeleteDialog(medicine),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isCompletedToday
                  ? Colors.green.withValues(alpha: 0.3)
                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.02)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with custom circular container depending on medicine type
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _getIconBgColor(medicine.type),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    _getIconForType(medicine.type),
                    color: _getIconColor(medicine.type),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name ?? 'Unknown Pill',
                      style: GoogleFonts.outfit(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange.withValues(alpha: 0.8),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${medicine.customDosage ?? "${medicine.dosage} ${medicine.type}"} • ${medicine.mealRelation}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Reminder Time Text + Actions button
              Row(
                children: [
                  if (isCompletedToday) ...[
                    Text(
                      'Done',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ] else if (isSkippedToday) ...[
                    Text(
                      'Skipped',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    Text(
                      timeStr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (nextPending != null)
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.fullScreenAlarm, arguments: nextPending.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : AppColors.greyLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : AppColors.greyLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeString(String? time24) {
    if (time24 == null || time24.isEmpty) return '';
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final date = DateTime(2026, 1, 1, hour, minute);
      return DateFormat('hh:mm a').format(date);
    } catch (_) {
      return time24;
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services_outlined, size: 54, color: AppColors.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No medicines scheduled yet',
              style: GoogleFonts.outfit(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap the + button below to add your first dose.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(context, Icons.home_rounded, 'Home', isSelected: true, onTap: () {}),
          _buildNavBarItem(
            context,
            Icons.analytics_outlined,
            'Progress',
            onTap: () => Get.offAllNamed(Routes.waterIntake),
          ),

          // Central Add Button
          GestureDetector(
            onTap: () => Get.toNamed(Routes.addMedicine),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.limeAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.limeAccent.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.limeDarkText,
                size: 28,
              ),
            ),
          ),

          _buildNavBarItem(
            context,
            Icons.library_books_outlined,
            'Blog',
            onTap: () => Get.offAllNamed(Routes.healthTips),
          ),
          _buildNavBarItem(
            context,
            Icons.menu_rounded,
            'Menu',
            onTap: () => Get.offAllNamed(Routes.menu),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Medicine medicine) {
    Get.defaultDialog(
      title: 'Delete Medicine',
      titleStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      middleText: 'Are you sure you want to delete ${medicine.name}?',
      middleTextStyle: GoogleFonts.outfit(),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        controller.deleteMedicine(medicine.id!);
        Get.back();
      },
    );
  }

  IconData _getIconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Icons.medication_rounded;
      case 'capsule':
        return Icons.medication_liquid_rounded;
      case 'syrup':
        return Icons.water_drop_rounded;
      case 'injection':
        return Icons.vaccines_rounded;
      case 'cream':
        return Icons.healing_rounded;
      case 'eye drop':
        return Icons.remove_red_eye_rounded;
      case 'ear drop':
        return Icons.hearing_rounded;
      case 'nasal spray':
        return Icons.air_rounded;
      case 'inhaler':
        return Icons.bubble_chart_rounded;
      case 'patch':
        return Icons.crop_landscape_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getIconBgColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Colors.green.withValues(alpha: 0.1);
      case 'capsule':
        return Colors.teal.withValues(alpha: 0.1);
      case 'syrup':
        return Colors.blue.withValues(alpha: 0.1);
      case 'injection':
        return Colors.red.withValues(alpha: 0.1);
      case 'cream':
        return Colors.orange.withValues(alpha: 0.1);
      case 'eye drop':
        return Colors.indigo.withValues(alpha: 0.1);
      case 'ear drop':
        return Colors.cyan.withValues(alpha: 0.1);
      case 'nasal spray':
        return Colors.purple.withValues(alpha: 0.1);
      case 'inhaler':
        return Colors.pink.withValues(alpha: 0.1);
      case 'patch':
        return Colors.amber.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'tablet':
        return Colors.green;
      case 'capsule':
        return Colors.teal;
      case 'syrup':
        return Colors.blue;
      case 'injection':
        return Colors.red;
      case 'cream':
        return Colors.orange;
      case 'eye drop':
        return Colors.indigo;
      case 'ear drop':
        return Colors.cyan;
      case 'nasal spray':
        return Colors.purple;
      case 'inhaler':
        return Colors.pink;
      case 'patch':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
