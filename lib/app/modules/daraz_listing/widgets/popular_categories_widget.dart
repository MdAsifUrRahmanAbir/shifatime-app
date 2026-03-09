import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class PopularCategoriesWidget extends GetView<DarazListingController> {
  const PopularCategoriesWidget({super.key});

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    final cats = <String, dynamic>{};
    for (final p in controller.displayProducts) {
      cats.putIfAbsent(p.category, () => p);
    }
    final entries = cats.entries.toList();
    final itemCount = entries.length > 8 ? 8 : entries.length;

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
                Expanded(
                  child: TextWidget.headlineSmall(AppStrings.popularCategories),
                ),
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
                  AppStrings.scrollMore,
                  color: AppColors.textPrimary,
                ),
                const Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: itemCount,
            itemBuilder: (context, i) {
              final cat = entries[i].key;
              final prod = entries[i].value;
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        imageUrl: prod.image as String,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextWidget.caption(
                    _capitalize(cat),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimary,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
