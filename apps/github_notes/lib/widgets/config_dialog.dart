import 'package:flutter/material.dart';
import 'package:github_notes/data/database/app_database.dart';
import 'package:github_notes/widgets/field_help_button.dart';

/// Reusable configuration dialog for inline path/owner/repo setup
class ConfigDialog extends StatefulWidget {
  final ProjectFile projectFile;

  const ConfigDialog({Key? key, required this.projectFile}) : super(key: key);

  static Future<ProjectFile?> show(
    BuildContext context, {
    required ProjectFile projectFile,
  }) async {
    return showDialog<ProjectFile?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Configure File'),
        content: ConfigDialog(projectFile: projectFile),
      ),
    );
  }

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  late TextEditingController ownerController;
  late TextEditingController repoController;
  late TextEditingController pathController;

  @override
  void initState() {
    super.initState();
    ownerController = TextEditingController(text: widget.projectFile.owner);
    repoController = TextEditingController(text: widget.projectFile.repo);
    pathController = TextEditingController(text: widget.projectFile.path);
  }

  @override
  void dispose() {
    ownerController.dispose();
    repoController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: 'Owner',
              hintText: 'e.g., johndoe',
              suffixIcon: FieldHelpButton(
                message: 'GitHub owner: username or organization',
              ),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: repoController,
            decoration: const InputDecoration(
              labelText: 'Repository',
              hintText: 'e.g., myapp',
              suffixIcon: FieldHelpButton(
                message: 'Repository name inside the owner/org',
              ),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: pathController,
            decoration: const InputDecoration(
              labelText: 'File Path',
              hintText: 'e.g., README.md',
              suffixIcon: FieldHelpButton(
                message: 'Relative path in the repo',
              ),
            ),
            maxLines: 2,
            minLines: 1,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}
