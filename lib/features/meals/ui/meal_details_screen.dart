import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';

/// Shows details for a single meal.
class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.mealId});

  final int mealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealAsync = ref.watch(mealDetailsProvider(mealId));
    return Scaffold(
      appBar: AppBar(
        title: mealAsync.maybeWhen(
            data: (m) => Text(m?.meal.name ?? ''),
            orElse: () => const Text('')),
      ),
      body: mealAsync.when(
        data: (meal) {
          if (meal == null) {
            return const Center(child: Text('Meal not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Products', style: TextStyle(fontSize: 16)),
              ...meal.entries.map((e) => ListTile(
                    title: Text(e.product.product.name),
                    trailing: Text('x${e.entry.quantity}'),
                  )),
              const SizedBox(height: 16),
              FutureBuilder<Map<int, double>>(
                future: ref
                    .watch(mealCalculationServiceProvider.future)
                    .then((svc) => svc.calculateMealTotals(meal)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final totals = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: totals.entries
                        .map((e) => Text('Category ${e.key}: ${e.value}'))
                        .toList(),
                  );
                },
              )
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
