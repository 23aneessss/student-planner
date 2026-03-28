// test/unit/sync_engine_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planora/core/constants.dart';
import 'package:planora/data/local/database.dart' hide OutboxEvent, Task;
import 'package:planora/data/remote/sync_remote.dart';
import 'package:planora/domain/models/outbox_event.dart' as outbox_model;
import 'package:planora/domain/models/task.dart' as task_model;
import 'package:planora/domain/repositories/sync_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/mock_api_client.dart';
import '../mocks/mock_database.dart';

class _FakeOutboxEvent extends Fake implements outbox_model.OutboxEvent {}

void main() {
  late AppDatabase database;
  late MockSyncRemote syncRemote;
  late SharedPreferences prefs;
  late SyncRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeOutboxEvent());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
    database = buildTestDatabase();
    syncRemote = MockSyncRemote();
    repository = SyncRepository(
      outboxDao: database.outboxDao,
      tasksDao: database.tasksDao,
      coursesDao: database.coursesDao,
      sessionsDao: database.sessionsDao,
      gradesDao: database.gradesDao,
      syncRemote: syncRemote,
      prefs: prefs,
      remoteEnabled: true,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('pushOutbox calls POST and deletes on 2xx', () async {
    await database.outboxDao.upsert(
      outbox_model.OutboxEvent(
        id: 'out-1',
        entityType: outbox_model.OutboxEntityType.task,
        entityId: 'task-1',
        operation: outbox_model.SyncOperation.create,
        payload: <String, dynamic>{'id': 'task-1'},
        createdAt: DateTime.now(),
      ),
    );
    when(() => syncRemote.pushEvent(any())).thenAnswer((_) async {});

    await repository.pushOutbox();

    verify(() => syncRemote.pushEvent(any())).called(1);
    expect(await database.outboxDao.pendingOutbox(), isEmpty);
  });

  test('pullSince server newer upserts local entity', () async {
    when(() => syncRemote.pullSince(any())).thenAnswer(
      (_) async => <SyncPullItem>[
        SyncPullItem(
          entityType: outbox_model.OutboxEntityType.task,
          id: 'task-2',
          payload: task_model.Task(
            id: 'task-2',
            title: 'Remote task',
            updatedAt: DateTime.now(),
          ).toJson(),
          updatedAt: DateTime.now(),
        ),
      ],
    );

    await repository.pullSince();

    final task_model.Task? stored = await database.tasksDao.getById('task-2');
    expect(stored?.title, 'Remote task');
    expect(prefs.getInt(kLastSyncKey), isNotNull);
  });

  test('pullSince ignores older server payload when local is newer', () async {
    final DateTime localUpdatedAt = DateTime.now();
    await database.tasksDao.upsert(
      task_model.Task(
        id: 'task-3',
        title: 'Local latest',
        updatedAt: localUpdatedAt,
      ),
    );
    when(() => syncRemote.pullSince(any())).thenAnswer(
      (_) async => <SyncPullItem>[
        SyncPullItem(
          entityType: outbox_model.OutboxEntityType.task,
          id: 'task-3',
          payload: task_model.Task(
            id: 'task-3',
            title: 'Stale remote title',
            updatedAt: localUpdatedAt.subtract(const Duration(hours: 1)),
          ).toJson(),
          updatedAt: localUpdatedAt.subtract(const Duration(hours: 1)),
        ),
      ],
    );

    await repository.pullSince();

    final task_model.Task? stored = await database.tasksDao.getById('task-3');
    expect(stored?.title, 'Local latest');
  });

  test('deletedAt soft-deletes local row correctly', () async {
    final DateTime updatedAt = DateTime.now();
    await database.tasksDao.upsert(
      task_model.Task(
        id: 'task-4',
        title: 'Delete me',
        updatedAt: updatedAt.subtract(const Duration(hours: 2)),
      ),
    );
    when(() => syncRemote.pullSince(any())).thenAnswer(
      (_) async => <SyncPullItem>[
        SyncPullItem(
          entityType: outbox_model.OutboxEntityType.task,
          id: 'task-4',
          payload: <String, dynamic>{'id': 'task-4'},
          updatedAt: updatedAt,
          deletedAt: updatedAt,
        ),
      ],
    );

    await repository.pullSince();

    final task_model.Task? stored = await database.tasksDao.getById('task-4');
    expect(stored?.deletedAt, isNotNull);
  });
}
