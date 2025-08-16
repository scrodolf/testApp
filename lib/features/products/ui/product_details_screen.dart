import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/data/daos/product_dao.dart';

/// Displays details for a single product and offers edit/delete actions.
class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  Future<double> _toOriginal(WidgetRef ref, ProductWithDetails product,
      CategoryValueDetail detail) async {
    final registry = await ref.read(unitRegistryProvider.future);
    final conversion = await ref.read(conversionServiceProvider.future);
    final units =
        await registry.getUnitsByDimension(detail.category.baseDimension);
    final baseUnit =
        units.firstWhere((u) => u.factorToBase == 1, orElse: () => units.first);
    return conversion.convert(detail.value, baseUnit.id, detail.unit.id,
        customUnitFactors: product.product.customUnitRatios);
  }

  Future<void> _deleteWithUndo(
      BuildContext context, WidgetRef ref, ProductWithDetails product) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete product'),
            content: Text(
                'Are you sure you want to delete "${product.product.name}"? This action cannot be undone.'),
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
    if (!confirmed) return;

    final repo = await ref.read(productRepositoryProvider.future);
    final registry = await ref.read(unitRegistryProvider.future);
    final conversion = await ref.read(conversionServiceProvider.future);

    await repo.deleteProduct(product.product.id);

    final snack = SnackBar(
      content: const Text('Product deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          final categoryInputs = <CategoryValueInput>[];
          for (final detail in product.values) {
            final units = await registry
                .getUnitsByDimension(detail.category.baseDimension);
            final baseUnit = units.firstWhere((u) => u.factorToBase == 1,
                orElse: () => units.first);
            final original = await conversion.convert(
                detail.value, baseUnit.id, detail.unit.id,
                customUnitFactors: product.product.customUnitRatios);
            categoryInputs.add(CategoryValueInput(
                categoryId: detail.category.id,
                value: original,
                unitId: detail.unit.id));
          }
          await repo.insertProduct(
            name: product.product.name,
            defaultServingSize: product.product.defaultServingSize,
            defaultServingUnitId: product.defaultUnit.id,
            categoryValues: categoryInputs,
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
    if (context.mounted) {
      context.go('/products');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: productAsync.maybeWhen(
            data: (p) => Text(p?.product.name ?? ''),
            orElse: () => const Text('')),
        actions: [
          productAsync.maybeWhen(
            data: (p) => IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  p == null ? null : () => _deleteWithUndo(context, ref, p),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: productAsync.maybeWhen(
        data: (p) => FloatingActionButton(
          onPressed: p == null
              ? null
              : () => context.push('/products/${p.product.id}/edit'),
          child: const Icon(Icons.edit),
        ),
        orElse: () => null,
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${product.product.defaultServingSize} ${product.defaultUnit.name}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ...product.values.map((detail) => FutureBuilder<double>(
                    future: _toOriginal(ref, product, detail),
                    builder: (context, snapshot) {
                      final orig = snapshot.data;
                      return ListTile(
                        title: Text(detail.category.name),
                        subtitle: orig == null
                            ? const Text('')
                            : Text(
                                '${orig.toStringAsFixed(2)} ${detail.unit.name} (${detail.value.toStringAsFixed(2)} base)'),
                      );
                    },
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
