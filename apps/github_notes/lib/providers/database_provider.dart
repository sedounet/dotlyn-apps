import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/data/database/app_database.dart';

// Lazy database instance - created only on first access
AppDatabase? _databaseInstance;

AppDatabase _getDatabaseInstance() {
  _databaseInstance ??= AppDatabase();
  return _databaseInstance;
}

/// Provider for the database singleton with lazy initialization
/// Only creates the database when first accessed, not at app startup
final databaseProvider = Provider<AppDatabase>((ref) {
  return _getDatabaseInstance();
});

/// Stream provider for all project files
/// Only watched when FilesListScreen is built
final projectFilesProvider = StreamProvider<List<ProjectFile>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllProjectFiles();
});

/// Future provider for app settings - cached and loaded lazily
/// Using FutureProvider instead of StreamProvider for startup optimization
final settingsProvider = FutureProvider<AppSetting?>((ref) async {
  final database = ref.watch(databaseProvider);
  return database.getSettings();
});

/// Stream provider for file content by project file ID
/// Lazy-loaded only when user opens a file
final fileContentProvider = StreamProvider.family<FileContent?, int?>((ref, projectFileId) {
  final database = ref.watch(databaseProvider);
  if (projectFileId == null) {
    // No project id provided -> emit null
    return const Stream<FileContent?>.empty();
  }
  return database.watchFileContent(projectFileId);
});
