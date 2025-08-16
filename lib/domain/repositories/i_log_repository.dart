import 'package:food_app/data/daos/log_dao.dart';

/// Abstraction for meal log persistence.
abstract class ILogRepository {
  Stream<List<LogWithDetails>> watchLogs();

  Future<int> insertLog({
    required int mealId,
    required DateTime loggedAtLocal,
    int? mealTypeId,
  });

  Future<bool> updateLog({
    required int id,
    required int mealId,
    required DateTime loggedAtLocal,
    int? mealTypeId,
  });

  Future<void> deleteLog(int id);
}
