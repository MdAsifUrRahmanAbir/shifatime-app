import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../model/fake_product_model.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SaleBannerWidget extends GetView<DarazListingController> {
  const SaleBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.gapXSmall),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.yellow,
                  size: 18,
                ),
                const SizedBox(width: 4),
                TextWidget.titleLarge('3.3 EID SALE', color: AppColors.yellow),
                const SizedBox(width: 8),
                Container(height: 1, width: 20, color: Colors.white54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextWidget.titleLarge(
                    'Get Up to 80% Off!',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: SaleCategoryCard(
                    label: 'Fashion',
                    product: controller.fakeProducts.isNotEmpty
                        ? controller.fakeProducts[0]
                        : null,
                    highlighted: false,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SaleCategoryCard(
                    label: 'Eid Sale',
                    product: controller.fakeProducts.length > 1
                        ? controller.fakeProducts[1]
                        : null,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SaleCategoryCard(
                    label: 'Hot Deals',
                    product: controller.fakeProducts.length > 2
                        ? controller.fakeProducts[2]
                        : null,
                    highlighted: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SaleCategoryCard extends StatelessWidget {
  final String label;
  final FakeProduct? product;
  final bool highlighted;
  const SaleCategoryCard({
    super.key,
    required this.label,
    required this.product,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (product != null)
            CachedNetworkImage(
              imageUrl: product!.image,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(6),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextWidget.titleSmall(label, color: Colors.white),
                  ),
                  if (highlighted)
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 12,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
