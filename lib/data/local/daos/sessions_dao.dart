// lib/data/local/daos/sessions_dao.dart
import 'package:drift/drift.dart';

import '../../../domain/models/session.dart' as model;
import '../database.dart';
import '../tables/sessions_table.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: <Type>[PomodoroSessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Stream<List<model.PomodoroSession>> watchAll() {
    final Selectable<PomodoroSession> query = (select(pomodoroSessions)
      ..where((PomodoroSessions tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function(PomodoroSessions)>[
        (PomodoroSessions tbl) => OrderingTerm.desc(tbl.startedAt),
      ]));
    return query.watch().map(
      (List<PomodoroSession> rows) => rows.map(_mapRow).toList(),
    );
  }

  Future<model.PomodoroSession?> getById(String id) async {
    final PomodoroSession? row = await (select(
      pomodoroSessions,
    )..where((PomodoroSessions tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> upsert(model.PomodoroSession session) {
    return into(pomodoroSessions).insertOnConflictUpdate(_toCompanion(session));
  }

  Future<void> softDelete(String id, DateTime updatedAt) {
    return (update(
      pomodoroSessions,
    )..where((PomodoroSessions tbl) => tbl.id.equals(id))).write(
      PomodoroSessionsCompanion(
        deletedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
        updatedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
      ),
    );
  }

  model.PomodoroSession _mapRow(PomodoroSession row) {
    return model.PomodoroSession(
      id: row.id,
      taskId: row.taskId,
      courseId: row.courseId,
      durationSec: row.durationSec,
      startedAt: DateTime.fromMillisecondsSinceEpoch(row.startedAt),
      endedAt: row.endedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.endedAt!),
      notes: row.notes,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      deletedAt: row.deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.deletedAt!),
    );
  }

  PomodoroSessionsCompanion _toCompanion(model.PomodoroSession session) {
    return PomodoroSessionsCompanion(
      id: Value<String>(session.id),
      taskId: Value<String?>(session.taskId),
      courseId: Value<String?>(session.courseId),
      durationSec: Value<int>(session.durationSec),
      startedAt: Value<int>(session.startedAt.millisecondsSinceEpoch),
      endedAt: Value<int?>(session.endedAt?.millisecondsSinceEpoch),
      notes: Value<String?>(session.notes),
      updatedAt: Value<int>(session.updatedAt.millisecondsSinceEpoch),
      deletedAt: Value<int?>(session.deletedAt?.millisecondsSinceEpoch),
    );
  }
}
