import 'package:flutter/material.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

class SnackHelper {
  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    _show(context, message,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, duration: duration);
  }

  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, backgroundColor: DotlynColors.success, duration: duration);
  }

  static void showError(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, backgroundColor: DotlynColors.error, duration: duration);
  }

  static void _show(BuildContext context, String message,
      {Color? backgroundColor, Duration? duration}) {
    final messenger = ScaffoldMessenger.of(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final marginBottom = bottomPadding + 80.0; // place above action buttons

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, marginBottom),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
