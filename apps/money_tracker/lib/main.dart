import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and seed data
  final database = AppDatabase();
  await database.seedInitialData();
  await database.seedFakeData(); // TODO: Remove in phase 0.1b

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
