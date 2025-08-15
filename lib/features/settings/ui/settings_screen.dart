import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Settings Screen Content\nConfigure your app preferences here later.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
