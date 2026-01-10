import 'package:flutter/material.dart';
import 'package:github_notes/models/sync_result.dart';

/// Dialog shown when file has conflicts on GitHub
class ConflictDialog extends StatelessWidget {
  final String remoteSha;

  const ConflictDialog({
    Key? key,
    required this.remoteSha,
  }) : super(key: key);

  static Future<ConflictChoice?> show(
    BuildContext context, {
    required String remoteSha,
  }) async {
    return showDialog<ConflictChoice?>(
      context: context,
      builder: (ctx) => ConflictDialog(remoteSha: remoteSha),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Conflict detected'),
      content: const Text('The file changed on GitHub since your last sync.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.fetchRemote),
          child: const Text('Fetch remote'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ConflictChoice.overwriteGitHub),
          child: const Text('Overwrite GitHub'),
        ),
      ],
    );
  }
}
