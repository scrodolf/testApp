import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// Combines a [LogItem] with its referenced [Meal].
class LogWithMeal {
  LogWithMeal({required this.log, required this.meal});

  final LogItem log;
  final Meal meal;
}

/// DAO responsible for CRUD operations on [LogItems].
class MealLogDao {
  MealLogDao(this._db);

  final AppDatabase _db;

  /// Watches all log items with their meals ordered by date/time.
  Stream<List<LogWithMeal>> watchAllLogs() {
    final query = _db.select(_db.logItems).join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logItems.mealId)),
    ])
      ..orderBy([
        OrderingTerm(expression: _db.logItems.date, mode: OrderingMode.desc),
        OrderingTerm(expression: _db.logItems.time, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows
        .map((r) => LogWithMeal(
            log: r.readTable(_db.logItems), meal: r.readTable(_db.meals)))
        .toList());
  }

  /// Watches a single log entry by [id].
  Stream<LogWithMeal?> watchLog(int id) {
    final query =
        (_db.select(_db.logItems)..where((tbl) => tbl.id.equals(id))).join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logItems.mealId)),
    ]);
    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return LogWithMeal(
          log: row.readTable(_db.logItems), meal: row.readTable(_db.meals));
    });
  }

  /// Inserts a new log item.
  Future<int> insertLog(LogItemsCompanion log) {
    return _db.into(_db.logItems).insert(log);
  }

  /// Updates an existing log item.
  Future<void> updateLog(LogItemsCompanion log) async {
    await (_db.update(_db.logItems)
          ..where((tbl) => tbl.id.equals(log.id.value)))
        .write(log);
  }

  /// Deletes a log item by [id].
  Future<void> deleteLog(int id) async {
    await (_db.delete(_db.logItems)..where((tbl) => tbl.id.equals(id))).go();
  }
}
