import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../model/fake_product_model.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class FlashSaleWidget extends GetView<DarazListingController> {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(top: AppSizes.gapXSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: [
                TextWidget.headlineLarge('Fla'),
                const Icon(Icons.flash_on, color: AppColors.primary, size: 18),
                TextWidget.headlineLarge('h Sale'),
                const SizedBox(width: 8),
                Obx(
                  () => CountdownBox(
                    value: controller.flashSaleHours.value.toString().padLeft(
                      2,
                      '0',
                    ),
                  ),
                ),
                const TimeSeparator(),
                Obx(
                  () => CountdownBox(
                    value: controller.flashSaleMinutes.value.toString().padLeft(
                      2,
                      '0',
                    ),
                  ),
                ),
                const TimeSeparator(),
                Obx(
                  () => CountdownBox(
                    value: controller.flashSaleSeconds.value.toString().padLeft(
                      2,
                      '0',
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextWidget.badge(AppStrings.eidSale),
                ),
                const SizedBox(width: 4),
                TextWidget.bodySmall(
                  AppStrings.shopMore,
                  color: AppColors.textPrimary,
                ),
                const Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.flashSaleProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) =>
                  FlashSaleCard(product: controller.flashSaleProducts[i]),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CountdownBox extends StatelessWidget {
  final String value;
  const CountdownBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    margin: const EdgeInsets.symmetric(horizontal: 1),
    decoration: BoxDecoration(
      color: AppColors.textPrimary,
      borderRadius: BorderRadius.circular(4),
    ),
    child: TextWidget.titleMedium(value, color: Colors.white),
  );
}

class TimeSeparator extends StatelessWidget {
  const TimeSeparator({super.key});
  @override
  Widget build(BuildContext context) => TextWidget.titleMedium(' : ');
}

class FlashSaleCard extends GetView<DarazListingController> {
  final FakeProduct product;
  const FlashSaleCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final discount = controller.discountPercent(product);
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    color: Colors.black.withValues(alpha: 0.54),
                    child: TextWidget.badge(
                      AppStrings.only1Left,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
            child: Row(
              children: [
                TextWidget.titleSmall(
                  '৳${product.price.toStringAsFixed(0)}',
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextWidget.badge('-$discount%'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
