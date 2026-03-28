// lib/providers/courses_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/course.dart';
import 'app_providers.dart';

final coursesStreamProvider = StreamProvider<List<Course>>(
  (Ref ref) => ref.watch(coursesRepositoryProvider).watchAll(),
);
