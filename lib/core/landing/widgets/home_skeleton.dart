import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';


class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ShimmerWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 48,
                    height: 48,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: const [
                      SkeletonLine(style: SkeletonLineStyle(height: 14)),
                      SizedBox(height: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 10,
                          maxLength: 180,
                          minLength: 120,
                          randomLength: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SkeletonLine(
              style: SkeletonLineStyle(width: 140, height: 16),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 34,
                          height: 34,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      SkeletonLine(style: SkeletonLineStyle(height: 12)),
                      SizedBox(height: 6),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 9,
                          maxLength: 90,
                          minLength: 60,
                          randomLength: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}