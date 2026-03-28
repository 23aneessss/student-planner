// test/unit/task_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:planora/data/local/database.dart' hide Task;
import 'package:planora/domain/models/outbox_event.dart' as outbox_model;
import 'package:planora/domain/models/task.dart' as task_model;
import 'package:planora/domain/repositories/tasks_repository.dart';

import '../mocks/mock_database.dart';

void main() {
  late AppDatabase database;
  late TasksRepository repository;

  setUp(() {
    database = buildTestDatabase();
    repository = TasksRepository(
      tasksDao: database.tasksDao,
      outboxDao: database.outboxDao,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('upsert saves to in-memory drift db', () async {
    final task_model.Task task = task_model.Task(
      id: 'task-1',
      title: 'Study algebra',
      updatedAt: DateTime.now(),
    );

    await repository.save(task, operation: outbox_model.SyncOperation.create);

    final task_model.Task? stored = await repository.getById(task.id);
    expect(stored, isNotNull);
    expect(stored?.title, 'Study algebra');
  });

  test('softDelete sets deletedAt and keeps row', () async {
    final task_model.Task task = task_model.Task(
      id: 'task-2',
      title: 'Review chemistry',
      updatedAt: DateTime.now(),
    );

    await repository.save(task, operation: outbox_model.SyncOperation.create);
    await repository.delete(task);

    final task_model.Task? stored = await repository.getById(task.id);
    expect(stored, isNotNull);
    expect(stored?.deletedAt, isNotNull);
  });

  test('watchAll stream emits updated list', () async {
    final Future<List<task_model.Task>> nextEmission = repository
        .watchAll()
        .firstWhere((List<task_model.Task> tasks) => tasks.isNotEmpty);

    await repository.save(
      task_model.Task(
        id: 'task-3',
        title: 'Prepare notes',
        updatedAt: DateTime.now(),
      ),
      operation: outbox_model.SyncOperation.create,
    );

    final List<task_model.Task> emitted = await nextEmission;
    expect(emitted, hasLength(1));
    expect(emitted.first.title, 'Prepare notes');
  });
}
