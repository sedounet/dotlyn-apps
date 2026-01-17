import 'package:flutter/material.dart';
import 'package:github_notes/models/sync_result.dart';
import '../l10n/app_localizations.dart';

/// Dialog shown when file has conflicts on GitHub
enum ConflictSituation {
  fileExistsRemote,
  bothModified,
  generic,
}

class ConflictDialog extends StatelessWidget {
  final String remoteSha;
  final ConflictSituation situation;

  const ConflictDialog({
    super.key,
    required this.remoteSha,
    this.situation = ConflictSituation.generic,
  });

  static Future<ConflictChoice?> show(
    BuildContext context, {
    required String remoteSha,
    ConflictSituation situation = ConflictSituation.generic,
  }) async {
    return showDialog<ConflictChoice?>(
      context: context,
      builder: (ctx) => ConflictDialog(remoteSha: remoteSha, situation: situation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String header = switch (situation) {
      ConflictSituation.fileExistsRemote => l10n.conflictFileExistsHeader,
      ConflictSituation.bothModified => l10n.conflictBothModifiedHeader,
      ConflictSituation.generic => l10n.conflictGenericHeader,
    };
    return AlertDialog(
      title: Text(l10n.conflictDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(l10n.conflictDialogDescription),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.cancel),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.fetchRemote),
          child: Text(l10n.conflictFetchRemote),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.overwriteGitHub),
          child: Text(l10n.conflictOverwriteRemote),
        ),
      ],
    );
  }
}
