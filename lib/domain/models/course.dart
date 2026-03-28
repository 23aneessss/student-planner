// lib/domain/models/course.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class CourseScheduleEntry with _$CourseScheduleEntry {
  const factory CourseScheduleEntry({
    required int day,
    required String start,
    required String end,
  }) = _CourseScheduleEntry;

  factory CourseScheduleEntry.fromJson(Map<String, dynamic> json) =>
      _$CourseScheduleEntryFromJson(json);
}

@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String name,
    required String colorHex,
    String? instructor,
    @Default(<CourseScheduleEntry>[]) List<CourseScheduleEntry> schedule,
    required String semester,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
