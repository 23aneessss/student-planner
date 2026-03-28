// lib/data/local/daos/tasks_dao.dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/models/task.dart' as model;
import '../database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: <Type>[Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Stream<List<model.Task>> watchAll() {
    final Selectable<Task> query = (select(tasks)
      ..where((Tasks tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function(Tasks)>[
        (Tasks tbl) => OrderingTerm.asc(tbl.dueDate),
        (Tasks tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]));
    return query.watch().map((List<Task> rows) => rows.map(_mapRow).toList());
  }

  Future<model.Task?> getById(String id) async {
    final Task? row = await (select(
      tasks,
    )..where((Tasks tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> upsert(model.Task task) {
    return into(tasks).insertOnConflictUpdate(_toCompanion(task));
  }

  Future<void> softDelete(String id, DateTime updatedAt) {
    return (update(tasks)..where((Tasks tbl) => tbl.id.equals(id))).write(
      TasksCompanion(
        deletedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
        updatedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
      ),
    );
  }

  Future<List<model.Task>> dueOn(DateTime day) {
    final int start = DateTime(
      day.year,
      day.month,
      day.day,
    ).millisecondsSinceEpoch;
    final int end = DateTime(
      day.year,
      day.month,
      day.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;
    final Selectable<Task> query = (select(tasks)
      ..where(
        (Tasks tbl) =>
            tbl.deletedAt.isNull() & tbl.dueDate.isBetweenValues(start, end),
      )
      ..orderBy(<OrderingTerm Function(Tasks)>[
        (Tasks tbl) => OrderingTerm.asc(tbl.dueDate),
      ]));
    return query.get().then((List<Task> rows) => rows.map(_mapRow).toList());
  }

  model.Task _mapRow(Task row) {
    return model.Task(
      id: row.id,
      title: row.title,
      description: row.description,
      courseId: row.courseId,
      status: _statusFromDb(row.status),
      priority: _priorityFromDb(row.priority),
      tags: row.tags == null
          ? <String>[]
          : List<String>.from(jsonDecode(row.tags!) as List<dynamic>),
      dueDate: row.dueDate == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.dueDate!),
      remindAt: row.remindAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.remindAt!),
      recurring: row.recurring == null
          ? null
          : Map<String, dynamic>.from(
              jsonDecode(row.recurring!) as Map<String, dynamic>,
            ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      deletedAt: row.deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.deletedAt!),
    );
  }

  TasksCompanion _toCompanion(model.Task task) {
    return TasksCompanion(
      id: Value<String>(task.id),
      title: Value<String>(task.title),
      description: Value<String?>(task.description),
      courseId: Value<String?>(task.courseId),
      status: Value<String>(_statusToDb(task.status)),
      priority: Value<int>(task.priority.index),
      tags: Value<String>(jsonEncode(task.tags)),
      dueDate: Value<int?>(task.dueDate?.millisecondsSinceEpoch),
      remindAt: Value<int?>(task.remindAt?.millisecondsSinceEpoch),
      recurring: Value<String?>(
        task.recurring == null ? null : jsonEncode(task.recurring),
      ),
      updatedAt: Value<int>(task.updatedAt.millisecondsSinceEpoch),
      deletedAt: Value<int?>(task.deletedAt?.millisecondsSinceEpoch),
    );
  }

  String _statusToDb(model.TaskStatus status) {
    switch (status) {
      case model.TaskStatus.todo:
        return 'todo';
      case model.TaskStatus.inProgress:
        return 'in_progress';
      case model.TaskStatus.done:
        return 'done';
      case model.TaskStatus.cancelled:
        return 'cancelled';
    }
  }

  model.TaskStatus _statusFromDb(String value) {
    switch (value) {
      case 'todo':
        return model.TaskStatus.todo;
      case 'in_progress':
        return model.TaskStatus.inProgress;
      case 'done':
        return model.TaskStatus.done;
      case 'cancelled':
        return model.TaskStatus.cancelled;
      default:
        return model.TaskStatus.todo;
    }
  }

  model.TaskPriority _priorityFromDb(int value) {
    switch (value) {
      case 0:
        return model.TaskPriority.low;
      case 1:
        return model.TaskPriority.medium;
      case 2:
        return model.TaskPriority.high;
      case 3:
        return model.TaskPriority.urgent;
      default:
        return model.TaskPriority.medium;
    }
  }
}
