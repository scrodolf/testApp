import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Statistics Screen Content\nVisualize your intake trends here in the future.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
