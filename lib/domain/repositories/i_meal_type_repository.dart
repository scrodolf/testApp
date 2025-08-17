import 'package:food_app/data/database/app_database.dart';

/// Abstraction for meal type persistence.
abstract class IMealTypeRepository {
  Stream<List<MealType>> watchMealTypes();

  Future<int> insertMealType({required String name, bool isBuiltin});

  Future<bool> updateMealType({
    required int id,
    required String name,
    bool? isBuiltin,
  });

  Future<void> deleteMealType(int id);
}
