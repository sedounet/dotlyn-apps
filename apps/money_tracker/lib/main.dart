import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

import 'providers/database_provider.dart';
import 'providers/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use a single database instance via ProviderContainer to avoid multiple instances
  final container = ProviderContainer();
  final database = container.read(databaseProvider);

  // Ensure initial seed is present (categories only, no UI data)
  await database.seedInitialData();

  // Initialize date formatting symbols (needed for DateFormat with locales)
  await initializeDateFormatting('fr_FR');

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Money Tracker',
      theme: DotlynTheme.lightTheme,
      darkTheme: DotlynTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
