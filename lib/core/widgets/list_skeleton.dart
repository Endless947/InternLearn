import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';


class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;

  const ListSkeleton({
    super.key,
    this.itemCount = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SkeletonListTile(
                hasSubtitle: true,
                leadingStyle: const SkeletonAvatarStyle(
                  width: 44,
                  height: 44,
                  shape: BoxShape.circle,
                ),
                titleStyle: const SkeletonLineStyle(height: 14),
                subtitleStyle: const SkeletonLineStyle(height: 10),
              ),
            ),
          );
        }),
      ),
    );
  }
}
