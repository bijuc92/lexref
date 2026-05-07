import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository();

@Riverpod(keepAlive: true)
Stream<AuthState> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@Riverpod(keepAlive: true)
Future<Map<String, dynamic>?> profile(ProfileRef ref) async {
  final authState = ref.watch(authStateProvider).valueOrNull;
  if (authState?.session == null) return null;
  return ref.read(authRepositoryProvider).getProfile();
}

/// Light/dark mode toggle — manual StateProvider (no codegen needed for simple state).
final themeModeProvider = StateProvider<ThemeMode>(
  (_) => ThemeMode.system,
);
