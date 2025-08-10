import 'package:flutter/material.dart';

class SelectProductsScreen extends StatelessWidget {
  const SelectProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Products')),
      body: const Center(child: Text('Product selection list goes here')),
    );
  }
}
