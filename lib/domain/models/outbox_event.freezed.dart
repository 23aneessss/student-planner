// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outbox_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OutboxEvent _$OutboxEventFromJson(Map<String, dynamic> json) {
  return _OutboxEvent.fromJson(json);
}

/// @nodoc
mixin _$OutboxEvent {
  String get id => throw _privateConstructorUsedError;
  OutboxEntityType get entityType => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  SyncOperation get operation => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OutboxEventCopyWith<OutboxEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutboxEventCopyWith<$Res> {
  factory $OutboxEventCopyWith(
    OutboxEvent value,
    $Res Function(OutboxEvent) then,
  ) = _$OutboxEventCopyWithImpl<$Res, OutboxEvent>;
  @useResult
  $Res call({
    String id,
    OutboxEntityType entityType,
    String entityId,
    SyncOperation operation,
    Map<String, dynamic> payload,
    DateTime createdAt,
    int attempts,
  });
}

/// @nodoc
class _$OutboxEventCopyWithImpl<$Res, $Val extends OutboxEvent>
    implements $OutboxEventCopyWith<$Res> {
  _$OutboxEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? createdAt = null,
    Object? attempts = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as OutboxEntityType,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as SyncOperation,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            attempts: null == attempts
                ? _value.attempts
                : attempts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OutboxEventImplCopyWith<$Res>
    implements $OutboxEventCopyWith<$Res> {
  factory _$$OutboxEventImplCopyWith(
    _$OutboxEventImpl value,
    $Res Function(_$OutboxEventImpl) then,
  ) = __$$OutboxEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    OutboxEntityType entityType,
    String entityId,
    SyncOperation operation,
    Map<String, dynamic> payload,
    DateTime createdAt,
    int attempts,
  });
}

/// @nodoc
class __$$OutboxEventImplCopyWithImpl<$Res>
    extends _$OutboxEventCopyWithImpl<$Res, _$OutboxEventImpl>
    implements _$$OutboxEventImplCopyWith<$Res> {
  __$$OutboxEventImplCopyWithImpl(
    _$OutboxEventImpl _value,
    $Res Function(_$OutboxEventImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? createdAt = null,
    Object? attempts = null,
  }) {
    return _then(
      _$OutboxEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as OutboxEntityType,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as SyncOperation,
        payload: null == payload
            ? _value._payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        attempts: null == attempts
            ? _value.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OutboxEventImpl implements _OutboxEvent {
  const _$OutboxEventImpl({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required final Map<String, dynamic> payload,
    required this.createdAt,
    this.attempts = 0,
  }) : _payload = payload;

  factory _$OutboxEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$OutboxEventImplFromJson(json);

  @override
  final String id;
  @override
  final OutboxEntityType entityType;
  @override
  final String entityId;
  @override
  final SyncOperation operation;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int attempts;

  @override
  String toString() {
    return 'OutboxEvent(id: $id, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, createdAt: $createdAt, attempts: $attempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutboxEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    entityId,
    operation,
    const DeepCollectionEquality().hash(_payload),
    createdAt,
    attempts,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutboxEventImplCopyWith<_$OutboxEventImpl> get copyWith =>
      __$$OutboxEventImplCopyWithImpl<_$OutboxEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OutboxEventImplToJson(this);
  }
}

abstract class _OutboxEvent implements OutboxEvent {
  const factory _OutboxEvent({
    required final String id,
    required final OutboxEntityType entityType,
    required final String entityId,
    required final SyncOperation operation,
    required final Map<String, dynamic> payload,
    required final DateTime createdAt,
    final int attempts,
  }) = _$OutboxEventImpl;

  factory _OutboxEvent.fromJson(Map<String, dynamic> json) =
      _$OutboxEventImpl.fromJson;

  @override
  String get id;
  @override
  OutboxEntityType get entityType;
  @override
  String get entityId;
  @override
  SyncOperation get operation;
  @override
  Map<String, dynamic> get payload;
  @override
  DateTime get createdAt;
  @override
  int get attempts;
  @override
  @JsonKey(ignore: true)
  _$$OutboxEventImplCopyWith<_$OutboxEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
