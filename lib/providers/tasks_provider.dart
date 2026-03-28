// lib/providers/tasks_provider.dart
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/outbox_event.dart';
import '../domain/models/task.dart';
import '../domain/repositories/tasks_repository.dart';
import 'app_providers.dart';
import 'notifications_provider.dart';

enum TaskSort { dueDate, priority, course }

final rawTasksProvider = StreamProvider<List<Task>>(
  (Ref ref) => ref.watch(tasksRepositoryProvider).watchAll(),
);

final taskStatusFilterProvider = StateProvider<TaskStatus?>((Ref ref) => null);
final taskSearchQueryProvider = StateProvider<String>((Ref ref) => '');
final taskSortProvider = StateProvider<TaskSort>((Ref ref) => TaskSort.dueDate);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((Ref ref) {
  final AsyncValue<List<Task>> tasksAsync = ref.watch(rawTasksProvider);
  final TaskStatus? status = ref.watch(taskStatusFilterProvider);
  final String query = ref.watch(taskSearchQueryProvider).trim().toLowerCase();
  final TaskSort sort = ref.watch(taskSortProvider);

  return tasksAsync.whenData((List<Task> tasks) {
    final Iterable<Task> filtered = tasks.where((Task task) {
      final bool matchesStatus = status == null || task.status == status;
      final bool matchesQuery =
          query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false);
      return matchesStatus && matchesQuery;
    });

    final List<Task> sorted = filtered.toList()
      ..sort((Task a, Task b) {
        switch (sort) {
          case TaskSort.priority:
            return b.priority.index.compareTo(a.priority.index);
          case TaskSort.course:
            return (a.courseId ?? '').compareTo(b.courseId ?? '');
          case TaskSort.dueDate:
            return (a.dueDate ?? DateTime(2100)).compareTo(
              b.dueDate ?? DateTime(2100),
            );
        }
      });

    return sorted;
  });
});

class TaskActions {
  const TaskActions(this._ref);

  final Ref _ref;

  Future<void> saveTask(Task task, {bool isNew = false}) async {
    await _ref
        .read(tasksRepositoryProvider)
        .save(
          task.copyWith(updatedAt: DateTime.now()),
          operation: isNew ? SyncOperation.create : SyncOperation.update,
        );
    if (task.remindAt != null) {
      await _ref
          .read(notificationsProvider)
          .scheduleTaskReminder(
            notificationId: task.id.hashCode,
            remindAt: task.remindAt!,
            title: task.title,
            body: task.description ?? 'Task reminder',
            payload: task.id,
          );
    }
  }

  Future<void> deleteTask(Task task) async {
    await _ref.read(tasksRepositoryProvider).delete(task);
    await _ref.read(notificationsProvider).cancel(task.id.hashCode);
  }

  Future<void> toggleTask(Task task) async {
    await _ref.read(tasksRepositoryProvider).toggleDone(task);
    if (task.status != TaskStatus.done) {
      await _ref.read(notificationsProvider).cancel(task.id.hashCode);
    }
  }

  Future<void> applyTemplateFromAsset(String asset) async {
    final String content = await rootBundle.loadString(asset);
    await _ref
        .read(tasksRepositoryProvider)
        .applyTemplate(jsonDecode(content) as Map<String, dynamic>);
  }

  Future<void> exportTasks(List<Task> tasks) async {
    final TasksRepository repository = _ref.read(tasksRepositoryProvider);
    final String csv = await repository.exportTasksAsCsv(tasks);
    final String ics = repository.exportTasksAsIcs(tasks);
    final Directory dir = Directory.systemTemp.createTempSync('planora_export');
    final File csvFile = File('${dir.path}/tasks.csv')..writeAsStringSync(csv);
    final File icsFile = File('${dir.path}/calendar.ics')
      ..writeAsStringSync(ics);
    await Share.shareXFiles(<XFile>[
      XFile(csvFile.path),
      XFile(icsFile.path),
    ], text: 'PLANORA task export');
  }

  Future<String> importTasks() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) {
      return 'Import canceled.';
    }
    final File file = File(result.files.single.path!);
    final String content = await file.readAsString();
    if (file.path.endsWith('.csv')) {
      final List<Task> imported = await _ref
          .read(tasksRepositoryProvider)
          .importTasksFromCsv(content);
      return 'Imported ${imported.length} tasks from CSV.';
    }
    if (file.path.endsWith('.ics')) {
      final List<Task> imported = await _ref
          .read(tasksRepositoryProvider)
          .importTasksFromIcs(content);
      return 'Imported ${imported.length} tasks from ICS.';
    }
    return 'Unsupported file type.';
  }
}

final taskActionsProvider = Provider<TaskActions>(
  (Ref ref) => TaskActions(ref),
);

final draftTaskProvider = Provider<Task>(
  (Ref ref) =>
      Task(id: const Uuid().v4(), title: '', updatedAt: DateTime.now()),
);
