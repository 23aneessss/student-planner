// lib/providers/pomodoro_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/outbox_event.dart';
import '../domain/models/session.dart';
import 'app_providers.dart';
import 'notifications_provider.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

final pomodoroDurationsProvider = Provider<Map<PomodoroMode, Duration>>((
  Ref ref,
) {
  return const <PomodoroMode, Duration>{
    PomodoroMode.focus: Duration(minutes: 25),
    PomodoroMode.shortBreak: Duration(minutes: 5),
    PomodoroMode.longBreak: Duration(minutes: 15),
  };
});

class PomodoroState {
  const PomodoroState({
    required this.mode,
    required this.remaining,
    required this.isRunning,
    this.completedToday = 0,
    this.totalMinutesToday = 0,
  });

  final PomodoroMode mode;
  final Duration remaining;
  final bool isRunning;
  final int completedToday;
  final int totalMinutesToday;

  PomodoroState copyWith({
    PomodoroMode? mode,
    Duration? remaining,
    bool? isRunning,
    int? completedToday,
    int? totalMinutesToday,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      completedToday: completedToday ?? this.completedToday,
      totalMinutesToday: totalMinutesToday ?? this.totalMinutesToday,
    );
  }
}

class PomodoroController extends Notifier<PomodoroState> {
  Timer? _timer;
  DateTime? _startedAt;

  @override
  PomodoroState build() {
    ref.onDispose(() => _timer?.cancel());
    return const PomodoroState(
      mode: PomodoroMode.focus,
      remaining: Duration(minutes: 25),
      isRunning: false,
    );
  }

  void setMode(PomodoroMode mode) {
    _timer?.cancel();
    state = state.copyWith(
      mode: mode,
      remaining: _durationFor(mode),
      isRunning: false,
    );
  }

  void start() {
    if (state.isRunning) {
      return;
    }
    _startedAt ??= DateTime.now();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (state.remaining.inSeconds <= 1) {
        timer.cancel();
        await _completeSession();
        return;
      }
      state = state.copyWith(
        remaining: Duration(seconds: state.remaining.inSeconds - 1),
      );
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    _startedAt = null;
    state = state.copyWith(
      remaining: _durationFor(state.mode),
      isRunning: false,
    );
  }

  Future<void> _completeSession() async {
    final DateTime endedAt = DateTime.now();
    final DateTime startedAt =
        _startedAt ?? endedAt.subtract(_durationFor(state.mode));
    final PomodoroSession session = PomodoroSession(
      id: const Uuid().v4(),
      durationSec: _durationFor(state.mode).inSeconds,
      startedAt: startedAt,
      endedAt: endedAt,
      updatedAt: endedAt,
    );
    await ref
        .read(sessionsRepositoryProvider)
        .save(session, operation: SyncOperation.create);
    await ref.read(notificationsProvider).showPomodoroComplete(session.id);
    _startedAt = null;
    state = state.copyWith(
      isRunning: false,
      remaining: _durationFor(state.mode),
      completedToday: state.completedToday + 1,
      totalMinutesToday:
          state.totalMinutesToday + _durationFor(state.mode).inMinutes,
    );
  }

  Duration _durationFor(PomodoroMode mode) {
    return ref.read(pomodoroDurationsProvider)[mode]!;
  }
}

final pomodoroProvider = NotifierProvider<PomodoroController, PomodoroState>(
  PomodoroController.new,
);
