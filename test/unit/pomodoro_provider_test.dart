// test/unit/pomodoro_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planora/data/local/database.dart';
import 'package:planora/providers/app_providers.dart';
import 'package:planora/providers/notifications_provider.dart';
import 'package:planora/providers/pomodoro_provider.dart';

import '../mocks/mock_database.dart';

class _FakeNotificationsService implements PlanoraNotificationsService {
  int completions = 0;

  @override
  Future<void> cancel(int notificationId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> scheduleTaskReminder({
    required int notificationId,
    required DateTime remindAt,
    required String title,
    required String body,
    required String payload,
  }) async {}

  @override
  Future<void> showPomodoroComplete(String sessionId) async {
    completions += 1;
  }
}

void main() {
  late AppDatabase database;
  late _FakeNotificationsService notifications;
  late ProviderContainer container;

  setUp(() {
    database = buildTestDatabase();
    notifications = _FakeNotificationsService();
    container = ProviderContainer(
      overrides: <Override>[
        appDatabaseProvider.overrideWithValue(database),
        notificationsProvider.overrideWithValue(notifications),
        pomodoroDurationsProvider
            .overrideWithValue(const <PomodoroMode, Duration>{
              PomodoroMode.focus: Duration(seconds: 2),
              PomodoroMode.shortBreak: Duration(seconds: 1),
              PomodoroMode.longBreak: Duration(seconds: 3),
            }),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('timer counts down', () async {
    final PomodoroController controller = container.read(
      pomodoroProvider.notifier,
    );
    final Duration initial = container.read(pomodoroProvider).remaining;

    controller.start();
    await Future<void>.delayed(const Duration(milliseconds: 1100));

    expect(container.read(pomodoroProvider).remaining, lessThan(initial));
  });

  test('pause stops countdown', () async {
    final PomodoroController controller = container.read(
      pomodoroProvider.notifier,
    );

    controller.start();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    controller.pause();
    final Duration paused = container.read(pomodoroProvider).remaining;

    await Future<void>.delayed(const Duration(milliseconds: 1100));

    expect(container.read(pomodoroProvider).remaining, paused);
  });

  test('completion saves session and resets timer state', () async {
    final PomodoroController controller = container.read(
      pomodoroProvider.notifier,
    );

    controller.setMode(PomodoroMode.shortBreak);
    controller.start();
    await Future<void>.delayed(const Duration(milliseconds: 2200));

    final sessions = await container
        .read(sessionsRepositoryProvider)
        .watchAll()
        .first;
    expect(sessions, hasLength(1));
    expect(container.read(pomodoroProvider).isRunning, isFalse);
    expect(
      container.read(pomodoroProvider).remaining,
      const Duration(seconds: 1),
    );
  });
}
