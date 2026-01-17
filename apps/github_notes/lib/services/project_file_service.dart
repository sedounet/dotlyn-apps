import 'package:drift/drift.dart' as drift;
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/data/database/app_database.dart' as db;

/// Service for managing project files (CRUD operations)
class ProjectFileService {
  final AppDatabase _database;

  ProjectFileService({required AppDatabase database}) : _database = database;

  /// Get all project files
  Future<List<db.ProjectFile>> getAllFiles() async {
    return (_database.select(_database.projectFiles)).get();
  }

  /// Get a single project file by ID
  Future<db.ProjectFile?> getFileById(int id) async {
    final query = _database.select(_database.projectFiles)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// Add a new project file
  Future<int> addFile({
    required String owner,
    required String repo,
    required String path,
    required String nickname,
  }) async {
    final entry = db.ProjectFilesCompanion(
      owner: drift.Value(owner),
      repo: drift.Value(repo),
      path: drift.Value(path),
      nickname: drift.Value(nickname),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    );
    return _database.into(_database.projectFiles).insert(entry);
  }

  /// Update an existing project file
  Future<bool> updateFile({
    required int id,
    required String owner,
    required String repo,
    required String path,
    required String nickname,
  }) async {
    // Lire la valeur actuelle de createdAt
    final existing = await getFileById(id);
    if (existing == null) {
      throw Exception('File not found for update: $id');
    }
    final entry = db.ProjectFilesCompanion(
      id: drift.Value(id),
      owner: drift.Value(owner),
      repo: drift.Value(repo),
      path: drift.Value(path),
      nickname: drift.Value(nickname),
      createdAt: drift.Value(existing.createdAt),
      updatedAt: drift.Value(DateTime.now()),
    );
    return _database.update(_database.projectFiles).replace(entry);
  }

  /// Delete a project file and its content
  Future<void> deleteFile(int id) async {
    // Delete content first (foreign key constraint)
    await (_database.delete(_database.fileContents)..where((t) => t.projectFileId.equals(id))).go();
    // Then delete the file
    await (_database.delete(_database.projectFiles)..where((t) => t.id.equals(id))).go();
  }

  /// Duplicate a project file with a new nickname
  Future<int> duplicateFile(int fileId, String newNickname) async {
    final original = await getFileById(fileId);
    if (original == null) throw Exception('File not found: $fileId');

    return addFile(
      owner: original.owner,
      repo: original.repo,
      path: original.path,
      nickname: newNickname,
    );
  }

  /// Check if a file with same owner/repo/path already exists
  Future<bool> fileExists({
    required String owner,
    required String repo,
    required String path,
    int? excludeId, // For edits: ignore this file ID
  }) async {
    final query = _database.select(_database.projectFiles)
      ..where((t) => t.owner.equals(owner) & t.repo.equals(repo) & t.path.equals(path));
    final results = await query.get();

    if (excludeId == null) {
      return results.isNotEmpty;
    }

    // Exclude the given ID (for editing)
    return results.any((f) => f.id != excludeId);
  }

  /// Get file content by project file ID
  Future<db.FileContent?> getFileContent(int projectFileId) async {
    final query = _database.select(_database.fileContents)
      ..where((t) => t.projectFileId.equals(projectFileId))
      ..orderBy(
          [(t) => drift.OrderingTerm(expression: t.localModifiedAt, mode: drift.OrderingMode.desc)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Save file content
  Future<int> saveFileContent({
    required int projectFileId,
    required String content,
    String? githubSha,
    bool isImportedFromGitHub = false,
  }) async {
    final now = DateTime.now();

    // If importing from GitHub with a SHA, status is "synced"
    // Otherwise, default to "pending"
    final status = (isImportedFromGitHub && githubSha != null) ? 'synced' : 'pending';

    final entry = db.FileContentsCompanion(
      projectFileId: drift.Value(projectFileId),
      content: drift.Value(content),
      githubSha: githubSha != null ? drift.Value(githubSha) : const drift.Value.absent(),
      syncStatus: drift.Value(status),
      lastSyncAt: drift.Value(now),
      localModifiedAt: drift.Value(now),
    );
    return _database.into(_database.fileContents).insert(entry);
  }

  /// Update file GitHub SHA (after successful sync)
  Future<void> updateFileSha({
    required int projectFileId,
    required String newSha,
  }) async {
    final content = await getFileContent(projectFileId);
    if (content == null) return;

    await (_database.update(_database.fileContents)..where((t) => t.id.equals(content.id)))
        .write(db.FileContentsCompanion(
      githubSha: drift.Value(newSha),
    ));
  }
}
