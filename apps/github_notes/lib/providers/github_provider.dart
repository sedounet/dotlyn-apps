import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/services/github_service.dart';
import 'package:github_notes/providers/database_provider.dart';

/// Provider for GitHub API service (depends on token from settings)
final githubServiceProvider = Provider<GitHubService>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  final token = settings?.githubToken;
  return GitHubService(token: token);
});
