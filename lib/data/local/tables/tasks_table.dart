// lib/data/local/tables/tasks_table.dart
import 'package:drift/drift.dart';

class Tasks extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get courseId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('todo'))();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  TextColumn get tags => text().nullable()();
  IntColumn get dueDate => integer().nullable()();
  IntColumn get remindAt => integer().nullable()();
  TextColumn get recurring => text().nullable()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
