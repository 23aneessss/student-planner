// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseScheduleEntryImpl _$$CourseScheduleEntryImplFromJson(
  Map<String, dynamic> json,
) => _$CourseScheduleEntryImpl(
  day: (json['day'] as num).toInt(),
  start: json['start'] as String,
  end: json['end'] as String,
);

Map<String, dynamic> _$$CourseScheduleEntryImplToJson(
  _$CourseScheduleEntryImpl instance,
) => <String, dynamic>{
  'day': instance.day,
  'start': instance.start,
  'end': instance.end,
};

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  instructor: json['instructor'] as String?,
  schedule:
      (json['schedule'] as List<dynamic>?)
          ?.map((e) => CourseScheduleEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CourseScheduleEntry>[],
  semester: json['semester'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorHex': instance.colorHex,
      'instructor': instance.instructor,
      'schedule': instance.schedule,
      'semester': instance.semester,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
