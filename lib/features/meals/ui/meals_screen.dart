import 'package:flutter/material.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Meals Screen Content\nPlan and compose meals from products here later.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
