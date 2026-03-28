// lib/domain/repositories/sync_repository.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import '../../data/local/daos/courses_dao.dart';
import '../../data/local/daos/grades_dao.dart';
import '../../data/local/daos/outbox_dao.dart';
import '../../data/local/daos/sessions_dao.dart';
import '../../data/local/daos/tasks_dao.dart';
import '../../data/remote/sync_remote.dart';
import '../models/course.dart';
import '../models/grade.dart';
import '../models/outbox_event.dart';
import '../models/session.dart';
import '../models/task.dart';

class SyncRepository {
  SyncRepository({
    required OutboxDao outboxDao,
    required TasksDao tasksDao,
    required CoursesDao coursesDao,
    required SessionsDao sessionsDao,
    required GradesDao gradesDao,
    required SyncRemote syncRemote,
    required SharedPreferences prefs,
    bool? remoteEnabled,
  }) : _outboxDao = outboxDao,
       _tasksDao = tasksDao,
       _coursesDao = coursesDao,
       _sessionsDao = sessionsDao,
       _gradesDao = gradesDao,
       _syncRemote = syncRemote,
       _prefs = prefs,
       _remoteEnabled = remoteEnabled ?? AppConfig.remoteServicesEnabled;

  final OutboxDao _outboxDao;
  final TasksDao _tasksDao;
  final CoursesDao _coursesDao;
  final SessionsDao _sessionsDao;
  final GradesDao _gradesDao;
  final SyncRemote _syncRemote;
  final SharedPreferences _prefs;
  final bool _remoteEnabled;

  Future<void> pushOutbox() async {
    if (!_remoteEnabled) {
      return;
    }
    final List<OutboxEvent> events = await _outboxDao.pendingOutbox();
    for (final OutboxEvent event in events) {
      try {
        await _syncRemote.pushEvent(event);
        await _outboxDao.remove(event.id);
      } catch (_) {
        await _outboxDao.incrementAttempts(event.id);
      }
    }
  }

  Future<void> pullSince() async {
    if (!_remoteEnabled) {
      return;
    }
    final int lastSyncMs = _prefs.getInt(kLastSyncKey) ?? 0;
    final List<SyncPullItem> items = await _syncRemote.pullSince(lastSyncMs);
    int maxSync = lastSyncMs;
    for (final SyncPullItem item in items) {
      maxSync = item.updatedAt.millisecondsSinceEpoch > maxSync
          ? item.updatedAt.millisecondsSinceEpoch
          : maxSync;
      await _applyPullItem(item);
    }
    await _prefs.setInt(kLastSyncKey, maxSync);
  }

  Future<void> syncNow() async {
    await pushOutbox();
    await pullSince();
  }

  Future<void> _applyPullItem(SyncPullItem item) async {
    switch (item.entityType) {
      case OutboxEntityType.task:
        await _applyTask(item);
      case OutboxEntityType.course:
        await _applyCourse(item);
      case OutboxEntityType.session:
        await _applySession(item);
      case OutboxEntityType.grade:
        await _applyGrade(item);
    }
  }

  Future<void> _applyTask(SyncPullItem item) async {
    final Task? local = await _tasksDao.getById(item.id);
    if (item.deletedAt != null) {
      if (local == null || !local.updatedAt.isAfter(item.deletedAt!)) {
        await _tasksDao.softDelete(item.id, item.deletedAt!);
      }
      return;
    }

    final Task task = Task.fromJson(item.payload);
    if (local == null || item.updatedAt.isAfter(local.updatedAt)) {
      await _tasksDao.upsert(task);
    }
  }

  Future<void> _applyCourse(SyncPullItem item) async {
    final Course? local = await _coursesDao.getById(item.id);
    if (item.deletedAt != null) {
      if (local == null || !local.updatedAt.isAfter(item.deletedAt!)) {
        await _coursesDao.softDelete(item.id, item.deletedAt!);
      }
      return;
    }

    final Course course = Course.fromJson(item.payload);
    if (local == null || item.updatedAt.isAfter(local.updatedAt)) {
      await _coursesDao.upsert(course);
    }
  }

  Future<void> _applySession(SyncPullItem item) async {
    final PomodoroSession? local = await _sessionsDao.getById(item.id);
    if (item.deletedAt != null) {
      if (local == null || !local.updatedAt.isAfter(item.deletedAt!)) {
        await _sessionsDao.softDelete(item.id, item.deletedAt!);
      }
      return;
    }

    final PomodoroSession session = PomodoroSession.fromJson(item.payload);
    if (local == null || item.updatedAt.isAfter(local.updatedAt)) {
      await _sessionsDao.upsert(session);
    }
  }

  Future<void> _applyGrade(SyncPullItem item) async {
    final Grade? local = await _gradesDao.getById(item.id);
    if (item.deletedAt != null) {
      if (local == null || !local.updatedAt.isAfter(item.deletedAt!)) {
        await _gradesDao.softDelete(item.id, item.deletedAt!);
      }
      return;
    }

    final Grade grade = Grade.fromJson(item.payload);
    if (local == null || item.updatedAt.isAfter(local.updatedAt)) {
      await _gradesDao.upsert(grade);
    }
  }
}
