import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as dr;
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/daos/meal_log_dao.dart';
import 'package:food_app/data/providers.dart';

class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();

  Future<void> _deleteLog(BuildContext context, LogWithMeal item) async {
    final repo = await ref.read(mealLogRepositoryProvider.future);
    final backup = LogItemsCompanion(
      id: dr.Value(item.log.id),
      mealId: dr.Value(item.log.mealId),
      date: dr.Value(item.log.date),
      time: dr.Value(item.log.time),
      mealType: dr.Value(item.log.mealType),
    );
    await repo.deleteLog(item.log.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Log deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => repo.insertLog(backup),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(allMealLogsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logs'),
          bottom: const TabBar(tabs: [
            Tab(text: 'List'),
            Tab(text: 'Calendar'),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/logs/add'),
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            // List view
            logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return const Center(
                    child: Text('No logs yet. Tap + to add one.'),
                  );
                }
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final item = logs[index];
                    return ListTile(
                      title: Text(item.meal.name ?? 'Meal ${item.meal.id}'),
                      subtitle: Text(
                          '${item.log.date} ${item.log.time} · ${item.log.mealType}'),
                      onTap: () => context.go('/logs/${item.log.id}/edit'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteLog(context, item),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            // Calendar view
            Column(
              children: [
                CalendarDatePicker(
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: _selectedDate,
                  onDateChanged: (d) => setState(() => _selectedDate = d),
                ),
                Expanded(
                  child: logsAsync.when(
                    data: (logs) {
                      final filtered = logs
                          .where((l) =>
                              l.log.date ==
                              '${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}')
                          .toList();
                      if (filtered.isEmpty) {
                        return const Center(
                            child: Text('No logs for this day'));
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title:
                                Text(item.meal.name ?? 'Meal ${item.meal.id}'),
                            subtitle:
                                Text('${item.log.time} · ${item.log.mealType}'),
                            onTap: () =>
                                context.go('/logs/${item.log.id}/edit'),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  ),
                )
              ],
=======

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Logs Screen Content'),
            SizedBox(height: 8),
            Text(
              'Review and add daily food logs here.',
              textAlign: TextAlign.center,

            ),
          ],
        ),
      ),
    );
  }
}
