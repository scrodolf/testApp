import 'package:food_app/data/daos/meal_log_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_meal_log_repository.dart';

/// Concrete implementation of [IMealLogRepository].
class MealLogRepositoryImpl implements IMealLogRepository {
  MealLogRepositoryImpl(this._dao);

  final MealLogDao _dao;

  @override
  Stream<List<LogWithMeal>> watchAllLogs() => _dao.watchAllLogs();

  @override
  Stream<LogWithMeal?> watchLogById(int id) => _dao.watchLog(id);

  @override
  Future<int> insertLog(LogItemsCompanion log) => _dao.insertLog(log);

  @override
  Future<void> updateLog(LogItemsCompanion log) => _dao.updateLog(log);

  @override
  Future<void> deleteLog(int id) => _dao.deleteLog(id);
}
