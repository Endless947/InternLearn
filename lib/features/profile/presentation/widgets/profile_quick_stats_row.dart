import 'package:flutter/material.dart';

class ProfileQuickStatsRow extends StatelessWidget {
  const ProfileQuickStatsRow({
    required this.totalXp,
    required this.streakDays,
    required this.completedTopics,
    super.key,
  });

  final int totalXp;
  final int streakDays;
  final int completedTopics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProfileStatTile(
            icon: Icons.bolt_rounded,
            title: 'XP',
            value: '$totalXp',
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProfileStatTile(
            icon: Icons.local_fire_department_rounded,
            title: 'Streak',
            value: '$streakDays d',
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProfileStatTile(
            icon: Icons.check_circle_outline_rounded,
            title: 'Topics',
            value: '$completedTopics',
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
