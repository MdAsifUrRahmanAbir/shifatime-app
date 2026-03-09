import 'package:flutter/material.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class QuickCategoryIconsWidget extends StatelessWidget {
  const QuickCategoryIconsWidget({super.key});

  static final _items = [
    const _QCItem('Play Now!', Icons.games_outlined, Color(0xFF00BFA5), true),
    const _QCItem(
      AppStrings.eidSale,
      Icons.star_outline,
      AppColors.primary,
      false,
    ),
    const _QCItem(
      AppStrings.freeDelivery,
      Icons.local_shipping_outlined,
      Color(0xFF2ECC71),
      false,
    ),
    const _QCItem(
      AppStrings.buyAny3,
      Icons.shopping_cart_outlined,
      Color(0xFFF1C40F),
      false,
    ),
    const _QCItem(
      AppStrings.darazFreebie,
      Icons.card_giftcard_outlined,
      Color(0xFF9B59B6),
      false,
    ),
    const _QCItem(
      AppStrings.beauty,
      Icons.face_retouching_natural,
      Colors.pink,
      false,
    ),
    const _QCItem(
      AppStrings.electronics,
      Icons.devices_outlined,
      Color(0xFF3498DB),
      false,
    ),
    const _QCItem(
      AppStrings.fashion,
      Icons.checkroom_outlined,
      AppColors.primary,
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: AppColors.cardBackground,
      toolbarHeight: 104,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.cardBackground,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, i) => _QCWidget(item: _items[i]),
            ),
          ),
        ),
      ),
    );
  }
}

class _QCItem {
  final String label;
  final IconData icon;
  final Color color;
  final bool hasArrow;
  const _QCItem(this.label, this.icon, this.color, this.hasArrow);
}

class _QCWidget extends StatelessWidget {
  final _QCItem item;
  const _QCWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: item.color, size: 26),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            TextWidget.caption(item.label, color: AppColors.textPrimary),
            if (item.hasArrow)
              const Icon(Icons.chevron_right, size: 12, color: AppColors.grey),
          ],
        ),
      ],
    );
  }
}
