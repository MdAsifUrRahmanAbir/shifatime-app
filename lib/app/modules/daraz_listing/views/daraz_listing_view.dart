import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/daraz_listing_controller.dart';
import '../widgets/bottom_tab_widget.dart';
import '../widgets/daily_deals_widget.dart';
import '../widgets/flash_sale_widget.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/popular_categories_widget.dart';
import '../widgets/product_feed_widget.dart';
import '../widgets/quick_category_icons_widget.dart';
import '../widgets/sale_banner_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/service_row_widget.dart';
import '../widgets/voucher_strip_widget.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/utils/shimmer_extension.dart';

class DarazListingView extends GetView<DarazListingController> {
  const DarazListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.bg, body: _body(context));
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final isLoading = controller.isLoadingFakeProducts.value;

        if (controller.fakeProducts.isEmpty && !isLoading) {
          return Center(child: TextWidget.body('No products found.'));
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: AppColors.primary,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Sticky Search Bar
                const SearchBarWidget(),

                // Header components that scroll away
                SliverToBoxAdapter(child: HeroBannerWidget()),
                const SliverToBoxAdapter(child: ServiceRowWidget()),
                const QuickCategoryIconsWidget(),
                const SliverToBoxAdapter(child: VoucherStripWidget()),
                SliverToBoxAdapter(child: SaleBannerWidget()),
                SliverToBoxAdapter(child: FlashSaleWidget()),
                SliverToBoxAdapter(child: DailyDealsWidget()),
                SliverToBoxAdapter(child: PopularCategoriesWidget()),

                // Bottom Tab Strip (pinned)
                const BottomTabWidget(),
              ];
            },
            // Main Product Feed
            body: const ProductFeedWidget(),
          ),
        ).skeletonizer(enabled: isLoading);
      }),
    );
  }
}
