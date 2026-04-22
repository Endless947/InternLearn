import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/core/providers/notifications_provider.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable notifications'),
                  subtitle: const Text(
                    'Turn all app notifications on or off for this device.',
                  ),
                  value: settings.notificationsEnabled,
                  onChanged: notifier.setNotificationsEnabled,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Push notifications'),
                  subtitle: const Text(
                    'Receive push alerts for your learning activity.',
                  ),
                  value: settings.pushNotificationsEnabled,
                  onChanged: settings.notificationsEnabled
                      ? notifier.setPushNotificationsEnabled
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'These preferences are stored locally on your phone.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
