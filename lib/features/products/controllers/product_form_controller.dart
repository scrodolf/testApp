import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';

/// Handles saving of products from the form UI.
class ProductFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Persists a product via the [IProductRepository].
  Future<void> saveProduct({
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
    required List<UnitOverrideInput> unitOverrides,
=======
  }) async {
    state = const AsyncLoading();
    final repo = await ref.watch(productRepositoryProvider.future);
    try {
      await repo.insertProduct(
        name: name,
        defaultServingSize: defaultServingSize,
        defaultServingUnitId: defaultServingUnitId,
        categoryValues: categoryValues,
        unitOverrides: unitOverrides,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Updates an existing product via the [IProductRepository].
  Future<void> updateProduct({
    required int id,
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
    required List<UnitOverrideInput> unitOverrides,
  }) async {
    state = const AsyncLoading();
    final repo = await ref.watch(productRepositoryProvider.future);
    try {
      await repo.updateProduct(
        id: id,
        name: name,
        defaultServingSize: defaultServingSize,
        defaultServingUnitId: defaultServingUnitId,
        categoryValues: categoryValues,
        unitOverrides: unitOverrides,
=======
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final productFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProductFormController, void>(
        ProductFormController.new);
