// lib/features/pomodoro/pomodoro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../providers/pomodoro_provider.dart';
import '../../theme/tokens.dart';
import 'widgets/pomodoro_ring.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PomodoroState state = ref.watch(pomodoroProvider);
    final PomodoroController controller = ref.read(pomodoroProvider.notifier);
    final Duration total = switch (state.mode) {
      PomodoroMode.focus => const Duration(minutes: 25),
      PomodoroMode.shortBreak => const Duration(minutes: 5),
      PomodoroMode.longBreak => const Duration(minutes: 15),
    };

    final int minutes = state.remaining.inMinutes.remainder(60);
    final int seconds = state.remaining.inSeconds.remainder(60);

    return GradientScaffold(
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: <Widget>[
          Text('Pomodoro', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 28),
          Center(
            child: PomodoroRing(
              progress: 1 - (state.remaining.inSeconds / total.inSeconds),
              timeLabel:
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              subtitle: switch (state.mode) {
                PomodoroMode.focus => 'Focus Session',
                PomodoroMode.shortBreak => 'Short Break',
                PomodoroMode.longBreak => 'Long Break',
              },
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: PrimaryButton(
                  label: 'Start',
                  onPressed: controller.start,
                ),
              ),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
                  ),
                  onPressed: controller.pause,
                  child: const Text('Pause'),
                ),
              ),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: kCoral,
                    side: const BorderSide(color: kCoral),
                    shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
                  ),
                  onPressed: controller.reset,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SegmentedButton<PomodoroMode>(
            segments: const <ButtonSegment<PomodoroMode>>[
              ButtonSegment(value: PomodoroMode.focus, label: Text('Focus')),
              ButtonSegment(
                value: PomodoroMode.shortBreak,
                label: Text('Short break'),
              ),
              ButtonSegment(
                value: PomodoroMode.longBreak,
                label: Text('Long break'),
              ),
            ],
            selected: <PomodoroMode>{state.mode},
            onSelectionChanged: (Set<PomodoroMode> selection) {
              controller.setMode(selection.first);
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kGlassSurface,
              borderRadius: kCardRadius,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Today\'s sessions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${state.completedToday} completed • ${state.totalMinutesToday} minutes',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 92,
                  height: 92,
                  child: Lottie.asset(
                    'assets/lottie/pomodoro_fire.json',
                    repeat: state.isRunning,
                    errorBuilder:
                        (
                          BuildContext _,
                          Object error,
                          StackTrace? stackTrace,
                        ) => Icon(
                          Icons.local_fire_department_rounded,
                          size: 68,
                          color: state.isRunning
                              ? kCoral
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
