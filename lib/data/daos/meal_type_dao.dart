import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// DAO for meal types.
class MealTypeDao {
  MealTypeDao(this._db);

  final AppDatabase _db;

  Stream<List<MealType>> watchAllMealTypes() {
    return _db.select(_db.mealTypes).watch();
  }

  Future<int> insertMealType(MealTypesCompanion entry) {
    return _db.into(_db.mealTypes).insert(entry);
  }

  Future<bool> updateMealType(MealTypesCompanion entry) {
    return _db.update(_db.mealTypes).replace(entry);
  }

  Future<int> deleteMealType(int id) {
    return (_db.delete(_db.mealTypes)..where((t) => t.id.equals(id))).go();
  }
}
