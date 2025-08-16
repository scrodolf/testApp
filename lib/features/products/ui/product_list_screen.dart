import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';

/// Displays all products stored in the database.
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);
    return Scaffold(
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No products yet. Tap + to add your first one.'),
              ),
            );
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p.product.name),
                subtitle: Text(
                    '${p.product.defaultServingSize} ${p.defaultUnit.name}'),
                onTap: () => context.push('/products/${p.product.id}'),

              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/products/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
