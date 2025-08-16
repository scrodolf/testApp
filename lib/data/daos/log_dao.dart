import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// Aggregates a log entry with its meal and meal type.
class LogWithDetails {
  LogWithDetails({required this.log, required this.meal, this.mealType});

  final Log log;
  final Meal meal;
  final MealType? mealType;
}

/// DAO for meal logs.
class LogDao {
  LogDao(this._db);

  final AppDatabase _db;

  Future<List<LogWithDetails>> getAllLogs() async {
    final query = _db.select(_db.logs).join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logs.mealId)),
      leftOuterJoin(
          _db.mealTypes, _db.mealTypes.id.equalsExp(_db.logs.mealTypeId))
    ])
      ..orderBy([
        OrderingTerm(expression: _db.logs.loggedAtLocal, mode: OrderingMode.desc)
      ]);
    final rows = await query.get();
    return rows
        .map((r) => LogWithDetails(
              log: r.readTable(_db.logs),
              meal: r.readTable(_db.meals),
              mealType: r.readTableOrNull(_db.mealTypes),
            ))
        .toList();
  }

  Stream<List<LogWithDetails>> watchAllLogs() {
    final query = _db.select(_db.logs).join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logs.mealId)),
      leftOuterJoin(
          _db.mealTypes, _db.mealTypes.id.equalsExp(_db.logs.mealTypeId))
    ])
      ..orderBy([
        OrderingTerm(expression: _db.logs.loggedAtLocal, mode: OrderingMode.desc)
      ]);
    return query.watch().map((rows) => rows
        .map((r) => LogWithDetails(
              log: r.readTable(_db.logs),
              meal: r.readTable(_db.meals),
              mealType: r.readTableOrNull(_db.mealTypes),
            ))
        .toList());
  }

  Future<int> insertLog(LogsCompanion entry) {
    return _db.into(_db.logs).insert(entry);
  }

  Future<bool> updateLog(LogsCompanion entry) {
    return _db.update(_db.logs).replace(entry);
  }

  Future<int> deleteLog(int id) {
    return (_db.delete(_db.logs)..where((t) => t.id.equals(id))).go();
  }
}
