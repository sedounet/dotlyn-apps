import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/data/database/app_database.dart' as db;
import 'package:github_notes/screens/file_editor_screen.dart';
import 'package:github_notes/screens/settings_screen.dart';
// using generated DB types from app_database.dart (aliased as `db`)

class FilesListScreen extends ConsumerWidget {
  const FilesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectFilesAsync = ref.watch(projectFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: projectFilesAsync.when(
          data: (files) {
            if (files.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_add, size: 64, color: DotlynColors.primary.withAlpha(128)),
                    const SizedBox(height: 16),
                    Text(
                      'No files configured',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Go to Settings to add files'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Open Settings'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return FileCard(
                  file: file,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FileEditorScreen(projectFile: file),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}

class FileCard extends ConsumerWidget {
  final db.ProjectFile file;
  final VoidCallback onTap;

  const FileCard({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileContentAsync = ref.watch(fileContentProvider(file.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      file.nickname,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  fileContentAsync.when(
                    data: (content) {
                      if (content == null) return const SizedBox.shrink();
                      return _SyncStatusBadge(syncStatus: content.syncStatus);
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${file.owner}/${file.repo}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DotlynColors.secondary.withAlpha(179),
                    ),
              ),
              Text(
                file.path,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DotlynColors.secondary.withAlpha(128),
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final String syncStatus;

  const _SyncStatusBadge({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (syncStatus) {
      case 'synced':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Synced';
        break;
      case 'modified':
        color = DotlynColors.primary;
        icon = Icons.edit;
        label = 'Modified';
        break;
      case 'conflict':
        color = Colors.red;
        icon = Icons.warning;
        label = 'Conflict';
        break;
      case 'error':
        color = Colors.red;
        icon = Icons.error;
        label = 'Error';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((0.3 * 255).round())),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
