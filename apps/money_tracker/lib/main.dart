import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/database_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use a single database instance via ProviderContainer to avoid multiple instances
  final container = ProviderContainer();
  final database = container.read(databaseProvider);

  debugPrint('=== MONEY TRACKER DB INIT START ===');

  // Ensure initial seed is present (no fake UI data seeded in 0.1b)
  await database.seedInitialData();

  // Initialize date formatting symbols (needed for DateFormat with locales)
  await initializeDateFormatting('fr_FR');

  // Log database state at startup for debugging
  final accounts = await database.select(database.accounts).get();
  final categories = await database.select(database.categories).get();
  final beneficiaries = await database.select(database.beneficiaries).get();
  final transactions = await database.select(database.transactions).get();

  debugPrint('[DB] Startup state:');
  debugPrint('  - Accounts: ${accounts.length} (${accounts.map((a) => a.name).toList()})');
  debugPrint('  - Categories: ${categories.length}');
  debugPrint(
    '  - Beneficiaries: ${beneficiaries.length} (${beneficiaries.map((b) => b.name).toList()})',
  );
  debugPrint('  - Transactions: ${transactions.length}');

  // Run integrity check
  await database.checkIntegrity();

  debugPrint('=== MONEY TRACKER DB INIT COMPLETE ===');

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
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
