import 'package:flutter/material.dart';

/// Dialog de confirmation générique
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Color? confirmColor;
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Annuler',
    this.confirmText = 'Confirmer',
    this.confirmColor,
    this.isDangerous = false,
  });

  /// Affiche le dialog et retourne true si confirmé
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Annuler',
    String confirmText = 'Confirmer',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmColor: confirmColor,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmColor = confirmColor ??
        (isDangerous ? theme.colorScheme.error : theme.colorScheme.primary);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDangerous || confirmColor != null
              ? ElevatedButton.styleFrom(
                  backgroundColor: effectiveConfirmColor,
                  foregroundColor: theme.colorScheme.onError,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}
