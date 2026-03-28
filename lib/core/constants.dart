// lib/core/constants.dart
import 'package:flutter/material.dart';

class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.planora.app',
  );
  static const bool remoteServicesEnabled = bool.fromEnvironment(
    'REMOTE_SERVICES_ENABLED',
    defaultValue: false,
  );
  static const bool googleSignInEnabled = bool.fromEnvironment(
    'GOOGLE_SIGN_IN_ENABLED',
    defaultValue: false,
  );
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

const String kOnboardingDoneKey = 'onboarding_done';
const String kLastSyncKey = 'last_sync_ms';
const String kProfileKey = 'user_profile_json';
const String kAccessTokenKey = 'access_token';
const String kRefreshTokenKey = 'refresh_token';

const List<String> kScholarYearOptions = <String>[
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
  '5th Year',
  'Master 1',
  'Master 2',
  'PhD',
];

const List<String> kTemplateAssets = <String>[
  'assets/templates/exam_week.json',
  'assets/templates/project_sprint.json',
  'assets/templates/weekly_review.json',
];

const List<String> kSyncEntities = <String>[
  'task',
  'course',
  'session',
  'grade',
];

const Map<String, String> kWeekdayNames = <String, String>{
  '1': 'Mon',
  '2': 'Tue',
  '3': 'Wed',
  '4': 'Thu',
  '5': 'Fri',
  '6': 'Sat',
  '7': 'Sun',
};

const EdgeInsets kScreenPadding = EdgeInsets.symmetric(horizontal: 20);
