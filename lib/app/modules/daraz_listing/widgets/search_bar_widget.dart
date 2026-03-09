import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daraz_listing_controller.dart';
import '../../../widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

import '../../../routes/app_pages.dart';

class SearchBarWidget extends GetView<DarazListingController> {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      toolbarHeight: 60,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Profile Image & Navigation
              GestureDetector(
                onTap: () => Get.toNamed(Routes.profile),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?u=johnd',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget.body(
                          AppStrings.searchHint,
                          color: AppColors.textHint,
                        ),
                      ),
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF007F),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: TextWidget.titleMedium(
                  AppStrings.search,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.upload_outlined, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
