import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
// removed unused import: drift
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:github_notes/services/github_service.dart';
import 'package:github_notes/widgets/project_file_form.dart';
import '../providers/theme_provider.dart';

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
  bool _showToken = true; // Show token by default (hide disabled)
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
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    final settings = await ref.read(databaseProvider).getSettings();
    final token = settings?.githubToken;
    if (token != null) {
      _tokenController.text = token;
    }
    // load preferences from secure storage
    final storage = ref.read(secureStorageProvider);
    final theme = await storage.read(key: 'theme_mode');
    final lang = await storage.read(key: 'app_language');
    setState(() {
      _themeMode = theme ?? 'system';
      _language = lang ?? 'system';
    });
  }

  Future<void> _saveToken() async {
    final database = ref.read(databaseProvider);
    final messenger = ScaffoldMessenger.of(context);
    final storage = ref.read(secureStorageProvider);

    setState(() => _isSavingToken = true);

    try {
      // Sanitize token: trim, remove whitespace/newlines and zero-width spaces
      var token = _tokenController.text.trim();
      token = token.replaceAll(RegExp(r'\s+'), '');
      token = token.replaceAll('\u200B', '');

      await storage.write(key: 'github_token', value: token);
      // also persist in DB for compatibility
      await database.saveGithubToken(token);
      // refresh token provider so consumers use the new value
      ref.invalidate(githubTokenProvider);

      // Update UI controller with sanitized token
      if (mounted) _tokenController.text = token;

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('GitHub token saved (secure) — ${token.length} chars')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error saving token: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSavingToken = false);
    }
  }

  Future<void> _saveThemeMode(String mode) async {
    final messenger = ScaffoldMessenger.of(context);
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
    messenger.showSnackBar(
      SnackBar(content: Text('Theme set to $mode')),
    );
  }

  Future<void> _saveLanguage(String lang) async {
    final messenger = ScaffoldMessenger.of(context);
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'app_language', value: lang);
    if (!mounted) return;
    setState(() => _language = lang);
    messenger.showSnackBar(
      SnackBar(content: Text('Language set to $lang (no translations yet)')),
    );
  }

  Future<void> _testToken() async {
    setState(() {
      _isTestingToken = true;
      _tokenValid = null;
    });

    // read token fresh from secure storage to avoid stale provider value
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'github_token');
    final githubService = GitHubService(token: token);
    final isValid = await githubService.testToken();

    setState(() {
      _isTestingToken = false;
      _tokenValid = isValid;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isValid ? 'Token is valid!' : 'Token is invalid'),
        backgroundColor: isValid ? DotlynColors.success : DotlynColors.error,
      ),
    );
  }

  void _showAddFileDialog({ProjectFile? prefill}) {
    final ownerController = TextEditingController(text: prefill?.owner ?? '');
    final repoController = TextEditingController(text: prefill?.repo ?? '');
    final pathController = TextEditingController(text: prefill?.path ?? '');
    final nicknameController = TextEditingController(text: prefill?.nickname ?? '');
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
                decoration: InputDecoration(
                  labelText: 'Owner',
                  hintText: 'e.g., johndoe or my-org',
                  suffixIcon: Tooltip(
                    message: 'Owner is the GitHub username or organization (e.g. johndoe)',
                    child: const Icon(Icons.info_outline),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: repoController,
                decoration: InputDecoration(
                  labelText: 'Repository',
                  hintText: 'e.g., myapp',
                  suffixIcon: Tooltip(
                    message: 'Repository name inside the owner/org (e.g. myapp)',
                    child: const Icon(Icons.info_outline),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pathController,
                decoration: InputDecoration(
                  labelText: 'File Path',
                  hintText: 'e.g., README.md or _docs/apps/myapp/PROMPT_USER.md',
                  suffixIcon: Tooltip(
                    message:
                        'Relative path within the repository (e.g. README.md or _docs/apps/myapp/PROMPT_USER.md)',
                    child: const Icon(Icons.info_outline),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'e.g., MyApp - User Prompt',
                  suffixIcon: Tooltip(
                    message: 'Friendly display name for this tracked file',
                    child: const Icon(Icons.info_outline),
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
              final messenger = ScaffoldMessenger.of(parentContext);
              final navigator = Navigator.of(parentContext);

              if (ownerController.text.isEmpty ||
                  repoController.text.isEmpty ||
                  pathController.text.isEmpty ||
                  nicknameController.text.isEmpty) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
                );
                return;
              }

              final owner = ownerController.text.trim();
              final repo = repoController.text.trim();
              final path = pathController.text.trim();

              // Check if file exists on GitHub
              try {
                final storage = ref.read(secureStorageProvider);
                final token = await storage.read(key: 'github_token');
                final githubService = GitHubService(token: token);
                try {
                  await githubService.fetchFile(owner: owner, repo: repo, path: path);

                  // File exists remotely — confirm with user
                  if (!mounted) return;
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('File exists on GitHub'),
                      content: Text(
                          'A file already exists at $path in $owner/$repo. Add to tracked files anyway?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel')),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
                      ],
                    ),
                  );

                  if (confirm != true) return;
                } on GitHubApiException catch (e) {
                  if (e.statusCode == 404) {
                    // Not found — OK to add
                  } else {
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text('GitHub error: ${e.message}')),
                    );
                    return;
                  }
                }
              } catch (e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('Error checking GitHub: $e')),
                );
                return;
              }

              final database = ref.read(databaseProvider);
              await database.addProjectFile(
                ProjectFilesCompanion.insert(
                  owner: ownerController.text.trim(),
                  repo: repoController.text.trim(),
                  path: pathController.text.trim(),
                  nickname: nicknameController.text.trim(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );

              if (!mounted) return;
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('File added successfully')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditFileDialog(ProjectFile file) {
    // Use the reusable ProjectFileForm dialog for editing
    final initial = ProjectFileData(
      owner: file.owner,
      repo: file.repo,
      path: file.path,
      nickname: file.nickname,
    );

    showDialog<ProjectFileData>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit File Settings'),
        content: ProjectFileForm(initial: initial, submitLabel: 'Save'),
      ),
    ).then((result) async {
      if (result == null) return;

      final database = ref.read(databaseProvider);
      await database.updateProjectFile(
        file.copyWith(
          owner: result.owner.trim(),
          repo: result.repo.trim(),
          path: result.path.trim(),
          nickname: result.nickname.trim(),
          updatedAt: DateTime.now(),
        ),
      );

      if (!mounted) return;
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('File updated successfully')));
    });
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
                onPressed: () async {
                  final result = await showDialog<ProjectFileData>(
                    context: context,
                    builder: (ctx) => const AlertDialog(
                      title: Text('Add File to Track'),
                      content: ProjectFileForm(),
                    ),
                  );

                  if (result == null) return; // cancelled

                  // Check if file exists on GitHub
                  try {
                    final storage = ref.read(secureStorageProvider);
                    final token = await storage.read(key: 'github_token');
                    final githubService = GitHubService(token: token);
                    try {
                      await githubService.fetchFile(
                          owner: result.owner, repo: result.repo, path: result.path);

                      // File exists remotely — confirm with user
                      if (!mounted) return;
                      // File exists remotely — confirm with user
                      final ctxForDialog = context;
                      final confirm = await showDialog<bool>(
                        context: ctxForDialog,
                        builder: (ctx) => AlertDialog(
                          title: const Text('File exists on GitHub'),
                          content: Text(
                              'A file already exists at ${result.path} in ${result.owner}/${result.repo}. Add to tracked files anyway?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Add')),
                          ],
                        ),
                      );

                      if (confirm != true) return;
                    } on GitHubApiException catch (e) {
                      if (e.statusCode == 404) {
                        // Not found — OK to add
                      } else {
                        if (!mounted) return;
                        // Safe: checked mounted immediately before using context
                        final ctxForMsg = context;
                        ScaffoldMessenger.of(ctxForMsg)
                            .showSnackBar(SnackBar(content: Text('GitHub error: ${e.message}')));
                        return;
                      }
                    }
                  } catch (e) {
                    if (!mounted) return;
                    // Safe: checked mounted immediately before using context
                    final ctxForMsg = context;
                    ScaffoldMessenger.of(ctxForMsg)
                        .showSnackBar(SnackBar(content: Text('Error checking GitHub: $e')));
                    return;
                  }

                  final database = ref.read(databaseProvider);
                  await database.addProjectFile(
                    ProjectFilesCompanion.insert(
                      owner: result.owner,
                      repo: result.repo,
                      path: result.path,
                      nickname: result.nickname,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );

                  if (!mounted) return;
                  // Safe: checked mounted immediately before using context
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  navigator.pop();
                  messenger.showSnackBar(const SnackBar(content: Text('File added successfully')));
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
                              final messenger = ScaffoldMessenger.of(parentContext);
                              final confirm = await showDialog<bool>(
                                context: parentContext,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Delete File?'),
                                  content: Text('Remove "${file.nickname}" from tracked files?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(dialogContext, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DotlynColors.error,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (!mounted) return;
                              if (confirm == true) {
                                await ref.read(databaseProvider).deleteProjectFile(file.id);
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('File removed')),
                                );
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
