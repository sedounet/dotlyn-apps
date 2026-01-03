import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:drift/drift.dart' as drift;
import 'package:github_notes/data/database/app_database.dart' as db;
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
import 'package:github_notes/services/github_service.dart';

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
    } else {
      // No local content, try fetching from GitHub
      await _fetchFromGitHub();
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File loaded from GitHub')),
      );
    } on GitHubApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved locally')),
      );
    }
  }

  Future<void> _syncToGitHub() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);
      final existing = await database.getFileContent(widget.projectFile.id);

      final githubService = ref.read(githubServiceProvider);

      // Fetch latest remote SHA to detect conflicts (with small delay to avoid initial race conditions)
      String? remoteSha;
      String? remoteContent;
      try {
        // Small delay to avoid sync race condition on first fetch
        await Future.delayed(const Duration(milliseconds: 500));

        final remote = await githubService.fetchFile(
          owner: widget.projectFile.owner,
          repo: widget.projectFile.repo,
          path: widget.projectFile.path,
        );
        remoteSha = remote.sha;
        remoteContent = remote.content;
      } on GitHubApiException catch (_) {
        // If fetch fails and we have no local SHA, re-fetch on initial sync attempt
        if (existing?.githubSha == null) {
          try {
            await Future.delayed(const Duration(seconds: 1));
            final remote = await githubService.fetchFile(
              owner: widget.projectFile.owner,
              repo: widget.projectFile.repo,
              path: widget.projectFile.path,
            );
            remoteSha = remote.sha;
            remoteContent = remote.content;
          } on GitHubApiException catch (_) {
            // Still failed, will handle below
          }
        }
      }

      final localSha = existing?.githubSha;

      // If both exist and differ -> conflict
      if (localSha != null && remoteSha != null && localSha != remoteSha) {
        if (!mounted) return;
        final choice = await showDialog<String?>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Conflict detected'),
            content: const Text(
                'The file changed on GitHub since you last synced. What would you like to do?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'fetch_remote'),
                child: const Text('Fetch remote'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, 'overwrite'),
                child: const Text('Overwrite GitHub'),
              ),
            ],
          ),
        );

        if (choice == 'fetch_remote') {
          if (remoteContent != null) {
            _controller.text = remoteContent;
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fetched remote content')),
            );
            return;
          }
        }

        if (choice != 'overwrite') {
          // user cancelled or no overwrite -> abort
          return;
        }
        // else proceed to overwrite GitHub (use localSha or remoteSha as base)
      }

      final shaToUse = localSha ?? remoteSha;

      if (shaToUse == null) {
        throw Exception('No SHA available. Fetch from GitHub first.');
      }

      final newSha = await githubService.updateFile(
        owner: widget.projectFile.owner,
        repo: widget.projectFile.repo,
        path: widget.projectFile.path,
        content: _controller.text,
        sha: shaToUse,
        message: 'Update ${widget.projectFile.nickname} from GitHub Notes',
      );

      // Update local DB with new SHA
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Synced to GitHub successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } on GitHubApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
                              onPressed: _hasLocalChanges ? _saveLocal : null,
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
                                foregroundColor: Colors.white,
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
