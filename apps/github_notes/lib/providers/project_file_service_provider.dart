import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/services/project_file_service.dart';

/// Provider for ProjectFileService
final projectFileServiceProvider = Provider<ProjectFileService>((ref) {
  final database = ref.watch(databaseProvider);
  return ProjectFileService(database: database);
});
