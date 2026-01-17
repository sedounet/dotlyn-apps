import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/screens/file_editor_screen.dart';
import 'package:github_notes/screens/settings_screen.dart';
import 'package:github_notes/widgets/file_card.dart';
import '../l10n/app_localizations.dart';
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
        child: Column(
          children: [
            // Widget de test pour la localisation
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.copilotTest,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            Expanded(
              child: projectFilesAsync.when(
                loading: () => const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                data: (files) {
                  if (files.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note_add,
                              size: 64, color: DotlynColors.primary.withAlpha(128)),
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
                        onDuplicate: (f) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsScreen(editingFile: f)),
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
