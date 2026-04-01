import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/providers/theme_provider.dart';

/// UI-only theme picker. Selection is local; app theme is unchanged until wired later.
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Choose how Intern Learn looks. Your preference is saved to your account.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          _ThemeOptionCard(
            icon: Icons.light_mode_outlined,
            title: 'Light',
            subtitle: 'Bright backgrounds, best in daylight',
            selected: selected == ThemeMode.light,
            onTap: () => notifier.setThemeMode(ThemeMode.light),
          ),
          const SizedBox(height: 12),
          _ThemeOptionCard(
            icon: Icons.dark_mode_outlined,
            title: 'Dark',
            subtitle: 'Easier on the eyes at night',
            selected: selected == ThemeMode.dark,
            onTap: () => notifier.setThemeMode(ThemeMode.dark),
          ),
          const SizedBox(height: 12),
          _ThemeOptionCard(
            icon: Icons.settings_suggest_outlined,
            title: 'System default',
            subtitle: 'Match your device setting',
            selected: selected == ThemeMode.system,
            onTap: () => notifier.setThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: selected ? 1 : 0,
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.55)
          : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.6),
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.7),
                child: Icon(icon, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: scheme.primary)
              else
                Icon(Icons.circle_outlined, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
