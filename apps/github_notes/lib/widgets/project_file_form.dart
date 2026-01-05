import 'package:flutter/material.dart';

/// Minimal data class used by the form dialog.
class ProjectFileData {
  final String owner;
  final String repo;
  final String path;
  final String nickname;

  ProjectFileData({
    required this.owner,
    required this.repo,
    required this.path,
    required this.nickname,
  });
}

/// Reusable form widget used to Add / Edit a tracked file.
///
/// Usage: showDialog<ProjectFileData>(context: context, builder: (_) => AlertDialog(content: ProjectFileForm(initial: ...)))
class ProjectFileForm extends StatefulWidget {
  final ProjectFileData? initial;
  final String submitLabel;

  const ProjectFileForm({
    super.key,
    this.initial,
    this.submitLabel = 'Add',
  });

  @override
  State<ProjectFileForm> createState() => _ProjectFileFormState();
}

class _ProjectFileFormState extends State<ProjectFileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ownerController;
  late final TextEditingController _repoController;
  late final TextEditingController _pathController;
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: widget.initial?.owner ?? '');
    _repoController = TextEditingController(text: widget.initial?.repo ?? '');
    _pathController = TextEditingController(text: widget.initial?.path ?? '');
    _nicknameController =
        TextEditingController(text: widget.initial?.nickname ?? '');
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _repoController.dispose();
    _pathController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final result = ProjectFileData(
      owner: _ownerController.text.trim(),
      repo: _repoController.text.trim(),
      path: _pathController.text.trim(),
      nickname: _nicknameController.text.trim(),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: 'Owner',
                hintText: 'e.g., sedounet',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter owner' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _repoController,
              decoration: const InputDecoration(
                labelText: 'Repository',
                hintText: 'e.g., dotlyn-apps',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter repository'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pathController,
              decoration: const InputDecoration(
                labelText: 'File Path',
                hintText: 'e.g., _docs/apps/money_tracker/PROMPT_USER.md',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter file path'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                hintText: 'e.g., Money Tracker - User Prompt',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a nickname'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.submitLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
