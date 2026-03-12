import 'package:interactive_learn/core/singleton.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

/// Streams every AuthState change from Supabase.
/// Emits immediately with the current session state on subscription.
@riverpod
Stream<AuthState> authState(Ref ref) {
  return supabase.auth.onAuthStateChange;
}

/// Derives the current User from authStateProvider.
/// Falls back to the synchronous session so the widget tree never flickers.
@riverpod
User? currentUser(Ref ref) {
  final asyncState = ref.watch(authStateProvider);
  return asyncState.asData?.value.session?.user ?? supabase.auth.currentUser;
}