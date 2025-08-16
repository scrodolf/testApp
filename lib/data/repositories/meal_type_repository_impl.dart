import 'package:drift/drift.dart';
import 'package:food_app/data/daos/meal_type_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_meal_type_repository.dart';

/// Implementation of [IMealTypeRepository].
class MealTypeRepositoryImpl implements IMealTypeRepository {
  MealTypeRepositoryImpl(this._dao);

  final MealTypeDao _dao;

  @override
  Stream<List<MealType>> watchMealTypes() => _dao.watchAllMealTypes();

  @override
  Future<int> insertMealType({required String name, bool isCustom = true}) {
    return _dao.insertMealType(MealTypesCompanion(
      name: Value(name),
      isCustom: Value(isCustom),
    ));
  }

  @override
  Future<bool> updateMealType({
    required int id,
    required String name,
    bool? isCustom,
  }) {
    return _dao.updateMealType(MealTypesCompanion(
      id: Value(id),
      name: Value(name),
      isCustom: isCustom != null ? Value(isCustom) : const Value.absent(),
    ));
  }

  @override
  Future<void> deleteMealType(int id) async {
    await _dao.deleteMealType(id);
  }
}
