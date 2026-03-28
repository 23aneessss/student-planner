// lib/data/local/daos/outbox_dao.dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/models/outbox_event.dart' as model;
import '../database.dart';
import '../tables/outbox_table.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: <Type>[OutboxEvents])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Stream<List<model.OutboxEvent>> watchAll() {
    final Selectable<OutboxEvent> query = (select(outboxEvents)
      ..orderBy(<OrderingTerm Function(OutboxEvents)>[
        (OutboxEvents tbl) => OrderingTerm.asc(tbl.createdAt),
      ]));
    return query.watch().map(
      (List<OutboxEvent> rows) => rows.map(_mapRow).toList(),
    );
  }

  Future<model.OutboxEvent?> getById(String id) async {
    final OutboxEvent? row = await (select(
      outboxEvents,
    )..where((OutboxEvents tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> upsert(model.OutboxEvent event) {
    return into(outboxEvents).insertOnConflictUpdate(
      OutboxEventsCompanion(
        id: Value<String>(event.id),
        entityType: Value<String>(event.entityType.name),
        entityId: Value<String>(event.entityId),
        operation: Value<String>(event.operation.name),
        payload: Value<String>(jsonEncode(event.payload)),
        createdAt: Value<int>(event.createdAt.millisecondsSinceEpoch),
        attempts: Value<int>(event.attempts),
      ),
    );
  }

  Future<void> softDelete(String id, DateTime updatedAt) {
    return (delete(
      outboxEvents,
    )..where((OutboxEvents tbl) => tbl.id.equals(id))).go();
  }

  Future<List<model.OutboxEvent>> pendingOutbox() async {
    final List<OutboxEvent> rows =
        await (select(outboxEvents)
              ..where((OutboxEvents tbl) => tbl.attempts.isSmallerThanValue(5))
              ..orderBy(<OrderingTerm Function(OutboxEvents)>[
                (OutboxEvents tbl) => OrderingTerm.asc(tbl.createdAt),
              ]))
            .get();
    return rows.map(_mapRow).toList();
  }

  Future<void> remove(String id) {
    return (delete(
      outboxEvents,
    )..where((OutboxEvents tbl) => tbl.id.equals(id))).go();
  }

  Future<void> incrementAttempts(String id) {
    return customUpdate(
      'UPDATE outbox_events SET attempts = attempts + 1 WHERE id = ?1',
      variables: <Variable<Object>>[Variable<String>(id)],
      updates: <TableInfo<Table, Object?>>{outboxEvents},
    );
  }

  model.OutboxEvent _mapRow(OutboxEvent row) {
    return model.OutboxEvent(
      id: row.id,
      entityType: model.OutboxEntityType.values.firstWhere(
        (model.OutboxEntityType type) => type.name == row.entityType,
      ),
      entityId: row.entityId,
      operation: model.SyncOperation.values.firstWhere(
        (model.SyncOperation operation) => operation.name == row.operation,
      ),
      payload: Map<String, dynamic>.from(
        jsonDecode(row.payload) as Map<String, dynamic>,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      attempts: row.attempts,
    );
  }
}
