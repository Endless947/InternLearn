import 'package:go_router/go_router.dart';
import 'package:nexus/core/routes/app_route_paths.dart';
import 'package:nexus/core/routes/auth/auth_routes.dart';
import 'package:nexus/core/routes/content/content_routes.dart';
import 'package:nexus/core/routes/profile/profile_routes.dart';
import 'package:nexus/core/routes/shell/shell_navigation_scaffold.dart';
import 'package:nexus/core/routes/shell/shell_routes.dart';
import 'package:nexus/core/singleton.dart';
import 'package:nexus/features/profile/presentation/screens/notifications_settings_screen.dart';
import 'package:nexus/features/profile/presentation/screens/theme_settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.rootPath,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellNavigationScaffold(
          location: state.matchedLocation,
          child: child,
        );
      },
      routes: [
        $homeTabRoute,
        $searchTabRoute,
        $leaderboardTabRoute,
        $progressTabRoute,
        $profileTabRoute,
      ],
    ),
    $loginRoute,
    $signupRoute,
    $subjectsRoute,
    $chaptersRoute,
    $topicsRoute,
    $subtopicsRoute,
    $slideViewerRoute,
    $editProfileRoute,
    $avatarPickerRoute,
    GoRoute(
      path: AppRoutePaths.notificationsSettingsPath,
      builder: (context, state) => const NotificationsSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.themeSettingsPath,
      builder: (context, state) => const ThemeSettingsScreen(),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = supabase.auth.currentSession != null;
    final location = state.matchedLocation;

    final inAuthArea =
        location == AppRoutePaths.loginPath ||
        location == AppRoutePaths.signupPath;

    if (!isLoggedIn && !inAuthArea) {
      return AppRoutePaths.loginPath;
    }

    if (isLoggedIn && inAuthArea) {
      return AppRoutePaths.rootPath;
    }

    return null;
  },
);
