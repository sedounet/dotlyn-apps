import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:drift/drift.dart' as drift;
import 'package:github_notes/data/database/app_database.dart' as db;
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
import 'package:github_notes/services/github_service.dart';
import 'package:github_notes/utils/snack_helper.dart';

class FileEditorScreen extends ConsumerStatefulWidget {
  final db.ProjectFile projectFile;

  const FileEditorScreen({super.key, required this.projectFile});

  @override
  ConsumerState<FileEditorScreen> createState() => _FileEditorScreenState();
}

class _FileEditorScreenState extends ConsumerState<FileEditorScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasLocalChanges = false;
  Timer? _autoSaveTimer;
  final Duration _autoSaveDelay = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _loadContent();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      if (_hasLocalChanges) _saveLocal(auto: true);
    });
  }

  Future<void> _loadContent() async {
    final database = ref.read(databaseProvider);
    final content = await database.getFileContent(widget.projectFile.id);

    if (content != null) {
      _controller.text = content.content;
      // ensure caret at start and scroll to top
      _controller.selection = const TextSelection.collapsed(offset: 0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) _scrollController.jumpTo(0);
      });
    }
    // No auto-fetch: user can manually fetch if needed via sync button
  }

  Future<void> _fetchFromGitHub() async {
    setState(() => _isLoading = true);

    try {
      final githubService = ref.read(githubServiceProvider);
      final response = await githubService.fetchFile(
        owner: widget.projectFile.owner,
        repo: widget.projectFile.repo,
        path: widget.projectFile.path,
      );

      _controller.text = response.content;

      // ensure caret at start and scroll to top
      _controller.selection = const TextSelection.collapsed(offset: 0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) _scrollController.jumpTo(0);
      });

      // Save to local DB
      final database = ref.read(databaseProvider);
      await database.upsertFileContent(
        db.FileContentsCompanion(
          projectFileId: drift.Value(widget.projectFile.id),
          content: drift.Value(response.content),
          githubSha: drift.Value(response.sha),
          syncStatus: const drift.Value('synced'),
          lastSyncAt: drift.Value(DateTime.now()),
          localModifiedAt: drift.Value(DateTime.now()),
        ),
      );

      if (!mounted) return;
      SnackHelper.showInfo(context, 'File loaded from GitHub');
    } on SocketException catch (_) {
      if (!mounted) return;
      SnackHelper.showError(context, 'Network error: please check your connection');
    } on GitHubApiException catch (e) {
      if (!mounted) return;
      SnackHelper.showError(context, 'Error: ${e.message}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveLocal({bool auto = false}) async {
    final database = ref.read(databaseProvider);
    final existing = await database.getFileContent(widget.projectFile.id);

    await database.upsertFileContent(
      db.FileContentsCompanion(
        id: existing == null ? const drift.Value.absent() : drift.Value(existing.id),
        projectFileId: drift.Value(widget.projectFile.id),
        content: drift.Value(_controller.text),
        githubSha: drift.Value(existing?.githubSha),
        syncStatus: const drift.Value('modified'),
        lastSyncAt: drift.Value(existing?.lastSyncAt ?? DateTime.now()),
        localModifiedAt: drift.Value(DateTime.now()),
      ),
    );

    if (mounted) {
      setState(() => _hasLocalChanges = false);
    } else {
      // If unmounted, just reset flag locally
      _hasLocalChanges = false;
    }

    if (!auto) {
      if (!mounted) return;
      SnackHelper.showInfo(context, 'Saved locally');
    }
  }

  Future<void> _syncToGitHub() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);
      final existing = await database.getFileContent(widget.projectFile.id);
      final githubService = ref.read(githubServiceProvider);

      String owner = widget.projectFile.owner;
      String repo = widget.projectFile.repo;
      String path = widget.projectFile.path;

      // Step 1: Validate config - if missing, ask user to configure
      if (owner.isEmpty || repo.isEmpty || path.isEmpty) {
        if (!mounted) return;

        final TextEditingController ownerController = TextEditingController(text: owner);
        final TextEditingController repoController = TextEditingController(text: repo);
        final TextEditingController pathController = TextEditingController(text: path);

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Configure GitHub path'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('This file needs a GitHub path to sync. Please provide:'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ownerController,
                    decoration: const InputDecoration(labelText: 'Owner (username)'),
                  ),
                  TextField(
                    controller: repoController,
                    decoration: const InputDecoration(labelText: 'Repository'),
                  ),
                  TextField(
                    controller: pathController,
                    decoration: const InputDecoration(labelText: 'Path (e.g., notes/myfile.md)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Save & Continue'),
              ),
            ],
          ),
        );

        if (confirmed != true) return;

        // Update config
        final updatedFile = widget.projectFile.copyWith(
          owner: ownerController.text.trim(),
          repo: repoController.text.trim(),
          path: pathController.text.trim(),
        );

        if (updatedFile.owner.isEmpty || updatedFile.repo.isEmpty || updatedFile.path.isEmpty) {
          if (!mounted) return;
          SnackHelper.showError(context, 'All fields are required');
          return;
        }

        await database.updateProjectFile(updatedFile);

        owner = updatedFile.owner;
        repo = updatedFile.repo;
        path = updatedFile.path;

        if (!mounted) return;
        SnackHelper.showInfo(context, 'Configuration saved');
      }

      // Step 2: Try to fetch remote file
      String? remoteSha;
      String? remoteContent;
      bool fileExistsOnGitHub = false;

      try {
        final remote = await githubService.fetchFile(owner: owner, repo: repo, path: path);
        remoteSha = remote.sha;
        remoteContent = remote.content;
        fileExistsOnGitHub = true;
      } on SocketException catch (_) {
        // Offline: cannot sync to GitHub
        if (!mounted) return;
        SnackHelper.showError(context, 'Offline: Cannot sync to GitHub. File saved locally.');
        return;
      } on GitHubApiException catch (e) {
        if (e.statusCode == 404) {
          // File doesn't exist on GitHub - will create below
          fileExistsOnGitHub = false;
        } else {
          rethrow; // Auth errors, etc.
        }
      }

      // Step 3: If file exists remotely, check for conflicts
      if (fileExistsOnGitHub) {
        final localSha = existing?.githubSha;

        // Compare SHA: if different, show conflict dialog
        if (localSha != null && localSha != remoteSha) {
          if (!mounted) return;
          final choice = await showDialog<String?>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Conflict detected'),
              content: const Text('The file changed on GitHub since your last sync.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'fetch'),
                  child: const Text('Fetch remote'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, 'push'),
                  child: const Text('Overwrite GitHub'),
                ),
              ],
            ),
          );

          if (choice == 'fetch') {
            _controller.text = remoteContent!;
            await database.upsertFileContent(
              db.FileContentsCompanion(
                id: existing == null ? const drift.Value.absent() : drift.Value(existing.id),
                projectFileId: drift.Value(widget.projectFile.id),
                content: drift.Value(remoteContent),
                githubSha: drift.Value(remoteSha),
                syncStatus: const drift.Value('synced'),
                lastSyncAt: drift.Value(DateTime.now()),
                localModifiedAt: drift.Value(DateTime.now()),
              ),
            );
            if (!mounted) return;
            SnackHelper.showSuccess(context, 'Fetched remote content');
            return;
          }

          if (choice != 'push') return; // Cancel
        }
      }

      // Step 4: Push to GitHub (create or update)
      final localSha = existing?.githubSha;
      final shaToUse = fileExistsOnGitHub ? (localSha ?? remoteSha) : null;

      final newSha = await githubService.updateFile(
        owner: owner,
        repo: repo,
        path: path,
        content: _controller.text,
        sha: shaToUse,
        message: shaToUse == null
            ? 'Create ${widget.projectFile.nickname} from GitHub Notes'
            : 'Update ${widget.projectFile.nickname} from GitHub Notes',
      );

      // Step 5: Update local DB
      await database.upsertFileContent(
        db.FileContentsCompanion(
          id: existing == null ? const drift.Value.absent() : drift.Value(existing.id),
          projectFileId: drift.Value(widget.projectFile.id),
          content: drift.Value(_controller.text),
          githubSha: drift.Value(newSha),
          syncStatus: const drift.Value('synced'),
          lastSyncAt: drift.Value(DateTime.now()),
          localModifiedAt: drift.Value(DateTime.now()),
        ),
      );

      if (!mounted) return;
      SnackHelper.showSuccess(
          context, fileExistsOnGitHub ? 'Synced to GitHub!' : 'Created on GitHub!');
    } on GitHubApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        SnackHelper.showError(context, 'Unauthorized: check your GitHub token');
      } else if (e.statusCode == 404) {
        SnackHelper.showError(context, 'Repository or path not found');
      } else if (e.statusCode == 409) {
        SnackHelper.showError(context, 'Conflict: File modified on GitHub. Try again.');
      } else {
        SnackHelper.showError(context, 'GitHub error: ${e.message}');
      }
    } catch (e) {
      if (!mounted) return;
      SnackHelper.showError(context, 'Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileContentAsync = ref.watch(fileContentProvider(widget.projectFile.id));

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // If there are local changes, save them before popping
        if (_hasLocalChanges) {
          await _saveLocal();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.projectFile.nickname),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Markdown quick help',
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (ctx) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Markdown quick reference',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 8),
                          Text('- # Heading 1'),
                          Text('- ## Heading 2'),
                          Text('- **bold**'),
                          Text('- *italic*'),
                          Text('- `inline code`'),
                          Text('- ```\ncode block\n```'),
                          Text('- - list item'),
                          Text('- [link](https://example.com)'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (fileContentAsync.valueOrNull?.syncStatus == 'synced')
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _isLoading ? null : _fetchFromGitHub,
                tooltip: 'Fetch from GitHub',
              ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Status bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: DotlynColors.secondary.withAlpha(13),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder_outlined,
                            size: 16,
                            color: DotlynColors.secondary.withAlpha(153),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${widget.projectFile.owner}/${widget.projectFile.repo}/${widget.projectFile.path}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: DotlynColors.secondary.withAlpha(153),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Editor
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: TextField(
                            controller: _controller,
                            scrollController: _scrollController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              hintText: 'Write your notes here...',
                              border: InputBorder.none,
                            ),
                            onChanged: (_) {
                              setState(() => _hasLocalChanges = true);
                              _scheduleAutoSave();
                            },
                          ),
                        ),
                      ),
                    ),

                    // Bottom actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withAlpha(60)
                                : Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !_isLoading ? _saveLocal : null,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Local'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _syncToGitHub,
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text('Sync GitHub'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DotlynColors.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
