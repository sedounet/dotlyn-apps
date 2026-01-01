enum SyncStatus {
  synced, // Local == GitHub
  modified, // Local modifié, pas encore sync
  conflict, // GitHub modifié aussi (différent SHA)
  error, // Erreur sync dernière tentative
}

class ProjectFile {
  final int? id;
  final String owner; // ex: "sedounet"
  final String repo; // ex: "dotlyn-apps"
  final String path; // ex: "_docs/apps/money_tracker/PROMPT_USER.md"
  final String nickname; // ex: "Money Tracker - User Prompt"
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectFile({
    this.id,
    required this.owner,
    required this.repo,
    required this.path,
    required this.nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get fullPath => '$owner/$repo/$path';

  ProjectFile copyWith({
    int? id,
    String? owner,
    String? repo,
    String? path,
    String? nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectFile(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      path: path ?? this.path,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FileContent {
  final int? id;
  final int projectFileId; // Foreign key to ProjectFile
  final String content;
  final String? githubSha; // SHA from GitHub API (for conflict detection)
  final SyncStatus syncStatus;
  final DateTime lastSyncAt;
  final DateTime localModifiedAt;

  FileContent({
    this.id,
    required this.projectFileId,
    required this.content,
    this.githubSha,
    this.syncStatus = SyncStatus.modified,
    DateTime? lastSyncAt,
    DateTime? localModifiedAt,
  })  : lastSyncAt = lastSyncAt ?? DateTime.now(),
        localModifiedAt = localModifiedAt ?? DateTime.now();

  FileContent copyWith({
    int? id,
    int? projectFileId,
    String? content,
    String? githubSha,
    SyncStatus? syncStatus,
    DateTime? lastSyncAt,
    DateTime? localModifiedAt,
  }) {
    return FileContent(
      id: id ?? this.id,
      projectFileId: projectFileId ?? this.projectFileId,
      content: content ?? this.content,
      githubSha: githubSha ?? this.githubSha,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
    );
  }
}
