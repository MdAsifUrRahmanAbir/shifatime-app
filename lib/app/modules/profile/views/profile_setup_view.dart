import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _feetCtrl = TextEditingController();
  final _inchesCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _isHeightCm = true;
  String _selectedGender = 'Male';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _feetCtrl.dispose();
    _inchesCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Heading
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

                // Form Fields
                _buildLabel('Full Name', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  style: GoogleFonts.outfit(),
                  decoration: _buildInputDec('Enter your name', Icons.person_outline_rounded, isDark),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Gender', isDark),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'Male'),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedGender == 'Male'
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark ? AppColors.darkCardBackground : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedGender == 'Male' ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male_rounded,
                                color: _selectedGender == 'Male' ? AppColors.primary : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Male',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedGender == 'Male' ? AppColors.primary : Colors.grey,
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
                        onTap: () => setState(() => _selectedGender = 'Female'),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedGender == 'Female'
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark ? AppColors.darkCardBackground : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedGender == 'Female' ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female_rounded,
                                color: _selectedGender == 'Female' ? AppColors.primary : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Female',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedGender == 'Female' ? AppColors.primary : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildLabel('Age (Years)', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(),
                  decoration: _buildInputDec('e.g. 25', Icons.calendar_today_outlined, isDark),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your age';
                    final parsed = int.tryParse(v);
                    if (parsed == null || parsed <= 0) return 'Please enter a valid age';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('Height', isDark),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : AppColors.greyLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _buildUnitTab('cm', _isHeightCm, () {
                            setState(() {
                              _isHeightCm = true;
                            });
                          }),
                          _buildUnitTab('ft/in', !_isHeightCm, () {
                            setState(() {
                              _isHeightCm = false;
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isHeightCm)
                  TextFormField(
                    controller: _heightCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.outfit(),
                    decoration: _buildInputDec('e.g. 175', Icons.height_outlined, isDark),
                    validator: (v) {
                      if (!_isHeightCm) return null;
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
                          controller: _feetCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.outfit(),
                          decoration: _buildInputDec('Feet (ft)', Icons.height_outlined, isDark),
                          validator: (v) {
                            if (_isHeightCm) return null;
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
                          controller: _inchesCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.outfit(),
                          decoration: _buildInputDec('Inches (in)', Icons.height_outlined, isDark),
                          validator: (v) {
                            if (_isHeightCm) return null;
                            if (v == null || v.isEmpty) return 'Inches';
                            final parsed = int.tryParse(v);
                            if (parsed == null || parsed < 0 || parsed > 11) return '0-11';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),

                _buildLabel('Weight (kg)', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(),
                  decoration: _buildInputDec('e.g. 70', Icons.scale_outlined, isDark),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your weight';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 10) return 'Please enter a valid weight (kg)';
                    return null;
                  },
                ),
                const SizedBox(height: 48),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDec(String hint, IconData icon, bool isDark) {
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

  Widget _buildUnitTab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.limeAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.limeDarkText : Colors.grey,
          ),
        ),
      ),
    );
  }

  void _saveDetails() async {
    if (_formKey.currentState!.validate()) {
      double heightInCm;
      if (_isHeightCm) {
        heightInCm = double.parse(_heightCtrl.text);
      } else {
        final feet = int.parse(_feetCtrl.text);
        final inches = int.parse(_inchesCtrl.text);
        heightInCm = ((feet * 12) + inches) * 2.54;
      }

      await controller.saveProfileDetails(
        nameVal: _nameCtrl.text.trim(),
        ageVal: int.parse(_ageCtrl.text),
        heightVal: heightInCm,
        weightVal: double.parse(_weightCtrl.text),
        genderVal: _selectedGender,
      );

      Get.offAllNamed(Routes.medicine);
      Get.snackbar(
        'Welcome ${controller.name.value}! 🎉',
        'Your profile has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
