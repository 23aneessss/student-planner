// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OutboxEventImpl _$$OutboxEventImplFromJson(Map<String, dynamic> json) =>
    _$OutboxEventImpl(
      id: json['id'] as String,
      entityType: $enumDecode(_$OutboxEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String,
      operation: $enumDecode(_$SyncOperationEnumMap, json['operation']),
      payload: json['payload'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$OutboxEventImplToJson(_$OutboxEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': _$OutboxEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'operation': _$SyncOperationEnumMap[instance.operation]!,
      'payload': instance.payload,
      'createdAt': instance.createdAt.toIso8601String(),
      'attempts': instance.attempts,
    };

const _$OutboxEntityTypeEnumMap = {
  OutboxEntityType.task: 'task',
  OutboxEntityType.course: 'course',
  OutboxEntityType.session: 'session',
  OutboxEntityType.grade: 'grade',
};

const _$SyncOperationEnumMap = {
  SyncOperation.create: 'create',
  SyncOperation.update: 'update',
  SyncOperation.delete: 'delete',
};
