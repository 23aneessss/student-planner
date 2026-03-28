// lib/data/local/tables/grades_table.dart
import 'package:drift/drift.dart';

class Grades extends Table {
  @override
  String get tableName => 'grades';

  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  RealColumn get score => real()();
  RealColumn get maxScore => real().withDefault(const Constant(100))();
  RealColumn get weight => real().withDefault(const Constant(1))();
  TextColumn get type => text()();
  IntColumn get gradedAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
