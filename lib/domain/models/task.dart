// lib/domain/models/task.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus { todo, inProgress, done, cancelled }

enum TaskPriority { low, medium, high, urgent }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    String? courseId,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(<String>[]) List<String> tags,
    DateTime? dueDate,
    DateTime? remindAt,
    Map<String, dynamic>? recurring,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
