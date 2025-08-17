import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/providers.dart';

/// Screen allowing the user to manage meal types.
class MealTypeManagerScreen extends ConsumerWidget {
  const MealTypeManagerScreen({super.key});

  Future<void> _addType(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal Type'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final repo = await ref.read(mealTypeRepositoryProvider.future);
      await repo.insertMealType(name: result, isBuiltin: false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(allMealTypesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Types')),
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('No meal types.'));
          }
          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              final t = types[index];
              return Dismissible(
                key: ValueKey(t.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) async {
                  await ref
                      .read(mealTypeRepositoryProvider.future)
                      .then((repo) => repo.deleteMealType(t.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Meal type deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          ref
                              .read(mealTypeRepositoryProvider.future)
                      .then((repo) => repo.insertMealType(
                                  name: t.nameKey, isBuiltin: t.isBuiltin));
                        },
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(t.nameKey),
                  onTap: () async {
                    final controller = TextEditingController(text: t.nameKey);
                    final newName = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Meal Type'),
                        content: TextField(controller: controller),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, controller.text),
                              child: const Text('Save')),
                        ],
                      ),
                    );
                    if (newName != null && newName.isNotEmpty) {
                      final repo =
                          await ref.read(mealTypeRepositoryProvider.future);
                      await repo.updateMealType(
                          id: t.id, name: newName, isBuiltin: t.isBuiltin);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addType(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
