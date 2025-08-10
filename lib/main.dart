import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodTrackerApp());
}

class FoodTrackerApp extends StatelessWidget {
  const FoodTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
