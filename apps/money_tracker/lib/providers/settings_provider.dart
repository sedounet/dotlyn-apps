import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import 'database_provider.dart';

// Watch all settings
final appSettingsProvider = StreamProvider.autoDispose<Map<String, String?>>((ref) {
  final database = ref.watch(databaseProvider);
  final stream = database.select(database.appSettings).watch();
  return stream.map((settings) {
    return Map.fromEntries(settings.map((s) => MapEntry(s.key, s.value)));
  });
});

/// Get a single setting value by key
final appSettingProvider = StreamProvider.autoDispose.family<String?, String>((ref, key) {
  final database = ref.watch(databaseProvider);
  final stream = (database.select(
    database.appSettings,
  )..where((s) => s.key.equals(key))).watchSingleOrNull();
  return stream.map((setting) => setting?.value);
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return AppSettingsRepository(database);
});

class AppSettingsRepository {
  AppSettingsRepository(this._database);

  final AppDatabase _database;

  // Setting keys
  static const String darkModeKey = 'dark_mode';
  static const String locale = 'locale';
  static const String hideBalance = 'hide_balance';
  static const String defaultAccount = 'default_account';

  /// Get a setting value by key
  Future<String?> getSetting(String key) {
    return (_database.select(
      _database.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull().then((s) => s?.value);
  }

  /// Set a setting value (creates or updates)
  Future<void> setSetting(String key, String? value) async {
    final existing = await (_database.select(
      _database.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();

    if (existing != null && value != null) {
      // Update existing
      await (_database.update(
        _database.appSettings,
      )..where((s) => s.key.equals(key))).write(AppSettingsCompanion(value: Value(value)));
    } else if (value != null) {
      // Insert new
      await _database
          .into(_database.appSettings)
          .insert(AppSettingsCompanion.insert(key: key, value: value));
    } else if (existing != null) {
      // Delete if value is null and setting exists
      await (_database.delete(_database.appSettings)..where((s) => s.key.equals(key))).go();
    }
  }

  /// Delete a setting
  Future<void> deleteSetting(String key) {
    return (_database.delete(_database.appSettings)..where((s) => s.key.equals(key))).go();
  }

  /// Clear all settings
  Future<void> clearAll() {
    return _database.delete(_database.appSettings).go();
  }
}
