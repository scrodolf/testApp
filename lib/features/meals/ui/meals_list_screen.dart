import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/daos/meal_dao.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';
import 'package:food_app/data/database/app_database.dart';

/// Displays a list of meals with basic information.
class MealsListScreen extends ConsumerWidget {
  const MealsListScreen({super.key});

  Future<void> _deleteWithUndo(
      BuildContext context, WidgetRef ref, MealWithDetails meal) async {
    final repo = await ref.read(mealRepositoryProvider.future);
    await repo.deleteMeal(meal.meal.id);

    final snack = SnackBar(
      content: const Text('Meal deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          final entryInputs = meal.entries
              .map((e) => MealEntryInput(
                  productId: e.entry.productId, quantity: e.entry.quantity))
              .toList();
          final customInputs = meal.customValues
              .map((v) => MealCategoryValueInput(
                  categoryId: v.category.id, value: v.value, unitId: v.unit.id))
              .toList();
          await repo.insertMeal(
              name: meal.meal.name,
              notes: meal.meal.notes,
              entries: entryInputs,
              customValues: customInputs);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(allMealsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meals/create'),
        child: const Icon(Icons.add),
      ),
      body: mealsAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return const Center(
              child: Text('No meals yet. Tap + to create one.'),
            );
          }
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return Dismissible(
                key: ValueKey(meal.meal.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteWithUndo(context, ref, meal),
                child: FutureBuilder<Map<Category, double>>(
                  future: ref
                      .watch(mealCalculationServiceProvider.future)
                      .then((svc) => svc.calculateMealTotals(meal)),
                  builder: (context, snapshot) {
                    String subtitle = '';
                    if (snapshot.hasData) {
                      final totals = snapshot.data!;
                      final calories = totals.entries.firstWhere(
                          (e) => e.key.name == 'Calories',
                          orElse: () => totals.entries.first);
                      final unitAsync = ref.watch(unitsProvider);
                      subtitle = unitAsync.maybeWhen(
                          data: (units) {
                            final unit = units.firstWhere(
                                (u) => u.id == calories.key.defaultDisplayUnitId);
                            return '${calories.value.toStringAsFixed(0)} ${unit.abbreviation}';
                          },
                          orElse: () => '');
                    }
                    return ListTile(
                      title: Text(meal.meal.name ?? 'Unnamed meal'),
                      subtitle: subtitle.isEmpty ? null : Text(subtitle),
                      onTap: () => context.push('/meals/${meal.meal.id}'),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
