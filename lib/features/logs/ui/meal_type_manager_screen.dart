import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as dr;
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/database/app_database.dart';

/// Screen allowing users to add, rename and remove meal types.
class MealTypeManagerScreen extends ConsumerWidget {
  const MealTypeManagerScreen({super.key});

  Future<void> _addType(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New meal type'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Add')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      final repo = await ref.read(mealTypeRepositoryProvider.future);
      await repo.insertType(MealTypesCompanion(name: dr.Value(result.trim())));
    }
  }

  Future<void> _renameType(BuildContext context, WidgetRef ref, MealType type) async {
    final controller = TextEditingController(text: type.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename meal type'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      final repo = await ref.read(mealTypeRepositoryProvider.future);
      await repo.updateType(MealTypesCompanion(id: dr.Value(type.id), name: dr.Value(result.trim())));
    }
  }

  Future<void> _deleteType(BuildContext context, WidgetRef ref, MealType type) async {
    final repo = await ref.read(mealTypeRepositoryProvider.future);
    final backup = type;
    await repo.deleteType(type.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Meal type deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => repo.insertType(MealTypesCompanion(name: dr.Value(backup.name))),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(allMealTypesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Types')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addType(context, ref),
        child: const Icon(Icons.add),
      ),
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('No meal types'));
          }
          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              final t = types[index];
              return ListTile(
                title: Text(t.name),
                onTap: () => _renameType(context, ref, t),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteType(context, ref, t),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
