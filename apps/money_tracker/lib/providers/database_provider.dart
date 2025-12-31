import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// Provider qui seed les données en arrière-plan (appelé explicitement si besoin)
final databaseSeederProvider = FutureProvider<void>((ref) async {
  final database = ref.watch(databaseProvider);
  await database.seedInitialData();
});
