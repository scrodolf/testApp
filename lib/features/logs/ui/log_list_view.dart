import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:food_app/data/daos/log_dao.dart';
import 'package:food_app/data/providers.dart';
import 'log_editor_dialog.dart';

/// List view of logged meals ordered chronologically.
class LogListView extends ConsumerWidget {
  const LogListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(allLogsProvider);
    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return const Center(child: Text('No logs yet.'));
        }
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final entry = logs[index];
            final dateStr = DateFormat('dd-MM-yyyy HH:mm')
                .format(entry.log.loggedAtLocal);
            return Dismissible(
              key: ValueKey(entry.log.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.startToEnd,
              onDismissed: (_) async {
                await ref
                    .read(logRepositoryProvider.future)
                    .then((repo) => repo.deleteLog(entry.log.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Log deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        ref
                            .read(logRepositoryProvider.future)
                            .then((repo) => repo.insertLog(
                                  mealId: entry.log.mealId,
                                  loggedAtLocal: entry.log.loggedAtLocal,
                                  mealTypeId: entry.log.mealTypeId,
                                ));
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(entry.meal.name),
                subtitle: Text(
                    '$dateStr${entry.mealType != null ? ' • ${entry.mealType!.name}' : ''}'),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => LogEditorDialog(existing: entry.log),
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
