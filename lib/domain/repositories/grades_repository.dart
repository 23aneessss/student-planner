// lib/domain/repositories/grades_repository.dart
import 'package:uuid/uuid.dart';

import '../../data/local/daos/grades_dao.dart';
import '../../data/local/daos/outbox_dao.dart';
import '../models/grade.dart';
import '../models/outbox_event.dart';

class GradesRepository {
  GradesRepository({required GradesDao gradesDao, required OutboxDao outboxDao})
    : _gradesDao = gradesDao,
      _outboxDao = outboxDao;

  final GradesDao _gradesDao;
  final OutboxDao _outboxDao;

  Stream<List<Grade>> watchAll() => _gradesDao.watchAll();
  Future<Grade?> getById(String id) => _gradesDao.getById(id);

  Future<void> save(
    Grade grade, {
    SyncOperation operation = SyncOperation.update,
  }) async {
    await _gradesDao.upsert(grade);
    await _outboxDao.upsert(
      OutboxEvent(
        id: const Uuid().v4(),
        entityType: OutboxEntityType.grade,
        entityId: grade.id,
        operation: operation,
        payload: grade.toJson(),
        createdAt: DateTime.now(),
      ),
    );
  }
}
