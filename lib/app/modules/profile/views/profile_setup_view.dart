import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_setup_body.dart';

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
      body: ResponsiveLayout(
        mobile: ProfileSetupBody(
          isDark: isDark,
          formKey: _formKey,
          nameCtrl: _nameCtrl,
          ageCtrl: _ageCtrl,
          heightCtrl: _heightCtrl,
          feetCtrl: _feetCtrl,
          inchesCtrl: _inchesCtrl,
          weightCtrl: _weightCtrl,
          isHeightCm: _isHeightCm,
          onHeightUnitChanged: (v) => setState(() => _isHeightCm = v),
          selectedGender: _selectedGender,
          onGenderChanged: (g) => setState(() => _selectedGender = g),
          onSave: _saveDetails,
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
