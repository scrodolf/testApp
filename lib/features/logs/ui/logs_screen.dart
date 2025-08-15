import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Logs Screen Content\nTrack what you eat here in the future.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
