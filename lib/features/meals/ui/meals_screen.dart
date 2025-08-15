import 'package:flutter/material.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Meals Screen Content'),
            SizedBox(height: 8),
            Text(
              'Plan and manage meals in this section.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
