import 'package:go_router_paths/go_router_paths.dart';

/// Centralized route paths powered by go_router_paths.
abstract final class AppRoutePaths {
  static const rootPath = '/';
  static const loginPath = '/login';
  static const signupPath = '/signup';
  static const searchPath = '/search';
  static const leaderboardPath = '/leaderboard';
  static const progressPath = '/progress';
  static const profilePath = '/profile';
  static const notificationsSettingsPath = '/profile/notifications';
  static const themeSettingsPath = '/profile/theme';

  static final root = Path('/');
  static final login = Path('login');
  static final signup = Path('signup');

  static final subjects = Path('subjects');
  static final chapters = Path('chapters');
  static final topics = Path('topics');
  static final subtopics = Path('subtopics');
  static final slides = Param('slides', 'subtopicId');

  static final editProfile = Path('profile/edit');
  static final avatarPicker = Path('profile/avatar');
  static final notificationsSettings = Path('profile/notifications');
  static final themeSettings = Path('profile/theme');
}
