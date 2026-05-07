import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const LoadingShimmer({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E4DD),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF4F2ED),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LoadingShimmer(height: 20, width: 50, borderRadius: 20),
                const SizedBox(width: 8),
                const LoadingShimmer(height: 14, width: 40),
              ],
            ),
            const SizedBox(height: 10),
            const LoadingShimmer(height: 16, width: double.infinity),
            const SizedBox(height: 6),
            const LoadingShimmer(height: 12, width: 220),
          ],
        ),
      ),
    );
  }
}
