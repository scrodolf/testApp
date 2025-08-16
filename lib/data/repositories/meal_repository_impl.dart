import 'package:drift/drift.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/daos/meal_dao.dart';
import 'package:food_app/data/daos/product_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';

/// Concrete implementation of [IMealRepository].
class MealRepositoryImpl implements IMealRepository {
  MealRepositoryImpl(
      this._mealDao, this._productDao, this._units, this._conversion);

  final MealDao _mealDao;
  final ProductDao _productDao;
  final IUnitRegistry _units;
  final IConversionService _conversion;

  @override
  Stream<List<MealWithDetails>> watchAllMeals() => _mealDao.watchAllMeals();

  @override
  Stream<MealWithDetails?> watchMealById(int id) => _mealDao.watchMealById(id);

  @override
  Future<int> insertMeal({
    String? name,
    String? notes,
    required List<MealEntryInput> entries,
    required List<MealCategoryValueInput> customValues,
  }) async {
    try {
      final meal = MealsCompanion(
        name: Value(name),
        notes: Value(notes),
      );
      final entryCompanions = entries
          .map((e) => MealEntriesCompanion(
                productId: Value(e.productId),
                quantity: Value(e.quantity),
              ))
          .toList();
      final valueCompanions = <MealCategoryValuesCompanion>[];
      for (final cv in customValues) {
        final category = await _productDao.getCategoryById(cv.categoryId);
        if (category == null) {
          throw MealPersistenceException(
              'Unknown category id ${cv.categoryId}');
        }
        final units = await _units.getUnitsByDimension(category.baseDimension);
        final baseUnit = units.firstWhere((u) => u.factorToBase == 1,
            orElse: () => units.first);
        final converted =
            await _conversion.convert(cv.value, cv.unitId, baseUnit.id);
        valueCompanions.add(MealCategoryValuesCompanion(
          categoryId: Value(cv.categoryId),
          value: Value(converted),
          originalUnitId: Value(cv.unitId),
        ));
      }
      return _mealDao.insertMeal(meal, entryCompanions, valueCompanions);
    } on AppException {
      rethrow;
    } catch (e) {
      throw MealPersistenceException('Failed to insert meal', e);
    }
  }

  @override
  Future<void> updateMeal({
    required int id,
    String? name,
    String? notes,
    required List<MealEntryInput> entries,
    required List<MealCategoryValueInput> customValues,
  }) async {
    try {
      final meal = MealsCompanion(
        id: Value(id),
        name: Value(name),
        notes: Value(notes),
      );
      final entryCompanions = entries
          .map((e) => MealEntriesCompanion(
                productId: Value(e.productId),
                quantity: Value(e.quantity),
              ))
          .toList();
      final valueCompanions = <MealCategoryValuesCompanion>[];
      for (final cv in customValues) {
        final category = await _productDao.getCategoryById(cv.categoryId);
        if (category == null) {
          throw MealPersistenceException(
              'Unknown category id ${cv.categoryId}');
        }
        final units = await _units.getUnitsByDimension(category.baseDimension);
        final baseUnit = units.firstWhere((u) => u.factorToBase == 1,
            orElse: () => units.first);
        final converted =
            await _conversion.convert(cv.value, cv.unitId, baseUnit.id);
        valueCompanions.add(MealCategoryValuesCompanion(
          categoryId: Value(cv.categoryId),
          value: Value(converted),
          originalUnitId: Value(cv.unitId),
        ));
      }
      await _mealDao.updateMeal(meal, entryCompanions, valueCompanions);
    } on AppException {
      rethrow;
    } catch (e) {
      throw MealPersistenceException('Failed to update meal', e);
    }
  }

  @override
  Future<void> deleteMeal(int id) async {
    try {
      await _mealDao.deleteMeal(id);
    } catch (e) {
      throw MealPersistenceException('Failed to delete meal', e);
    }
  }
}
