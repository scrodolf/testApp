import 'package:drift/drift.dart';
import 'package:food_app/data/database/app_database.dart';

/// Aggregates a goal with its category and unit.
class GoalWithDetails {
  GoalWithDetails({
    required this.goal,
    required this.category,
    required this.unit,
  });

  final Goal goal;
  final Category category;
  final Unit unit;
}

/// DAO for nutritional goals.
class GoalDao {
  GoalDao(this._db);

  final AppDatabase _db;

  Stream<List<GoalWithDetails>> watchAllGoals() {
    final query = _db.select(_db.goals).join([
      innerJoin(
          _db.categories, _db.categories.id.equalsExp(_db.goals.categoryId)),
      innerJoin(_db.units, _db.units.id.equalsExp(_db.goals.unitId)),
    ]);
    return query.watch().map((rows) => rows
        .map((r) => GoalWithDetails(
              goal: r.readTable(_db.goals),
              category: r.readTable(_db.categories),
              unit: r.readTable(_db.units),
            ))
        .toList());
  }

  Future<int> insertGoal(GoalsCompanion entry) {
    return _db.into(_db.goals).insert(entry);
  }

  Future<bool> updateGoal(GoalsCompanion entry) {
    return _db.update(_db.goals).replace(entry);
  }

  Future<int> deleteGoal(int id) {
    return (_db.delete(_db.goals)..where((t) => t.id.equals(id))).go();
  }
}
