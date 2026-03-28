// lib/features/tasks/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_input.dart';
import '../../domain/models/task.dart';
import '../../providers/tasks_provider.dart';
import '../../theme/tokens.dart';
import 'widgets/task_card.dart';
import 'widgets/task_filter_bar.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Task>> tasksAsync = ref.watch(filteredTasksProvider);
    final TaskStatus? status = ref.watch(taskStatusFilterProvider);
    final TaskSort sort = ref.watch(taskSortProvider);

    return GradientScaffold(
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => context.go('/tasks/new'),
                child: Ink(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kCardSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: kCardBorder),
                  ),
                  child: const Icon(Icons.add_rounded, color: kInk),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TaskFilterBar(
            selectedStatus: status,
            onStatusChanged: (TaskStatus? value) =>
                ref.read(taskStatusFilterProvider.notifier).state = value,
            sort: sort,
            onSortChanged: (TaskSort value) =>
                ref.read(taskSortProvider.notifier).state = value,
          ),
          const SizedBox(height: 16),
          PlanoraTextField(
            hint: 'Search tasks',
            prefixIcon: const Icon(Icons.search),
            onChanged: (String value) =>
                ref.read(taskSearchQueryProvider.notifier).state = value,
          ),
          const SizedBox(height: 20),
          tasksAsync.when(
            data: (List<Task> tasks) {
              if (tasks.isEmpty) {
                return const EmptyState(
                  title: 'No tasks match this view.',
                  subtitle: 'Try another filter or create a fresh task.',
                );
              }
              final Map<String, List<Task>> grouped = <String, List<Task>>{};
              for (final Task task in tasks) {
                final String key =
                    task.dueDate?.startOfDay.toIso8601String() ?? 'No due date';
                grouped.putIfAbsent(key, () => <Task>[]).add(task);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grouped.entries.map((
                  MapEntry<String, List<Task>> entry,
                ) {
                  final String heading = entry.key == 'No due date'
                      ? entry.key
                      : DateTime.parse(entry.key).weekdayAndDate;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          heading,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...entry.value.map(
                          (Task task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: ValueKey<String>(task.id),
                              background: _dismissBackground(
                                context,
                                color: Colors.green,
                                icon: Icons.check_rounded,
                                alignment: Alignment.centerLeft,
                              ),
                              secondaryBackground: _dismissBackground(
                                context,
                                color: Colors.redAccent,
                                icon: Icons.delete_rounded,
                                alignment: Alignment.centerRight,
                              ),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      await ref
                                          .read(taskActionsProvider)
                                          .deleteTask(task);
                                      return true;
                                    }
                                    await ref
                                        .read(taskActionsProvider)
                                        .toggleTask(task);
                                    return false;
                                  },
                              child: TaskCard(
                                task: task,
                                onTap: () => context.go('/tasks/${task.id}'),
                                onToggle: () => ref
                                    .read(taskActionsProvider)
                                    .toggleTask(task),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) =>
                Text(error.toString()),
          ),
        ],
      ),
    );
  }

  Widget _dismissBackground(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
