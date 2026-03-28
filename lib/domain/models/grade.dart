// lib/domain/models/grade.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade.freezed.dart';
part 'grade.g.dart';

enum GradeType { exam, quiz, assignment, project }

@freezed
class Grade with _$Grade {
  const factory Grade({
    required String id,
    required String courseId,
    required String title,
    required double score,
    @Default(100) double maxScore,
    @Default(1) double weight,
    @Default(GradeType.assignment) GradeType type,
    required DateTime gradedAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Grade;

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
}
