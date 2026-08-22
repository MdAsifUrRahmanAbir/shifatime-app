import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../controllers/medicine_controller.dart';
import '../../water_intake/controllers/water_intake_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../widgets/medicine_home_body.dart';
import '../../../widgets/app_bottom_nav_bar.dart';

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
          child: ResponsiveLayout(
            mobile: MedicineHomeBody(waterCtrl: waterCtrl, profileCtrl: profileCtrl),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(current: AppNavTab.home),
    );
  }
}
