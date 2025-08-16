import 'package:food_app/data/daos/meal_dao.dart';

/// Input describing a product used in a meal.
class MealEntryInput {
  MealEntryInput({required this.productId, required this.quantity});

  final int productId;
  final double quantity;
}

/// Input describing a custom category value attached to a meal.
class MealCategoryValueInput {
  MealCategoryValueInput(
      {required this.categoryId, required this.value, required this.unitId});

  final int categoryId;
  final double value;
  final int unitId;
}

/// Repository interface for persisting and retrieving meals.
abstract class IMealRepository {
  Stream<List<MealWithDetails>> watchAllMeals();
  Stream<MealWithDetails?> watchMealById(int id);

  Future<int> insertMeal({
    String? name,
    String? notes,
    required List<MealEntryInput> entries,
    required List<MealCategoryValueInput> customValues,
  });

  Future<void> updateMeal({
    required int id,
    String? name,
    String? notes,
    required List<MealEntryInput> entries,
    required List<MealCategoryValueInput> customValues,
  });

  Future<void> deleteMeal(int id);
}
