import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Products Screen Content\nMaintain your product list here in the future.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
