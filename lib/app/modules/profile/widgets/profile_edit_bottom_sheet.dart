import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/profile_controller.dart';
import 'profile_form_fields.dart';

void showProfileEditBottomSheet(BuildContext context, ProfileController controller) {
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
                ProfileFormFields(
                  variant: ProfileFormVariant.edit,
                  isDark: isDark,
                  nameCtrl: nameCtrl,
                  ageCtrl: ageCtrl,
                  heightCtrl: heightCtrl,
                  feetCtrl: feetCtrl,
                  inchesCtrl: inchesCtrl,
                  weightCtrl: weightCtrl,
                  isHeightCm: isHeightCm,
                  onHeightUnitChanged: (v) => setSheetState(() => isHeightCm = v),
                  selectedGender: selectedGender,
                  onGenderChanged: (g) => setSheetState(() => selectedGender = g),
                ),
                const SizedBox(height: 24),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      },
    ),
  );
}
