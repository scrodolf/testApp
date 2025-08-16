import 'package:food_app/data/daos/goal_dao.dart';
import 'package:food_app/data/database/app_database.dart';

/// Abstraction for goal persistence.
abstract class IGoalRepository {
  Stream<List<GoalWithDetails>> watchGoals();

  Future<int> insertGoal({
    required int categoryId,
    required GoalPeriod period,
    required double capValue,
    required int unitId,
    required GoalDisposition disposition,
    required GoalImpactLevel impact,
  });

  Future<bool> updateGoal({
    required int id,
    required int categoryId,
    required GoalPeriod period,
    required double capValue,
    required int unitId,
    required GoalDisposition disposition,
    required GoalImpactLevel impact,
  });

  Future<void> deleteGoal(int id);
}
