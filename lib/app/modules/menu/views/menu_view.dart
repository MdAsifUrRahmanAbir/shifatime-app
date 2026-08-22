import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../medicine/controllers/medicine_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../widgets/menu_main_grid.dart';
import '../widgets/menu_inventory_view.dart';
import '../widgets/menu_achievements_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _ViewState();
}

class _ViewState extends State<MenuView> {
  String _currentView = 'menu'; // menu, inventory, achievements
  final MedicineController medCtrl = Get.put(MedicineController());
  final ProfileController profileCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          _currentView == 'menu'
              ? 'Menu Hub'
              : (_currentView == 'inventory' ? 'Stock Inventory' : 'Streaks & Achievements'),
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: _currentView != 'menu'
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
                onPressed: () => setState(() => _currentView = 'menu'),
              )
            : null,
      ),
      body: ResponsiveLayout(mobile: _buildBody(context, isDark)),
      bottomNavigationBar: _currentView == 'menu' ? const AppBottomNavBar(current: AppNavTab.menu) : null,
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    switch (_currentView) {
      case 'inventory':
        return MenuInventoryView(medCtrl: medCtrl, isDark: isDark);
      case 'achievements':
        return MenuAchievementsView(isDark: isDark);
      default:
        return MenuMainGrid(
          isDark: isDark,
          profileCtrl: profileCtrl,
          onInventoryTap: () => setState(() => _currentView = 'inventory'),
          onAchievementsTap: () => setState(() => _currentView = 'achievements'),
          onThemeToggle: () {
            LocalStorage.switchTheme();
            setState(() {});
          },
        );
    }
  }
}
