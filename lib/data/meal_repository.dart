import 'package:riverpod/riverpod.dart';
import 'package:drift/drift.dart';

import 'local/app_database.dart';
import 'product_repository.dart' show appDatabaseProvider;

/// Riverpod provider for [MealRepository].
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MealRepository(db);
});

/// Exception thrown when validation fails for meal operations.
class MealValidationException implements Exception {
  MealValidationException(this.message);
  final String message;
  @override
  String toString() => 'MealValidationException: $message';
}

/// Aggregates a meal with its items and custom entries.
class MealWithDetails {
  MealWithDetails({
    required this.meal,
    required this.items,
    required this.customEntries,
  });

  final Meal meal;
  final List<MealItem> items;
  final List<MealCustomEntry> customEntries;
}

class MealRepository {
  MealRepository(this._db);
  final AppDatabase _db;

  double _fix(double value) => double.parse(value.toStringAsFixed(4));

  Future<int> addMeal({
    required String name,
    required List<MealItem> items,
    required List<MealCustomEntry> customEntries,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw MealValidationException('Name must not be empty');
    }
    for (final item in items) {
      if (item.amountBase < 0) {
        throw MealValidationException('Item amount must be >= 0');
      }
    }
    for (final entry in customEntries) {
      if (entry.amountBase < 0) {
        throw MealValidationException('Custom entry amount must be >= 0');
      }
    }
    return _db.transaction(() async {
      final mealId = await _db.into(_db.meals).insert(MealsCompanion.insert(name: trimmed));
      if (items.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.mealItems,
            items
                .map(
                  (e) => MealItemsCompanion.insert(
                    mealId: mealId,
                    productId: e.productId,
                    amountBase: _fix(e.amountBase),
                    originalUnitId: Value(e.originalUnitId),
                  ),
                )
                .toList(),
          );
        });
      }
      if (customEntries.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.mealCustomEntries,
            customEntries
                .map(
                  (e) => MealCustomEntriesCompanion.insert(
                    mealId: mealId,
                    categoryId: e.categoryId,
                    amountBase: _fix(e.amountBase),
                    originalUnitId: Value(e.originalUnitId),
                  ),
                )
                .toList(),
          );
        });
      }
      return mealId;
    });
  }

  Future<void> updateMeal({
    required int mealId,
    String? name,
    List<MealItem>? items,
    List<MealCustomEntry>? customEntries,
  }) async {
    final existing = await (_db.select(_db.meals)..where((m) => m.id.equals(mealId))).getSingleOrNull();
    if (existing == null) {
      throw MealValidationException('Meal not found');
    }
    if (name != null) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw MealValidationException('Name must not be empty');
      }
      await (_db.update(_db.meals)..where((m) => m.id.equals(mealId))).write(MealsCompanion(name: Value(trimmed)));
    }
    if (items != null) {
      for (final item in items) {
        if (item.amountBase < 0) {
          throw MealValidationException('Item amount must be >= 0');
        }
      }
      await (_db.delete(_db.mealItems)..where((t) => t.mealId.equals(mealId))).go();
      if (items.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.mealItems,
            items
                .map(
                  (e) => MealItemsCompanion.insert(
                    mealId: mealId,
                    productId: e.productId,
                    amountBase: _fix(e.amountBase),
                    originalUnitId: Value(e.originalUnitId),
                  ),
                )
                .toList(),
          );
        });
      }
    }
    if (customEntries != null) {
      for (final entry in customEntries) {
        if (entry.amountBase < 0) {
          throw MealValidationException('Custom entry amount must be >= 0');
        }
      }
      await (_db.delete(_db.mealCustomEntries)..where((t) => t.mealId.equals(mealId))).go();
      if (customEntries.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(
            _db.mealCustomEntries,
            customEntries
                .map(
                  (e) => MealCustomEntriesCompanion.insert(
                    mealId: mealId,
                    categoryId: e.categoryId,
                    amountBase: _fix(e.amountBase),
                    originalUnitId: Value(e.originalUnitId),
                  ),
                )
                .toList(),
          );
        });
      }
    }
  }

  Future<List<Meal>> getMeals() {
    return _db.select(_db.meals).get();
  }

  Future<MealWithDetails?> getMealById(int mealId) async {
    final meal = await (_db.select(_db.meals)..where((m) => m.id.equals(mealId))).getSingleOrNull();
    if (meal == null) return null;
    final items = await (_db.select(_db.mealItems)..where((i) => i.mealId.equals(mealId))).get();
    final custom = await (_db.select(_db.mealCustomEntries)..where((c) => c.mealId.equals(mealId))).get();
    return MealWithDetails(meal: meal, items: items, customEntries: custom);
  }

  Future<void> deleteMeal(int mealId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.mealItems)..where((i) => i.mealId.equals(mealId))).go();
      await (_db.delete(_db.mealCustomEntries)..where((i) => i.mealId.equals(mealId))).go();
      await (_db.delete(_db.meals)..where((m) => m.id.equals(mealId))).go();
    });
  }
}

