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
import 'package:interactive_learn/screens/tabs/widgets/profile_settings_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? 'Unknown';
    final displayName = email.split('@').first;

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
      );
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
                ProfileSettingsCard(
                  onManageProfile: pushManageProfile,
                  onNotifications: pushNotifications,
                  onTheme: pushTheme,
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
