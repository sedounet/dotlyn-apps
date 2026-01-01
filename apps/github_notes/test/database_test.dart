import 'package:flutter_test/flutter_test.dart';
import 'package:github_notes/data/database/app_database.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Create an in-memory database for testing
    database = AppDatabase.testConstructor(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase ProjectFiles', () {
    test('should insert and retrieve a project file', () async {
      final entry = ProjectFilesCompanion.insert(
        owner: 'testuser',
        repo: 'testrepo',
        path: 'test.md',
        nickname: 'Test Note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await database.addProjectFile(entry);
      expect(id, greaterThan(0));

      final files = await database.getAllProjectFiles();
      expect(files, hasLength(1));
      expect(files.first.nickname, 'Test Note');
      expect(files.first.owner, 'testuser');
    });

    test('should delete a project file', () async {
      final entry = ProjectFilesCompanion.insert(
        owner: 'testuser',
        repo: 'testrepo',
        path: 'test.md',
        nickname: 'Test Note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await database.addProjectFile(entry);
      await database.deleteProjectFile(id);

      final files = await database.getAllProjectFiles();
      expect(files, isEmpty);
    });
  });

  group('AppDatabase FileContents', () {
    test('should insert and retrieve file content', () async {
      // First create a project file
      final projectEntry = ProjectFilesCompanion.insert(
        owner: 'testuser',
        repo: 'testrepo',
        path: 'test.md',
        nickname: 'Test Note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final projectId = await database.addProjectFile(projectEntry);

      // Insert file content
      final contentEntry = FileContentsCompanion.insert(
        projectFileId: projectId,
        content: '# Test Content',
        githubSha: const Value('abc123'),
        syncStatus: 'synced',
        lastSyncAt: DateTime.now(),
        localModifiedAt: DateTime.now(),
      );

      await database.upsertFileContent(contentEntry);

      final content = await database.getFileContent(projectId);
      expect(content, isNotNull);
      expect(content!.content, '# Test Content');
      expect(content.githubSha, 'abc123');
      expect(content.syncStatus, 'synced');
    });

    test('should update existing file content', () async {
      final projectEntry = ProjectFilesCompanion.insert(
        owner: 'testuser',
        repo: 'testrepo',
        path: 'test.md',
        nickname: 'Test Note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final projectId = await database.addProjectFile(projectEntry);

      // Insert initial content
      final contentEntry = FileContentsCompanion.insert(
        projectFileId: projectId,
        content: '# Original',
        syncStatus: 'synced',
        lastSyncAt: DateTime.now(),
        localModifiedAt: DateTime.now(),
      );
      await database.upsertFileContent(contentEntry);

      // Get existing content ID
      final existing = await database.getFileContent(projectId);

      // Update content with existing ID
      final updatedEntry = FileContentsCompanion(
        id: Value(existing!.id),
        projectFileId: Value(projectId),
        content: const Value('# Updated'),
        syncStatus: const Value('modified'),
        lastSyncAt: Value(DateTime.now()),
        localModifiedAt: Value(DateTime.now()),
      );
      await database.upsertFileContent(updatedEntry);

      final content = await database.getFileContent(projectId);
      expect(content!.content, '# Updated');
      expect(content.syncStatus, 'modified');
    });
  });

  group('AppDatabase AppSettings', () {
    test('should save and retrieve GitHub token', () async {
      const testToken = 'ghp_test123456';
      await database.saveGithubToken(testToken);

      final settings = await database.getSettings();
      expect(settings, isNotNull);
      expect(settings!.githubToken, testToken);
    });

    test('should update existing GitHub token', () async {
      await database.saveGithubToken('ghp_old');
      await database.saveGithubToken('ghp_new');

      final settings = await database.getSettings();
      expect(settings!.githubToken, 'ghp_new');
    });
  });
}
