import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Statistics Screen Content'),
            SizedBox(height: 8),
            Text(
              'Visualize your progress over time here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
