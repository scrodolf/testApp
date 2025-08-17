import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/goals/ui/goal_list_view.dart';
import 'package:food_app/features/shared/widgets/paste_data_dialog.dart';

/// Screen hosting [GoalListView] with a paste action to add goals from text.
class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => const PasteDataDialog(),
              );
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Goal saved')), );
              }
            },
          )
        ],
      ),
      body: const GoalListView(),
    );
  }
}
