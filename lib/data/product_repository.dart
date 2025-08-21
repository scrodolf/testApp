import 'package:riverpod/riverpod.dart';
import 'package:drift/drift.dart';

import 'local/app_database.dart';

/// Provides a singleton instance of [AppDatabase].
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Riverpod provider for [ProductRepository].
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductRepository(db);
});

/// Domain model representing a product with associated category values and
/// optional unit overrides.
class ProductWithDetails {
  ProductWithDetails({
    required this.product,
    required this.categoryValues,
    required this.unitOverrides,
  });

  final Product product;
  final Map<int, double> categoryValues;
  final Map<int, double> unitOverrides;
}

/// Exception thrown when validation fails for product operations.
class ProductValidationException implements Exception {
  ProductValidationException(this.message);
  final String message;
  @override
  String toString() => 'ProductValidationException: $message';
}

/// Exception thrown when a product could not be located in the database.
class ProductNotFoundException implements Exception {
  ProductNotFoundException(this.productId);
  final int productId;
  @override
  String toString() => 'ProductNotFoundException: $productId';
}

class ProductRepository {
  ProductRepository(this._db);

  final AppDatabase _db;

  double _fix(double value) => double.parse(value.toStringAsFixed(4));

  Future<void> addProduct({
    required String name,
    required double defaultServingSize,
    required int defaultUnitId,
    required Map<int, double> categoryValues,
    Map<int, double>? unitOverrides,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ProductValidationException('Name must not be empty');
    }

    final existing = await (_db.select(_db.products)
          ..where((p) => p.name.equals(trimmedName)))
        .getSingleOrNull();
    if (existing != null) {
      throw ProductValidationException('Product with same name exists');
    }
    if (defaultServingSize < 0) {
      throw ProductValidationException('defaultServingSize must be >= 0');
    }
    final unit = await (_db.select(_db.units)
          ..where((u) => u.id.equals(defaultUnitId)))
        .getSingleOrNull();
    if (unit == null) {
      throw ProductValidationException('Unit does not exist');
    }
    for (final entry in categoryValues.entries) {
      if (entry.value < 0) {
        throw ProductValidationException('Category value must be >= 0');
      }
    }
    if (unitOverrides != null) {
      for (final entry in unitOverrides.entries) {
        if (entry.value < 0) {
          throw ProductValidationException('Unit override must be >= 0');
        }
      }
    }

    await _db.transaction(() async {
      final productId = await _db.into(_db.products).insert(
            ProductsCompanion.insert(
              name: trimmedName,
              servingAmountBase: _fix(defaultServingSize),
              servingUnitId: defaultUnitId,
            ),
          );

      if (categoryValues.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.productCategoryValues,
            categoryValues.entries
                .map(
                  (e) => ProductCategoryValuesCompanion.insert(
                    productId: productId,
                    categoryId: e.key,
                    amountBase: _fix(e.value),
                    originalUnitId: const Value.absent(),
                  ),
                )
                .toList(),
          );
        });
      }

      if (unitOverrides != null && unitOverrides.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.productUnitOverrides,
            unitOverrides.entries
                .map(
                  (e) => ProductUnitOverridesCompanion.insert(
                    productId: productId,
                    unitId: e.key,
                    amountBase: _fix(e.value),
                  ),
                )
                .toList(),
          );
        });
      }
    });
  }

  Future<List<ProductWithDetails>> getProducts() async {
    final products = await _db.select(_db.products).get();
    final categoryRows = await _db.select(_db.productCategoryValues).get();
    final overrideRows = await _db.select(_db.productUnitOverrides).get();

    return products.map((p) {
      final catMap = <int, double>{};
      for (final row in categoryRows.where((r) => r.productId == p.id)) {
        catMap[row.categoryId] = row.amountBase;
      }
      final unitMap = <int, double>{};
      for (final row in overrideRows.where((r) => r.productId == p.id)) {
        unitMap[row.unitId] = row.amountBase;
      }
      return ProductWithDetails(
        product: p,
        categoryValues: catMap,
        unitOverrides: unitMap,
      );
    }).toList();
  }

  Future<ProductWithDetails?> getProductById(int productId) async {
    final product = await (_db.select(_db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) return null;

    final categoryRows = await (_db.select(_db.productCategoryValues)
          ..where((r) => r.productId.equals(productId)))
        .get();
    final overrideRows = await (_db.select(_db.productUnitOverrides)
          ..where((r) => r.productId.equals(productId)))
        .get();

    return ProductWithDetails(
      product: product,
      categoryValues: {
        for (final row in categoryRows) row.categoryId: row.amountBase,
      },
      unitOverrides: {
        for (final row in overrideRows) row.unitId: row.amountBase,
      },
    );
  }

  Future<void> updateProduct({
    required int productId,
    String? name,
    double? defaultServingSize,
    int? defaultUnitId,
    Map<int, double>? categoryValues,
    Map<int, double>? unitOverrides,
  }) async {
    final product = await (_db.select(_db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) {
      throw ProductNotFoundException(productId);
    }

    final trimmedName = name?.trim();
    if (trimmedName != null) {
      if (trimmedName.isEmpty) {
        throw ProductValidationException('Name must not be empty');
      }
      final existing = await (_db.select(_db.products)
            ..where((p) => p.name.equals(trimmedName)))
          .get();
      if (existing.any((e) => e.id != productId)) {
        throw ProductValidationException('Product with same name exists');
      }
    }
    if (defaultServingSize != null && defaultServingSize < 0) {
      throw ProductValidationException('defaultServingSize must be >= 0');
    }
    if (defaultUnitId != null) {
      final unit = await (_db.select(_db.units)
            ..where((u) => u.id.equals(defaultUnitId)))
          .getSingleOrNull();
      if (unit == null) {
        throw ProductValidationException('Unit does not exist');
      }
    }
    if (categoryValues != null) {
      for (final e in categoryValues.entries) {
        if (e.value < 0) {
          throw ProductValidationException('Category value must be >= 0');
        }
      }
    }
    if (unitOverrides != null) {
      for (final e in unitOverrides.entries) {
        if (e.value < 0) {
          throw ProductValidationException('Unit override must be >= 0');
        }
      }
    }

    await _db.transaction(() async {
      final companion = ProductsCompanion(
        name: trimmedName != null ? Value(trimmedName) : const Value.absent(),
        servingAmountBase: defaultServingSize != null
            ? Value(_fix(defaultServingSize))
            : const Value.absent(),
        servingUnitId:
            defaultUnitId != null ? Value(defaultUnitId) : const Value.absent(),
      );
      await (_db.update(_db.products)
            ..where((p) => p.id.equals(productId)))
          .write(companion);

      if (categoryValues != null) {
        await _db.batch((b) {
          for (final entry in categoryValues.entries) {
            b.insert(
              _db.productCategoryValues,
              ProductCategoryValuesCompanion.insert(
                productId: productId,
                categoryId: entry.key,
                amountBase: _fix(entry.value),
                originalUnitId: const Value.absent(),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }

      if (unitOverrides != null) {
        await _db.batch((b) {
          b.deleteWhere(
            _db.productUnitOverrides,
            (tbl) => tbl.productId.equals(productId),
          );
          for (final entry in unitOverrides.entries) {
            b.insert(
              _db.productUnitOverrides,
              ProductUnitOverridesCompanion.insert(
                productId: productId,
                unitId: entry.key,
                amountBase: _fix(entry.value),
              ),
            );
          }
        });
      }
    });
  }

  Future<void> deleteProduct(int productId) async {
    final deleted = await _db.transaction(() async {
      await (_db.delete(_db.productCategoryValues)
            ..where((tbl) => tbl.productId.equals(productId)))
          .go();
      await (_db.delete(_db.productUnitOverrides)
            ..where((tbl) => tbl.productId.equals(productId)))
          .go();
      return (_db.delete(_db.products)
            ..where((tbl) => tbl.id.equals(productId)))
          .go();
    });
    if (deleted == 0) {
      throw ProductNotFoundException(productId);
    }
  }
}

