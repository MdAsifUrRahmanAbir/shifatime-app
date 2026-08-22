import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/medicine_controller.dart';
import '../../water_intake/controllers/water_intake_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import 'medicine_home_header.dart';
import 'medicine_progress_card.dart';
import 'medicine_summary_grid.dart';
import 'medicine_tip_card.dart';
import 'medicine_calendar_bar.dart';
import 'medicine_dashboard_card.dart';
import 'medicine_empty_state.dart';

class MedicineHomeBody extends GetView<MedicineController> {
  final WaterIntakeController waterCtrl;
  final ProfileController profileCtrl;

  const MedicineHomeBody({super.key, required this.waterCtrl, required this.profileCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Premium Header (Profile + 2 circular buttons)
        MedicineHomeHeader(profileCtrl: profileCtrl),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // 2. Lime Green Progress Card
                MedicineProgressCard(waterCtrl: waterCtrl),

                const SizedBox(height: 16),
                // 3. Grid Row (Active Medicines + Water Log)
                MedicineSummaryGrid(waterCtrl: waterCtrl),

                const SizedBox(height: 16),
                // Health Tip of the Day
                const MedicineTipCard(),

                const SizedBox(height: 24),
                // 4. Calendar Strip Row
                const MedicineCalendarBar(),

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
                    return const MedicineEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.medicines.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final medicine = controller.medicines[index];
                      return MedicineDashboardCard(medicine: medicine);
                    },
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
