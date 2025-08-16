import 'package:drift/drift.dart';
import 'package:food_app/data/daos/log_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_log_repository.dart';

/// Implementation of [ILogRepository].
class LogRepositoryImpl implements ILogRepository {
  LogRepositoryImpl(this._dao);

  final LogDao _dao;

  @override
  Stream<List<LogWithDetails>> watchLogs() => _dao.watchAllLogs();

  @override
  Future<int> insertLog({
    required int mealId,
    required DateTime loggedAtLocal,
    int? mealTypeId,
  }) {
    return _dao.insertLog(LogsCompanion(
      mealId: Value(mealId),
      loggedAtLocal: Value(loggedAtLocal),
      mealTypeId: Value(mealTypeId),
    ));
  }

  @override
  Future<bool> updateLog({
    required int id,
    required int mealId,
    required DateTime loggedAtLocal,
    int? mealTypeId,
  }) {
    return _dao.updateLog(LogsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      loggedAtLocal: Value(loggedAtLocal),
      mealTypeId: Value(mealTypeId),
    ));
  }

  @override
  Future<void> deleteLog(int id) async {
    await _dao.deleteLog(id);
  }
}
