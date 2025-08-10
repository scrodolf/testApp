import 'package:flutter/material.dart';

class SelectMealsScreen extends StatelessWidget {
  const SelectMealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Meals')),
      body: const Center(child: Text('Meal selection list goes here')),
    );
  }
}
