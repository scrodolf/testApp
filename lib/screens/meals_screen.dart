import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/meal_repository.dart';
import '../widgets/undo_snackbar.dart';
import 'meal_form_view.dart';
import 'package:food_tracker/l10n/app_localizations.dart';


class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({super.key});

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<Meal> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(mealRepositoryProvider);
    final meals = await repo.getMeals();
    setState(() {
      _items
        ..clear()
        ..addAll(meals);
      _loading = false;
    });
  }

  Future<void> _addMeal() async {
    final result = await context.push<Meal>('/meals/new');
    if (result != null) {
      setState(() {
        _items.insert(0, result);
        _listKey.currentState?.insertItem(0);
      });
    }
  }

  Future<void> _editMeal(Meal meal, int index) async {
    final result = await context.push<Meal>('/meals/${meal.id}');
    if (result != null) {
      setState(() {
        _items[index] = result;
      });
    }
  }

  Future<void> _deleteMeal(int index) async {
    final repo = ref.read(mealRepositoryProvider);
    final removed = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildItem(removed, index),
      ),
    );
    await repo.deleteMeal(removed.id);
    if (!mounted) return;
    showUndoSnackbar(
      context,
      message: AppLocalizations.of(context)!.mealDeleted,
      undoLabel: AppLocalizations.of(context)!.undoButton,
      onUndo: () async {
        await _load();
      },

    );
  }

  Widget _buildItem(Meal meal, int index) {
    return Semantics(
      button: true,
      label: meal.name,
      child: ListTile(
        title: Text(meal.name),
        onTap: () => _editMeal(meal, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.mealsTitle)),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _items.isEmpty
            ? Center(
                key: const ValueKey('empty'),
                child: Text(AppLocalizations.of(context)!.mealsEmpty),
              )
            : AnimatedList(
                key: _listKey,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) {
                  final meal = _items[index];
                  return SizeTransition(

                  sizeFactor: animation,
                  child: Dismissible(
                    key: ValueKey(meal.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteMeal(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Theme.of(context).colorScheme.error,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    child: _buildItem(meal, index),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: Semantics(
        label: AppLocalizations.of(context)!.addMealTooltip,
        button: true,
        child: FloatingActionButton(
          onPressed: _addMeal,
          tooltip: AppLocalizations.of(context)!.addMealTooltip,
          child: const Icon(Icons.add),
        ),

      ),
    );
  }
}

