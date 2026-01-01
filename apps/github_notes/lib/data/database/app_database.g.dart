// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectFilesTable extends ProjectFiles
    with TableInfo<$ProjectFilesTable, ProjectFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
      'owner', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repoMeta = const VerificationMeta('repo');
  @override
  late final GeneratedColumn<String> repo = GeneratedColumn<String>(
      'repo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, owner, repo, path, nickname, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_files';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('repo')) {
      context.handle(
          _repoMeta, repo.isAcceptableOrUnknown(data['repo']!, _repoMeta));
    } else if (isInserting) {
      context.missing(_repoMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectFile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      owner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner'])!,
      repo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repo'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProjectFilesTable createAlias(String alias) {
    return $ProjectFilesTable(attachedDatabase, alias);
  }
}

class ProjectFile extends DataClass implements Insertable<ProjectFile> {
  final int id;
  final String owner;
  final String repo;
  final String path;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectFile(
      {required this.id,
      required this.owner,
      required this.repo,
      required this.path,
      required this.nickname,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner'] = Variable<String>(owner);
    map['repo'] = Variable<String>(repo);
    map['path'] = Variable<String>(path);
    map['nickname'] = Variable<String>(nickname);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectFilesCompanion toCompanion(bool nullToAbsent) {
    return ProjectFilesCompanion(
      id: Value(id),
      owner: Value(owner),
      repo: Value(repo),
      path: Value(path),
      nickname: Value(nickname),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectFile(
      id: serializer.fromJson<int>(json['id']),
      owner: serializer.fromJson<String>(json['owner']),
      repo: serializer.fromJson<String>(json['repo']),
      path: serializer.fromJson<String>(json['path']),
      nickname: serializer.fromJson<String>(json['nickname']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'owner': serializer.toJson<String>(owner),
      'repo': serializer.toJson<String>(repo),
      'path': serializer.toJson<String>(path),
      'nickname': serializer.toJson<String>(nickname),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectFile copyWith(
          {int? id,
          String? owner,
          String? repo,
          String? path,
          String? nickname,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProjectFile(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        repo: repo ?? this.repo,
        path: path ?? this.path,
        nickname: nickname ?? this.nickname,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProjectFile copyWithCompanion(ProjectFilesCompanion data) {
    return ProjectFile(
      id: data.id.present ? data.id.value : this.id,
      owner: data.owner.present ? data.owner.value : this.owner,
      repo: data.repo.present ? data.repo.value : this.repo,
      path: data.path.present ? data.path.value : this.path,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectFile(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('repo: $repo, ')
          ..write('path: $path, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, owner, repo, path, nickname, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectFile &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.repo == this.repo &&
          other.path == this.path &&
          other.nickname == this.nickname &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectFilesCompanion extends UpdateCompanion<ProjectFile> {
  final Value<int> id;
  final Value<String> owner;
  final Value<String> repo;
  final Value<String> path;
  final Value<String> nickname;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectFilesCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.repo = const Value.absent(),
    this.path = const Value.absent(),
    this.nickname = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectFilesCompanion.insert({
    this.id = const Value.absent(),
    required String owner,
    required String repo,
    required String path,
    required String nickname,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : owner = Value(owner),
        repo = Value(repo),
        path = Value(path),
        nickname = Value(nickname),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProjectFile> custom({
    Expression<int>? id,
    Expression<String>? owner,
    Expression<String>? repo,
    Expression<String>? path,
    Expression<String>? nickname,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (repo != null) 'repo': repo,
      if (path != null) 'path': path,
      if (nickname != null) 'nickname': nickname,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectFilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? owner,
      Value<String>? repo,
      Value<String>? path,
      Value<String>? nickname,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProjectFilesCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      path: path ?? this.path,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (repo.present) {
      map['repo'] = Variable<String>(repo.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectFilesCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('repo: $repo, ')
          ..write('path: $path, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FileContentsTable extends FileContents
    with TableInfo<$FileContentsTable, FileContent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _projectFileIdMeta =
      const VerificationMeta('projectFileId');
  @override
  late final GeneratedColumn<int> projectFileId = GeneratedColumn<int>(
      'project_file_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES project_files (id) ON DELETE CASCADE'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _githubShaMeta =
      const VerificationMeta('githubSha');
  @override
  late final GeneratedColumn<String> githubSha = GeneratedColumn<String>(
      'github_sha', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _localModifiedAtMeta =
      const VerificationMeta('localModifiedAt');
  @override
  late final GeneratedColumn<DateTime> localModifiedAt =
      GeneratedColumn<DateTime>('local_modified_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectFileId,
        content,
        githubSha,
        syncStatus,
        lastSyncAt,
        localModifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_contents';
  @override
  VerificationContext validateIntegrity(Insertable<FileContent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_file_id')) {
      context.handle(
          _projectFileIdMeta,
          projectFileId.isAcceptableOrUnknown(
              data['project_file_id']!, _projectFileIdMeta));
    } else if (isInserting) {
      context.missing(_projectFileIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('github_sha')) {
      context.handle(_githubShaMeta,
          githubSha.isAcceptableOrUnknown(data['github_sha']!, _githubShaMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    if (data.containsKey('local_modified_at')) {
      context.handle(
          _localModifiedAtMeta,
          localModifiedAt.isAcceptableOrUnknown(
              data['local_modified_at']!, _localModifiedAtMeta));
    } else if (isInserting) {
      context.missing(_localModifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileContent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileContent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectFileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_file_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      githubSha: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}github_sha']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at'])!,
      localModifiedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_modified_at'])!,
    );
  }

  @override
  $FileContentsTable createAlias(String alias) {
    return $FileContentsTable(attachedDatabase, alias);
  }
}

class FileContent extends DataClass implements Insertable<FileContent> {
  final int id;
  final int projectFileId;
  final String content;
  final String? githubSha;
  final String syncStatus;
  final DateTime lastSyncAt;
  final DateTime localModifiedAt;
  const FileContent(
      {required this.id,
      required this.projectFileId,
      required this.content,
      this.githubSha,
      required this.syncStatus,
      required this.lastSyncAt,
      required this.localModifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_file_id'] = Variable<int>(projectFileId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || githubSha != null) {
      map['github_sha'] = Variable<String>(githubSha);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    map['local_modified_at'] = Variable<DateTime>(localModifiedAt);
    return map;
  }

  FileContentsCompanion toCompanion(bool nullToAbsent) {
    return FileContentsCompanion(
      id: Value(id),
      projectFileId: Value(projectFileId),
      content: Value(content),
      githubSha: githubSha == null && nullToAbsent
          ? const Value.absent()
          : Value(githubSha),
      syncStatus: Value(syncStatus),
      lastSyncAt: Value(lastSyncAt),
      localModifiedAt: Value(localModifiedAt),
    );
  }

  factory FileContent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileContent(
      id: serializer.fromJson<int>(json['id']),
      projectFileId: serializer.fromJson<int>(json['projectFileId']),
      content: serializer.fromJson<String>(json['content']),
      githubSha: serializer.fromJson<String?>(json['githubSha']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastSyncAt: serializer.fromJson<DateTime>(json['lastSyncAt']),
      localModifiedAt: serializer.fromJson<DateTime>(json['localModifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectFileId': serializer.toJson<int>(projectFileId),
      'content': serializer.toJson<String>(content),
      'githubSha': serializer.toJson<String?>(githubSha),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastSyncAt': serializer.toJson<DateTime>(lastSyncAt),
      'localModifiedAt': serializer.toJson<DateTime>(localModifiedAt),
    };
  }

  FileContent copyWith(
          {int? id,
          int? projectFileId,
          String? content,
          Value<String?> githubSha = const Value.absent(),
          String? syncStatus,
          DateTime? lastSyncAt,
          DateTime? localModifiedAt}) =>
      FileContent(
        id: id ?? this.id,
        projectFileId: projectFileId ?? this.projectFileId,
        content: content ?? this.content,
        githubSha: githubSha.present ? githubSha.value : this.githubSha,
        syncStatus: syncStatus ?? this.syncStatus,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      );
  FileContent copyWithCompanion(FileContentsCompanion data) {
    return FileContent(
      id: data.id.present ? data.id.value : this.id,
      projectFileId: data.projectFileId.present
          ? data.projectFileId.value
          : this.projectFileId,
      content: data.content.present ? data.content.value : this.content,
      githubSha: data.githubSha.present ? data.githubSha.value : this.githubSha,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
      localModifiedAt: data.localModifiedAt.present
          ? data.localModifiedAt.value
          : this.localModifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileContent(')
          ..write('id: $id, ')
          ..write('projectFileId: $projectFileId, ')
          ..write('content: $content, ')
          ..write('githubSha: $githubSha, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('localModifiedAt: $localModifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectFileId, content, githubSha,
      syncStatus, lastSyncAt, localModifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileContent &&
          other.id == this.id &&
          other.projectFileId == this.projectFileId &&
          other.content == this.content &&
          other.githubSha == this.githubSha &&
          other.syncStatus == this.syncStatus &&
          other.lastSyncAt == this.lastSyncAt &&
          other.localModifiedAt == this.localModifiedAt);
}

class FileContentsCompanion extends UpdateCompanion<FileContent> {
  final Value<int> id;
  final Value<int> projectFileId;
  final Value<String> content;
  final Value<String?> githubSha;
  final Value<String> syncStatus;
  final Value<DateTime> lastSyncAt;
  final Value<DateTime> localModifiedAt;
  const FileContentsCompanion({
    this.id = const Value.absent(),
    this.projectFileId = const Value.absent(),
    this.content = const Value.absent(),
    this.githubSha = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.localModifiedAt = const Value.absent(),
  });
  FileContentsCompanion.insert({
    this.id = const Value.absent(),
    required int projectFileId,
    required String content,
    this.githubSha = const Value.absent(),
    required String syncStatus,
    required DateTime lastSyncAt,
    required DateTime localModifiedAt,
  })  : projectFileId = Value(projectFileId),
        content = Value(content),
        syncStatus = Value(syncStatus),
        lastSyncAt = Value(lastSyncAt),
        localModifiedAt = Value(localModifiedAt);
  static Insertable<FileContent> custom({
    Expression<int>? id,
    Expression<int>? projectFileId,
    Expression<String>? content,
    Expression<String>? githubSha,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastSyncAt,
    Expression<DateTime>? localModifiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectFileId != null) 'project_file_id': projectFileId,
      if (content != null) 'content': content,
      if (githubSha != null) 'github_sha': githubSha,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (localModifiedAt != null) 'local_modified_at': localModifiedAt,
    });
  }

  FileContentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? projectFileId,
      Value<String>? content,
      Value<String?>? githubSha,
      Value<String>? syncStatus,
      Value<DateTime>? lastSyncAt,
      Value<DateTime>? localModifiedAt}) {
    return FileContentsCompanion(
      id: id ?? this.id,
      projectFileId: projectFileId ?? this.projectFileId,
      content: content ?? this.content,
      githubSha: githubSha ?? this.githubSha,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectFileId.present) {
      map['project_file_id'] = Variable<int>(projectFileId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (githubSha.present) {
      map['github_sha'] = Variable<String>(githubSha.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (localModifiedAt.present) {
      map['local_modified_at'] = Variable<DateTime>(localModifiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileContentsCompanion(')
          ..write('id: $id, ')
          ..write('projectFileId: $projectFileId, ')
          ..write('content: $content, ')
          ..write('githubSha: $githubSha, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('localModifiedAt: $localModifiedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _githubTokenMeta =
      const VerificationMeta('githubToken');
  @override
  late final GeneratedColumn<String> githubToken = GeneratedColumn<String>(
      'github_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, githubToken, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('github_token')) {
      context.handle(
          _githubTokenMeta,
          githubToken.isAcceptableOrUnknown(
              data['github_token']!, _githubTokenMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      githubToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}github_token']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String? githubToken;
  final DateTime updatedAt;
  const AppSetting(
      {required this.id, this.githubToken, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || githubToken != null) {
      map['github_token'] = Variable<String>(githubToken);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      githubToken: githubToken == null && nullToAbsent
          ? const Value.absent()
          : Value(githubToken),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      githubToken: serializer.fromJson<String?>(json['githubToken']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'githubToken': serializer.toJson<String?>(githubToken),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith(
          {int? id,
          Value<String?> githubToken = const Value.absent(),
          DateTime? updatedAt}) =>
      AppSetting(
        id: id ?? this.id,
        githubToken: githubToken.present ? githubToken.value : this.githubToken,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      githubToken:
          data.githubToken.present ? data.githubToken.value : this.githubToken,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('githubToken: $githubToken, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, githubToken, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.githubToken == this.githubToken &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String?> githubToken;
  final Value<DateTime> updatedAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.githubToken = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.githubToken = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? githubToken,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (githubToken != null) 'github_token': githubToken,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? githubToken,
      Value<DateTime>? updatedAt}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      githubToken: githubToken ?? this.githubToken,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (githubToken.present) {
      map['github_token'] = Variable<String>(githubToken.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('githubToken: $githubToken, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectFilesTable projectFiles = $ProjectFilesTable(this);
  late final $FileContentsTable fileContents = $FileContentsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projectFiles, fileContents, appSettings];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('project_files',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('file_contents', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ProjectFilesTableCreateCompanionBuilder = ProjectFilesCompanion
    Function({
  Value<int> id,
  required String owner,
  required String repo,
  required String path,
  required String nickname,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ProjectFilesTableUpdateCompanionBuilder = ProjectFilesCompanion
    Function({
  Value<int> id,
  Value<String> owner,
  Value<String> repo,
  Value<String> path,
  Value<String> nickname,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProjectFilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectFilesTable, ProjectFile> {
  $$ProjectFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FileContentsTable, List<FileContent>>
      _fileContentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.fileContents,
              aliasName: $_aliasNameGenerator(
                  db.projectFiles.id, db.fileContents.projectFileId));

  $$FileContentsTableProcessedTableManager get fileContentsRefs {
    final manager = $$FileContentsTableTableManager($_db, $_db.fileContents)
        .filter((f) => f.projectFileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fileContentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectFilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectFilesTable> {
  $$ProjectFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repo => $composableBuilder(
      column: $table.repo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> fileContentsRefs(
      Expression<bool> Function($$FileContentsTableFilterComposer f) f) {
    final $$FileContentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fileContents,
        getReferencedColumn: (t) => t.projectFileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FileContentsTableFilterComposer(
              $db: $db,
              $table: $db.fileContents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectFilesTable> {
  $$ProjectFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repo => $composableBuilder(
      column: $table.repo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectFilesTable> {
  $$ProjectFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get repo =>
      $composableBuilder(column: $table.repo, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> fileContentsRefs<T extends Object>(
      Expression<T> Function($$FileContentsTableAnnotationComposer a) f) {
    final $$FileContentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fileContents,
        getReferencedColumn: (t) => t.projectFileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FileContentsTableAnnotationComposer(
              $db: $db,
              $table: $db.fileContents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectFilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectFilesTable,
    ProjectFile,
    $$ProjectFilesTableFilterComposer,
    $$ProjectFilesTableOrderingComposer,
    $$ProjectFilesTableAnnotationComposer,
    $$ProjectFilesTableCreateCompanionBuilder,
    $$ProjectFilesTableUpdateCompanionBuilder,
    (ProjectFile, $$ProjectFilesTableReferences),
    ProjectFile,
    PrefetchHooks Function({bool fileContentsRefs})> {
  $$ProjectFilesTableTableManager(_$AppDatabase db, $ProjectFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> owner = const Value.absent(),
            Value<String> repo = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String> nickname = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProjectFilesCompanion(
            id: id,
            owner: owner,
            repo: repo,
            path: path,
            nickname: nickname,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String owner,
            required String repo,
            required String path,
            required String nickname,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              ProjectFilesCompanion.insert(
            id: id,
            owner: owner,
            repo: repo,
            path: path,
            nickname: nickname,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProjectFilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({fileContentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (fileContentsRefs) db.fileContents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fileContentsRefs)
                    await $_getPrefetchedData<ProjectFile, $ProjectFilesTable,
                            FileContent>(
                        currentTable: table,
                        referencedTable: $$ProjectFilesTableReferences
                            ._fileContentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectFilesTableReferences(db, table, p0)
                                .fileContentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectFileId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectFilesTable,
    ProjectFile,
    $$ProjectFilesTableFilterComposer,
    $$ProjectFilesTableOrderingComposer,
    $$ProjectFilesTableAnnotationComposer,
    $$ProjectFilesTableCreateCompanionBuilder,
    $$ProjectFilesTableUpdateCompanionBuilder,
    (ProjectFile, $$ProjectFilesTableReferences),
    ProjectFile,
    PrefetchHooks Function({bool fileContentsRefs})>;
typedef $$FileContentsTableCreateCompanionBuilder = FileContentsCompanion
    Function({
  Value<int> id,
  required int projectFileId,
  required String content,
  Value<String?> githubSha,
  required String syncStatus,
  required DateTime lastSyncAt,
  required DateTime localModifiedAt,
});
typedef $$FileContentsTableUpdateCompanionBuilder = FileContentsCompanion
    Function({
  Value<int> id,
  Value<int> projectFileId,
  Value<String> content,
  Value<String?> githubSha,
  Value<String> syncStatus,
  Value<DateTime> lastSyncAt,
  Value<DateTime> localModifiedAt,
});

final class $$FileContentsTableReferences
    extends BaseReferences<_$AppDatabase, $FileContentsTable, FileContent> {
  $$FileContentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectFilesTable _projectFileIdTable(_$AppDatabase db) =>
      db.projectFiles.createAlias($_aliasNameGenerator(
          db.fileContents.projectFileId, db.projectFiles.id));

  $$ProjectFilesTableProcessedTableManager get projectFileId {
    final $_column = $_itemColumn<int>('project_file_id')!;

    final manager = $$ProjectFilesTableTableManager($_db, $_db.projectFiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectFileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FileContentsTableFilterComposer
    extends Composer<_$AppDatabase, $FileContentsTable> {
  $$FileContentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get githubSha => $composableBuilder(
      column: $table.githubSha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localModifiedAt => $composableBuilder(
      column: $table.localModifiedAt,
      builder: (column) => ColumnFilters(column));

  $$ProjectFilesTableFilterComposer get projectFileId {
    final $$ProjectFilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectFileId,
        referencedTable: $db.projectFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectFilesTableFilterComposer(
              $db: $db,
              $table: $db.projectFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileContentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileContentsTable> {
  $$FileContentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get githubSha => $composableBuilder(
      column: $table.githubSha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localModifiedAt => $composableBuilder(
      column: $table.localModifiedAt,
      builder: (column) => ColumnOrderings(column));

  $$ProjectFilesTableOrderingComposer get projectFileId {
    final $$ProjectFilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectFileId,
        referencedTable: $db.projectFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectFilesTableOrderingComposer(
              $db: $db,
              $table: $db.projectFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileContentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileContentsTable> {
  $$FileContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get githubSha =>
      $composableBuilder(column: $table.githubSha, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localModifiedAt => $composableBuilder(
      column: $table.localModifiedAt, builder: (column) => column);

  $$ProjectFilesTableAnnotationComposer get projectFileId {
    final $$ProjectFilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectFileId,
        referencedTable: $db.projectFiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectFilesTableAnnotationComposer(
              $db: $db,
              $table: $db.projectFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FileContentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FileContentsTable,
    FileContent,
    $$FileContentsTableFilterComposer,
    $$FileContentsTableOrderingComposer,
    $$FileContentsTableAnnotationComposer,
    $$FileContentsTableCreateCompanionBuilder,
    $$FileContentsTableUpdateCompanionBuilder,
    (FileContent, $$FileContentsTableReferences),
    FileContent,
    PrefetchHooks Function({bool projectFileId})> {
  $$FileContentsTableTableManager(_$AppDatabase db, $FileContentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileContentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileContentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> projectFileId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> githubSha = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> lastSyncAt = const Value.absent(),
            Value<DateTime> localModifiedAt = const Value.absent(),
          }) =>
              FileContentsCompanion(
            id: id,
            projectFileId: projectFileId,
            content: content,
            githubSha: githubSha,
            syncStatus: syncStatus,
            lastSyncAt: lastSyncAt,
            localModifiedAt: localModifiedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int projectFileId,
            required String content,
            Value<String?> githubSha = const Value.absent(),
            required String syncStatus,
            required DateTime lastSyncAt,
            required DateTime localModifiedAt,
          }) =>
              FileContentsCompanion.insert(
            id: id,
            projectFileId: projectFileId,
            content: content,
            githubSha: githubSha,
            syncStatus: syncStatus,
            lastSyncAt: lastSyncAt,
            localModifiedAt: localModifiedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FileContentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectFileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (projectFileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectFileId,
                    referencedTable:
                        $$FileContentsTableReferences._projectFileIdTable(db),
                    referencedColumn: $$FileContentsTableReferences
                        ._projectFileIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FileContentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FileContentsTable,
    FileContent,
    $$FileContentsTableFilterComposer,
    $$FileContentsTableOrderingComposer,
    $$FileContentsTableAnnotationComposer,
    $$FileContentsTableCreateCompanionBuilder,
    $$FileContentsTableUpdateCompanionBuilder,
    (FileContent, $$FileContentsTableReferences),
    FileContent,
    PrefetchHooks Function({bool projectFileId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String?> githubToken,
  required DateTime updatedAt,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String?> githubToken,
  Value<DateTime> updatedAt,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get githubToken => $composableBuilder(
      column: $table.githubToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get githubToken => $composableBuilder(
      column: $table.githubToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get githubToken => $composableBuilder(
      column: $table.githubToken, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> githubToken = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            githubToken: githubToken,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> githubToken = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            githubToken: githubToken,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectFilesTableTableManager get projectFiles =>
      $$ProjectFilesTableTableManager(_db, _db.projectFiles);
  $$FileContentsTableTableManager get fileContents =>
      $$FileContentsTableTableManager(_db, _db.fileContents);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
