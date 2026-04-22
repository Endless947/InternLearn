import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:nexus/core/widgets/list_skeleton.dart';

class ProgressSkeleton extends StatelessWidget {
  const ProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 130,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: 92,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: 92,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: 92,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: 92,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 96,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          const SizedBox(height: 14),
          const ListSkeleton(itemCount: 4, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
