// test/widget/sign_in_screen_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planora/domain/models/user_profile.dart';
import 'package:planora/domain/repositories/auth_repository.dart';
import 'package:planora/features/auth/sign_in_screen.dart';
import 'package:planora/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    authRepository = MockAuthRepository();
    when(() => authRepository.restoreSession()).thenAnswer((_) async => null);
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: const MaterialApp(home: SignInScreen()),
    );
  }

  testWidgets('empty submit shows validation errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
  });

  testWidgets('valid credentials triggers authNotifier signIn', (
    WidgetTester tester,
  ) async {
    when(() => authRepository.signInWithEmail(any(), any())).thenAnswer(
      (_) async => const UserProfile(
        id: 'user-1',
        email: 'student@example.com',
        fullName: 'Student One',
        scholarYear: '1st Year',
      ),
    );

    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'student@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(
      () => authRepository.signInWithEmail('student@example.com', 'secret123'),
    ).called(1);
  });

  testWidgets('loading state shows PrimaryButton spinner', (
    WidgetTester tester,
  ) async {
    final Completer<UserProfile> completer = Completer<UserProfile>();
    when(
      () => authRepository.signInWithEmail(any(), any()),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'student@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
