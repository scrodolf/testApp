import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Placeholder screen for upcoming QR code scanning feature.
class QrScannerPlaceholderScreen extends StatefulWidget {
  const QrScannerPlaceholderScreen({super.key});

  @override
  State<QrScannerPlaceholderScreen> createState() => _QrScannerPlaceholderState();
}

class _QrScannerPlaceholderState extends State<QrScannerPlaceholderScreen> {
  @override
  void initState() {
    super.initState();
    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'QR scanning will allow quick product lookup.\n'
            'Camera permission is requested on entry.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
