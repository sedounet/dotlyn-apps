/// Result of a sync operation with GitHub
sealed class SyncResult {
  const SyncResult();
}

/// File successfully synced to GitHub
class SyncSuccess extends SyncResult {
  final String sha;
  final bool isCreated;

  const SyncSuccess({required this.sha, this.isCreated = false});
}

/// Cannot sync - offline mode
class SyncOffline extends SyncResult {
  const SyncOffline();
}

/// File has conflicts on GitHub
class SyncConflict extends SyncResult {
  final String remoteSha;
  final String? remoteContent;
  final ConflictChoice userChoice;

  const SyncConflict({
    required this.remoteSha,
    this.remoteContent,
    required this.userChoice,
  });
}

/// Sync error
class SyncError extends SyncResult {
  final String message;
  final int? statusCode;

  const SyncError(this.message, {this.statusCode});
}

/// User choice during conflict
enum ConflictChoice { cancel, fetchRemote, overwriteGitHub }

/// Extension for pattern matching on SyncResult
extension SyncResultExt on SyncResult {
  T when<T>({
    required T Function(SyncSuccess) success,
    required T Function(SyncOffline) offline,
    required T Function(SyncConflict) conflict,
    required T Function(SyncError) error,
  }) {
    return switch (this) {
      SyncSuccess s => success(s),
      SyncOffline o => offline(o),
      SyncConflict c => conflict(c),
      SyncError e => error(e),
    };
  }
}
