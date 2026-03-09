import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Extension to add shimmer loading effect to any widget.
/// Usage: MyWidget().shimmerLoading(true);
// extension ShimmerExtension on Widget {
//   Widget shimmerLoading(bool isLoading) {
//     if (!isLoading) return this;
//
//     return Shimmer.fromColors(
//       baseColor: AppColors.primary.withValues(alpha: 0.2),
//       highlightColor: Colors.grey.withValues(alpha: 0.3),
//       child: this,
//     );
//   }
// }



extension WidgetSkeletonizer on Widget {
  Widget skeletonizer({required bool enabled}) {
    return Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(
        baseColor: AppColors.primary.withValues(alpha: 0.3),
        highlightColor: Colors.white,
        duration: const Duration(seconds: 1),
      ),
      child: this,
    );
  }
}
