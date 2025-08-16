import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as dr;
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_meal_log_repository.dart';
import 'package:food_app/data/providers.dart';

/// Controller handling creation, update and deletion of log entries.
class LogMealController extends AsyncNotifier<void> {
  LogMealController();

  late final IMealLogRepository _repo;

  @override
  Future<void> build() async {
    _repo = await ref.watch(mealLogRepositoryProvider.future);
  }

  Future<void> saveLog(
      {int? id,
      required int mealId,
      required String date,
      required String time,
      required String mealType}) async {
    state = const AsyncLoading();
    final companion = LogItemsCompanion(
      id: id == null ? const dr.Value.absent() : dr.Value(id),
      mealId: dr.Value(mealId),
      date: dr.Value(date),
      time: dr.Value(time),
      mealType: dr.Value(mealType),
    );
    if (id == null) {
      await _repo.insertLog(companion);
    } else {
      await _repo.updateLog(companion);
    }
    state = const AsyncData(null);
  }

  Future<void> deleteLog(int id) async {
    state = const AsyncLoading();
    await _repo.deleteLog(id);
    state = const AsyncData(null);
  }
}

/// Provider for [LogMealController].
final logMealControllerProvider =
    AsyncNotifierProvider<LogMealController, void>(LogMealController.new);
