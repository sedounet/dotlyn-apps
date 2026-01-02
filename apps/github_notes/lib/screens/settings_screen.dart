import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
// removed unused import: drift
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/providers/github_provider.dart';
import 'package:github_notes/services/github_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadToken();
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
  }

  Future<void> _saveToken() async {
    final database = ref.read(databaseProvider);
    final token = _tokenController.text.trim();
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'github_token', value: token);
    // also persist in DB for compatibility
    await database.saveGithubToken(token);
    // refresh token provider so consumers use the new value
    ref.invalidate(githubTokenProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GitHub token saved (secure)')),
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
        backgroundColor: isValid ? Colors.green : Colors.red,
      ),
    );
  }

  void _showAddFileDialog() {
    final ownerController = TextEditingController();
    final repoController = TextEditingController();
    final pathController = TextEditingController();
    final nicknameController = TextEditingController();
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
                  hintText: 'e.g., sedounet',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: repoController,
                decoration: const InputDecoration(
                  labelText: 'Repository',
                  hintText: 'e.g., dotlyn-apps',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pathController,
                decoration: const InputDecoration(
                  labelText: 'File Path',
                  hintText: 'e.g., _docs/apps/money_tracker/PROMPT_USER.md',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'e.g., Money Tracker - User Prompt',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
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
              Navigator.pop(parentContext);
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text('File added successfully')),
              );
            },
            child: const Text('Add'),
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
              suffixIcon: _tokenValid != null
                  ? Icon(
                      _tokenValid! ? Icons.check_circle : Icons.error,
                      color: _tokenValid! ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            obscureText: true,
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
                  onPressed: _saveToken,
                  child: const Text('Save Token'),
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
                await showDialog<void>(
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
                          if (token != null) Clipboard.setData(ClipboardData(text: token));
                          Navigator.pop(ctx);
                        },
                        child: const Text('Copy'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show token (debug)'),
            ),
          ],

          const SizedBox(height: 32),
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
                onPressed: _showAddFileDialog,
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final parentContext = context;
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
                                    backgroundColor: Colors.red,
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
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(content: Text('File removed')),
                            );
                          }
                        },
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
