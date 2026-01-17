import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
import 'package:github_notes/providers/token_provider.dart';
import 'package:github_notes/providers/project_file_service_provider.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:github_notes/services/github_service.dart';
import 'package:github_notes/widgets/field_help_button.dart';
import 'package:github_notes/models/sync_result.dart';
import '../providers/theme_provider.dart';
import 'package:github_notes/utils/snack_helper.dart';
import 'package:github_notes/widgets/conflict_dialog.dart';
import 'package:github_notes/utils/token_helper.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final ProjectFile? editingFile;

  const SettingsScreen({super.key, this.editingFile});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _tokenController = TextEditingController();
  bool _isTestingToken = false;
  bool? _tokenValid;
  bool _showToken = false; // Hide token by default
  bool _isSavingToken = false;
  String _themeMode = 'system';
  String _language = 'system';

  @override
  void initState() {
    super.initState();
    _loadToken();
    if (widget.editingFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddFileDialog(prefill: widget.editingFile);
      });
    }
  }

  @override
  void dispose() {
    // Ensure token is hidden when leaving settings
    _showToken = false;
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    final tokenService = ref.read(tokenServiceProvider);
    final token = await tokenService.loadToken();

    // load preferences from secure storage
    final storage = ref.read(secureStorageProvider);
    final theme = await storage.read(key: 'theme_mode');
    final lang = await storage.read(key: 'app_language');

    if (token != null) {
      _tokenController.text = token;
    }

    setState(() {
      _themeMode = theme ?? 'system';
      _language = lang ?? 'system';
    });
  }

  Future<void> _saveToken() async {
    final tokenService = ref.read(tokenServiceProvider);

    setState(() => _isSavingToken = true);

    try {
      // Sanitize token: trim, remove whitespace/newlines and zero-width spaces
      var token = TokenHelper.sanitizeToken(_tokenController.text);

      await tokenService.saveToken(token);
      // refresh token provider so consumers use the new value
      ref.invalidate(tokenServiceProvider);

      // Update UI controller with sanitized token
      if (mounted) _tokenController.text = token;

      if (!mounted) return;
      SnackHelper.showSuccess(context, 'GitHub token saved (secure) — ${token.length} chars');
    } catch (e) {
      if (!mounted) return;
      SnackHelper.showError(context, 'Error saving token: $e');
    } finally {
      if (mounted) setState(() => _isSavingToken = false);
    }
  }

  Future<void> _saveThemeMode(String mode) async {
    // Map string -> ThemeMode and persist via provider
    final notifier = ref.read(themeModeProvider.notifier);
    if (mode == 'light') {
      await notifier.setMode(ThemeMode.light);
    } else if (mode == 'dark') {
      await notifier.setMode(ThemeMode.dark);
    } else {
      await notifier.setMode(ThemeMode.system);
    }
    if (!mounted) return;
    setState(() => _themeMode = mode);
    SnackHelper.showSuccess(context, 'Theme set to $mode');
  }

  Future<void> _saveLanguage(String lang) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'app_language', value: lang);
    if (!mounted) return;
    setState(() => _language = lang);
    SnackHelper.showSuccess(context, 'Language set to $lang (no translations yet)');
  }

  Future<void> _testToken() async {
    setState(() {
      _isTestingToken = true;
      _tokenValid = null;
    });

    // Use the provider to get the service with fresh token
    final githubService = ref.read(githubServiceProvider);
    final isValid = await githubService.testToken();

    setState(() {
      _isTestingToken = false;
      _tokenValid = isValid;
    });

    if (!mounted) return;
    if (isValid) {
      SnackHelper.showSuccess(context, 'Token is valid!');
    } else {
      SnackHelper.showError(context, 'Token is invalid');
    }
  }

  void _showAddFileDialog({ProjectFile? prefill}) async {
    final ownerController = TextEditingController(text: prefill?.owner ?? '');
    final repoController = TextEditingController(text: prefill?.repo ?? '');
    final pathController = TextEditingController(text: prefill?.path ?? '');

    // For duplication, suggest intelligently: append "_2", "_3", etc. to alias
    late final String suggestedNickname;
    if (prefill != null) {
      // Generate smart suggestion: "essai" → "essai_2"
      final baseName = prefill.nickname.replaceAll(RegExp(r'_\d+$'), '');
      suggestedNickname = '${baseName}_2';
    } else {
      suggestedNickname = '';
    }
    final nicknameController = TextEditingController(text: suggestedNickname);
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add File to Track'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(
                  labelText: 'Owner',
                  hintText: 'e.g., johndoe or my-org',
                  suffixIcon: FieldHelpButton(
                    message: 'Owner is the GitHub username or organization (e.g. johndoe)',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: repoController,
                decoration: const InputDecoration(
                  labelText: 'Repository',
                  hintText: 'e.g., myapp',
                  suffixIcon: FieldHelpButton(
                    message: 'Repository name inside the owner/org (e.g. myapp)',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pathController,
                decoration: const InputDecoration(
                  labelText: 'File Path',
                  hintText: 'e.g., README.md or _docs/apps/myapp/PROMPT_USER.md',
                  suffixIcon: FieldHelpButton(
                    message:
                        'Relative path within the repository (e.g. README.md or _docs/apps/myapp/PROMPT_USER.md)',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'e.g., MyApp - User Prompt',
                  suffixIcon: FieldHelpButton(
                    message: 'Friendly display name for this tracked file',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(parentContext);

              if (ownerController.text.isEmpty ||
                  repoController.text.isEmpty ||
                  pathController.text.isEmpty ||
                  nicknameController.text.isEmpty) {
                SnackHelper.showError(parentContext, 'All fields are required');
                return;
              }

              final owner = ownerController.text.trim();
              final repo = repoController.text.trim();
              final path = pathController.text.trim();
              final nickname = nicknameController.text.trim();

              // Check if this owner/repo/path already exists (prevent duplication)
              final fileService = ref.read(projectFileServiceProvider);
              // IMPORTANT: If we're duplicating (prefill != null), we DON'T exclude it
              // We want to BLOCK if owner/repo/path already exist
              // Only exclude for edits where we're modifying the same file
              final alreadyExists = await fileService.fileExists(
                owner: owner,
                repo: repo,
                path: path,
                excludeId: null, // Never exclude — we want to prevent exact duplicates
              );

              if (alreadyExists) {
                SnackHelper.showError(
                  parentContext,
                  'This GitHub path ($owner/$repo/$path) is already tracked. Change the path or filename to create a duplicate.',
                );
                return;
              }

              // Check if file exists on GitHub (UX: propose harmonized conflict menu)
              try {
                final githubService = ref.read(githubServiceProvider);
                try {
                  final remoteContent =
                      await githubService.fetchFile(owner: owner, repo: repo, path: path);

                  // File exists remotely — show harmonized conflict dialog
                  if (!mounted) return;
                  final choice = await ConflictDialog.show(
                    context,
                    remoteSha: remoteContent.sha,
                    situation: ConflictSituation.fileExistsRemote,
                  );

                  // Handle user choice
                  if (choice == null || choice == ConflictChoice.cancel) {
                    return; // User cancelled
                  }

                  final fileService = ref.read(projectFileServiceProvider);

                  if (choice == ConflictChoice.fetchRemote) {
                    // Import remote: add file with remote content
                    final fileId = await fileService.addFile(
                      owner: owner,
                      repo: repo,
                      path: path,
                      nickname: nickname,
                    );
                    // Save the remote content + SHA (mark as synced since we just fetched it)
                    await fileService.saveFileContent(
                      projectFileId: fileId,
                      content: remoteContent.content,
                      githubSha: remoteContent.sha,
                      isImportedFromGitHub: true,
                    );
                  } else {
                    // ConflictChoice.overwriteGitHub or default: add local config only
                    await fileService.addFile(
                      owner: owner,
                      repo: repo,
                      path: path,
                      nickname: nickname,
                    );
                  }

                  // Close the add file dialog FIRST, then show snack (so snack appears on top)
                  if (!mounted) return;
                  navigator.pop();

                  // Now show success message with dialog closed
                  final message = choice == ConflictChoice.fetchRemote
                      ? 'File imported from GitHub'
                      : 'File added (local only)';
                  SnackHelper.showSuccess(context, message);
                  return;
                } on GitHubApiException catch (e) {
                  if (e.statusCode == 404) {
                    // Not found — OK to add
                  } else {
                    if (!mounted) return;
                    // Friendly messages for common cases
                    if (e.statusCode == 401) {
                      SnackHelper.showError(
                          parentContext, 'Invalid GitHub token. Please update it in Settings.');
                    } else {
                      SnackHelper.showError(parentContext,
                          'GitHub error (${e.statusCode ?? 'unknown'}). Please try again later.');
                    }
                    return;
                  }
                }
              } on SocketException catch (_) {
                // No network: allow adding the tracked file locally and inform the user.
                final fileService = ref.read(projectFileServiceProvider);
                await fileService.addFile(
                  owner: owner,
                  repo: repo,
                  path: path,
                  nickname: nickname,
                );
                if (!mounted) return;
                navigator.pop();
                SnackHelper.showInfo(
                    parentContext, 'No network: file added locally. It will sync when online.');
                return;
              } catch (e) {
                if (!mounted) return;
                SnackHelper.showError(parentContext, 'Error checking GitHub: $e');
                return;
              }

              // File doesn't exist remotely — add it locally
              final fileId = await fileService.addFile(
                owner: owner,
                repo: repo,
                path: path,
                nickname: nickname,
              );
              // Create empty FileContent with "pending" status
              await fileService.saveFileContent(
                projectFileId: fileId,
                content: '',
                isImportedFromGitHub: false,
              );

              if (!mounted) return;
              navigator.pop();
              SnackHelper.showSuccess(context, 'File added successfully');
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditFileDialog(ProjectFile file) {
    final ownerController = TextEditingController(text: file.owner);
    final repoController = TextEditingController(text: file.repo);
    final pathController = TextEditingController(text: file.path);
    final nicknameController = TextEditingController(text: file.nickname);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit File Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(
                  labelText: 'Owner',
                  suffixIcon: FieldHelpButton(
                    message: 'Owner is the GitHub username or organization',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: repoController,
                decoration: const InputDecoration(
                  labelText: 'Repository',
                  suffixIcon: FieldHelpButton(
                    message: 'Repository name inside the owner/org',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pathController,
                decoration: const InputDecoration(
                  labelText: 'File Path',
                  suffixIcon: FieldHelpButton(
                    message: 'Relative path within the repository',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  suffixIcon: FieldHelpButton(
                    message: 'Friendly display name for this tracked file',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (ownerController.text.isEmpty ||
                  repoController.text.isEmpty ||
                  pathController.text.isEmpty ||
                  nicknameController.text.isEmpty) {
                SnackHelper.showError(context, 'All fields are required');
                return;
              }

              try {
                // Use ProjectFileService to update file
                final fileService = ref.read(projectFileServiceProvider);
                final success = await fileService.updateFile(
                  id: file.id,
                  owner: ownerController.text.trim(),
                  repo: repoController.text.trim(),
                  path: pathController.text.trim(),
                  nickname: nicknameController.text.trim(),
                );

                if (!mounted) return;

                if (!success) {
                  SnackHelper.showError(context, 'Failed to update file. Please try again.');
                  return;
                }

                final navigator = Navigator.of(context);
                navigator.pop();
                SnackHelper.showSuccess(context, 'File updated successfully');
              } catch (e) {
                if (!mounted) return;
                SnackHelper.showError(context, 'Error updating file: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectFilesAsync = ref.watch(projectFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // GitHub Token Section
          Text(
            'GitHub Authentication',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a Personal Access Token with "repo" scope at github.com/settings/tokens',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DotlynColors.secondary.withAlpha(153),
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              labelText: 'GitHub Token',
              hintText: 'ghp_xxxxxxxxxxxx',
              border: const OutlineInputBorder(),
              // Right side: validation icon + visibility icon button
              suffixIcon: SizedBox(
                width: 96,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_tokenValid != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          _tokenValid! ? Icons.check_circle : Icons.error,
                          color: _tokenValid! ? DotlynColors.success : DotlynColors.error,
                          size: 20,
                        ),
                      ),
                    IconButton(
                      icon: Icon(_showToken ? Icons.visibility_off : Icons.visibility),
                      tooltip: _showToken ? 'Masquer le token' : 'Montrer le token',
                      onPressed: () => setState(() => _showToken = !_showToken),
                    ),
                  ],
                ),
              ),
            ),
            obscureText: !_showToken,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isTestingToken ? null : _testToken,
                  child: _isTestingToken
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Test Token'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSavingToken ? null : _saveToken,
                  child: _isSavingToken
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Token'),
                ),
              ),
            ],
          ),

          // Debug: show stored token (only in debug builds)
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                final storage = ref.read(secureStorageProvider);
                final token = await storage.read(key: 'github_token');
                if (!mounted) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Debug: GitHub token'),
                      content: SelectableText(token ?? '<empty>'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (token != null) {
                              Clipboard.setData(ClipboardData(text: token));
                            }
                            Navigator.pop(ctx);
                          },
                          child: const Text('Copy'),
                        ),
                      ],
                    ),
                  );
                });
              },
              child: const Text('Show token (debug)'),
            ),
          ],

          const SizedBox(height: 24),

          // Appearance & Language
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeMode == 'system'
                ? 'System'
                : _themeMode == 'light'
                    ? 'Light'
                    : 'Dark'),
            trailing: DropdownButton<String>(
              value: _themeMode,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (v) {
                if (v != null) _saveThemeMode(v);
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language == 'system'
                ? 'System (device)'
                : _language == 'en'
                    ? 'English'
                    : 'Français'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
              ],
              onChanged: (v) {
                if (v != null) _saveLanguage(v);
              },
            ),
          ),

          const SizedBox(height: 8),

          const Divider(),
          const SizedBox(height: 16),

          // Tracked Files Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tracked Files',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () {
                  // Show file add dialog
                  _showAddFileDialog();
                },
                icon: const Icon(Icons.add_circle, color: DotlynColors.primary),
                tooltip: 'Add file',
              ),
            ],
          ),
          const SizedBox(height: 12),

          projectFilesAsync.when(
            data: (files) {
              if (files.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No files tracked yet. Tap + to add one.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                children: files.map((file) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(file.nickname),
                      subtitle: Text(
                        '${file.owner}/${file.repo}/${file.path}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: DotlynColors.primary),
                            tooltip: 'Edit settings',
                            onPressed: () {
                              // Show edit dialog with pre-filled values
                              _showEditFileDialog(file);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: DotlynColors.error),
                            onPressed: () async {
                              final parentContext = context;
                              final confirm = await showDialog<bool>(
                                context: parentContext,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete File?'),
                                  content: Text('Remove "${file.nickname}" from tracked files?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (!mounted) return;
                              if (confirm == true) {
                                final fileService = ref.read(projectFileServiceProvider);
                                await fileService.deleteFile(file.id);
                                if (!mounted) return;
                                SnackHelper.showSuccess(parentContext, 'File removed');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
