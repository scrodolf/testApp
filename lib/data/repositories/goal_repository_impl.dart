import 'package:food_app/data/daos/goal_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_goal_repository.dart';

/// Default implementation of [IGoalRepository].
class GoalRepositoryImpl implements IGoalRepository {
  GoalRepositoryImpl(this._dao);

  final GoalDao _dao;

  @override
  Stream<List<GoalWithDetails>> watchGoals() => _dao.watchAllGoals();

  @override
  Future<int> insertGoal({
    required int categoryId,
    required GoalPeriod period,
    required double capValue,
    required int unitId,
    required GoalDisposition disposition,
    required GoalImpactLevel impact,
  }) {
    return _dao.insertGoal(GoalsCompanion.insert(
      categoryId: categoryId,
      period: Value(period),
      capValue: capValue,
      unitId: unitId,
      disposition: Value(disposition),
      impact: Value(impact),
    ));
  }

  @override
  Future<bool> updateGoal({
    required int id,
    required int categoryId,
    required GoalPeriod period,
    required double capValue,
    required int unitId,
    required GoalDisposition disposition,
    required GoalImpactLevel impact,
  }) {
    return _dao.updateGoal(GoalsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      period: Value(period),
      capValue: Value(capValue),
      unitId: Value(unitId),
      disposition: Value(disposition),
      impact: Value(impact),
    ));
  }

  @override
  Future<void> deleteGoal(int id) => _dao.deleteGoal(id);
}
