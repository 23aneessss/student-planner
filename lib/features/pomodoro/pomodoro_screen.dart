// lib/features/pomodoro/pomodoro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
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
    final bool hasStarted = state.remaining < total;
    final String primaryLabel = state.isRunning
        ? 'Pause'
        : hasStarted
        ? 'Resume'
        : 'Start';
    final VoidCallback primaryAction = state.isRunning
        ? controller.pause
        : controller.start;

    return GradientScaffold(
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/');
                },
                child: Ink(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: kCardSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: kCardBorder),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: kInk),
                ),
              ),
              const SizedBox(width: 12),
              Text('Pomodoro', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
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
          const SizedBox(height: 24),
          _PomodoroControlCard(
            state: state,
            primaryLabel: primaryLabel,
            onPrimaryAction: primaryAction,
            onReset: controller.reset,
            onModeChanged: controller.setMode,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCardSurface,
              borderRadius: kCardRadius,
              border: Border.all(color: kCardBorder),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: kInk.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Today\'s sessions',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: kCardText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${state.completedToday} completed • ${state.totalMinutesToday} minutes',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 74,
                  height: 74,
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
                          size: 54,
                          color: state.isRunning
                              ? kCoral
                              : kCardSubtext.withValues(alpha: 0.6),
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

class _PomodoroControlCard extends StatelessWidget {
  const _PomodoroControlCard({
    required this.state,
    required this.primaryLabel,
    required this.onPrimaryAction,
    required this.onReset,
    required this.onModeChanged,
  });

  final PomodoroState state;
  final String primaryLabel;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;
  final ValueChanged<PomodoroMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kInk.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Session controls',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: kCardText),
          ),
          const SizedBox(height: 6),
          Text(
            'Switch modes quickly and keep the timer close to your thumb.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
          const SizedBox(height: 16),
          _PomodoroModeBar(selected: state.mode, onChanged: onModeChanged),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: onPrimaryAction,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(primaryLabel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: kCoral,
                    side: const BorderSide(color: kCoral),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PomodoroModeBar extends StatelessWidget {
  const _PomodoroModeBar({required this.selected, required this.onChanged});

  final PomodoroMode selected;
  final ValueChanged<PomodoroMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kCardSurfaceSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: <Widget>[
          _ModeChip(
            label: 'Focus',
            isSelected: selected == PomodoroMode.focus,
            onTap: () => onChanged(PomodoroMode.focus),
          ),
          _ModeChip(
            label: 'Short break',
            isSelected: selected == PomodoroMode.shortBreak,
            onTap: () => onChanged(PomodoroMode.shortBreak),
          ),
          _ModeChip(
            label: 'Long break',
            isSelected: selected == PomodoroMode.longBreak,
            onTap: () => onChanged(PomodoroMode.longBreak),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? kCoral : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : kCardText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
