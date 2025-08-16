import 'package:food_app/data/daos/meal_log_dao.dart';
import 'package:food_app/data/database/app_database.dart';

/// Abstraction for accessing meal log data.
abstract class IMealLogRepository {
  Stream<List<LogWithMeal>> watchAllLogs();
  Stream<LogWithMeal?> watchLogById(int id);
  Future<int> insertLog(LogItemsCompanion log);
  Future<void> updateLog(LogItemsCompanion log);
  Future<void> deleteLog(int id);
}
