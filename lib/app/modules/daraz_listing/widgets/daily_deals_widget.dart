import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../model/fake_product_model.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class DailyDealsWidget extends GetView<DarazListingController> {
  const DailyDealsWidget({super.key});

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
                TextWidget.headlineMedium(AppStrings.dailySheraDeals),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.yellow, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextWidget.badge(
                    AppStrings.choice,
                    color: AppColors.yellow,
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
                TextWidget.caption(
                  'Shop Now | Free Gift! ',
                  color: AppColors.textPrimary,
                ),
                const Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
          SizedBox(
            height: 195,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.dailyDealsProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) =>
                  DailyDealCard(product: controller.dailyDealsProducts[i]),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DailyDealCard extends GetView<DarazListingController> {
  final FakeProduct product;
  const DailyDealCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final discount = controller.discountPercent(product);
    final orig = controller.originalPrice(product);
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radius),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextWidget.titleMedium(
                      '৳${product.price.toStringAsFixed(0)}',
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: TextWidget.badge('-$discount%'),
                    ),
                  ],
                ),
                TextWidget.caption(
                  '৳${orig.toStringAsFixed(0)}',
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
