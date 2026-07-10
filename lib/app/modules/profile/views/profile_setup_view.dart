import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
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
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                // Heading
                Text(
                  'Let\'s Get Started! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your offline health profile to calculate BMI and customize daily water targets.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Fields
                _buildLabel('Full Name', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _buildInputDec('Enter your name', Icons.person_outline, isDark),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Age (Years)', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDec('e.g. 25', Icons.calendar_today_outlined, isDark),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your age';
                    final parsed = int.tryParse(v);
                    if (parsed == null || parsed <= 0) return 'Please enter a valid age';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildLabel('Height (cm)', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDec('e.g. 175', Icons.height_outlined, isDark),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your height';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 50) return 'Please enter a valid height (cm)';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildLabel('Weight (kg)', isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
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
                    child: const Text(
                      'Save & Proceed',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDec(String hint, IconData icon, bool isDark) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  void _saveDetails() async {
    if (_formKey.currentState!.validate()) {
      await controller.saveProfileDetails(
        nameVal: _nameCtrl.text.trim(),
        ageVal: int.parse(_ageCtrl.text),
        heightVal: double.parse(_heightCtrl.text),
        weightVal: double.parse(_weightCtrl.text),
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
