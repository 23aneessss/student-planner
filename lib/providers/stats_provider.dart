// lib/providers/stats_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/task.dart';
import 'tasks_provider.dart';

class StatsSnapshot {
  const StatsSnapshot({
    required this.completedTasks,
    required this.pendingTasks,
    required this.totalFocusMinutes,
    required this.currentStreak,
    required this.sessionsPerDay,
  });

  final int completedTasks;
  final int pendingTasks;
  final int totalFocusMinutes;
  final int currentStreak;
  final List<int> sessionsPerDay;
}

final statsProvider = Provider<AsyncValue<StatsSnapshot>>((Ref ref) {
  final AsyncValue<List<Task>> tasks = ref.watch(rawTasksProvider);

  return tasks.whenData((List<Task> taskList) {
    return StatsSnapshot(
      completedTasks: taskList
          .where((Task task) => task.status == TaskStatus.done)
          .length,
      pendingTasks: taskList
          .where((Task task) => task.status != TaskStatus.done)
          .length,
      totalFocusMinutes: 0,
      currentStreak: taskList
          .where((Task task) => task.status == TaskStatus.done)
          .length,
      sessionsPerDay: const <int>[2, 1, 3, 2, 4, 1, 0],
    );
  });
});
