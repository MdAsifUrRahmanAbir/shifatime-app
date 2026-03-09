import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class HeroBannerWidget extends GetView<DarazListingController> {
  const HeroBannerWidget({super.key});

  static final _banners = [
    const _BannerData(
      gradient: [AppColors.primary, AppColors.primaryLight],
      title: AppStrings.bannerEidSaleTitle,
      subtitle: AppStrings.bannerEidSaleSub,
      badge: AppStrings.upTo80Off,
    ),
    const _BannerData(
      gradient: [Color(0xFF7B2FF7), Color(0xFFD63AFA)],
      title: 'Flash Deals',
      subtitle: "Today Only – Don't Miss Out!",
      badge: 'Limited Stock',
    ),
    const _BannerData(
      gradient: [Color(0xFF00B894), Color(0xFF00CEC9)],
      title: AppStrings.freeDelivery,
      subtitle: 'On orders above ৳500',
      badge: 'No Min. Order',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.bannerPageController,
            itemCount: _banners.length,
            onPageChanged: (i) => controller.currentBannerPage.value = i,
            itemBuilder: (ctx, i) => _BannerSlide(data: _banners[i]),
          ),
          Positioned(
            bottom: AppSizes.paddingXSmall,
            right: 10,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: TextWidget.caption(
                  '${controller.currentBannerPage.value + 1}/${_banners.length}',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (i) => Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: controller.currentBannerPage.value == i ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: controller.currentBannerPage.value == i
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.54),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final _BannerData data;
  const _BannerSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusXSmall),
              ),
              child: TextWidget.displayBold(data.title),
            ),
            const SizedBox(height: AppSizes.gapXSmall),
            TextWidget.body(
              data.subtitle,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: TextWidget.titleMedium(
                    data.badge,
                    color: data.gradient.first,
                  ),
                ),
                const SizedBox(width: AppSizes.gapSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: data.gradient.first,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: TextWidget.titleMedium(
                    AppStrings.shopNow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerData {
  final List<Color> gradient;
  final String title;
  final String subtitle;
  final String badge;
  const _BannerData({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}
