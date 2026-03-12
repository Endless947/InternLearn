import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/providers/auth_provider.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:interactive_learn/pages/auth/login.dart';
import 'package:interactive_learn/pages/tab_widget_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = ColorScheme.fromSeed(
      seedColor: Colors.lightBlueAccent,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intern Learn',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colors.primary.withAlpha(150),
          foregroundColor: Colors.white,
        ),
        colorScheme: colors,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: colors.primary.withAlpha(200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

/// Listens to [authStateProvider] and routes to the correct screen.
/// Checks the synchronous session during loading to avoid a flicker.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    return authAsync.when(
      data: (state) {
        if (state.session != null) return const TabWidgetTree();
        return const LoginPage();
      },
      loading: () {
        // Use synchronous session to avoid a white flash on re-launch
        if (supabase.auth.currentSession != null) return const TabWidgetTree();
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (_, _) => const LoginPage(),
    );
  }
}
