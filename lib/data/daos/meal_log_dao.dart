import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// Combines a [LogItem] with its referenced [Meal] and [MealType].
class LogWithDetails {
  LogWithDetails({required this.log, required this.meal, required this.mealType});

  final LogItem log;
  final Meal meal;
  final MealType mealType;
}

/// DAO responsible for CRUD operations on [LogItems].
class MealLogDao {
  MealLogDao(this._db);

  final AppDatabase _db;

  /// Watches all log items with their meals ordered by date/time.
  Stream<List<LogWithDetails>> watchAllLogs() {
    final query = _db.select(_db.logItems).join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logItems.mealId)),
      innerJoin(
          _db.mealTypes, _db.mealTypes.id.equalsExp(_db.logItems.mealTypeId)),
    ])
      ..orderBy([
        OrderingTerm(
            expression: _db.logItems.loggedAtLocal, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) =>
        rows.map((r) => LogWithDetails(
                log: r.readTable(_db.logItems),
                meal: r.readTable(_db.meals),
                mealType: r.readTable(_db.mealTypes)))
            .toList());
  }

  /// Watches a single log entry by [id].
  Stream<LogWithDetails?> watchLog(int id) {
    final query = (_db.select(_db.logItems)
          ..where((tbl) => tbl.id.equals(id)))
        .join([
      innerJoin(_db.meals, _db.meals.id.equalsExp(_db.logItems.mealId)),
      innerJoin(
          _db.mealTypes, _db.mealTypes.id.equalsExp(_db.logItems.mealTypeId)),
    ]);
    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return LogWithDetails(
          log: row.readTable(_db.logItems),
          meal: row.readTable(_db.meals),
          mealType: row.readTable(_db.mealTypes));
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
