import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_repository.dart';
import '../data/meal_repository.dart';
import '../data/log_repository.dart';
import '../data/local/app_database.dart';

/// Populates the database with a small set of sample data for demos and
/// development. The operation is idempotent: if the sample products already
/// exist, nothing happens.
Future<void> createSampleData(WidgetRef ref) async {
  final productRepo = ref.read(productRepositoryProvider);
  final mealRepo = ref.read(mealRepositoryProvider);
  final logRepo = ref.read(logRepositoryProvider);
  final db = ref.read(appDatabaseProvider);

  // Avoid duplicates by checking for one of the sample products.
  final existing = await productRepo.getProducts();
  if (existing.any((p) => p.product.name == 'Whey Protein')) {
    return;
  }

  // Helper to fetch unit id by symbol, inserting custom units if needed.
  Future<int> _unitId(String symbol,
      {String? name, String dimension = 'mass', bool custom = false}) async {
    final row = await (db.select(db.units)
          ..where((u) => u.symbol.equals(symbol)))
        .getSingleOrNull();
    if (row != null) return row.id;
    return db.into(db.units).insert(UnitsCompanion.insert(
          name: name ?? symbol,
          symbol: Value(symbol),
          dimension: dimension,
          factorToBase: 1,
          isCustom: Value(custom),
        ));
  }

  // Helper to fetch category id by key.
  Future<int> _catId(String key) async {
    final row = await (db.select(db.categories)
          ..where((c) => c.nameKey.equals(key)))
        .getSingle();
    return row.id;
  }

  final gramId = await _unitId('g', name: 'gram');
  final scoopId = await _unitId('scoop', name: 'scoop', custom: true);

  final caloriesId = await _catId('calories');
  final proteinId = await _catId('protein');
  final carbsId = await _catId('carbs');
  final fatId = await _catId('fat');

  // --- Products ---
  await productRepo.addProduct(
    name: 'Whey Protein',
    defaultServingSize: 32, // 32 g per serving
    defaultUnitId: gramId,
    categoryValues: {
      caloriesId: 120,
      proteinId: 25,
      carbsId: 2,
      fatId: 1,
    },
    unitOverrides: {scoopId: 32}, // 1 scoop = 32 g
  );

  await productRepo.addProduct(
    name: 'Banana',
    defaultServingSize: 118, // average banana weight
    defaultUnitId: gramId,
    categoryValues: {
      caloriesId: 105,
      proteinId: 1,
      carbsId: 27,
      fatId: 0,
    },
  );

  final productsAfter = await productRepo.getProducts();
  final whey =
      productsAfter.firstWhere((p) => p.product.name == 'Whey Protein').product;
  final banana =
      productsAfter.firstWhere((p) => p.product.name == 'Banana').product;

  // --- Meal ---
  final shakeMealId = await mealRepo.addMeal(
    name: 'Post-Workout Shake',
    items: [
      MealItem(
        id: 0,
        mealId: 0,
        productId: whey.id,
        amountBase: 32,
        originalUnitId: scoopId,
      ),
      MealItem(
        id: 0,
        mealId: 0,
        productId: banana.id,
        amountBase: 118,
        originalUnitId: null,
      ),
    ],
    customEntries: const [],
  );

  // --- Logs ---
  Future<int> _mealTypeId(String key) async {
    final row = await (db.select(db.mealTypes)
          ..where((m) => m.nameKey.equals(key)))
        .getSingle();
    return row.id;
  }

  final breakfastId = await _mealTypeId('breakfast');
  final dinnerId = await _mealTypeId('dinner');
  final now = DateTime.now();

  await logRepo.addLog(
    mealId: shakeMealId,
    quantity: 1,
    loggedAtLocal: now,
    mealTypeId: breakfastId,
  );

  await logRepo.addLog(
    productId: banana.id,
    quantity: 1,
    loggedAtLocal: now.subtract(const Duration(hours: 5)),
    mealTypeId: dinnerId,
  );
}
