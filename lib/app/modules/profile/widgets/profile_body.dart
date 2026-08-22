import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/profile_controller.dart';
import 'bmi_card.dart';
import 'profile_edit_bottom_sheet.dart';
import 'profile_stat_card.dart';
import 'profile_stat_tile.dart';

class ProfileBody extends StatelessWidget {
  final ProfileController controller;

  const ProfileBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.limeAccent, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=shifatime_user'),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => Text(
                      controller.name.value.isNotEmpty ? controller.name.value : 'Sajibur Rahman',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    )),
                const SizedBox(height: 4),
                Obx(() => Text(
                      'Age: ${controller.age.value} Years | Gender: ${controller.gender.value} | Offline Account',
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          BmiCard(controller: controller, isDark: isDark),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(() => ProfileStatTile(
                      title: 'Height',
                      value: '${controller.height.value.toInt()} cm',
                      icon: Icons.height_rounded,
                      color: Colors.blueAccent,
                      isDark: isDark,
                    )),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Obx(() => ProfileStatTile(
                      title: 'Weight',
                      value: '${controller.weight.value.toInt()} kg',
                      icon: Icons.scale_rounded,
                      color: Colors.orangeAccent,
                      isDark: isDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => ProfileStatCard(
                title: 'Daily Water Target',
                value: '${controller.waterTarget.value.toInt()} ml',
                icon: Icons.local_drink_rounded,
                color: Colors.teal,
                isDark: isDark,
              )),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => showProfileEditBottomSheet(context, controller),
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 24),
              label: Text(
                'Edit Health Details',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
