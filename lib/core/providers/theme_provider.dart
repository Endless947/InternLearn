import 'package:flutter/material.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'theme_provider.g.dart';

/// Holds the current [ThemeMode] for the whole app.
/// Updated by ThemeSettingsPage; read in MyApp.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final user = supabase.auth.currentUser;
    final raw = user?.userMetadata?['theme_mode'] as String?;
    return _fromStorage(raw);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'theme_mode': _toStorage(mode),
          },
        ),
      );
    } catch (e) {
      logger.e('Theme preference update failed', error: e);
    }
  }

  ThemeMode _fromStorage(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _toStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
