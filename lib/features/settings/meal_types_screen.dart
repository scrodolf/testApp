import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/providers.dart';
import 'providers.dart';

/// Allows users to manage the list of meal types used when logging food.
class MealTypesScreen extends ConsumerWidget {
  const MealTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(editableMealTypesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Types')),
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('No meal types'));
          }
          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, i) {
              final t = types[i];
              return Dismissible(
                key: ValueKey(t.id),
                direction:
                    t.isBuiltin ? DismissDirection.none : DismissDirection.endToStart,
                onDismissed: (_) async {
                  final repo = await ref.read(mealTypeRepositoryProvider.future);
                  await repo.deleteMealType(t.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(t.nameKey),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add meal type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == true) {
      final repo = await ref.read(mealTypeRepositoryProvider.future);
      await repo.insertMealType(name: controller.text, isBuiltin: false);
    }
  }
}
