import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'profile_form_fields.dart';

class ProfileSetupBody extends StatelessWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController heightCtrl;
  final TextEditingController feetCtrl;
  final TextEditingController inchesCtrl;
  final TextEditingController weightCtrl;
  final bool isHeightCm;
  final ValueChanged<bool> onHeightUnitChanged;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onSave;

  const ProfileSetupBody({
    super.key,
    required this.isDark,
    required this.formKey,
    required this.nameCtrl,
    required this.ageCtrl,
    required this.heightCtrl,
    required this.feetCtrl,
    required this.inchesCtrl,
    required this.weightCtrl,
    required this.isHeightCm,
    required this.onHeightUnitChanged,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(28.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Let\'s Get Started! 👋',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your offline health profile to calculate BMI and customize daily water targets.',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            ProfileFormFields(
              variant: ProfileFormVariant.setup,
              isDark: isDark,
              nameCtrl: nameCtrl,
              ageCtrl: ageCtrl,
              heightCtrl: heightCtrl,
              feetCtrl: feetCtrl,
              inchesCtrl: inchesCtrl,
              weightCtrl: weightCtrl,
              isHeightCm: isHeightCm,
              onHeightUnitChanged: onHeightUnitChanged,
              selectedGender: selectedGender,
              onGenderChanged: onGenderChanged,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Save & Proceed',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
