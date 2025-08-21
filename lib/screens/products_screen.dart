import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/product_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Displays the list of products with support for adding, editing and
/// deleting items. Uses [AnimatedList] for smooth insert/remove animations
/// and shows an UNDO snackbar on deletions.
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<ProductWithDetails> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(productRepositoryProvider);
    final products = await repo.getProducts();
    setState(() {
      _items.clear();
      _items.addAll(products);
      _loading = false;
    });
  }

  Future<void> _addProduct() async {
    final result = await context.push<ProductWithDetails>('/products/new');
    if (result != null) {
      setState(() {
        _items.insert(0, result);
        _listKey.currentState?.insertItem(0);
      });
    }
  }

  Future<void> _editProduct(ProductWithDetails product, int index) async {
    final result = await context.push<ProductWithDetails>(
      '/products/${product.product.id}',
    );
    if (result != null) {
      setState(() {
        _items[index] = result;
      });
    }
  }

  Future<void> _deleteProduct(int index) async {
    final repo = ref.read(productRepositoryProvider);
    final removed = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildItem(removed, index),
      ),
    );
    await repo.deleteProduct(removed.product.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.productDeleted),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undoButton,
          onPressed: () async {
            await repo.addProduct(
              name: removed.product.name,
              defaultServingSize: removed.product.servingAmountBase,
              defaultUnitId: removed.product.servingUnitId,
              categoryValues: removed.categoryValues,
              unitOverrides: removed.unitOverrides.isEmpty
                  ? null
                  : removed.unitOverrides,
            );
            await _load();
          },
        ),
      ),
    );
  }

  Widget _buildItem(ProductWithDetails product, int index) {
    return Semantics(
      button: true,
      label: product.product.name,
      child: ListTile(
        title: Text(product.product.name),
        onTap: () => _editProduct(product, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.productsTitle)),
      body: _items.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.productsEmpty))
          : AnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                final product = _items[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: Dismissible(
                    key: ValueKey(product.product.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteProduct(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Theme.of(context).colorScheme.error,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    child: _buildItem(product, index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        tooltip: AppLocalizations.of(context)!.addProductTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}

