import 'package:riverpod/riverpod.dart';
import 'package:drift/drift.dart';

import 'local/app_database.dart';
import 'product_repository.dart' show appDatabaseProvider;

/// Riverpod provider for [LogRepository].
final logRepositoryProvider = Provider<LogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LogRepository(db);
});

/// Provides meal types ordered by sort order.
final mealTypesProvider = StreamProvider<List<MealType>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.mealTypes)
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
      ).watch();
});

/// Provides all meals.
final mealsProvider = StreamProvider<List<Meal>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.meals).watch();
});

/// Provides all products.
final productsProvider = StreamProvider<List<Product>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.products).watch();
});

/// Watches logs for a specific day.
final logsByDateProvider =
    StreamProvider.family<List<LogWithDetails>, DateTime>((ref, date) {
  final repo = ref.watch(logRepositoryProvider);
  return repo.watchLogsForDate(date);
});

/// Aggregated log with optional meal or product.
class LogWithDetails {
  LogWithDetails({
    required this.log,
    this.meal,
    this.product,
    required this.mealType,
  });

  final Log log;
  final Meal? meal;
  final Product? product;
  final MealType mealType;
}

/// Exception thrown for validation errors in log operations.
class LogValidationException implements Exception {
  LogValidationException(this.message);
  final String message;
  @override
  String toString() => 'LogValidationException: $message';
}

class LogRepository {
  LogRepository(this._db);
  final AppDatabase _db;

  double _fix(double value) => double.parse(value.toStringAsFixed(4));

  /// Watches logs within a given day (local time).
  Stream<List<LogWithDetails>> watchLogsForDate(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.logs).join([
      leftOuterJoin(_db.meals, _db.meals.id.equalsExp(_db.logs.mealId)),
      leftOuterJoin(
          _db.products, _db.products.id.equalsExp(_db.logs.productId)),
      leftOuterJoin(
          _db.mealTypes, _db.mealTypes.id.equalsExp(_db.logs.mealTypeId)),
    ])
      ..where(_db.logs.loggedAtLocal.isBetweenValues(start, end))
      ..orderBy([OrderingTerm(expression: _db.logs.loggedAtLocal)]);

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => LogWithDetails(
              log: row.readTable(_db.logs),
              meal: row.readTableOrNull(_db.meals),
              product: row.readTableOrNull(_db.products),
              mealType: row.readTable(_db.mealTypes),
            ),
          )
          .toList();
    });
  }

  /// Adds a new log entry.
  Future<int> addLog({
    int? mealId,
    int? productId,
    required double quantity,
    required DateTime loggedAtLocal,
    required int mealTypeId,
  }) async {
    if ((mealId == null && productId == null) ||
        (mealId != null && productId != null)) {
      throw LogValidationException('Provide either meal or product');
    }
    if (quantity < 0) {
      throw LogValidationException('Quantity must be >= 0');
    }
    final tz = loggedAtLocal.timeZoneOffset.inMinutes;
    return _db.into(_db.logs).insert(LogsCompanion.insert(
          mealId: Value(mealId),
          productId: Value(productId),
          quantity: _fix(quantity),
          mealTypeId: mealTypeId,
          loggedAtLocal: loggedAtLocal,
          timeZoneOffsetMinutes: tz,
        ));
  }

  /// Updates an existing log entry.
  Future<void> updateLog({
    required int logId,
    int? mealId,
    int? productId,
    double? quantity,
    DateTime? loggedAtLocal,
    int? mealTypeId,
  }) async {
    final existing = await (_db.select(_db.logs)
          ..where((l) => l.id.equals(logId)))
        .getSingleOrNull();
    if (existing == null) {
      throw LogValidationException('Log not found');
    }
    if (mealId != null && productId != null) {
      throw LogValidationException('Cannot set both meal and product');
    }
    final companion = LogsCompanion(
      mealId: mealId != null ? Value(mealId) : const Value.absent(),
      productId:
          productId != null ? Value(productId) : const Value.absent(),
      quantity:
          quantity != null ? Value(_fix(quantity)) : const Value.absent(),
      mealTypeId:
          mealTypeId != null ? Value(mealTypeId) : const Value.absent(),
      loggedAtLocal: loggedAtLocal != null ? Value(loggedAtLocal) : const Value.absent(),
      timeZoneOffsetMinutes: loggedAtLocal != null
          ? Value(loggedAtLocal.timeZoneOffset.inMinutes)
          : const Value.absent(),
    );
    await (_db.update(_db.logs)..where((l) => l.id.equals(logId))).write(
        companion);
  }

  /// Deletes a log entry.
  Future<void> deleteLog(int logId) async {
    await (_db.delete(_db.logs)..where((l) => l.id.equals(logId))).go();
  }
}

