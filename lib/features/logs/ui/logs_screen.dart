import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Logs Screen Content'),
            SizedBox(height: 8),
            Text(
              'Review and add daily food logs here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
