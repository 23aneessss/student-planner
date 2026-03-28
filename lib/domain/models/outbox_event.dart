// lib/domain/models/outbox_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'outbox_event.freezed.dart';
part 'outbox_event.g.dart';

enum OutboxEntityType { task, course, session, grade }

enum SyncOperation { create, update, delete }

@freezed
class OutboxEvent with _$OutboxEvent {
  const factory OutboxEvent({
    required String id,
    required OutboxEntityType entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
    required DateTime createdAt,
    @Default(0) int attempts,
  }) = _OutboxEvent;

  factory OutboxEvent.fromJson(Map<String, dynamic> json) =>
      _$OutboxEventFromJson(json);
}
