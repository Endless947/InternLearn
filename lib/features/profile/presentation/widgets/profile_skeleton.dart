import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:nexus/core/widgets/list_skeleton.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ShimmerWidget(
        child: Column(
          children: [
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: 104,
                height: 104,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            const SkeletonLine(
              style: SkeletonLineStyle(width: 160, height: 16),
            ),
            const SizedBox(height: 8),
            const SkeletonLine(
              style: SkeletonLineStyle(width: 220, height: 12),
            ),
            const SizedBox(height: 24),
            const ListSkeleton(itemCount: 4, padding: EdgeInsets.zero),
          ],
        ),
      ),
    );
  }
}