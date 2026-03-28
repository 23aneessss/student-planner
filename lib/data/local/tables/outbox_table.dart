// lib/data/local/tables/outbox_table.dart
import 'package:drift/drift.dart';

class OutboxEvents extends Table {
  @override
  String get tableName => 'outbox_events';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get createdAt => integer()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
