import 'package:flutter/material.dart';
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/models/sync_result.dart';
import 'package:github_notes/models/remote_file.dart';
import 'package:github_notes/services/github_service.dart';

/// Service handling GitHub file synchronization logic
class SyncService {
  final GitHubService _githubService;
  // ignore: unused_field
  final AppDatabase _database;

  SyncService({
    required GitHubService githubService,
    required AppDatabase database,
  })  : _githubService = githubService,
        _database = database;

  /// Sync file to GitHub with conflict detection
  Future<SyncResult> syncFile({
    required BuildContext context,
    required ProjectFile projectFile,
    required String content,
    required String? localSha,
  }) async {
    // Step 1: Try to fetch remote file
    RemoteFile? remoteFile;
    bool fileExistsOnGitHub = false;

    try {
      remoteFile = await _fetchRemote(projectFile);
      fileExistsOnGitHub = true;
    } on GitHubApiException catch (e) {
      if (e.statusCode == 404) {
        // File doesn't exist - will create
        fileExistsOnGitHub = false;
      } else {
        return SyncError('GitHub error: ${e.message}', statusCode: e.statusCode);
      }
    }

    // Step 2: Check for conflicts if file exists
    if (fileExistsOnGitHub && remoteFile != null) {
      if (localSha != null && localSha != remoteFile.sha) {
        if (!context.mounted) return const SyncError('Context unmounted');

        final choice = await _showConflictDialog(
          context,
          remoteSha: remoteFile.sha,
          remoteContent: remoteFile.content,
        );

        if (choice == ConflictChoice.cancel) {
          return const SyncError('Sync cancelled');
        } else if (choice == ConflictChoice.fetchRemote) {
          return SyncConflict(
            remoteSha: remoteFile.sha,
            remoteContent: remoteFile.content,
            userChoice: ConflictChoice.fetchRemote,
          );
        }
        // else: overwriteGitHub - continue with push
      }
    }

    // Step 3: Push to GitHub
    try {
      final shaToUse = fileExistsOnGitHub ? (localSha ?? remoteFile?.sha) : null;

      final newSha = await _githubService.updateFile(
        owner: projectFile.owner,
        repo: projectFile.repo,
        path: projectFile.path,
        content: content,
        sha: shaToUse,
        message: shaToUse == null
            ? 'Create ${projectFile.nickname} from GitHub Notes'
            : 'Update ${projectFile.nickname} from GitHub Notes',
      );

      return SyncSuccess(sha: newSha, isCreated: !fileExistsOnGitHub);
    } on GitHubApiException catch (e) {
      if (e.statusCode == 401) {
        return const SyncError('Unauthorized: check your GitHub token');
      } else if (e.statusCode == 409) {
        return const SyncError('Conflict: File modified on GitHub. Try again.');
      } else {
        return SyncError('GitHub error: ${e.message}', statusCode: e.statusCode);
      }
    } catch (e) {
      return SyncError('Unexpected error: $e');
    }
  }

  /// Fetch remote file from GitHub
  Future<RemoteFile> _fetchRemote(ProjectFile projectFile) async {
    final file = await _githubService.fetchFile(
      owner: projectFile.owner,
      repo: projectFile.repo,
      path: projectFile.path,
    );
    return RemoteFile(
      sha: file.sha,
      content: file.content,
      path: projectFile.path,
    );
  }

  /// Show conflict dialog and return user choice
  Future<ConflictChoice> _showConflictDialog(
    BuildContext context, {
    required String remoteSha,
    required String remoteContent,
  }) async {
    final choice = await showDialog<ConflictChoice?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conflict detected'),
        content: const Text('The file changed on GitHub since your last sync.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, ConflictChoice.cancel),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ConflictChoice.fetchRemote),
            child: const Text('Fetch remote'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ConflictChoice.overwriteGitHub),
            child: const Text('Overwrite GitHub'),
          ),
        ],
      ),
    );

    return choice ?? ConflictChoice.cancel;
  }
}
