// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeImpl _$$GradeImplFromJson(Map<String, dynamic> json) => _$GradeImpl(
  id: json['id'] as String,
  courseId: json['courseId'] as String,
  title: json['title'] as String,
  score: (json['score'] as num).toDouble(),
  maxScore: (json['maxScore'] as num?)?.toDouble() ?? 100,
  weight: (json['weight'] as num?)?.toDouble() ?? 1,
  type:
      $enumDecodeNullable(_$GradeTypeEnumMap, json['type']) ??
      GradeType.assignment,
  gradedAt: DateTime.parse(json['gradedAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$GradeImplToJson(_$GradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'score': instance.score,
      'maxScore': instance.maxScore,
      'weight': instance.weight,
      'type': _$GradeTypeEnumMap[instance.type]!,
      'gradedAt': instance.gradedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$GradeTypeEnumMap = {
  GradeType.exam: 'exam',
  GradeType.quiz: 'quiz',
  GradeType.assignment: 'assignment',
  GradeType.project: 'project',
};
