import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// Represents a nutritional value for a [Category] along with its unit.
class CategoryValueDetail {
  CategoryValueDetail(
      {required this.category, required this.value, required this.unit});

  final Category category;
  final double value;
  final Unit unit;
}

/// Aggregates a [Product] with its default serving unit and all category values.
class ProductWithDetails {
  ProductWithDetails(
      {required this.product, required this.defaultUnit, required this.values});

  final Product product;
  final Unit defaultUnit;
  final List<CategoryValueDetail> values;
}

/// Data access object responsible for CRUD operations on products and related
/// entities.
class ProductDao {
  ProductDao(this._db);

  final AppDatabase _db;

  /// Ensures built-in categories exist in the database.
  Future<void> ensureBaseCategories() async {
    final existing = await _db.select(_db.categories).get();
    if (existing.isNotEmpty) return;

    final gram = await (_db.select(_db.units)
          ..where((u) => u.name.equals('gram')))
        .getSingle();
    final kcal = await (_db.select(_db.units)
          ..where((u) => u.name.equals('kilocalorie')))
        .getSingle();

    await _db.batch((batch) {
      batch.insertAll(_db.categories, [
        CategoriesCompanion(
          name: const Value('Calories'),
          baseDimension: const Value('energy'),
          defaultDisplayUnitId: Value(kcal.id),
        ),
        CategoriesCompanion(
          name: const Value('Fat'),
          baseDimension: const Value('mass'),
          defaultDisplayUnitId: Value(gram.id),
        ),
        CategoriesCompanion(
          name: const Value('Protein'),
          baseDimension: const Value('mass'),
          defaultDisplayUnitId: Value(gram.id),
        ),
        CategoriesCompanion(
          name: const Value('Carbs'),
          baseDimension: const Value('mass'),
          defaultDisplayUnitId: Value(gram.id),
        ),
        CategoriesCompanion(
          name: const Value('Fiber'),
          baseDimension: const Value('mass'),
          defaultDisplayUnitId: Value(gram.id),
        ),
      ]);
    });
  }

  /// Retrieves all products with their details.
  Future<List<ProductWithDetails>> getAllProducts() async {
    final productsQuery = _db.select(_db.products).join([
      innerJoin(
          _db.units, _db.units.id.equalsExp(_db.products.defaultServingUnitId)),
    ]);
    final productRows = await productsQuery.get();

    final results = <ProductWithDetails>[];
    for (final row in productRows) {
      final product = row.readTable(_db.products);
      final unit = row.readTable(_db.units);

      final valuesRows = await _db.select(_db.productCategoryValues).join([
        innerJoin(_db.categories,
            _db.categories.id.equalsExp(_db.productCategoryValues.categoryId)),
        innerJoin(_db.units,
            _db.units.id.equalsExp(_db.productCategoryValues.unitId)),
      ])
        ..where(_db.productCategoryValues.productId.equals(product.id));
      final fetched = await valuesRows.get();
      final details = fetched
          .map((r) => CategoryValueDetail(
                category: r.readTable(_db.categories),
                value: r.readTable(_db.productCategoryValues).value,
                unit: r.readTable(_db.units),
              ))
          .toList();

      results.add(ProductWithDetails(
          product: product, defaultUnit: unit, values: details));
    }
    return results;
  }

  /// Watches all products and emits updates whenever the underlying tables
  /// change.
  Stream<List<ProductWithDetails>> watchAllProducts() {
    return _db.select(_db.products).watch().asyncMap((_) => getAllProducts());
  }

  /// Retrieves a product by [id] with its details.
  Future<ProductWithDetails?> getProductById(int id) async {
    final productsQuery = _db.select(_db.products).join([
      innerJoin(
          _db.units, _db.units.id.equalsExp(_db.products.defaultServingUnitId)),
    ])
      ..where(_db.products.id.equals(id));
    final row = await productsQuery.getSingleOrNull();
    if (row == null) return null;
    final product = row.readTable(_db.products);
    final unit = row.readTable(_db.units);

    final valuesRows = await _db.select(_db.productCategoryValues).join([
      innerJoin(_db.categories,
          _db.categories.id.equalsExp(_db.productCategoryValues.categoryId)),
      innerJoin(
          _db.units, _db.units.id.equalsExp(_db.productCategoryValues.unitId)),
    ])
      ..where(_db.productCategoryValues.productId.equals(product.id));
    final fetched = await valuesRows.get();
    final details = fetched
        .map((r) => CategoryValueDetail(
              category: r.readTable(_db.categories),
              value: r.readTable(_db.productCategoryValues).value,
              unit: r.readTable(_db.units),
            ))
        .toList();

    return ProductWithDetails(
        product: product, defaultUnit: unit, values: details);
  }

  /// Watches a single product identified by [id]. Emits `null` when the
  /// product is deleted.
  Stream<ProductWithDetails?> watchProductById(int id) {
    return _db.select(_db.products).watch().asyncMap((_) => getProductById(id));
  }

=======
  /// Inserts a product and associated category values within a transaction.
  Future<int> insertProduct(ProductsCompanion product,
      List<ProductCategoryValuesCompanion> categoryValues) async {
    return _db.transaction(() async {
      final productId = await _db.into(_db.products).insert(product);
      for (final value in categoryValues) {
        await _db
            .into(_db.productCategoryValues)
            .insert(value.copyWith(productId: Value(productId)));
      }
      return productId;
    });
  }

  /// Updates a product and its category values.
  Future<bool> updateProduct(ProductsCompanion product,
      List<ProductCategoryValuesCompanion> categoryValues) async {
    return _db.transaction(() async {
      final updated = await (_db.update(_db.products)
            ..where((tbl) => tbl.id.equals(product.id.value)))
          .write(product);
      await (_db.delete(_db.productCategoryValues)
            ..where((tbl) => tbl.productId.equals(product.id.value)))
          .go();
      for (final value in categoryValues) {
        await _db
            .into(_db.productCategoryValues)
            .insert(value.copyWith(productId: Value(product.id.value)));
      }
      return updated > 0;
    });
  }

  /// Deletes a product and its associated values.
  Future<void> deleteProduct(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.productCategoryValues)
            ..where((tbl) => tbl.productId.equals(id)))
          .go();
      await (_db.delete(_db.products)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  /// Retrieves a category by its [id].
  Future<Category?> getCategoryById(int id) {
    final query = _db.select(_db.categories)..where((c) => c.id.equals(id));
    return query.getSingleOrNull();
  }
}
