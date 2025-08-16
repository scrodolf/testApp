import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/daos/goal_dao.dart';
import 'goal_editor_dialog.dart';

/// Displays all defined nutritional goals.
class GoalListView extends ConsumerWidget {
  const GoalListView({super.key});

  Color _colorForDisposition(GoalDisposition d) {
    switch (d) {
      case GoalDisposition.good:
        return Colors.green;
      case GoalDisposition.bad:
        return Colors.red;
      case GoalDisposition.mixed:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(allGoalsProvider);
    return goalsAsync.when(
      data: (goals) {
        if (goals.isEmpty) {
          return const Center(child: Text('No goals defined.'));
        }
        return ListView.builder(
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final entry = goals[index];
            return Dismissible(
              key: ValueKey(entry.goal.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.startToEnd,
              onDismissed: (_) async {
                await ref
                    .read(goalRepositoryProvider.future)
                    .then((repo) => repo.deleteGoal(entry.goal.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Goal deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        ref.read(goalRepositoryProvider.future).then((repo) =>
                            repo.insertGoal(
                              categoryId: entry.category.id,
                              period: entry.goal.period,
                              capValue: entry.goal.capValue,
                              unitId: entry.unit.id,
                              disposition: entry.goal.disposition,
                              impact: entry.goal.impact,
                            ));
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.flag,
                    color: _colorForDisposition(entry.goal.disposition)),
                title: Text(entry.category.name),
                subtitle: Text(
                    '${entry.goal.period.name} • ${entry.goal.capValue} ${entry.unit.name}'),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => GoalEditorDialog(initial: entry),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
