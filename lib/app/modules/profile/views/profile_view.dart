import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User avatar and base details
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
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=shifatime_user',
                      ),
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
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // BMI Display Card
            _buildBmiCard(context, isDark),
            const SizedBox(height: 20),

            // Detailed parameters cards
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildStatTile(
                        context,
                        'Height',
                        '${controller.height.value.toInt()} cm',
                        Icons.height_rounded,
                        Colors.blueAccent,
                      )),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Obx(() => _buildStatTile(
                        context,
                        'Weight',
                        '${controller.weight.value.toInt()} kg',
                        Icons.scale_rounded,
                        Colors.orangeAccent,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Water Target Card
            Obx(() => _buildStatCard(
                  context,
                  'Daily Water Target',
                  '${controller.waterTarget.value.toInt()} ml',
                  Icons.local_drink_rounded,
                  Colors.teal,
                )),
            const SizedBox(height: 40),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showEditBottomSheet(context),
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 24),
                label: Text(
                  'Edit Health Details',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
              Text(
                'BMI (Body Mass Index)',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Obx(() => _buildBmiBadge(controller.bmiCategory.value)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Obx(() => Text(
                    '${controller.bmi.value}',
                    style: GoogleFonts.outfit(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: _getBmiColor(controller.bmiCategory.value),
                    ),
                  )),
              const SizedBox(width: 8),
              Text(
                'kg/m²',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Health Suggestion:',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 6),
          Obx(() => Text(
                controller.healthAdvice.value,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                  height: 1.4,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBmiBadge(String category) {
    final color = _getBmiColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getBmiColor(String category) {
    switch (category.toLowerCase()) {
      case 'normal weight':
        return Colors.green;
      case 'underweight':
        return Colors.orange;
      case 'overweight':
        return Colors.amber[800]!;
      case 'obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController(text: controller.name.value);
    final ageCtrl = TextEditingController(text: '${controller.age.value}');
    
    final initialHeight = controller.height.value;
    final heightCtrl = TextEditingController(text: '${initialHeight.toInt()}');
    
    final totalInches = initialHeight / 2.54;
    final initialFeet = (totalInches / 12).floor();
    final initialInches = (totalInches % 12).round();
    final feetCtrl = TextEditingController(text: '$initialFeet');
    final inchesCtrl = TextEditingController(text: '$initialInches');
    
    final weightCtrl = TextEditingController(text: '${controller.weight.value.toInt()}');
    
    bool isHeightCm = true;
    String selectedGender = controller.gender.value;

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile Details',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name input
                  TextFormField(
                    controller: nameCtrl,
                    style: GoogleFonts.outfit(),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: GoogleFonts.outfit(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 14),

                  // Age input
                  TextFormField(
                    controller: ageCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.outfit(),
                    decoration: InputDecoration(
                      labelText: 'Age (Years)',
                      labelStyle: GoogleFonts.outfit(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || int.tryParse(v) == null || int.parse(v) <= 0) ? 'Please enter valid age' : null,
                  ),
                  const SizedBox(height: 14),

                  // Gender Selector
                  Text(
                    'Gender',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setSheetState(() => selectedGender = 'Male'),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: selectedGender == 'Male'
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.02)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedGender == 'Male' ? AppColors.primary : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.male_rounded,
                                  color: selectedGender == 'Male' ? AppColors.primary : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Male',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: selectedGender == 'Male' ? AppColors.primary : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setSheetState(() => selectedGender = 'Female'),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: selectedGender == 'Female'
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.02)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedGender == 'Female' ? AppColors.primary : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.female_rounded,
                                  color: selectedGender == 'Female' ? AppColors.primary : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Female',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: selectedGender == 'Female' ? AppColors.primary : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Height Selector & Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Height',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setSheetState(() => isHeightCm = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isHeightCm ? AppColors.limeAccent : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'cm',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isHeightCm ? AppColors.limeDarkText : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setSheetState(() => isHeightCm = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: !isHeightCm ? AppColors.limeAccent : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ft/in',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !isHeightCm ? AppColors.limeDarkText : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (isHeightCm)
                    TextFormField(
                      controller: heightCtrl,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(),
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        labelStyle: GoogleFonts.outfit(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (!isHeightCm) return null;
                        if (v == null || v.isEmpty) return 'Please enter your height';
                        final parsed = double.tryParse(v);
                        if (parsed == null || parsed <= 50) return 'Please enter a valid height (cm)';
                        return null;
                      },
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: feetCtrl,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.outfit(),
                            decoration: InputDecoration(
                              labelText: 'Feet (ft)',
                              labelStyle: GoogleFonts.outfit(),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) {
                              if (isHeightCm) return null;
                              if (v == null || v.isEmpty) return 'Feet';
                              final parsed = int.tryParse(v);
                              if (parsed == null || parsed < 1 || parsed > 9) return '1-9';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: inchesCtrl,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.outfit(),
                            decoration: InputDecoration(
                              labelText: 'Inches (in)',
                              labelStyle: GoogleFonts.outfit(),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) {
                              if (isHeightCm) return null;
                              if (v == null || v.isEmpty) return 'Inches';
                              final parsed = int.tryParse(v);
                              if (parsed == null || parsed < 0 || parsed > 11) return '0-11';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),

                  // Weight input
                  TextFormField(
                    controller: weightCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.outfit(),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: GoogleFonts.outfit(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || double.tryParse(v) == null || double.parse(v) <= 10) ? 'Please enter valid weight' : null,
                  ),
                  const SizedBox(height: 24),

                  // Save Changes Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          double heightInCm;
                          if (isHeightCm) {
                            heightInCm = double.parse(heightCtrl.text);
                          } else {
                            final feet = int.parse(feetCtrl.text);
                            final inches = int.parse(inchesCtrl.text);
                            heightInCm = ((feet * 12) + inches) * 2.54;
                          }

                          await controller.saveProfileDetails(
                            nameVal: nameCtrl.text.trim(),
                            ageVal: int.parse(ageCtrl.text),
                            heightVal: heightInCm,
                            weightVal: double.parse(weightCtrl.text),
                            genderVal: selectedGender,
                          );
                          Get.back();
                          Get.snackbar(
                            'Profile Updated! 👍',
                            'Your health indices and targets have been recalculated.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
