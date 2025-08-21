import 'package:flutter/material.dart';

/// Common button styles ensuring 48dp tap targets and visible
/// pressed/disabled states.
class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primary(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(64, 48)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return scheme.onSurface.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return scheme.primary.withOpacity(0.8);
        }
        return scheme.primary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return scheme.onSurface.withOpacity(0.38);
        }
        return scheme.onPrimary;
      }),
    );
  }
}
