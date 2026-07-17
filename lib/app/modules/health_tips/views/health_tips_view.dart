import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';

class HealthTipsView extends StatelessWidget {
  const HealthTipsView({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Medicine Tips',
      'icon': Icons.medication_rounded,
      'color': Colors.green,
      'tips': [
        'Always complete the prescribed course of antibiotics, even if you feel better.',
        'Never take medicine with carbonated drinks or juice. Stick to plain water.',
        'Keep a list of all current medications, including dosage, in case of emergency.',
        'Store your medicine in a cool, dry place away from direct sunlight.'
      ]
    },
    {
      'title': 'Hydration Tips',
      'icon': Icons.water_drop_rounded,
      'color': Colors.blue,
      'tips': [
        'Drinking water regularly helps maintain body temperature and supports digestion.',
        'Try to drink water consistently throughout the day instead of waiting until you feel thirsty.',
        'Drink one glass of water after waking up to rehydrate your body after sleep.',
        'Carry a reusable water bottle with you to track your intake easily.'
      ]
    },
    {
      'title': 'Healthy Diet',
      'icon': Icons.restaurant_rounded,
      'color': Colors.orange,
      'tips': [
        'A balanced meal should include vegetables, protein, and whole grains.',
        'Limit processed foods and foods with high added sugar contents.',
        'Eat slowly to give your brain time to realize your stomach is full.',
        'Include healthy fats like olive oil, nuts, and avocados in your diet.'
      ]
    },
    {
      'title': 'Better Sleep',
      'icon': Icons.bedtime_rounded,
      'color': Colors.indigo,
      'tips': [
        'Avoid mobile screens in bed to significantly improve your sleep quality.',
        'Maintain a consistent sleep schedule, even on weekends.',
        'Keep your bedroom dark, quiet, and cool for optimal rest.',
        'Avoid caffeine and heavy meals 4-6 hours before bedtime.'
      ]
    },
    {
      'title': 'Exercise',
      'icon': Icons.directions_run_rounded,
      'color': Colors.deepOrange,
      'tips': [
        'Try to walk at least 30 minutes daily to keep your heart healthy.',
        'Take active breaks: stretch or walk for 2 minutes for every hour of sitting.',
        'Combine strength training with cardio for comprehensive physical fitness.',
        'Listen to your body and rest when you feel pain or fatigue.'
      ]
    },
    {
      'title': 'Heart Health',
      'icon': Icons.favorite_rounded,
      'color': Colors.red,
      'tips': [
        'Reduce sodium intake to support healthy blood pressure levels.',
        'Incorporate omega-3 fatty acids from fish, seeds, or walnuts.',
        'Practice deep breathing exercises to manage stress and lower heart rate.',
        'Regular physical checkups are crucial to monitor heart parameters.'
      ]
    },
    {
      'title': 'Diabetes',
      'icon': Icons.bloodtype_rounded,
      'color': Colors.purple,
      'tips': [
        'Monitor carbohydrate portions to avoid blood sugar spikes.',
        'Prefer high-fiber foods as they slow sugar absorption.',
        'Stay active to help your muscles use glucose for energy.',
        'Always check your feet for cuts or blisters as diabetes slows healing.'
      ]
    },
    {
      'title': 'Blood Pressure',
      'icon': Icons.speed_rounded,
      'color': Colors.teal,
      'tips': [
        'Keep stress low through meditation, music, or gardening.',
        'Limit alcohol intake and avoid smoking to protect arteries.',
        'A potassium-rich diet (bananas, spinach) helps balance sodium.',
        'Measure your blood pressure at home consistently and log the values.'
      ]
    },
    {
      'title': 'General Wellness',
      'icon': Icons.spa_rounded,
      'color': Colors.amber,
      'tips': [
        'Take regular breaks from digital screens to prevent eye strain.',
        'Practice gratitude and mindfulness daily for positive mental health.',
        'Maintain close social connections with family and friends.',
        'Wash your hands regularly to protect yourself from common infections.'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Pick daily tip
    final allTips = categories.expand((cat) => cat['tips'] as List<String>).toList();
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final tipOfTheDay = allTips[dayOfYear % allTips.length];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Health Library',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Health Tip Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.limeAccent,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.limeAccent.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_incandescent_rounded, color: AppColors.limeDarkText, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'TODAY\'S HEALTH TIP',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.limeDarkText.withValues(alpha: 0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tipOfTheDay,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.limeDarkText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section Title
            Text(
              'Browse Categories',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Grid of categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final color = cat['color'] as Color;
                return GestureDetector(
                  onTap: () => _showTipsBottomSheet(context, cat['title'], cat['tips'], color),
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                          child: Icon(cat['icon'] as IconData, color: color, size: 24),
                        ),
                        Text(
                          cat['title'],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  void _showTipsBottomSheet(BuildContext context, String title, List<String> tips, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: tips.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          tips[index],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
            isSelected: true,
            onTap: () {},
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
}
