import 'package:food_app/data/database/app_database.dart';

/// Abstraction for CRUD operations on [MealType] records.
abstract class IMealTypeRepository {
  Stream<List<MealType>> watchAllTypes();
  Future<int> insertType(MealTypesCompanion type);
  Future<void> updateType(MealTypesCompanion type);
  Future<void> deleteType(int id);
}
