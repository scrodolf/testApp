import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Settings Screen Content'),
            SizedBox(height: 8),
            Text(
              'Adjust your app preferences here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
