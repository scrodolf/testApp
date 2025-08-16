import 'package:food_app/data/database/app_database.dart';

/// Abstraction for meal type persistence.
abstract class IMealTypeRepository {
  Stream<List<MealType>> watchMealTypes();

  Future<int> insertMealType({required String name, bool isCustom});

  Future<bool> updateMealType({
    required int id,
    required String name,
    bool? isCustom,
  });

  Future<void> deleteMealType(int id);
}
