import 'package:flutter/material.dart';
import 'package:github_notes/widgets/field_help_button.dart';
import '../l10n/app_localizations.dart';

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
    _nicknameController = TextEditingController(text: widget.initial?.nickname ?? '');
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.ownerLabel,
                hintText: AppLocalizations.of(context)!.ownerHint,
                suffixIcon: FieldHelpButton(
                  message: AppLocalizations.of(context)!.ownerHint,
                ),
              ),
              maxLines: 1,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppLocalizations.of(context)!.ownerRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _repoController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.repoLabel,
                hintText: AppLocalizations.of(context)!.repoHint,
                suffixIcon: FieldHelpButton(
                  message: AppLocalizations.of(context)!.repoHint,
                ),
              ),
              maxLines: 1,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppLocalizations.of(context)!.repoRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.pathLabel,
                hintText: AppLocalizations.of(context)!.pathHint,
                suffixIcon: FieldHelpButton(
                  message: AppLocalizations.of(context)!.pathHint,
                ),
              ),
              maxLines: 2,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppLocalizations.of(context)!.pathRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nicknameLabel,
                hintText: AppLocalizations.of(context)!.nicknameHint,
                suffixIcon: FieldHelpButton(
                  message: AppLocalizations.of(context)!.nicknameHint,
                ),
              ),
              maxLines: 1,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppLocalizations.of(context)!.nicknameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.submitLabel == 'Add'
                      ? AppLocalizations.of(context)!.add
                      : widget.submitLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
