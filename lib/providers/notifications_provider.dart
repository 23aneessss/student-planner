// lib/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlanoraNotificationsService {
  PlanoraNotificationsService._();

  static final PlanoraNotificationsService instance =
      PlanoraNotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'planora_tasks',
            'Task Reminders',
            importance: Importance.max,
          ),
        );

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
    );
  }

  Future<void> scheduleTaskReminder({
    required int notificationId,
    required DateTime remindAt,
    required String title,
    required String body,
    required String payload,
  }) {
    return _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(remindAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'planora_tasks',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancel(int notificationId) => _plugin.cancel(notificationId);

  Future<void> showPomodoroComplete(String sessionId) {
    return _plugin.show(
      sessionId.hashCode,
      'Time\'s up!',
      'Your focus session just finished.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'planora_tasks',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: sessionId,
    );
  }
}

final notificationsProvider = Provider<PlanoraNotificationsService>(
  (Ref ref) => PlanoraNotificationsService.instance,
);
