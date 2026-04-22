import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsState {
  const NotificationSettingsState({
    required this.notificationsEnabled,
    required this.pushNotificationsEnabled,
  });

  final bool notificationsEnabled;
  final bool pushNotificationsEnabled;

  NotificationSettingsState copyWith({
    bool? notificationsEnabled,
    bool? pushNotificationsEnabled,
  }) {
    return NotificationSettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}

class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsNotifier()
    : super(
        const NotificationSettingsState(
          notificationsEnabled: true,
          pushNotificationsEnabled: true,
        ),
      ) {
    unawaited(_restore());
  }

  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _pushNotificationsEnabledKey = 'push_notifications_enabled';

  Future<void> setNotificationsEnabled(bool enabled) async {
    final nextState = state.copyWith(
      notificationsEnabled: enabled,
      pushNotificationsEnabled: enabled
          ? state.pushNotificationsEnabled
          : false,
    );

    state = nextState;
    await _persist(nextState);
  }

  Future<void> setPushNotificationsEnabled(bool enabled) async {
    if (!state.notificationsEnabled) {
      return;
    }

    final nextState = state.copyWith(pushNotificationsEnabled: enabled);
    state = nextState;
    await _persist(nextState);
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled =
        prefs.getBool(_notificationsEnabledKey) ?? true;
    final pushNotificationsEnabled =
        prefs.getBool(_pushNotificationsEnabledKey) ?? true;

    state = NotificationSettingsState(
      notificationsEnabled: notificationsEnabled,
      pushNotificationsEnabled: notificationsEnabled
          ? pushNotificationsEnabled
          : false,
    );
  }

  Future<void> _persist(NotificationSettingsState settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _notificationsEnabledKey,
      settings.notificationsEnabled,
    );
    await prefs.setBool(
      _pushNotificationsEnabledKey,
      settings.pushNotificationsEnabled,
    );
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<
      NotificationSettingsNotifier,
      NotificationSettingsState
    >((ref) {
      return NotificationSettingsNotifier();
    });
