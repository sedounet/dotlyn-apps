import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Tables
class ProjectFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get owner => text()();
  TextColumn get repo => text()();
  TextColumn get path => text()();
  TextColumn get nickname => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class FileContents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectFileId =>
      integer().references(ProjectFiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  TextColumn get githubSha => text().nullable()();
  TextColumn get syncStatus => text()(); // enum as string
  DateTimeColumn get lastSyncAt => dateTime()();
  DateTimeColumn get localModifiedAt => dateTime()();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get githubToken => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [ProjectFiles, FileContents, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Test constructor for unit tests
  AppDatabase.testConstructor(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'github_notes_db');
  }

  // ProjectFiles queries
  Future<List<ProjectFile>> getAllProjectFiles() => select(projectFiles).get();

  Stream<List<ProjectFile>> watchAllProjectFiles() => select(projectFiles).watch();

  Future<int> addProjectFile(ProjectFilesCompanion entry) => into(projectFiles).insert(entry);

  Future<bool> updateProjectFile(ProjectFile entry) => update(projectFiles).replace(entry);

  Future<int> deleteProjectFile(int id) =>
      (delete(projectFiles)..where((t) => t.id.equals(id))).go();

  // FileContents queries
  Future<FileContent?> getFileContent(int? projectFileId) {
    if (projectFileId == null) return Future.value(null);
    return (select(fileContents)..where((t) => t.projectFileId.equals(projectFileId)))
        .getSingleOrNull();
  }

  Stream<FileContent?> watchFileContent(int? projectFileId) {
    if (projectFileId == null) return const Stream<FileContent?>.empty();
    return (select(fileContents)..where((t) => t.projectFileId.equals(projectFileId)))
        .watchSingleOrNull();
  }

  Future<int> upsertFileContent(FileContentsCompanion entry) =>
      into(fileContents).insertOnConflictUpdate(entry);

  // AppSettings queries
  Future<AppSetting?> getSettings() => (select(appSettings)..limit(1)).getSingleOrNull();

  Stream<AppSetting?> watchSettings() => (select(appSettings)..limit(1)).watchSingleOrNull();

  Future<void> saveGithubToken(String token) async {
    final existing = await getSettings();
    if (existing == null) {
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          githubToken: Value(token),
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      await (update(appSettings)..where((t) => t.id.equals(existing.id))).write(
        AppSettingsCompanion(
          githubToken: Value(token),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }
}
