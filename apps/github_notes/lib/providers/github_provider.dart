import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_notes/services/github_service.dart';
import 'package:github_notes/providers/token_provider.dart';

/// Async provider that reads the GitHub token from secure storage
final githubTokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.read(key: 'github_token');
  return token;
});

/// Provider for GitHub API service (depends on token from secure storage)
final githubServiceProvider = Provider<GitHubService>((ref) {
  final token = ref.watch(githubTokenProvider).valueOrNull;
  return GitHubService(token: token);
});
