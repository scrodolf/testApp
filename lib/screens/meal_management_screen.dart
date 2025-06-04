import 'package:flutter/material.dart';

class MealManagementScreen extends StatelessWidget {
  const MealManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Meals')),
      body: const Center(child: Text('List of meals with nutrients')),
    );
  }
}
