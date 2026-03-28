// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/extensions.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../domain/models/course.dart';
import '../../domain/models/task.dart';
import '../../features/home/widgets/today_summary_card.dart';
import '../../features/tasks/widgets/task_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/courses_provider.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../theme/tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String firstName =
        ref.watch(authProvider).valueOrNull?.user?.fullName.firstWord ??
        'Student';
    final PomodoroController pomodoroController = ref.read(
      pomodoroProvider.notifier,
    );
    final AsyncValue<List<Task>> tasksAsync = ref.watch(rawTasksProvider);
    final AsyncValue<List<Course>> coursesAsync = ref.watch(
      coursesStreamProvider,
    );
    final PomodoroState pomodoro = ref.watch(pomodoroProvider);
    final SyncState syncState = ref.watch(syncProvider);

    return GradientScaffold(
      backgroundImageAsset: kPrimaryBackgroundAsset,
      body: tasksAsync.when(
        data: (List<Task> tasks) {
          final List<Task> upcoming = tasks.take(6).toList();
          final int dueToday = tasks
              .where(
                (Task task) =>
                    task.dueDate?.isSameDate(DateTime.now()) ?? false,
              )
              .length;
          final int streak = tasks
              .where((Task task) => task.status == TaskStatus.done)
              .length;
          final String todayLabel = DateFormat(
            'EEEE, d MMMM',
          ).format(DateTime.now());
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 128),
            children: <Widget>[
              if (syncState.phase == SyncPhase.syncing) ...<Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kLavenderBright.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Syncing your planner...',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
              _HomeHero(
                firstName: firstName,
                todayLabel: todayLabel,
                dueToday: dueToday,
                completedToday: pomodoro.completedToday,
                onProfileTap: () => context.go('/profile'),
              ),
              const SizedBox(height: 18),
              _FocusQuickActionCard(
                state: pomodoro,
                onOpen: () => context.go('/pomodoro'),
                onPrimaryAction: pomodoro.isRunning
                    ? pomodoroController.pause
                    : pomodoroController.start,
              ),
              const SizedBox(height: 28),
              TodaySummaryCard(
                tasksDueToday: dueToday,
                sessionsLogged: pomodoro.completedToday,
                streakDays: streak,
              ),
              const SizedBox(height: 26),
              _SectionHeader(
                'Upcoming tasks',
                'View all',
                () => context.go('/tasks'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 214,
                child: upcoming.isEmpty
                    ? const _EmptyGlow(message: 'No upcoming tasks yet.')
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: upcoming.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (BuildContext context, int index) {
                          final Task task = upcoming[index];
                          return SizedBox(
                            width: 310,
                            child: TaskCard(
                              task: task,
                              onTap: () => context.go('/tasks/${task.id}'),
                              onToggle: () => ref
                                  .read(taskActionsProvider)
                                  .toggleTask(task),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 26),
              _SectionHeader('Templates', 'Apply', () {}),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: kTemplateAssets
                    .map(
                      (String asset) => _TemplateChip(
                        label: asset
                            .split('/')
                            .last
                            .replaceAll('.json', '')
                            .replaceAll('_', ' '),
                        onTap: () => ref
                            .read(taskActionsProvider)
                            .applyTemplateFromAsset(asset),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 26),
              _SectionHeader('Today\'s schedule', 'Sync now', () {
                ref.read(syncProvider.notifier).syncNow();
              }),
              const SizedBox(height: 14),
              coursesAsync.when(
                data: (List<Course> courses) {
                  final List<_ScheduleItem> schedule = _scheduleForToday(
                    courses,
                  );
                  if (schedule.isEmpty) {
                    return const _EmptyGlow(
                      message: 'No classes scheduled for today.',
                    );
                  }
                  return Column(
                    children: schedule
                        .map((_ScheduleItem item) => _ScheduleCard(item: item))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) =>
                    Text(error.toString()),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
      ),
    );
  }

  List<_ScheduleItem> _scheduleForToday(List<Course> courses) {
    final int today = DateTime.now().weekday;
    return courses
        .expand(
          (Course course) => course.schedule
              .where((CourseScheduleEntry slot) => slot.day == today)
              .map(
                (CourseScheduleEntry slot) => _ScheduleItem(
                  courseName: course.name,
                  colorHex: course.colorHex,
                  start: slot.start,
                  end: slot.end,
                ),
              ),
        )
        .toList();
  }
}

class _ScheduleItem {
  const _ScheduleItem({
    required this.courseName,
    required this.colorHex,
    required this.start,
    required this.end,
  });

  final String courseName;
  final String colorHex;
  final String start;
  final String end;
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.firstName,
    required this.todayLabel,
    required this.dueToday,
    required this.completedToday,
    required this.onProfileTap,
  });

  final String firstName;
  final String todayLabel;
  final int dueToday;
  final int completedToday;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _HeroCapsule(
              icon: Icons.calendar_month_outlined,
              label: todayLabel,
            ),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onProfileTap,
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Icon(Icons.person_outline_rounded, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Good morning,\n$firstName', style: textTheme.displayLarge),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            dueToday == 0
                ? 'A quiet canvas today. Use the calm to make progress that compounds.'
                : '$dueToday tasks are waiting. You have logged $completedToday focus sessions so far.',
            style: textTheme.bodyLarge?.copyWith(color: kMutedText),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            _HeroCapsule(
              icon: Icons.bolt_rounded,
              label: dueToday == 0 ? 'Clear horizon' : '$dueToday due today',
              emphasis: true,
            ),
            const SizedBox(width: 10),
            _HeroCapsule(
              icon: Icons.timer_outlined,
              label: '$completedToday focus sessions',
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroCapsule extends StatelessWidget {
  const _HeroCapsule({
    required this.icon,
    required this.label,
    this.emphasis = false,
  });

  final IconData icon;
  final String label;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: emphasis
            ? kLavenderBright.withValues(alpha: 0.88)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: emphasis
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: emphasis ? kInk : Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: emphasis ? kInk : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, this.action, this.onPressed);

  final String title;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  action,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: kLavenderBright),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_outward_rounded,
                  size: 14,
                  color: kLavenderBright,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateChip extends StatelessWidget {
  const _TemplateChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kCardSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: kCardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.auto_awesome_rounded, size: 16, color: kCoral),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kCardText),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.item});

  final _ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 52,
            decoration: BoxDecoration(
              color: Color(int.parse(item.colorHex.replaceFirst('#', '0xFF'))),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.courseName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: kCardText),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.start} - ${item.end}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: kCardSurfaceSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(Icons.north_east_rounded, size: 16, color: kInk),
          ),
        ],
      ),
    );
  }
}

class _EmptyGlow extends StatelessWidget {
  const _EmptyGlow({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
      ),
    );
  }
}

class _FocusQuickActionCard extends StatelessWidget {
  const _FocusQuickActionCard({
    required this.state,
    required this.onPrimaryAction,
    required this.onOpen,
  });

  final PomodoroState state;
  final VoidCallback onPrimaryAction;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final String modeLabel = switch (state.mode) {
      PomodoroMode.focus => 'Focus mode',
      PomodoroMode.shortBreak => 'Short break',
      PomodoroMode.longBreak => 'Long break',
    };
    final String timeLabel =
        '${state.remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${state.remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}';

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
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kCardSurfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: kCoral,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Quick focus',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: kCardText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      modeLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kCardSurfaceSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  timeLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: kInk),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            state.isRunning
                ? 'A session is already running. Pause it or open the full timer.'
                : 'Bring Pomodoro forward and jump straight into a focus session.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: onPrimaryAction,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(state.isRunning ? 'Pause' : 'Start focus'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpen,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    foregroundColor: kCardText,
                    side: const BorderSide(color: kCardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('Open timer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
