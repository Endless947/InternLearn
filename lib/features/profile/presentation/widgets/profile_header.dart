import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.displayName,
    required this.email,
    required this.avatarSeed,
    required this.totalXp,
    super.key,
  });

  final String displayName;
  final String email;
  final String avatarSeed;
  final int totalXp;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Center(
          child: Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: ClipOval(
              child: RandomAvatar(
                avatarSeed,
                width: 104,
                height: 104,
                trBackground: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            displayName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            email,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'XP: $totalXp',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
