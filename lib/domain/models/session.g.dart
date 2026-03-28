// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PomodoroSessionImpl _$$PomodoroSessionImplFromJson(
  Map<String, dynamic> json,
) => _$PomodoroSessionImpl(
  id: json['id'] as String,
  taskId: json['taskId'] as String?,
  courseId: json['courseId'] as String?,
  durationSec: (json['durationSec'] as num).toInt(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  notes: json['notes'] as String?,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$PomodoroSessionImplToJson(
  _$PomodoroSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'courseId': instance.courseId,
  'durationSec': instance.durationSec,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'notes': instance.notes,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
