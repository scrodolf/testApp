import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/daos/product_dao.dart';

/// Associates a [MealEntry] with its loaded [ProductWithDetails].
class MealEntryDetail {
  MealEntryDetail({required this.entry, required this.product});

  final MealEntry entry;
  final ProductWithDetails product;
}

/// Aggregates a [Meal] with its entries and custom category values.
class MealWithDetails {
  MealWithDetails(
      {required this.meal, required this.entries, required this.customValues});

  final Meal meal;
  final List<MealEntryDetail> entries;
  final List<CategoryValueDetail> customValues;
}

/// DAO handling CRUD for meals and related entities.
class MealDao {
  MealDao(this._db, this._productDao);

  final AppDatabase _db;
  final ProductDao _productDao;

  Future<List<MealWithDetails>> _fetchMeals(List<Meal> meals) async {
    final result = <MealWithDetails>[];
    for (final meal in meals) {
      final entryRows = await (_db.select(_db.mealEntries)
            ..where((tbl) => tbl.mealId.equals(meal.id)))
          .get();
      final entries = <MealEntryDetail>[];
      for (final entry in entryRows) {
        final product = await _productDao.getProductById(entry.productId);
        if (product != null) {
          entries.add(MealEntryDetail(entry: entry, product: product));
        }
      }
      final customRows = await _db.select(_db.mealCategoryValues).join([
        innerJoin(_db.categories,
            _db.categories.id.equalsExp(_db.mealCategoryValues.categoryId)),
        innerJoin(_db.units,
            _db.units.id.equalsExp(_db.mealCategoryValues.originalUnitId)),
      ])
        ..where(_db.mealCategoryValues.mealId.equals(meal.id));
      final fetched = await customRows.get();
      final customValues = fetched
          .map((r) => CategoryValueDetail(
                category: r.readTable(_db.categories),
                value: r.readTable(_db.mealCategoryValues).value,
                unit: r.readTable(_db.units),
              ))
          .toList();
      result.add(MealWithDetails(
          meal: meal, entries: entries, customValues: customValues));
    }
    return result;
  }

  /// Retrieves all meals with their details.
  Future<List<MealWithDetails>> getAllMeals() async {
    final meals = await _db.select(_db.meals).get();
    return _fetchMeals(meals);
  }

  /// Watches all meals and emits updates when underlying tables change.
  Stream<List<MealWithDetails>> watchAllMeals() {
    return _db
        .select(_db.meals)
        .watch()
        .asyncMap((meals) => _fetchMeals(meals));
  }

  /// Retrieves a single meal by [id].
  Future<MealWithDetails?> getMealById(int id) async {
    final meal = await (_db.select(_db.meals)..where((m) => m.id.equals(id)))
        .getSingleOrNull();
    if (meal == null) return null;
    final meals = await _fetchMeals([meal]);
    return meals.isEmpty ? null : meals.first;
  }

  /// Watches a single meal.
  Stream<MealWithDetails?> watchMealById(int id) {
    return _db.select(_db.meals).watch().asyncMap((_) => getMealById(id));
  }

  /// Inserts a meal with entries and custom values within a transaction.
  Future<int> insertMeal(
      MealsCompanion meal,
      List<MealEntriesCompanion> entries,
      List<MealCategoryValuesCompanion> customValues) async {
    return _db.transaction(() async {
      final mealId = await _db.into(_db.meals).insert(meal);
      for (final e in entries) {
        await _db
            .into(_db.mealEntries)
            .insert(e.copyWith(mealId: Value(mealId)));
      }
      for (final v in customValues) {
        await _db
            .into(_db.mealCategoryValues)
            .insert(v.copyWith(mealId: Value(mealId)));
      }
      return mealId;
    });
  }

  /// Updates a meal, replacing its entries and custom values.
  Future<void> updateMeal(
      MealsCompanion meal,
      List<MealEntriesCompanion> entries,
      List<MealCategoryValuesCompanion> customValues) async {
    return _db.transaction(() async {
      await (_db.update(_db.meals)
            ..where((tbl) => tbl.id.equals(meal.id.value)))
          .write(meal);
      await (_db.delete(_db.mealEntries)
            ..where((tbl) => tbl.mealId.equals(meal.id.value)))
          .go();
      await (_db.delete(_db.mealCategoryValues)
            ..where((tbl) => tbl.mealId.equals(meal.id.value)))
          .go();
      for (final e in entries) {
        await _db
            .into(_db.mealEntries)
            .insert(e.copyWith(mealId: Value(meal.id.value)));
      }
      for (final v in customValues) {
        await _db
            .into(_db.mealCategoryValues)
            .insert(v.copyWith(mealId: Value(meal.id.value)));
      }
    });
  }

  /// Deletes a meal and all related records.
  Future<void> deleteMeal(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.mealEntries)..where((e) => e.mealId.equals(id)))
          .go();
      await (_db.delete(_db.mealCategoryValues)
            ..where((v) => v.mealId.equals(id)))
          .go();
      await (_db.delete(_db.meals)..where((m) => m.id.equals(id))).go();
    });
  }
}
