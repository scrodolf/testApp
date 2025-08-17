import 'package:flutter/material.dart';

/// Placeholder screen for upcoming QR code scanning feature.
class QrScannerPlaceholderScreen extends StatelessWidget {
  const QrScannerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('QR Scanner')), 
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'QR scanning will allow quick product lookup.\n'
            'Camera permission will be requested when implemented.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
