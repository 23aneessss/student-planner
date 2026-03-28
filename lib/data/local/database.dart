// lib/data/local/database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/courses_dao.dart';
import 'daos/grades_dao.dart';
import 'daos/outbox_dao.dart';
import 'daos/sessions_dao.dart';
import 'daos/tasks_dao.dart';
import 'tables/courses_table.dart';
import 'tables/grades_table.dart';
import 'tables/outbox_table.dart';
import 'tables/sessions_table.dart';
import 'tables/tasks_table.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final File file = File(p.join(documentsDirectory.path, 'planora.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: <Type>[Tasks, Courses, PomodoroSessions, Grades, OutboxEvents],
  daos: <Type>[TasksDao, CoursesDao, SessionsDao, GradesDao, OutboxDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
