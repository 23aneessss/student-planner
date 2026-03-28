// lib/providers/auth_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user_profile.dart';
import 'app_providers.dart';

class AuthState {
  const AuthState({this.user, this.errorMessage});

  final UserProfile? user;
  final String? errorMessage;

  bool get isAuthenticated => user != null;
  bool get isLoading => false;

  AuthState copyWith({
    UserProfile? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
    final UserProfile? profile = await ref
        .read(authRepositoryProvider)
        .restoreSession();
    return AuthState(user: profile);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final UserProfile user = await ref
          .read(authRepositoryProvider)
          .signInWithEmail(email, password);
      return AuthState(user: user);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String scholarYear,
  }) async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final UserProfile user = await ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email, password, fullName, scholarYear);
      return AuthState(user: user);
    });
  }

  Future<void> signInGoogle() async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final UserProfile user = await ref
          .read(authRepositoryProvider)
          .signInWithGoogle();
      return AuthState(user: user);
    });
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final UserProfile updated = await ref
          .read(authRepositoryProvider)
          .updateProfile(profile);
      return AuthState(user: updated);
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue<AuthState>.data(AuthState());
  }
}

final authProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
