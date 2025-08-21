import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// Exception thrown when validation of product data fails.
class ProductValidationException implements Exception {
  final String message;
  ProductValidationException(this.message);
  @override
  String toString() => 'ProductValidationException: ' + message;
}

/// Exception thrown when a product could not be found.
class ProductNotFoundException implements Exception {
  final int id;
  ProductNotFoundException(this.id);
  @override
  String toString() => 'Product with id ' + id.toString() + ' not found';
}

/// Aggregated view of a product with its category values and unit overrides.
class ProductWithDetails {
  final Product product;
  final Map<int, double> categoryValues; // categoryId -> amountBase
  final Map<int, double> unitOverrides; // unitId -> amountBase

  ProductWithDetails({
    required this.product,
    required this.categoryValues,
    required this.unitOverrides,
  });
}

class ProductRepository {
  ProductRepository(this._db);
  final AppDatabase _db;

  double _round4(double value) => double.parse(value.toStringAsFixed(4));

  Future<void> addProduct({
    required String name,
    required double defaultServingSize,
    required int defaultUnitId,
    required Map<int, double> categoryValues,
    Map<int, double>? unitOverrides,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ProductValidationException('Name is required');
    }

    final existingByName = await (_db.select(_db.products)
          ..where((p) => p.name.equals(trimmedName)))
        .getSingleOrNull();
    if (existingByName != null) {
      throw ProductValidationException('Product with name "$trimmedName" already exists');
    }

    if (defaultServingSize < 0) {
      throw ProductValidationException('defaultServingSize must be non-negative');
    }

    final unit = await (_db.select(_db.units)
          ..where((u) => u.id.equals(defaultUnitId)))
        .getSingleOrNull();
    if (unit == null) {
      throw ProductValidationException('defaultUnitId $defaultUnitId does not exist');
    }

    for (final entry in categoryValues.entries) {
      if (entry.value < 0) {
        throw ProductValidationException('Value for category ${entry.key} must be non-negative');
      }
      final categoryExists = await (_db.select(_db.categories)
            ..where((c) => c.id.equals(entry.key)))
          .getSingleOrNull();
      if (categoryExists == null) {
        throw ProductValidationException('Category id ${entry.key} does not exist');
      }
    }

    if (unitOverrides != null) {
      for (final entry in unitOverrides.entries) {
        if (entry.value < 0) {
          throw ProductValidationException('Override for unit ${entry.key} must be non-negative');
        }
        final unitExists = await (_db.select(_db.units)
              ..where((u) => u.id.equals(entry.key)))
            .getSingleOrNull();
        if (unitExists == null) {
          throw ProductValidationException('Override unit id ${entry.key} does not exist');
        }
      }
    }

    await _db.transaction(() async {
      final productId = await _db.into(_db.products).insert(ProductsCompanion.insert(
            name: trimmedName,
            servingAmountBase: _round4(defaultServingSize),
            servingUnitId: defaultUnitId,
          ));

      await _db.batch((batch) {
        batch.insertAll(
            _db.productCategoryValues,
            categoryValues.entries
                .map((e) => ProductCategoryValuesCompanion.insert(
                      productId: productId,
                      categoryId: e.key,
                      amountBase: _round4(e.value),
                    ))
                .toList());
        if (unitOverrides != null && unitOverrides.isNotEmpty) {
          batch.insertAll(
              _db.productUnitOverrides,
              unitOverrides.entries
                  .map((e) => ProductUnitOverridesCompanion.insert(
                        productId: productId,
                        unitId: e.key,
                        amountBase: _round4(e.value),
                      ))
                  .toList());
        }
      });
    });
  }

  Future<List<ProductWithDetails>> getProducts() async {
    final productsList = await _db.select(_db.products).get();
    final result = <ProductWithDetails>[];
    for (final p in productsList) {
      final categoriesRows = await (_db.select(_db.productCategoryValues)
            ..where((c) => c.productId.equals(p.id)))
          .get();
      final catMap = {for (var row in categoriesRows) row.categoryId: row.amountBase};

      final overrideRows = await (_db.select(_db.productUnitOverrides)
            ..where((u) => u.productId.equals(p.id)))
          .get();
      final overrideMap = {for (var row in overrideRows) row.unitId: row.amountBase};

      result.add(ProductWithDetails(
          product: p, categoryValues: catMap, unitOverrides: overrideMap));
    }
    return result;
  }

  Future<ProductWithDetails?> getProductById(int productId) async {
    final product = await (_db.select(_db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) return null;

    final categoriesRows = await (_db.select(_db.productCategoryValues)
          ..where((c) => c.productId.equals(productId)))
        .get();
    final catMap = {for (var row in categoriesRows) row.categoryId: row.amountBase};

    final overrideRows = await (_db.select(_db.productUnitOverrides)
          ..where((u) => u.productId.equals(productId)))
        .get();
    final overrideMap = {for (var row in overrideRows) row.unitId: row.amountBase};

    return ProductWithDetails(
        product: product, categoryValues: catMap, unitOverrides: overrideMap);
  }

  Future<void> updateProduct({
    required int productId,
    String? name,
    double? defaultServingSize,
    int? defaultUnitId,
    Map<int, double>? categoryValues,
    Map<int, double>? unitOverrides,
  }) async {
    final existing = await (_db.select(_db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (existing == null) {
      throw ProductNotFoundException(productId);
    }

    final trimmedName = name?.trim();
    if (trimmedName != null) {
      if (trimmedName.isEmpty) {
        throw ProductValidationException('Name is required');
      }
      final sameName = await (_db.select(_db.products)
            ..where((p) => p.name.equals(trimmedName)))
          .get();
      if (sameName.any((p) => p.id != productId)) {
        throw ProductValidationException('Product with name "$trimmedName" already exists');
      }
    }

    if (defaultServingSize != null && defaultServingSize < 0) {
      throw ProductValidationException('defaultServingSize must be non-negative');
    }

    if (defaultUnitId != null) {
      final unit = await (_db.select(_db.units)
            ..where((u) => u.id.equals(defaultUnitId)))
          .getSingleOrNull();
      if (unit == null) {
        throw ProductValidationException('defaultUnitId $defaultUnitId does not exist');
      }
    }

    if (categoryValues != null) {
      for (final entry in categoryValues.entries) {
        if (entry.value < 0) {
          throw ProductValidationException('Value for category ${entry.key} must be non-negative');
        }
        final categoryExists = await (_db.select(_db.categories)
              ..where((c) => c.id.equals(entry.key)))
            .getSingleOrNull();
        if (categoryExists == null) {
          throw ProductValidationException('Category id ${entry.key} does not exist');
        }
      }
    }

    if (unitOverrides != null) {
      for (final entry in unitOverrides.entries) {
        if (entry.value < 0) {
          throw ProductValidationException('Override for unit ${entry.key} must be non-negative');
        }
        final unitExists = await (_db.select(_db.units)
              ..where((u) => u.id.equals(entry.key)))
            .getSingleOrNull();
        if (unitExists == null) {
          throw ProductValidationException('Override unit id ${entry.key} does not exist');
        }
      }
    }

    await _db.transaction(() async {
      if (name != null || defaultServingSize != null || defaultUnitId != null) {
        final companion = ProductsCompanion(
          name: name != null ? Value(trimmedName!) : const Value.absent(),
          servingAmountBase: defaultServingSize != null
              ? Value(_round4(defaultServingSize))
              : const Value.absent(),
          servingUnitId: defaultUnitId != null ? Value(defaultUnitId) : const Value.absent(),
        );
        await (_db.update(_db.products)
              ..where((p) => p.id.equals(productId)))
            .write(companion);
      }

      if (categoryValues != null) {
        await (_db.delete(_db.productCategoryValues)
              ..where((c) => c.productId.equals(productId)))
            .go();
        await _db.batch((batch) {
          batch.insertAll(
              _db.productCategoryValues,
              categoryValues.entries
                  .map((e) => ProductCategoryValuesCompanion.insert(
                        productId: productId,
                        categoryId: e.key,
                        amountBase: _round4(e.value),
                      ))
                  .toList());
        });
      }

      if (unitOverrides != null) {
        await (_db.delete(_db.productUnitOverrides)
              ..where((u) => u.productId.equals(productId)))
            .go();
        if (unitOverrides.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
                _db.productUnitOverrides,
                unitOverrides.entries
                    .map((e) => ProductUnitOverridesCompanion.insert(
                          productId: productId,
                          unitId: e.key,
                          amountBase: _round4(e.value),
                        ))
                    .toList());
          });
        }
      }
    });
  }

  Future<void> deleteProduct(int productId) async {
    final deleted = await _db.transaction(() async {
      await (_db.delete(_db.productCategoryValues)
            ..where((c) => c.productId.equals(productId)))
          .go();
      await (_db.delete(_db.productUnitOverrides)
            ..where((u) => u.productId.equals(productId)))
          .go();
      return await (_db.delete(_db.products)
            ..where((p) => p.id.equals(productId)))
          .go();
    });
    if (deleted == 0) {
      throw ProductNotFoundException(productId);
    }
  }
}
