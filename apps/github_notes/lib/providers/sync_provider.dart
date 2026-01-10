import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
import 'package:github_notes/services/sync_service.dart';

/// Provider for SyncService
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final githubService = ref.watch(githubServiceProvider);
  return SyncService(
    githubService: githubService,
    database: database,
  );
});
