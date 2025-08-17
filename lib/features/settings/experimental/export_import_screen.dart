import 'package:flutter/material.dart';

/// Placeholder screen for data export/import feature.
class ExportImportPlaceholderScreen extends StatelessWidget {
  const ExportImportPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Export / Import')), 
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Future versions will allow exporting your logs to JSON\n'
            'and restoring them on another device.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
