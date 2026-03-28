// lib/data/local/tables/sessions_table.dart
import 'package:drift/drift.dart';

class PomodoroSessions extends Table {
  @override
  String get tableName => 'pomodoro_sessions';

  TextColumn get id => text()();
  TextColumn get taskId => text().nullable()();
  TextColumn get courseId => text().nullable()();
  IntColumn get durationSec => integer()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
