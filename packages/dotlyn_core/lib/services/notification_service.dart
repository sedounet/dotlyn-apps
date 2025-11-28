import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings, onDidReceiveNotificationResponse: (response) {
      // TODO: router vers l'écran Timer si besoin
      print('Notification clicked: ${response.payload}');
    });
  }

  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'timer_test',
      'Timer Test',
      channelDescription: 'Test notification',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(999, '🔔 Test', 'Notifications OK!', details);
  }

  static Future<void> showTimerComplete() async {
    const androidDetails = AndroidNotificationDetails(
      'timer_complete',
      'Timer',
      channelDescription: 'Notifications when timer completes',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'timer',
      category: AndroidNotificationCategory.alarm,
    );
    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(1, 'Timer terminé !', 'Votre timer est terminé', details,
        payload: 'timer_complete');
  }

  static Future<void> showTimerRunning(Duration remaining) async {
    final mins = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final title = 'Timer en cours';
    final body = 'Temps restant : ${remaining.inHours.toString().padLeft(2, '0')}:$mins:$secs';

    final androidDetails = AndroidNotificationDetails(
      'timer_running',
      'Timer running',
      channelDescription: 'Ongoing timer notification',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      showWhen: false,
    );
    final iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(2, title, body, details, payload: 'timer_running');
  }

  static Future<void> scheduleTimerComplete(Duration duration) async {
    // Using zonedSchedule with timezone package for precise scheduling
    final scheduled = DateTime.now().add(duration);

    const androidDetails = AndroidNotificationDetails(
      'timer_complete',
      'Timer',
      channelDescription: 'Notifications when timer completes',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.zonedSchedule(
      1,
      'Timer terminé !',
      'Votre timer est terminé',
      tz.TZDateTime.from(scheduled, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
