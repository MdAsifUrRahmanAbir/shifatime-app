import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/models/medicine_model.dart';
import '../../medicine/controllers/medicine_controller.dart';
import '../../profile/controllers/profile_controller.dart';

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
      body: _buildBody(context, isDark),
      bottomNavigationBar: _currentView == 'menu' ? _buildBottomNavBar(context) : null,
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    switch (_currentView) {
      case 'inventory':
        return _buildInventoryView(context, isDark);
      case 'achievements':
        return _buildAchievementsView(context, isDark);
      default:
        return _buildMainMenuGrid(context, isDark);
    }
  }

  // 1. MAIN MENU HUB GRID
  Widget _buildMainMenuGrid(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User profile snippet card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(28),
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
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.limeAccent, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=shifatime_user',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            profileCtrl.name.value.isNotEmpty ? profileCtrl.name.value : 'Sajibur Rahman',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        'Offline Personal Health Profile',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onPressed: () => Get.toNamed(Routes.profile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
            children: [
              _buildMenuCard(
                isDark,
                'Health Profile',
                'View BMI & suggestions',
                Icons.person_pin_rounded,
                Colors.blue,
                () => Get.toNamed(Routes.profile),
              ),
              _buildMenuCard(
                isDark,
                'Stock Inventory',
                'Manage remaining pills',
                Icons.inventory_2_rounded,
                Colors.orange,
                () => setState(() => _currentView = 'inventory'),
              ),
              _buildMenuCard(
                isDark,
                'Achievements',
                'Streak logs & awards',
                Icons.stars_rounded,
                Colors.amber,
                () => setState(() => _currentView = 'achievements'),
              ),
              _buildMenuCard(
                isDark,
                'Alarm Settings',
                'Sounds & repeat intervals',
                Icons.notifications_active_rounded,
                Colors.deepOrangeAccent,
                () => Get.toNamed(Routes.notificationSettings),
              ),
              _buildMenuCard(
                isDark,
                'Reminder History',
                'Logs of medicine & water',
                Icons.history_rounded,
                Colors.teal,
                () => Get.toNamed(Routes.reminderHistory),
              ),
              _buildMenuCard(
                isDark,
                isDark ? 'Light Mode' : 'Dark Mode',
                'Toggle system theme',
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                Colors.purple,
                () {
                  LocalStorage.switchTheme();
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    bool isDark,
    String title,
    String desc,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 2. MEDICINE STOCK INVENTORY VIEW
  Widget _buildInventoryView(BuildContext context, bool isDark) {
    return Obx(() {
      final list = medCtrl.medicines;
      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No medicines scheduled',
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final medicine = list[index];
          final hasStock = medicine.totalStock != null;
          final isLow = hasStock && (medicine.totalStock! <= (medicine.stockThreshold ?? 5));

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isLow
                    ? Colors.redAccent.withValues(alpha: 0.3)
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name ?? 'Pill',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dosage: ${medicine.customDosage ?? "${medicine.dosage} ${medicine.type}(s)"}',
                          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLow
                            ? Colors.redAccent.withValues(alpha: 0.15)
                            : (hasStock ? Colors.green.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        hasStock
                            ? '${medicine.totalStock} remaining'
                            : 'Unlimited Stock',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isLow
                              ? Colors.redAccent
                              : (hasStock ? Colors.green : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                if (hasStock) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refill Medicine Stock',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          _buildRefillButton(medicine, 10, '+10'),
                          const SizedBox(width: 8),
                          _buildRefillButton(medicine, 30, '+30'),
                          const SizedBox(width: 8),
                          _buildRefillButton(medicine, 50, '+50'),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildRefillButton(Medicine medicine, int amount, String label) {
    return GestureDetector(
      onTap: () async {
        medicine.totalStock = (medicine.totalStock ?? 0) + amount;
        await medicine.save();
        medCtrl.medicines.refresh();
        Get.snackbar(
          'Stock Refilled! 📦',
          'Successfully refilled ${medicine.name} by $amount counts.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 3. STREAKS & ACHIEVEMENTS VIEW
  Widget _buildAchievementsView(BuildContext context, bool isDark) {
    // Read stats from storage
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
          // Streaks Row
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

          // Badge List
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
              color: isUnlocked
                  ? Colors.amber.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
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
                    color: isUnlocked
                        ? (isDark ? Colors.white : AppColors.textPrimary)
                        : Colors.grey,
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
          _buildNavBarItem(
            context,
            Icons.home_rounded,
            'Home',
            onTap: () => Get.offAllNamed(Routes.medicine),
          ),
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
            isSelected: true,
            onTap: () {},
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
}
