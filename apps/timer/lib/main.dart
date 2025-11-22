import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dotlyn_core/services/notification_service.dart';
import 'screens/timer_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/timer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await NotificationService.initialize();
  // Test notification au démarrage
  await NotificationService.showTestNotification();
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerProvider(),
      child: MaterialApp(
        title: 'Dotlyn Timer',
        theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const TimerScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
