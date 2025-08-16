import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';

/// Controller handling creation of meals.
class CreateMealController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    String? name,
    String? notes,
    required List<MealEntryInput> entries,
    required List<MealCategoryValueInput> customValues,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = await ref.read(mealRepositoryProvider.future);
      await repo.insertMeal(
          name: name,
          notes: notes,
          entries: entries,
          customValues: customValues);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final createMealControllerProvider =
    AsyncNotifierProvider<CreateMealController, void>(CreateMealController.new);
