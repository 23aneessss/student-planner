// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PomodoroSession _$PomodoroSessionFromJson(Map<String, dynamic> json) {
  return _PomodoroSession.fromJson(json);
}

/// @nodoc
mixin _$PomodoroSession {
  String get id => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  String? get courseId => throw _privateConstructorUsedError;
  int get durationSec => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PomodoroSessionCopyWith<PomodoroSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroSessionCopyWith<$Res> {
  factory $PomodoroSessionCopyWith(
    PomodoroSession value,
    $Res Function(PomodoroSession) then,
  ) = _$PomodoroSessionCopyWithImpl<$Res, PomodoroSession>;
  @useResult
  $Res call({
    String id,
    String? taskId,
    String? courseId,
    int durationSec,
    DateTime startedAt,
    DateTime? endedAt,
    String? notes,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$PomodoroSessionCopyWithImpl<$Res, $Val extends PomodoroSession>
    implements $PomodoroSessionCopyWith<$Res> {
  _$PomodoroSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? courseId = freezed,
    Object? durationSec = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? notes = freezed,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            taskId: freezed == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String?,
            courseId: freezed == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationSec: null == durationSec
                ? _value.durationSec
                : durationSec // ignore: cast_nullable_to_non_nullable
                      as int,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PomodoroSessionImplCopyWith<$Res>
    implements $PomodoroSessionCopyWith<$Res> {
  factory _$$PomodoroSessionImplCopyWith(
    _$PomodoroSessionImpl value,
    $Res Function(_$PomodoroSessionImpl) then,
  ) = __$$PomodoroSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? taskId,
    String? courseId,
    int durationSec,
    DateTime startedAt,
    DateTime? endedAt,
    String? notes,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$PomodoroSessionImplCopyWithImpl<$Res>
    extends _$PomodoroSessionCopyWithImpl<$Res, _$PomodoroSessionImpl>
    implements _$$PomodoroSessionImplCopyWith<$Res> {
  __$$PomodoroSessionImplCopyWithImpl(
    _$PomodoroSessionImpl _value,
    $Res Function(_$PomodoroSessionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? courseId = freezed,
    Object? durationSec = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? notes = freezed,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$PomodoroSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: freezed == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String?,
        courseId: freezed == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationSec: null == durationSec
            ? _value.durationSec
            : durationSec // ignore: cast_nullable_to_non_nullable
                  as int,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PomodoroSessionImpl implements _PomodoroSession {
  const _$PomodoroSessionImpl({
    required this.id,
    this.taskId,
    this.courseId,
    required this.durationSec,
    required this.startedAt,
    this.endedAt,
    this.notes,
    required this.updatedAt,
    this.deletedAt,
  });

  factory _$PomodoroSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PomodoroSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String? taskId;
  @override
  final String? courseId;
  @override
  final int durationSec;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  final String? notes;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'PomodoroSession(id: $id, taskId: $taskId, courseId: $courseId, durationSec: $durationSec, startedAt: $startedAt, endedAt: $endedAt, notes: $notes, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taskId,
    courseId,
    durationSec,
    startedAt,
    endedAt,
    notes,
    updatedAt,
    deletedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroSessionImplCopyWith<_$PomodoroSessionImpl> get copyWith =>
      __$$PomodoroSessionImplCopyWithImpl<_$PomodoroSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PomodoroSessionImplToJson(this);
  }
}

abstract class _PomodoroSession implements PomodoroSession {
  const factory _PomodoroSession({
    required final String id,
    final String? taskId,
    final String? courseId,
    required final int durationSec,
    required final DateTime startedAt,
    final DateTime? endedAt,
    final String? notes,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$PomodoroSessionImpl;

  factory _PomodoroSession.fromJson(Map<String, dynamic> json) =
      _$PomodoroSessionImpl.fromJson;

  @override
  String get id;
  @override
  String? get taskId;
  @override
  String? get courseId;
  @override
  int get durationSec;
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;
  @override
  String? get notes;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$PomodoroSessionImplCopyWith<_$PomodoroSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
