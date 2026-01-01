import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/data/database/app_database.dart';

/// Provider for the database singleton
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Stream provider for all project files
final projectFilesProvider = StreamProvider<List<ProjectFile>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllProjectFiles();
});

/// Stream provider for app settings (GitHub token)
final settingsProvider = StreamProvider<AppSetting?>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchSettings();
});

/// Stream provider for file content by project file ID
final fileContentProvider = StreamProvider.family<FileContent?, int?>((ref, projectFileId) {
  final database = ref.watch(databaseProvider);
  if (projectFileId == null) {
    // No project id provided -> emit null
    return const Stream<FileContent?>.empty();
  }
  return database.watchFileContent(projectFileId);
});
