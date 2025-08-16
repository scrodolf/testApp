import 'package:food_app/data/daos/product_dao.dart';

/// Represents raw user input for a category value before conversion.
class CategoryValueInput {
  CategoryValueInput(
      {required this.categoryId, required this.value, required this.unitId});

  final int categoryId;
  final double value;
  final int unitId;
}

/// Raw user input representing a unit override for a product.
class UnitOverrideInput {
  UnitOverrideInput({required this.unitId, required this.factorToBase});

  final int unitId;
  final double factorToBase;
}

/// Abstraction for product persistence and retrieval.
abstract class IProductRepository {
  /// Watches all products and emits updates whenever data changes.
  Stream<List<ProductWithDetails>> watchAllProducts();

  /// Retrieves a product by [id].
  Future<ProductWithDetails?> getProductById(int id);

  /// Watches a single product and emits updates whenever it changes.
  Stream<ProductWithDetails?> watchProductById(int id);

  /// Inserts a new product and returns its identifier.
  Future<int> insertProduct({
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
    required List<UnitOverrideInput> unitOverrides,
  });

  /// Updates an existing product. Returns `true` if any row was affected.
  Future<bool> updateProduct({
    required int id,
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
    required List<UnitOverrideInput> unitOverrides,
  });

  /// Deletes a product by [id].
  Future<void> deleteProduct(int id);
}
