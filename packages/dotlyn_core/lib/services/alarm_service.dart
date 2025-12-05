import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'notification_service.dart';

// Callback top-level obligatoire pour Android
@pragma('vm:entry-point')
Future<void> fireTimerAlarm() async {
  // Android : ce code s'exécute au réveil, même si l'app est tuée
  await NotificationService.showTimerComplete();
}

class AlarmService {
  static Future<void> scheduleTimer(Duration duration) async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.oneShotAt(
        DateTime.now().add(duration),
        0, // alarm ID
        fireTimerAlarm,
        exact: true,
        wakeup: true,
      );
    } else if (Platform.isIOS) {
      // iOS : notification programmée simple
      await NotificationService.scheduleTimerComplete(duration);
    }
  }

  static Future<void> cancelTimer() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(0);
    } else if (Platform.isIOS) {
      await NotificationService.cancelAll();
    }
  }
}
