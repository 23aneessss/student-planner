// lib/domain/models/user_profile.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String fullName,
    required String scholarYear,
    @Default('20') String gradeScale,
    String? avatarUrl,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool syncEnabled,
    @Default(false) bool isLocalOnly,
    DateTime? lastSyncAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
