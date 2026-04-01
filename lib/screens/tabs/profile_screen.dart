import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/providers/auth_provider.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:interactive_learn/screens/tabs/manage_profile_page.dart';
import 'package:interactive_learn/screens/tabs/notifications_settings_page.dart';
import 'package:interactive_learn/screens/tabs/theme_settings_page.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_email_card.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_header.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_logout_tile.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_about_card.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_danger_zone_card.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_settings_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDeletingAccount = false;

  Future<void> _deleteAccountFlow() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This will submit a deletion request and sign you out immediately. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    setState(() => _isDeletingAccount = true);
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'deletion_requested_at': DateTime.now().toUtc().toIso8601String(),
            'deletion_requested': true,
          },
        ),
      );
      await supabase.auth.signOut();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not submit deletion request. Please try again.')),
      );
      logger.e('Delete account request failed', error: e);
    } finally {
      if (mounted) {
        setState(() => _isDeletingAccount = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? 'Unknown';
    final metadata = user?.userMetadata ?? const <String, dynamic>{};
    final savedDisplayName = metadata['display_name'] as String?;
    final displayName = (savedDisplayName != null && savedDisplayName.trim().isNotEmpty)
        ? savedDisplayName.trim()
        : email.split('@').first;
    final bio = (metadata['bio'] as String?)?.trim();
    final createdAtRaw = user?.createdAt;
    final createdAt = createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw);
    final memberSince = createdAt == null
      ? 'Unknown'
      : '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
    final shortUserId = user == null
      ? 'Unknown'
      : user.id.length > 8
        ? '${user.id.substring(0, 8)}...'
        : user.id;

    Future<void> handleLogout() async {
      try {
        await supabase.auth.signOut();
        // AuthGate in main.dart will automatically navigate to LoginPage
      } catch (e) {
        logger.e('Logout error', error: e);
      }
    }

    void pushManageProfile() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ManageProfilePage(),
        ),
      ).then((_) {
        ref.invalidate(currentUserProvider);
      });
    }

    void pushNotifications() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const NotificationsSettingsPage(),
        ),
      );
    }

    void pushTheme() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ThemeSettingsPage(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(displayName: displayName, email: email),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileEmailCard(email: email),
                const SizedBox(height: 16),
                ProfileAboutCard(
                  bio: (bio == null || bio.isEmpty) ? 'No bio added yet.' : bio,
                  memberSince: memberSince,
                  userId: shortUserId,
                ),
                const SizedBox(height: 16),
                ProfileSettingsCard(
                  onManageProfile: pushManageProfile,
                  onNotifications: pushNotifications,
                  onTheme: pushTheme,
                ),
                const SizedBox(height: 16),
                ProfileDangerZoneCard(
                  onDeleteAccount: _deleteAccountFlow,
                  isProcessing: _isDeletingAccount,
                ),
                const SizedBox(height: 16),
                ProfileLogoutTile(onLogout: handleLogout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
