import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/fakestore_service.dart';
import '../model/fake_product_model.dart';

class DarazListingController extends GetxController
    with GetTickerProviderStateMixin {
  // ── Loading states ──────────────────────────────────────────────────────────
  var isLoadingFakeProducts = true.obs;
  var isRefreshing = false.obs;

  // ── Data ────────────────────────────────────────────────────────────────────
  var fakeProducts = <FakeProduct>[].obs;
  var categories = <String>[].obs;
  var currentTabIndex = 0.obs;

  // ── Bottom tab ───────────────────────────────────────────────────────────────
  var currentBottomTab = 0.obs;
  late PageController feedPageController;
  late ScrollController tabScrollController;

  // ── Hero Banner ──────────────────────────────────────────────────────────────
  late PageController bannerPageController;
  var currentBannerPage = 0.obs;
  Timer? _bannerTimer;

  // ── Flash Sale Countdown ─────────────────────────────────────────────────────
  var flashSaleHours = 12.obs;
  var flashSaleMinutes = 36.obs;
  var flashSaleSeconds = 30.obs;
  Timer? _countdownTimer;

  // ── Section product helpers ───────────────────────────────────────────────────
  List<FakeProduct> get displayProducts => isLoadingFakeProducts.value
      ? List.generate(12, (i) => FakeProduct.dummy(id: i))
      : fakeProducts;

  List<FakeProduct> get flashSaleProducts {
    final list = displayProducts;
    return list.length >= 6 ? list.sublist(0, 6) : list.toList();
  }

  List<FakeProduct> get dailyDealsProducts {
    final list = displayProducts;
    return list.length >= 9 ? list.sublist(3, 9) : list.toList();
  }

  List<FakeProduct> get popularCategoryProducts {
    final list = displayProducts;
    return list.length >= 12 ? list.sublist(0, 12) : list.toList();
  }

  List<FakeProduct> get forYouProducts {
    final list = displayProducts;
    switch (currentBottomTab.value) {
      case 1:
        return list.length >= 10 ? list.sublist(0, 10) : list.toList();
      case 2:
        return list.length >= 8
            ? list.sublist(4, 12 > list.length ? list.length : 12)
            : list.toList();
      case 3:
        return list.length >= 6
            ? list.sublist(2, 8 > list.length ? list.length : 8)
            : list.toList();
      default:
        return list.toList();
    }
  }

  // ── Tab controller ───────────────────────────────────────────────────────────
  TabController? tabController;

  // ── Horizontal swipe animation ───────────────────────────────────────────────
  late AnimationController dragAnimationController;
  var dragOffset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    bannerPageController = PageController();
    feedPageController = PageController();
    tabScrollController = ScrollController();
    dragAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchFakeProducts();
    _startCountdown();
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (currentBannerPage.value + 1) % 3;
      currentBannerPage.value = next;
      if (bannerPageController.hasClients) {
        bannerPageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (flashSaleSeconds.value > 0) {
        flashSaleSeconds.value--;
      } else if (flashSaleMinutes.value > 0) {
        flashSaleMinutes.value--;
        flashSaleSeconds.value = 59;
      } else if (flashSaleHours.value > 0) {
        flashSaleHours.value--;
        flashSaleMinutes.value = 59;
        flashSaleSeconds.value = 59;
      }
    });
  }

  Future<void> fetchFakeProducts({int limit = 20}) async {
    isLoadingFakeProducts.value = true;
    final result = await FakestoreService.getFakeProducts(limit: limit);
    fakeProducts.value = result;
    final seen = <String>{};
    categories.value = result.map((p) => p.category).where(seen.add).toList();
    currentTabIndex.value = 0;
    tabController?.dispose();
    tabController = TabController(
      length: categories.length,
      vsync: this,
      initialIndex: 0,
    );
    tabController!.addListener(() {
      if (!tabController!.indexIsChanging) {
        currentTabIndex.value = tabController!.index;
      }
    });
    isLoadingFakeProducts.value = false;
    _startBannerAutoScroll();
  }

  Future<void> onRefresh() async {
    isRefreshing.value = true;
    await fetchFakeProducts();
    isRefreshing.value = false;
  }

  void onTabTapped(int index) {
    if (index == currentTabIndex.value) return;
    currentTabIndex.value = index;
  }

  void onBottomTabTapped(int index) {
    if (index == currentBottomTab.value) return;
    currentBottomTab.value = index;
    if (feedPageController.hasClients) {
      feedPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFeedPageChanged(int index) {
    currentBottomTab.value = index;
  }

  List<FakeProduct> getProductsByTab(int tabIndex) {
    final list = displayProducts;
    switch (tabIndex) {
      case 1:
        return list.where((p) => discountPercent(p) >= 60).toList();
      case 2:
        return list.where((p) => p.id % 2 == 0).toList();
      case 3:
        return list.reversed.toList();
      default:
        return list.toList();
    }
  }

  int discountPercent(FakeProduct p) {
    final discounts = [
      36,
      70,
      58,
      67,
      66,
      48,
      72,
      65,
      55,
      40,
      80,
      35,
      60,
      45,
      50,
    ];
    return discounts[p.id % discounts.length];
  }

  double originalPrice(FakeProduct p) {
    final disc = discountPercent(p);
    return p.price / (1 - disc / 100);
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (categories.isEmpty && !isLoadingFakeProducts.value) return;
    dragOffset.value += details.delta.dx;
  }

  void handleHorizontalDragEnd(DragEndDetails details, double screenWidth) {
    if (categories.isEmpty && !isLoadingFakeProducts.value) return;
    // ... animation logic ...
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    _countdownTimer?.cancel();
    bannerPageController.dispose();
    feedPageController.dispose();
    tabScrollController.dispose();
    tabController?.dispose();
    dragAnimationController.dispose();
    super.onClose();
  }
}
