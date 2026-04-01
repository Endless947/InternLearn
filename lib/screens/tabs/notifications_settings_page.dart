import 'package:flutter/material.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _emailDigest = true;
  bool _newContent = true;
  bool _reminders = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final metadata = supabase.auth.currentUser?.userMetadata ?? const <String, dynamic>{};
    _emailDigest = (metadata['notif_email_digest'] as bool?) ?? true;
    _newContent = (metadata['notif_new_content'] as bool?) ?? true;
    _reminders = (metadata['notif_reminders'] as bool?) ?? false;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'notif_email_digest': _emailDigest,
            'notif_new_content': _newContent,
            'notif_reminders': _reminders,
          },
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification settings saved.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save settings. Please try again.')),
      );
      logger.e('Notification settings update failed', error: e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Control what you hear about. Your choices are saved to your account.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: scheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.email_outlined, color: scheme.primary),
                  title: const Text('Email digest'),
                  subtitle: const Text('Weekly summary of your progress'),
                  value: _emailDigest,
                  onChanged: (v) => setState(() => _emailDigest = v),
                ),
                Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                SwitchListTile(
                  secondary: Icon(Icons.new_releases_outlined, color: scheme.primary),
                  title: const Text('New content'),
                  subtitle: const Text('When new lessons are available'),
                  value: _newContent,
                  onChanged: (v) => setState(() => _newContent = v),
                ),
                Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                SwitchListTile(
                  secondary: Icon(Icons.alarm_outlined, color: scheme.primary),
                  title: const Text('Study reminders'),
                  subtitle: const Text('Nudges to keep your streak'),
                  value: _reminders,
                  onChanged: (v) => setState(() => _reminders = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
