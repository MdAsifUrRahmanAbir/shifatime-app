import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'water_weekly_chart.dart';
import 'water_parameters_grid.dart';
import 'water_quick_cup_button.dart';
import 'water_custom_input_button.dart';
import 'water_today_logs_list.dart';

class WaterIntakeBody extends StatelessWidget {
  const WaterIntakeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Weekly Intake Bar Chart Card (Mockup Style)
          const WaterWeeklyChart(),

          const SizedBox(height: 16),

          // 2. Parameters Grid (Logs Count & Progress)
          const WaterParametersGrid(),

          const SizedBox(height: 24),

          // 3. Quick Log Water Buttons
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Log Intake',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WaterQuickCupButton(amount: 150, label: 'Cup', icon: Icons.local_cafe_outlined),
              WaterQuickCupButton(amount: 250, label: 'Glass', icon: Icons.local_drink_outlined),
              WaterQuickCupButton(amount: 500, label: 'Bottle', icon: Icons.water_drop_outlined),
              WaterCustomInputButton(),
            ],
          ),

          const SizedBox(height: 28),

          // 4. Today's Logs Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Today\'s Logs',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. Today's Logs List
          const WaterTodayLogsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
