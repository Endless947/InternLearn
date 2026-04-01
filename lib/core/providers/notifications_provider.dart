import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

class NotificationsSettings {
  const NotificationsSettings({
    required this.emailDigest,
    required this.newContent,
    required this.reminders,
  });

  final bool emailDigest;
  final bool newContent;
  final bool reminders;

  NotificationsSettings copyWith({
    bool? emailDigest,
    bool? newContent,
    bool? reminders,
  }) {
    return NotificationsSettings(
      emailDigest: emailDigest ?? this.emailDigest,
      newContent: newContent ?? this.newContent,
      reminders: reminders ?? this.reminders,
    );
  }
}

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  NotificationsSettings build() {
    return const NotificationsSettings(
      emailDigest: true,
      newContent: true,
      reminders: false,
    );
  }

  void setEmailDigest(bool value) {
    state = state.copyWith(emailDigest: value);
  }

  void setNewContent(bool value) {
    state = state.copyWith(newContent: value);
  }

  void setReminders(bool value) {
    state = state.copyWith(reminders: value);
  }
}
