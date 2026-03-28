// lib/domain/repositories/tasks_repository.dart
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/daos/outbox_dao.dart';
import '../../data/local/daos/tasks_dao.dart';
import '../models/outbox_event.dart';
import '../models/task.dart';

class TasksRepository {
  TasksRepository({required TasksDao tasksDao, required OutboxDao outboxDao})
    : _tasksDao = tasksDao,
      _outboxDao = outboxDao;

  final TasksDao _tasksDao;
  final OutboxDao _outboxDao;

  Stream<List<Task>> watchAll() => _tasksDao.watchAll();

  Future<Task?> getById(String id) => _tasksDao.getById(id);

  Future<void> save(
    Task task, {
    SyncOperation operation = SyncOperation.update,
  }) async {
    await _tasksDao.upsert(task);
    await _enqueue(task, operation);
  }

  Future<void> toggleDone(Task task) {
    final Task updated = task.copyWith(
      status: task.status == TaskStatus.done
          ? TaskStatus.todo
          : TaskStatus.done,
      updatedAt: DateTime.now(),
    );
    return save(updated);
  }

  Future<void> delete(Task task) async {
    final DateTime now = DateTime.now();
    await _tasksDao.softDelete(task.id, now);
    await _enqueue(
      task.copyWith(deletedAt: now, updatedAt: now),
      SyncOperation.delete,
    );
  }

  Future<String> exportTasksAsCsv(List<Task> tasks) async {
    final List<List<Object?>> rows = <List<Object?>>[
      <Object?>[
        'id',
        'title',
        'courseId',
        'status',
        'priority',
        'dueDate',
        'tags',
      ],
      ...tasks.map(
        (Task task) => <Object?>[
          task.id,
          task.title,
          task.courseId ?? '',
          task.status.name,
          task.priority.index,
          task.dueDate?.toIso8601String() ?? '',
          task.tags.join('|'),
        ],
      ),
    ];
    return const ListToCsvConverter().convert(rows);
  }

  String exportTasksAsIcs(List<Task> tasks) {
    final StringBuffer buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//PLANORA//Student Planner//EN');

    for (final Task task in tasks.where((Task item) => item.dueDate != null)) {
      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln('UID:${task.id}@planora')
        ..writeln('DTSTART:${_formatIcs(task.dueDate!)}')
        ..writeln('SUMMARY:${task.title}')
        ..writeln('DESCRIPTION:${task.description ?? ''}')
        ..writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  Future<List<Task>> importTasksFromCsv(String csvContent) async {
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      csvContent,
    );
    if (rows.length <= 1) {
      return <Task>[];
    }
    final List<Task> imported = <Task>[];
    for (final List<dynamic> row in rows.skip(1)) {
      final Task task = Task(
        id: row[0] as String,
        title: row[1] as String,
        courseId: (row[2] as String).isEmpty ? null : row[2] as String,
        status: TaskStatus.values.firstWhere(
          (TaskStatus status) => status.name == row[3],
          orElse: () => TaskStatus.todo,
        ),
        priority: TaskPriority.values[(row[4] as num).toInt()],
        dueDate: (row[5] as String).isEmpty
            ? null
            : DateTime.parse(row[5] as String),
        tags: (row[6] as String).isEmpty
            ? <String>[]
            : (row[6] as String).split('|'),
        updatedAt: DateTime.now(),
      );
      await save(task, operation: SyncOperation.create);
      imported.add(task);
    }
    return imported;
  }

  Future<List<Task>> importTasksFromIcs(String content) async {
    final List<Task> tasks = <Task>[];
    final List<String> lines = const LineSplitter().convert(content);
    String? title;
    String? description;
    DateTime? dueDate;
    for (final String line in lines) {
      if (line == 'BEGIN:VEVENT') {
        title = null;
        description = null;
        dueDate = null;
      } else if (line.startsWith('SUMMARY:')) {
        title = line.replaceFirst('SUMMARY:', '');
      } else if (line.startsWith('DESCRIPTION:')) {
        description = line.replaceFirst('DESCRIPTION:', '');
      } else if (line.startsWith('DTSTART:')) {
        dueDate = DateTime.tryParse(line.replaceFirst('DTSTART:', ''));
      } else if (line == 'END:VEVENT' && title != null) {
        final Task task = Task(
          id: const Uuid().v4(),
          title: title,
          description: description,
          dueDate: dueDate,
          updatedAt: DateTime.now(),
        );
        await save(task, operation: SyncOperation.create);
        tasks.add(task);
      }
    }
    return tasks;
  }

  Future<void> applyTemplate(Map<String, dynamic> template) async {
    final DateTime now = DateTime.now();
    final List<dynamic> tasks =
        template['tasks'] as List<dynamic>? ?? <dynamic>[];
    for (final dynamic item in tasks) {
      final Map<String, dynamic> taskJson = item as Map<String, dynamic>;
      final Task task = Task(
        id: const Uuid().v4(),
        title: taskJson['title'] as String,
        priority: TaskPriority.values[(taskJson['priority'] as int?) ?? 1],
        dueDate: now.add(Duration(days: (taskJson['dueOffset'] as int?) ?? 0)),
        tags: List<String>.from(
          (taskJson['tags'] as List<dynamic>?) ?? <dynamic>[],
        ),
        recurring: Map<String, dynamic>.from(
          (taskJson['recurrence'] as Map<Object?, Object?>?) ??
              <Object?, Object?>{},
        ),
        updatedAt: DateTime.now(),
      );
      await save(task, operation: SyncOperation.create);
    }
  }

  Future<void> _enqueue(Task task, SyncOperation operation) {
    return _outboxDao.upsert(
      OutboxEvent(
        id: const Uuid().v4(),
        entityType: OutboxEntityType.task,
        entityId: task.id,
        operation: operation,
        payload: task.toJson(),
        createdAt: DateTime.now(),
      ),
    );
  }

  String _formatIcs(DateTime value) {
    final DateTime utc = value.toUtc();
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${utc.year}${twoDigits(utc.month)}${twoDigits(utc.day)}T${twoDigits(utc.hour)}${twoDigits(utc.minute)}${twoDigits(utc.second)}Z';
  }
}
