// lib/data/local/tables/courses_table.dart
import 'package:drift/drift.dart';

class Courses extends Table {
  @override
  String get tableName => 'courses';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
  TextColumn get instructor => text().nullable()();
  TextColumn get schedule => text()();
  TextColumn get semester => text()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
