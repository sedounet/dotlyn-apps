import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

import 'providers/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting only (lightweight, essential)
  await initializeDateFormatting('fr_FR');

  // Launch app - providers will load lazily when needed
  runApp(const ProviderScope(child: MyApp()));
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
