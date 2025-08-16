import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';

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
              return Dismissible(
                key: ValueKey(p.product.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete product'),
                          content: Text(
                              'Are you sure you want to delete "${p.product.name}"?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Delete')),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (_) async {
                  final repo = await ref.read(productRepositoryProvider.future);
                  final registry = await ref.read(unitRegistryProvider.future);
                  final conversion =
                      await ref.read(conversionServiceProvider.future);
                  await repo.deleteProduct(p.product.id);
                  final snack = SnackBar(
                    content: const Text('Product deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        final overrideMap = {
                          for (final o in p.unitOverrides)
                            o.unit.id: o.factorToBase
                        };
                        final categoryInputs = <CategoryValueInput>[];
                        for (final detail in p.values) {
                          final units = await registry.getUnitsByDimension(
                              detail.category.baseDimension);
                          final baseUnit = units.firstWhere(
                              (u) => u.factorToBase == 1,
                              orElse: () => units.first);
                          final original = await conversion.convert(
                              detail.value, baseUnit.id, detail.unit.id,
                              customUnitFactors: overrideMap);
                          categoryInputs.add(CategoryValueInput(
                              categoryId: detail.category.id,
                              value: original,
                              unitId: detail.unit.id));
                        }
                        final overrideInputs = p.unitOverrides
                            .map((o) => UnitOverrideInput(
                                unitId: o.unit.id,
                                factorToBase: o.factorToBase))
                            .toList();
                        await repo.insertProduct(
                          name: p.product.name,
                          defaultServingSize: p.product.defaultServingSize,
                          defaultServingUnitId: p.defaultUnit.id,
                          categoryValues: categoryInputs,
                          unitOverrides: overrideInputs,
                        );
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                },
                child: ListTile(
                  title: Text(p.product.name),
                  subtitle: Text(
                      '${p.product.defaultServingSize} ${p.defaultUnit.name}'),
                  onTap: () => context.push('/products/${p.product.id}'),
                ),
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
