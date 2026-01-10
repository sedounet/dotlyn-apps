import 'package:flutter/material.dart';

/// Reusable dialog helpers to reduce boilerplate across screens
class DialogHelpers {
  /// Show a yes/no confirmation dialog
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String yesLabel = 'Yes',
    String noLabel = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(noLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(yesLabel),
          ),
        ],
      ),
    );
  }

  /// Show an error dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show a message dialog
  static Future<void> showMessageDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await showErrorDialog(context, title: title, message: message);
  }
}
