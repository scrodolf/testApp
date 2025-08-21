import 'package:riverpod/riverpod.dart';
import 'package:drift/drift.dart';

import 'local/app_database.dart';
import 'product_repository.dart' show appDatabaseProvider;
import 'conversion_service.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return GoalRepository(db);
});

/// Watches all goals with their category and unit details.
final goalsProvider = StreamProvider<List<GoalWithDetails>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchGoals();
});

/// Provides progress information for a goal.
final goalProgressProvider =
    FutureProvider.family<GoalProgress, int>((ref, goalId) async {
  final repo = ref.watch(goalRepositoryProvider);
  final conv = ref.watch(conversionServiceProvider);
  return repo.computeProgress(goalId, conv);
});

class GoalWithDetails {
  GoalWithDetails({required this.goal, required this.category, this.unit});
  final Goal goal;
  final Category category;
  final Unit? unit;
}

class GoalProgress {
  GoalProgress({
    required this.goal,
    required this.category,
    required this.unit,
    required this.capValue,
    required this.weeklyTotals,
    required this.monthlyTotals,
    required this.weeklyDisposition,
    required this.monthlyDisposition,
    required this.weeklyImpact,
    required this.monthlyImpact,
  });

  final Goal goal;
  final Category category;
  final Unit? unit;
  final double capValue;
  final List<double> weeklyTotals; // display units
  final List<double> monthlyTotals; // cumulative in display units
  final GoalDisposition weeklyDisposition;
  final GoalDisposition monthlyDisposition;
  final GoalImpact weeklyImpact;
  final GoalImpact monthlyImpact;
}

class GoalValidationException implements Exception {
  GoalValidationException(this.message);
  final String message;
  @override
  String toString() => 'GoalValidationException: $message';
}

class GoalRepository {
  GoalRepository(this._db);
  final AppDatabase _db;

  double _fix(double value) => double.parse(value.toStringAsFixed(4));

  Stream<List<GoalWithDetails>> watchGoals() {
    final query = _db.select(_db.goals).join([
      innerJoin(_db.categories, _db.categories.id.equalsExp(_db.goals.categoryId)),
      leftOuterJoin(
          _db.units, _db.units.id.equalsExp(_db.goals.originalUnitId)),
    ]);
    return query.watch().map((rows) {
      return rows
          .map(
            (row) => GoalWithDetails(
              goal: row.readTable(_db.goals),
              category: row.readTable(_db.categories),
              unit: row.readTableOrNull(_db.units),
            ),
          )
          .toList();
    });
  }

  Future<GoalWithDetails?> getGoalById(int id) async {
    final query = _db.select(_db.goals).join([
      innerJoin(_db.categories, _db.categories.id.equalsExp(_db.goals.categoryId)),
      leftOuterJoin(
          _db.units, _db.units.id.equalsExp(_db.goals.originalUnitId)),
    ])
      ..where(_db.goals.id.equals(id));
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    return GoalWithDetails(
      goal: result.readTable(_db.goals),
      category: result.readTable(_db.categories),
      unit: result.readTableOrNull(_db.units),
    );
  }

  Future<int> addGoal({
    required int categoryId,
    required GoalPeriod period,
    required double amountBase,
    required int originalUnitId,
  }) async {
    if (amountBase < 0) {
      throw GoalValidationException('cap must be >= 0');
    }
    final exists = await (_db.select(_db.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    if (exists == null) {
      throw GoalValidationException('category not found');
    }
    return _db.into(_db.goals).insert(
          GoalsCompanion.insert(
            categoryId: categoryId,
            amountBase: _fix(amountBase),
            originalUnitId: Value(originalUnitId),
            period: period,
            disposition: GoalDisposition.good,
            impact: GoalImpact.mild,
            startDate: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateGoal({
    required int goalId,
    int? categoryId,
    GoalPeriod? period,
    double? amountBase,
    int? originalUnitId,
    GoalDisposition? disposition,
    GoalImpact? impact,
  }) async {
    final existing = await (_db.select(_db.goals)
          ..where((g) => g.id.equals(goalId)))
        .getSingleOrNull();
    if (existing == null) {
      throw GoalValidationException('Goal not found');
    }
    if (amountBase != null && amountBase < 0) {
      throw GoalValidationException('cap must be >= 0');
    }
    final companion = GoalsCompanion(
      categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      period: period != null ? Value(period) : const Value.absent(),
      amountBase:
          amountBase != null ? Value(_fix(amountBase)) : const Value.absent(),
      originalUnitId: originalUnitId != null
          ? Value(originalUnitId)
          : const Value.absent(),
      disposition: disposition != null
          ? Value(disposition)
          : const Value.absent(),
      impact: impact != null ? Value(impact) : const Value.absent(),
    );
    await (_db.update(_db.goals)..where((g) => g.id.equals(goalId))).write(
      companion,
    );
  }

  Future<void> deleteGoal(int goalId) async {
    await (_db.delete(_db.goals)..where((g) => g.id.equals(goalId))).go();
  }

  GoalDisposition _dispositionFor(double total, double cap) {
    if (total <= cap) return GoalDisposition.good;
    if (total <= cap * 1.1) return GoalDisposition.mixed;
    return GoalDisposition.bad;
  }

  GoalImpact _impactFor(double total, double cap) {
    if (total <= cap) return GoalImpact.mild;
    if (total <= cap * 1.1) return GoalImpact.moderate;
    return GoalImpact.severe;
  }

  Future<Map<DateTime, double>> _totalsForCategory(
      int categoryId, DateTime start, DateTime end) async {
    final result = await _db.customSelect(
      'SELECT day, SUM(total) AS total FROM ('
      ' SELECT date(l.logged_at_local) AS day, SUM(l.quantity * pcv.amount_base) AS total'
      ' FROM logs l'
      ' JOIN product_category_values pcv ON pcv.product_id = l.product_id AND pcv.category_id = ?'
      ' WHERE l.product_id IS NOT NULL AND l.logged_at_local >= ? AND l.logged_at_local < ?'
      ' GROUP BY day'
      ' UNION ALL'
      ' SELECT date(l.logged_at_local) AS day, '
      ' SUM(l.quantity * mi.amount_base * pcv.amount_base / p.serving_amount_base) AS total'
      ' FROM logs l'
      ' JOIN meal_items mi ON mi.meal_id = l.meal_id'
      ' JOIN products p ON p.id = mi.product_id'
      ' JOIN product_category_values pcv ON pcv.product_id = mi.product_id AND pcv.category_id = ?'
      ' WHERE l.meal_id IS NOT NULL AND l.logged_at_local >= ? AND l.logged_at_local < ?'
      ' GROUP BY day'
      ' UNION ALL'
      ' SELECT date(l.logged_at_local) AS day, SUM(l.quantity * mce.amount_base) AS total'
      ' FROM logs l'
      ' JOIN meal_custom_entries mce ON mce.meal_id = l.meal_id AND mce.category_id = ?'
      ' WHERE l.meal_id IS NOT NULL AND l.logged_at_local >= ? AND l.logged_at_local < ?'
      ' GROUP BY day'
      ') GROUP BY day',
      variables: [
        Variable<int>(categoryId),
        Variable<DateTime>(start),
        Variable<DateTime>(end),
        Variable<int>(categoryId),
        Variable<DateTime>(start),
        Variable<DateTime>(end),
        Variable<int>(categoryId),
        Variable<DateTime>(start),
        Variable<DateTime>(end),
      ],
    ).get();
    final map = <DateTime, double>{};
    for (final row in result) {
      final day = DateTime.parse(row.data['day'] as String);
      final total = row.data['total'] as double? ?? 0;
      map[DateTime(day.year, day.month, day.day)] = total;
    }
    return map;
  }

  Future<GoalProgress> computeProgress(
      int goalId, ConversionService conv) async {
    final goalData = await getGoalById(goalId);
    if (goalData == null) {
      throw GoalValidationException('Goal not found');
    }
    final goal = goalData.goal;
    final now = DateTime.now();
    // Weekly
    final weekStart =
        DateTime(now.year, now.month, now.day - (now.weekday - DateTime.monday));
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekMap =
        await _totalsForCategory(goal.categoryId, weekStart, weekEnd);
    final weeklyBase = List<double>.generate(7, (i) {
      final day = DateTime(weekStart.year, weekStart.month, weekStart.day + i);
      return weekMap[day] ?? 0;
    });
    final weeklyTotals = <double>[];
    for (final v in weeklyBase) {
      weeklyTotals.add(await conv.fromBase(
          unitId: goal.originalUnitId!, amount: v));
    }
    final weeklySumBase = weeklyBase.fold(0.0, (a, b) => a + b);
    final weeklyDisposition = _dispositionFor(weeklySumBase, goal.amountBase);
    final weeklyImpact = _impactFor(weeklySumBase, goal.amountBase);

    // Monthly
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    final daysInMonth = nextMonth.difference(monthStart).inDays;
    final monthMap =
        await _totalsForCategory(goal.categoryId, monthStart, nextMonth);
    final monthlyBase = <double>[];
    double cumulative = 0;
    for (int i = 0; i < daysInMonth; i++) {
      final day = DateTime(monthStart.year, monthStart.month, monthStart.day + i);
      cumulative += monthMap[day] ?? 0;
      monthlyBase.add(cumulative);
    }
    final monthlyTotals = <double>[];
    for (final v in monthlyBase) {
      monthlyTotals.add(
          await conv.fromBase(unitId: goal.originalUnitId!, amount: v));
    }
    final monthlyDisposition = _dispositionFor(cumulative, goal.amountBase);
    final monthlyImpact = _impactFor(cumulative, goal.amountBase);

    final capValue =
        await conv.fromBase(unitId: goal.originalUnitId!, amount: goal.amountBase);

    return GoalProgress(
      goal: goal,
      category: goalData.category,
      unit: goalData.unit,
      capValue: capValue,
      weeklyTotals: weeklyTotals,
      monthlyTotals: monthlyTotals,
      weeklyDisposition: weeklyDisposition,
      monthlyDisposition: monthlyDisposition,
      weeklyImpact: weeklyImpact,
      monthlyImpact: monthlyImpact,
    );
  }
}

