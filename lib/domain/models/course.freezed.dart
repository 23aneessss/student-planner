// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseScheduleEntry _$CourseScheduleEntryFromJson(Map<String, dynamic> json) {
  return _CourseScheduleEntry.fromJson(json);
}

/// @nodoc
mixin _$CourseScheduleEntry {
  int get day => throw _privateConstructorUsedError;
  String get start => throw _privateConstructorUsedError;
  String get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseScheduleEntryCopyWith<CourseScheduleEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseScheduleEntryCopyWith<$Res> {
  factory $CourseScheduleEntryCopyWith(
    CourseScheduleEntry value,
    $Res Function(CourseScheduleEntry) then,
  ) = _$CourseScheduleEntryCopyWithImpl<$Res, CourseScheduleEntry>;
  @useResult
  $Res call({int day, String start, String end});
}

/// @nodoc
class _$CourseScheduleEntryCopyWithImpl<$Res, $Val extends CourseScheduleEntry>
    implements $CourseScheduleEntryCopyWith<$Res> {
  _$CourseScheduleEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? start = null, Object? end = null}) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            start: null == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as String,
            end: null == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseScheduleEntryImplCopyWith<$Res>
    implements $CourseScheduleEntryCopyWith<$Res> {
  factory _$$CourseScheduleEntryImplCopyWith(
    _$CourseScheduleEntryImpl value,
    $Res Function(_$CourseScheduleEntryImpl) then,
  ) = __$$CourseScheduleEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, String start, String end});
}

/// @nodoc
class __$$CourseScheduleEntryImplCopyWithImpl<$Res>
    extends _$CourseScheduleEntryCopyWithImpl<$Res, _$CourseScheduleEntryImpl>
    implements _$$CourseScheduleEntryImplCopyWith<$Res> {
  __$$CourseScheduleEntryImplCopyWithImpl(
    _$CourseScheduleEntryImpl _value,
    $Res Function(_$CourseScheduleEntryImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? start = null, Object? end = null}) {
    return _then(
      _$CourseScheduleEntryImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        start: null == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String,
        end: null == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseScheduleEntryImpl implements _CourseScheduleEntry {
  const _$CourseScheduleEntryImpl({
    required this.day,
    required this.start,
    required this.end,
  });

  factory _$CourseScheduleEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseScheduleEntryImplFromJson(json);

  @override
  final int day;
  @override
  final String start;
  @override
  final String end;

  @override
  String toString() {
    return 'CourseScheduleEntry(day: $day, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseScheduleEntryImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, day, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseScheduleEntryImplCopyWith<_$CourseScheduleEntryImpl> get copyWith =>
      __$$CourseScheduleEntryImplCopyWithImpl<_$CourseScheduleEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseScheduleEntryImplToJson(this);
  }
}

abstract class _CourseScheduleEntry implements CourseScheduleEntry {
  const factory _CourseScheduleEntry({
    required final int day,
    required final String start,
    required final String end,
  }) = _$CourseScheduleEntryImpl;

  factory _CourseScheduleEntry.fromJson(Map<String, dynamic> json) =
      _$CourseScheduleEntryImpl.fromJson;

  @override
  int get day;
  @override
  String get start;
  @override
  String get end;
  @override
  @JsonKey(ignore: true)
  _$$CourseScheduleEntryImplCopyWith<_$CourseScheduleEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Course _$CourseFromJson(Map<String, dynamic> json) {
  return _Course.fromJson(json);
}

/// @nodoc
mixin _$Course {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  String? get instructor => throw _privateConstructorUsedError;
  List<CourseScheduleEntry> get schedule => throw _privateConstructorUsedError;
  String get semester => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseCopyWith<Course> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res, Course>;
  @useResult
  $Res call({
    String id,
    String name,
    String colorHex,
    String? instructor,
    List<CourseScheduleEntry> schedule,
    String semester,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$CourseCopyWithImpl<$Res, $Val extends Course>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? instructor = freezed,
    Object? schedule = null,
    Object? semester = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            colorHex: null == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            instructor: freezed == instructor
                ? _value.instructor
                : instructor // ignore: cast_nullable_to_non_nullable
                      as String?,
            schedule: null == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as List<CourseScheduleEntry>,
            semester: null == semester
                ? _value.semester
                : semester // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$CourseImplCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$$CourseImplCopyWith(
    _$CourseImpl value,
    $Res Function(_$CourseImpl) then,
  ) = __$$CourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String colorHex,
    String? instructor,
    List<CourseScheduleEntry> schedule,
    String semester,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$CourseImplCopyWithImpl<$Res>
    extends _$CourseCopyWithImpl<$Res, _$CourseImpl>
    implements _$$CourseImplCopyWith<$Res> {
  __$$CourseImplCopyWithImpl(
    _$CourseImpl _value,
    $Res Function(_$CourseImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? instructor = freezed,
    Object? schedule = null,
    Object? semester = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$CourseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        colorHex: null == colorHex
            ? _value.colorHex
            : colorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        instructor: freezed == instructor
            ? _value.instructor
            : instructor // ignore: cast_nullable_to_non_nullable
                  as String?,
        schedule: null == schedule
            ? _value._schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as List<CourseScheduleEntry>,
        semester: null == semester
            ? _value.semester
            : semester // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$CourseImpl implements _Course {
  const _$CourseImpl({
    required this.id,
    required this.name,
    required this.colorHex,
    this.instructor,
    final List<CourseScheduleEntry> schedule = const <CourseScheduleEntry>[],
    required this.semester,
    required this.updatedAt,
    this.deletedAt,
  }) : _schedule = schedule;

  factory _$CourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String colorHex;
  @override
  final String? instructor;
  final List<CourseScheduleEntry> _schedule;
  @override
  @JsonKey()
  List<CourseScheduleEntry> get schedule {
    if (_schedule is EqualUnmodifiableListView) return _schedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedule);
  }

  @override
  final String semester;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Course(id: $id, name: $name, colorHex: $colorHex, instructor: $instructor, schedule: $schedule, semester: $semester, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.instructor, instructor) ||
                other.instructor == instructor) &&
            const DeepCollectionEquality().equals(other._schedule, _schedule) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
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
    name,
    colorHex,
    instructor,
    const DeepCollectionEquality().hash(_schedule),
    semester,
    updatedAt,
    deletedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      __$$CourseImplCopyWithImpl<_$CourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseImplToJson(this);
  }
}

abstract class _Course implements Course {
  const factory _Course({
    required final String id,
    required final String name,
    required final String colorHex,
    final String? instructor,
    final List<CourseScheduleEntry> schedule,
    required final String semester,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$CourseImpl;

  factory _Course.fromJson(Map<String, dynamic> json) = _$CourseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get colorHex;
  @override
  String? get instructor;
  @override
  List<CourseScheduleEntry> get schedule;
  @override
  String get semester;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
