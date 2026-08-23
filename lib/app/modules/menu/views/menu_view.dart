import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../profile/controllers/profile_controller.dart';
import '../widgets/menu_main_grid.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileCtrl = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Menu Hub',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveLayout(
        mobile: MenuMainGrid(
          isDark: isDark,
          profileCtrl: profileCtrl,
          onThemeToggle: () => LocalStorage.switchTheme(),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(current: AppNavTab.menu),
    );
  }
}
