import 'package:flutter/material.dart';

/// Debug-only screen that would populate the database with sample content.
class DebugSampleDataScreen extends StatelessWidget {
  const DebugSampleDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Data')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sample data creation stubbed.')),
            );
          },
          child: const Text('Create sample data'),
        ),
      ),
    );
  }
}
