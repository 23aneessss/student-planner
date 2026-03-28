// lib/domain/repositories/sessions_repository.dart
import 'package:uuid/uuid.dart';

import '../../data/local/daos/outbox_dao.dart';
import '../../data/local/daos/sessions_dao.dart';
import '../models/outbox_event.dart';
import '../models/session.dart';

class SessionsRepository {
  SessionsRepository({
    required SessionsDao sessionsDao,
    required OutboxDao outboxDao,
  }) : _sessionsDao = sessionsDao,
       _outboxDao = outboxDao;

  final SessionsDao _sessionsDao;
  final OutboxDao _outboxDao;

  Stream<List<PomodoroSession>> watchAll() => _sessionsDao.watchAll();
  Future<PomodoroSession?> getById(String id) => _sessionsDao.getById(id);

  Future<void> save(
    PomodoroSession session, {
    SyncOperation operation = SyncOperation.update,
  }) async {
    await _sessionsDao.upsert(session);
    await _outboxDao.upsert(
      OutboxEvent(
        id: const Uuid().v4(),
        entityType: OutboxEntityType.session,
        entityId: session.id,
        operation: operation,
        payload: session.toJson(),
        createdAt: DateTime.now(),
      ),
    );
  }
}
