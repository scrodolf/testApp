import 'package:flutter/material.dart';

class NewLogScreen extends StatelessWidget {
  const NewLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Log')),
      body: const Center(child: Text('Select meals or products to log.')),
    );
  }
}
