import 'package:flutter/material.dart';

/// Common button styles ensuring 48dp tap targets and visible
/// pressed/disabled states.
class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primary(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(64, 48)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withAlpha(31);
        }
        if (states.contains(WidgetState.pressed)) {
          return scheme.primary.withAlpha(204);
        }
        return scheme.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withAlpha(97);
        }
        return scheme.onPrimary;
      }),
    );
  }
}
