// lib/domain/models/session.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class PomodoroSession with _$PomodoroSession {
  const factory PomodoroSession({
    required String id,
    String? taskId,
    String? courseId,
    required int durationSec,
    required DateTime startedAt,
    DateTime? endedAt,
    String? notes,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _PomodoroSession;

  factory PomodoroSession.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSessionFromJson(json);
}
