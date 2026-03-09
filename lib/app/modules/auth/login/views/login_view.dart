import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_form_widget.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              LoginHeaderWidget(isDark: isDark),

              // Form
              const LoginFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
