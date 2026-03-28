// lib/data/remote/sync_remote.dart
import '../../domain/models/outbox_event.dart';
import 'api_client.dart';

class SyncPullItem {
  const SyncPullItem({
    required this.entityType,
    required this.id,
    required this.payload,
    required this.updatedAt,
    this.deletedAt,
  });

  final OutboxEntityType entityType;
  final String id;
  final Map<String, dynamic> payload;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory SyncPullItem.fromJson(Map<String, dynamic> json) {
    return SyncPullItem(
      entityType: OutboxEntityType.values.firstWhere(
        (OutboxEntityType type) => type.name == json['entityType'],
      ),
      id: json['id'] as String,
      payload: Map<String, dynamic>.from(
        (json['payload'] as Map<Object?, Object?>?) ?? <Object?, Object?>{},
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['deletedAt'] as int),
    );
  }
}

class SyncRemote {
  const SyncRemote(this._client);

  final ApiClient _client;

  Future<void> pushEvent(OutboxEvent event) async {
    await _client.dio.post<void>(
      '/api/v1/sync/push',
      data: <String, dynamic>{
        'entityType': event.entityType.name,
        'entityId': event.entityId,
        'operation': event.operation.name,
        'payload': event.payload,
      },
    );
  }

  Future<List<SyncPullItem>> pullSince(int sinceMs) async {
    final Map<String, dynamic> data =
        (await _client.dio.get<Map<String, dynamic>>(
          '/api/v1/sync/pull',
          queryParameters: <String, dynamic>{
            'since': sinceMs,
            'entities': 'task,course,session,grade',
          },
        )).data ??
        <String, dynamic>{};

    final List<dynamic> items =
        (data['items'] as List<dynamic>?) ?? <dynamic>[];
    return items
        .map(
          (dynamic item) => SyncPullItem.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
