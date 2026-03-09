import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class BottomTabWidget extends GetView<DarazListingController> {
  const BottomTabWidget({super.key});

  static const _tabs = [
    _TabItem(Icons.local_fire_department, 'For You', Colors.deepOrange),
    _TabItem(Icons.local_offer_outlined, 'Hot Deals', Colors.red),
    _TabItem(Icons.confirmation_num_outlined, 'Voucher Max', AppColors.primary),
    _TabItem(Icons.storefront_outlined, 'Daraz Lo', Colors.purple),
    _TabItem(Icons.face_retouching_natural, 'Beauty', Colors.pink),
    _TabItem(Icons.checkroom_outlined, 'Fashion', Colors.teal),
    _TabItem(Icons.electrical_services_outlined, 'Electronics', Colors.blue),
    _TabItem(Icons.diamond_outlined, 'Jewelry', Colors.amber),
    _TabItem(Icons.man_outlined, "Men's", Colors.blueGrey),
    _TabItem(Icons.woman_outlined, "Women's", Colors.pinkAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      scrolledUnderElevation: 0,
      expandedHeight: 0,
      toolbarHeight: 46,
      elevation: 2,
      backgroundColor: AppColors.cardBackground,
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(
          () => SingleChildScrollView(
            controller: controller.tabScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXSmall,
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = controller.currentBottomTab.value == i;
                return InkWell(
                  onTap: () => controller.onBottomTabTapped(i),
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMid,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected ? _tabs[i].color : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          color: selected ? _tabs[i].color : AppColors.grey,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        TextWidget.titleSmall(
                          _tabs[i].label,
                          color: selected ? _tabs[i].color : AppColors.grey,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final Color color;
  const _TabItem(this.icon, this.label, [Color? c])
    : color = c ?? AppColors.primary;
}
