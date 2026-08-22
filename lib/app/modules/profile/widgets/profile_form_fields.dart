import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'profile_form_label.dart';
import 'profile_unit_tab.dart';

/// `setup` matches the full-screen onboarding form's look (icon-prefixed
/// filled fields, label shown above each field). `edit` matches the
/// profile-edit bottom sheet's look (floating labelText, outlined fields).
enum ProfileFormVariant { setup, edit }

/// Shared name/gender/age/height/weight form, used by both the onboarding
/// screen and the "Edit Health Details" bottom sheet — the two previously
/// had near-duplicate copies of this exact field set and validation.
class ProfileFormFields extends StatelessWidget {
  final ProfileFormVariant variant;
  final bool isDark;
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

  const ProfileFormFields({
    super.key,
    required this.variant,
    required this.isDark,
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
  });

  bool get _isSetup => variant == ProfileFormVariant.setup;
  double get _fieldSpacing => _isSetup ? 20 : 14;
  double get _genderBoxHeight => _isSetup ? 50 : 48;
  double get _fieldRadius => _isSetup ? 16 : 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isSetup) ...[
          ProfileFormLabel(text: 'Full Name', isDark: isDark),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: nameCtrl,
          style: GoogleFonts.outfit(),
          decoration: _decoration(hint: 'Enter your name', label: 'Full Name', icon: Icons.person_outline_rounded),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? (_isSetup ? 'Please enter your name' : 'Please enter name')
              : null,
        ),
        SizedBox(height: _fieldSpacing),

        ProfileFormLabel(text: 'Gender', isDark: isDark),
        const SizedBox(height: 8),
        _genderRow(),
        SizedBox(height: _fieldSpacing),

        if (_isSetup) ...[
          ProfileFormLabel(text: 'Age (Years)', isDark: isDark),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: ageCtrl,
          keyboardType: TextInputType.number,
          style: GoogleFonts.outfit(),
          decoration: _decoration(hint: 'e.g. 25', label: 'Age (Years)', icon: Icons.calendar_today_outlined),
          validator: (v) {
            if (v == null || v.isEmpty) return _isSetup ? 'Please enter your age' : 'Please enter valid age';
            final parsed = int.tryParse(v);
            if (parsed == null || parsed <= 0) {
              return _isSetup ? 'Please enter a valid age' : 'Please enter valid age';
            }
            return null;
          },
        ),
        SizedBox(height: _fieldSpacing),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileFormLabel(text: 'Height', isDark: isDark),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : AppColors.greyLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ProfileUnitTab(label: 'cm', isSelected: isHeightCm, onTap: () => onHeightUnitChanged(true)),
                  ProfileUnitTab(label: 'ft/in', isSelected: !isHeightCm, onTap: () => onHeightUnitChanged(false)),
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
            decoration: _decoration(hint: 'e.g. 175', label: 'Height (cm)', icon: Icons.height_outlined),
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
                  decoration: _decoration(hint: 'Feet (ft)', label: 'Feet (ft)', icon: Icons.height_outlined),
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
                  decoration: _decoration(hint: 'Inches (in)', label: 'Inches (in)', icon: Icons.height_outlined),
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
        SizedBox(height: _fieldSpacing),

        if (_isSetup) ...[
          ProfileFormLabel(text: 'Weight (kg)', isDark: isDark),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: weightCtrl,
          keyboardType: TextInputType.number,
          style: GoogleFonts.outfit(),
          decoration: _decoration(hint: 'e.g. 70', label: 'Weight (kg)', icon: Icons.scale_outlined),
          validator: (v) {
            if (v == null || v.isEmpty) return _isSetup ? 'Please enter your weight' : 'Please enter valid weight';
            final parsed = double.tryParse(v);
            if (parsed == null || parsed <= 10) {
              return _isSetup ? 'Please enter a valid weight (kg)' : 'Please enter valid weight';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _decoration({required String hint, required String label, required IconData icon}) {
    if (_isSetup) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      );
    }
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.outfit(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _genderRow() {
    return Row(
      children: [
        Expanded(child: _genderOption('Male', Icons.male_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _genderOption('Female', Icons.female_rounded)),
      ],
    );
  }

  Widget _genderOption(String label, IconData icon) {
    final isSelected = selectedGender == label;
    final unselectedBg = _isSetup
        ? (isDark ? AppColors.darkCardBackground : Colors.white)
        : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.02));
    return GestureDetector(
      onTap: () => onGenderChanged(label),
      child: Container(
        height: _genderBoxHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : unselectedBg,
          borderRadius: BorderRadius.circular(_fieldRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
