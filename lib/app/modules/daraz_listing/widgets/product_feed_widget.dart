import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../model/fake_product_model.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class ProductFeedWidget extends GetView<DarazListingController> {
  const ProductFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.feedPageController,
      onPageChanged: controller.onFeedPageChanged,
      itemCount: 10,
      itemBuilder: (context, tabIndex) {
        return _FeedGrid(tabIndex: tabIndex);
      },
    );
  }
}

class _FeedGrid extends GetView<DarazListingController> {
  final int tabIndex;
  const _FeedGrid({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.getProductsByTab(tabIndex);
      if (products.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXLarge),
            child: TextWidget.body('No products in this category.'),
          ),
        );
      }
      return GridView.builder(
        key: PageStorageKey<String>('tab_$tabIndex'),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ProductFeedCard(product: products[i]),
      );
    });
  }
}

class ProductFeedCard extends GetView<DarazListingController> {
  final FakeProduct product;
  const ProductFeedCard({super.key, required this.product});

  String _formatSold(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final discount = controller.discountPercent(product);
    final rnd = Random(product.id);
    final isFreeDelivery = rnd.nextBool();
    final isCoins = rnd.nextBool();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Wrap(
                      spacing: 3,
                      children: [
                        if (isFreeDelivery)
                          _Badge(
                            label: 'FREE DELIVERY',
                            bg: Colors.green.shade700,
                          ),
                        if (isCoins)
                          _Badge(label: 'COINS', bg: Colors.amber.shade700),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.favorite_border,
                      size: AppSizes.iconXSmall - 2,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 5, 7, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: TextWidget.badge('3.3'),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: TextWidget.bodySmall(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  TextWidget.bodySmall(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget.titleMedium(
                        '৳${product.price.toStringAsFixed(0)}',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
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
                  Row(
                    children: [
                      const Icon(Icons.star, size: 11, color: AppColors.yellow),
                      TextWidget.caption(' ${product.rating.rate}'),
                      TextWidget.caption(
                        '  ${_formatSold(product.rating.count)} Sold',
                      ),
                    ],
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

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  const _Badge({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(3),
    ),
    child: TextWidget.badgeXS(label),
  );
}
