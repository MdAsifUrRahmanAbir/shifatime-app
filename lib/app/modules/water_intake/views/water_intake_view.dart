import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/water_intake_controller.dart';

class WaterIntakeView extends StatefulWidget {
  const WaterIntakeView({super.key});

  @override
  State<WaterIntakeView> createState() => _WaterIntakeViewState();
}

class _WaterIntakeViewState extends State<WaterIntakeView>
    with SingleTickerProviderStateMixin {
  final WaterIntakeController controller = Get.find<WaterIntakeController>();
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Statistic',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
            onPressed: () {
              Get.snackbar(
                'Water Logs 💧',
                'Keep logging to view monthly patterns.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Weekly Intake Bar Chart Card (Mockup Style)
            _buildWeeklyChart(context),

            const SizedBox(height: 16),

            // 2. Parameters Grid (Logs Count & Progress)
            _buildParametersGrid(context),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickCup(150, 'Cup', Icons.local_cafe_outlined),
                _buildQuickCup(250, 'Glass', Icons.local_drink_outlined),
                _buildQuickCup(500, 'Bottle', Icons.water_drop_outlined),
                _buildCustomInputButton(context),
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
            Obx(() {
              if (controller.logs.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBackground : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.water_drop_outlined, size: 40, color: Colors.blue.withValues(alpha: 0.4)),
                      const SizedBox(height: 8),
                      Text(
                        'No water logged today yet',
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.logs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final log = controller.logs[index];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.opacity_rounded, color: Colors.blue, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${log['amount']} ml',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  log['time'] ?? 'Unknown time',
                                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () => controller.deleteLog(index),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Mock percentages for the week to match mockup screen 2:
    final percentages = [44, 34, 110, 47, 32, 79, 24];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(28),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Intake',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${controller.consumedMl.value.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ml',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              Obx(() => Text(
                    'Target: ${controller.targetMl.value.toInt()} ml',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 24),

          // Bars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final day = weekdays[index];
              final pct = percentages[index];
              final isHighlighted = index == 2; // Wednesday highlighted

              // Max bar height = 130
              final barHeight = (pct / 120.0 * 120.0).clamp(10.0, 120.0);

              return Column(
                children: [
                  Text(
                    '$pct%',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                      color: isHighlighted
                          ? AppColors.primary
                          : (isDark ? Colors.white30 : Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppColors.primary
                          : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.15)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      color: isHighlighted
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Left Parameter Card: Logs Summary
        Expanded(
          child: Obx(() {
            final double progress = controller.targetMl.value > 0
                ? (controller.consumedMl.value / controller.targetMl.value)
                : 0.0;
            final percent = (progress * 100).toInt().clamp(0, 100);

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
                        'Hydration',
                        style: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$percent%',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'completed',
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Small waveform illustration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(12, (index) {
                      final heights = [14.0, 8.0, 22.0, 12.0, 18.0, 6.0, 16.0, 26.0, 10.0, 14.0, 20.0, 8.0];
                      return Container(
                        width: 3,
                        height: heights[index],
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 14),

        // Right Parameter Card: Logs List count
        Expanded(
          child: Obx(() {
            final logCount = controller.logs.length;

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
                        'Total Drinks',
                        style: GoogleFonts.outfit(
                          color: Colors.grey,
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
                        child: const Icon(Icons.opacity_rounded, color: Colors.blueAccent, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$logCount logs',
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'saved today',
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Flat wave line decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: const Size(double.infinity, 18),
                          painter: SparklinePainter(isDark: isDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuickCup(int amount, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        controller.logWater(amount);
        Get.snackbar(
          'Water Logged 💧',
          'Successfully added $amount ml!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            '$amount ml',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomInputButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textController = TextEditingController();

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Custom Amount',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(),
                  decoration: InputDecoration(
                    hintText: 'Enter amount in ml (e.g. 350)',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final int? amount = int.tryParse(textController.text);
                      if (amount != null && amount > 0) {
                        controller.logWater(amount);
                        Get.back();
                        Get.snackbar(
                          'Water Logged 💧',
                          'Successfully added $amount ml!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue.withValues(alpha: 0.8),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 1),
                        );
                      } else {
                        Get.snackbar('Error', 'Please enter a valid amount');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Log Water',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            'Custom',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            'Log target',
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final bool isDark;
  SparklinePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.3, size.height * 0.2);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.6, size.height * 0.9);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 1.0, size.height * 0.5);

    canvas.drawPath(path, paint);

    // Heart circle highlight
    final dotPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.1), 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
