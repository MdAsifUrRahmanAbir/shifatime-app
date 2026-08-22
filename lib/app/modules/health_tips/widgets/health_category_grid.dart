import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'health_tips_bottom_sheet.dart';

/// Grid of health-tip category cards; tapping a card opens the tips bottom sheet.
class HealthCategoryGrid extends StatelessWidget {
  const HealthCategoryGrid({super.key});

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

  static List<String> get allTips =>
      categories.expand((cat) => cat['tips'] as List<String>).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
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
          onTap: () => showHealthTipsBottomSheet(context, cat['title'], cat['tips'], color),
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
    );
  }
}
