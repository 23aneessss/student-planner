// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      scholarYear: json['scholarYear'] as String,
      gradeScale: json['gradeScale'] as String? ?? '20',
      avatarUrl: json['avatarUrl'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      syncEnabled: json['syncEnabled'] as bool? ?? true,
      isLocalOnly: json['isLocalOnly'] as bool? ?? false,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'scholarYear': instance.scholarYear,
      'gradeScale': instance.gradeScale,
      'avatarUrl': instance.avatarUrl,
      'notificationsEnabled': instance.notificationsEnabled,
      'syncEnabled': instance.syncEnabled,
      'isLocalOnly': instance.isLocalOnly,
      'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
    };
