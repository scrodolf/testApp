import 'package:food_app/data/daos/meal_type_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_meal_type_repository.dart';

/// Concrete implementation of [IMealTypeRepository].
class MealTypeRepositoryImpl implements IMealTypeRepository {
  MealTypeRepositoryImpl(this._dao);

  final MealTypeDao _dao;

  @override
  Stream<List<MealType>> watchAllTypes() => _dao.watchAllMealTypes();

  @override
  Future<int> insertType(MealTypesCompanion type) => _dao.insertMealType(type);

  @override
  Future<void> updateType(MealTypesCompanion type) => _dao.updateMealType(type);

  @override
  Future<void> deleteType(int id) => _dao.deleteMealType(id);
}
