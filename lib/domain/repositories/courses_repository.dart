// lib/domain/repositories/courses_repository.dart
import 'package:uuid/uuid.dart';

import '../../data/local/daos/courses_dao.dart';
import '../../data/local/daos/outbox_dao.dart';
import '../models/course.dart';
import '../models/outbox_event.dart';

class CoursesRepository {
  CoursesRepository({
    required CoursesDao coursesDao,
    required OutboxDao outboxDao,
  }) : _coursesDao = coursesDao,
       _outboxDao = outboxDao;

  final CoursesDao _coursesDao;
  final OutboxDao _outboxDao;

  Stream<List<Course>> watchAll() => _coursesDao.watchAll();
  Future<Course?> getById(String id) => _coursesDao.getById(id);

  Future<void> save(
    Course course, {
    SyncOperation operation = SyncOperation.update,
  }) async {
    await _coursesDao.upsert(course);
    await _outboxDao.upsert(
      OutboxEvent(
        id: const Uuid().v4(),
        entityType: OutboxEntityType.course,
        entityId: course.id,
        operation: operation,
        payload: course.toJson(),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> delete(Course course) async {
    final DateTime now = DateTime.now();
    await _coursesDao.softDelete(course.id, now);
    await _outboxDao.upsert(
      OutboxEvent(
        id: const Uuid().v4(),
        entityType: OutboxEntityType.course,
        entityId: course.id,
        operation: SyncOperation.delete,
        payload: course.copyWith(deletedAt: now, updatedAt: now).toJson(),
        createdAt: now,
      ),
    );
  }
}
