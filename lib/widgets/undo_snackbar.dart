import 'package:flutter/material.dart';

/// Shows a SnackBar with an UNDO action and semantics support.
void showUndoSnackbar(
  BuildContext context, {
  required String message,
  required String undoLabel,
  required VoidCallback onUndo,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, semanticsLabel: message),
      action: SnackBarAction(label: undoLabel, onPressed: onUndo),
      duration: const Duration(seconds: 3),
    ),
  );
}
