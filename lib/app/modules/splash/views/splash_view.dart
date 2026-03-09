import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: _SplashMobile(),
    );
  }
}

class _SplashMobile extends StatefulWidget {
  const _SplashMobile();

  @override
  State<_SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends State<_SplashMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.logoSize,
                height: AppSizes.logoSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: AppSizes.iconExtraLarge,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.gapLarge),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: AppSizes.fontXXXLarge,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSizes.gapXSmall),
              Text(
                AppStrings.appTagline,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: AppSizes.splashBottomGap),
              const SizedBox(
                width: AppSizes.progressIndicatorSize,
                height: AppSizes.progressIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.indicatorStrokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
