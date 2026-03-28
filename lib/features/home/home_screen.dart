// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/extensions.dart';
import '../../core/widgets/cloud_decoration.dart';
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
    final AsyncValue<List<Task>> tasksAsync = ref.watch(rawTasksProvider);
    final AsyncValue<List<Course>> coursesAsync = ref.watch(
      coursesStreamProvider,
    );
    final PomodoroState pomodoro = ref.watch(pomodoroProvider);
    final SyncState syncState = ref.watch(syncProvider);

    return GradientScaffold(
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: kLavender,
        foregroundColor: kDark,
        onPressed: () => context.go('/tasks/new'),
        child: const Icon(Icons.add_rounded),
      ),
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
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
            children: <Widget>[
              if (syncState.phase == SyncPhase.syncing) ...<Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kLavender,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Syncing your planner…',
                    style: TextStyle(color: kDark, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Good morning, $firstName',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('EEEE, d MMMM').format(DateTime.now()),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: kLavender),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TodaySummaryCard(
                tasksDueToday: dueToday,
                sessionsLogged: pomodoro.completedToday,
                streakDays: streak,
              ),
              const SizedBox(height: 26),
              _sectionHeader(
                context,
                'Upcoming tasks',
                'View all',
                () => context.go('/tasks'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 190,
                child: upcoming.isEmpty
                    ? const Center(child: Text('No upcoming tasks yet.'))
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
              _sectionHeader(context, 'Templates', 'Apply', () {}),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: kTemplateAssets
                    .map(
                      (String asset) => ActionChip(
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        label: Text(
                          asset
                              .split('/')
                              .last
                              .replaceAll('.json', '')
                              .replaceAll('_', ' '),
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        onPressed: () => ref
                            .read(taskActionsProvider)
                            .applyTemplateFromAsset(asset),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 26),
              _sectionHeader(context, 'Today\'s schedule', 'Sync now', () {
                ref.read(syncProvider.notifier).syncNow();
              }),
              const SizedBox(height: 14),
              coursesAsync.when(
                data: (List<Course> courses) => Column(
                  children: _scheduleForToday(courses)
                      .map(
                        (_ScheduleItem item) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kGlassSurface,
                            borderRadius: kCardRadius,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      item.colorHex.replaceFirst('#', '0xFF'),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.courseName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.start} - ${item.end}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.72,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
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

  Widget _sectionHeader(
    BuildContext context,
    String title,
    String action,
    VoidCallback onPressed,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
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
