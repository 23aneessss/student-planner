// lib/providers/app_providers.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../data/local/database.dart' hide Course, Task;
import '../data/remote/api_client.dart';
import '../data/remote/auth_remote.dart';
import '../data/remote/sync_remote.dart';
import '../domain/models/course.dart';
import '../domain/models/outbox_event.dart';
import '../domain/models/task.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/courses_repository.dart';
import '../domain/repositories/grades_repository.dart';
import '../domain/repositories/sessions_repository.dart';
import '../domain/repositories/sync_repository.dart';
import '../domain/repositories/tasks_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (Ref ref) =>
      throw UnimplementedError('sharedPreferencesProvider must be overridden.'),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (Ref ref) => const FlutterSecureStorage(),
);

final appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(ref.watch(secureStorageProvider)),
);

final authRemoteProvider = Provider<AuthRemote>(
  (Ref ref) => AuthRemote(ref.watch(apiClientProvider)),
);

final syncRemoteProvider = Provider<SyncRemote>(
  (Ref ref) => SyncRemote(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepository(
    secureStorage: ref.watch(secureStorageProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    authRemote: ref.watch(authRemoteProvider),
    apiClient: ref.watch(apiClientProvider),
  ),
);

final tasksRepositoryProvider = Provider<TasksRepository>(
  (Ref ref) => TasksRepository(
    tasksDao: ref.watch(appDatabaseProvider).tasksDao,
    outboxDao: ref.watch(appDatabaseProvider).outboxDao,
  ),
);

final coursesRepositoryProvider = Provider<CoursesRepository>(
  (Ref ref) => CoursesRepository(
    coursesDao: ref.watch(appDatabaseProvider).coursesDao,
    outboxDao: ref.watch(appDatabaseProvider).outboxDao,
  ),
);

final sessionsRepositoryProvider = Provider<SessionsRepository>(
  (Ref ref) => SessionsRepository(
    sessionsDao: ref.watch(appDatabaseProvider).sessionsDao,
    outboxDao: ref.watch(appDatabaseProvider).outboxDao,
  ),
);

final gradesRepositoryProvider = Provider<GradesRepository>(
  (Ref ref) => GradesRepository(
    gradesDao: ref.watch(appDatabaseProvider).gradesDao,
    outboxDao: ref.watch(appDatabaseProvider).outboxDao,
  ),
);

final syncRepositoryProvider = Provider<SyncRepository>(
  (Ref ref) => SyncRepository(
    outboxDao: ref.watch(appDatabaseProvider).outboxDao,
    tasksDao: ref.watch(appDatabaseProvider).tasksDao,
    coursesDao: ref.watch(appDatabaseProvider).coursesDao,
    sessionsDao: ref.watch(appDatabaseProvider).sessionsDao,
    gradesDao: ref.watch(appDatabaseProvider).gradesDao,
    syncRemote: ref.watch(syncRemoteProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  ),
);

final onboardingProvider = StateProvider<bool>(
  (Ref ref) =>
      ref.watch(sharedPreferencesProvider).getBool(kOnboardingDoneKey) ?? false,
);

final appBootstrapProvider = FutureProvider<void>((Ref ref) async {
  final TasksRepository tasksRepository = ref.watch(tasksRepositoryProvider);
  final CoursesRepository coursesRepository = ref.watch(
    coursesRepositoryProvider,
  );

  final List<Task> tasks = await tasksRepository.watchAll().first;
  final List<Course> courses = await coursesRepository.watchAll().first;
  if (tasks.isNotEmpty || courses.isNotEmpty) {
    return;
  }

  final DateTime now = DateTime.now();
  await coursesRepository.save(
    Course(
      id: 'course-math',
      name: 'Applied Mathematics',
      colorHex: '#C8B3FD',
      instructor: 'Dr. Nadir',
      schedule: const <CourseScheduleEntry>[
        CourseScheduleEntry(day: 1, start: '08:00', end: '09:30'),
        CourseScheduleEntry(day: 3, start: '10:00', end: '11:30'),
      ],
      semester: 'Spring 2026',
      updatedAt: now,
    ),
    operation: SyncOperation.create,
  );
  await coursesRepository.save(
    Course(
      id: 'course-design',
      name: 'Design Systems',
      colorHex: '#EE6C4D',
      instructor: 'Prof. Lila',
      schedule: const <CourseScheduleEntry>[
        CourseScheduleEntry(day: 2, start: '13:00', end: '14:30'),
      ],
      semester: 'Spring 2026',
      updatedAt: now,
    ),
    operation: SyncOperation.create,
  );
  await tasksRepository.save(
    Task(
      id: 'task-1',
      title: 'Review calculus notes',
      description: 'Prepare for Monday quiz.',
      courseId: 'course-math',
      priority: TaskPriority.high,
      dueDate: now.add(const Duration(hours: 8)),
      tags: const <String>['study', 'quiz'],
      updatedAt: now,
    ),
    operation: SyncOperation.create,
  );
  await tasksRepository.save(
    Task(
      id: 'task-2',
      title: 'Finish UI critique',
      description: 'Share annotated screenshots with the team.',
      courseId: 'course-design',
      priority: TaskPriority.medium,
      dueDate: now.add(const Duration(days: 1)),
      tags: const <String>['design'],
      updatedAt: now,
    ),
    operation: SyncOperation.create,
  );
});
