import 'package:go_router/go_router.dart';
import 'package:interactive_learn/core/routes/app_route_paths.dart';
import 'package:interactive_learn/core/routes/app_routes.dart';
import 'package:interactive_learn/core/singleton.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.root.path,
  routes: $appRoutes,
  // refreshListenable: _AuthRefreshListenable(supabase.auth.onAuthStateChange),
  redirect: (context, state) {
    final isLoggedIn = supabase.auth.currentSession != null;
    final location = state.matchedLocation;

    final inAuthArea =
        location == AppRoutePaths.login.path ||
        location == AppRoutePaths.signup.path;

    if (!isLoggedIn && !inAuthArea) {
      return AppRoutePaths.login.path;
    }

    if (isLoggedIn && inAuthArea) {
      return AppRoutePaths.root.path;
    }

    return null;
  },
);
