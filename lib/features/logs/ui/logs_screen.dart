import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as dr;
import 'package:table_calendar/table_calendar.dart';
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

  Future<void> _deleteLog(BuildContext context, LogWithDetails item) async {
    final repo = await ref.read(mealLogRepositoryProvider.future);
    final backup = LogItemsCompanion(
      id: dr.Value(item.log.id),
      mealId: dr.Value(item.log.mealId),
      loggedAtLocal: dr.Value(item.log.loggedAtLocal),
      mealTypeId: dr.Value(item.log.mealTypeId),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.label),
              onPressed: () => context.go('/logs/types'),
            )
          ],
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
                    final d = item.log.loggedAtLocal;
                    final dateStr =
                        '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
                    final timeStr =
                        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
                    final future = Future<double?>(() async {
                      final svc =
                          await ref.read(mealCalculationServiceProvider.future);
                      final mealDetails =
                          await ref.read(mealDetailsProvider(item.meal.id).future);
                      if (mealDetails == null) return null;
                      final totals = await svc.calculateMealTotals(mealDetails);
                      final entry = totals.entries
                          .firstWhere((e) => e.key.name == 'Calories',
                              orElse: () => null);
                      return entry?.value;
                    });
                    return FutureBuilder<double?>(
                      future: future,
                      builder: (context, snapshot) {
                        final cal = snapshot.data;
                        final calStr =
                            cal == null ? '' : ' · ${cal.toStringAsFixed(0)} kcal';
                        return ListTile(
                          title:
                              Text(item.meal.name ?? 'Meal ${item.meal.id}'),
                          subtitle: Text(
                              '$dateStr $timeStr · ${item.mealType.name}$calStr'),
                          onTap: () => context.go('/logs/${item.log.id}/edit'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteLog(context, item),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            // Calendar view
            logsAsync.when(
              data: (logs) {
                final events = <DateTime, List<LogWithDetails>>{};
                for (final l in logs) {
                  final day = DateTime(
                      l.log.loggedAtLocal.year,
                      l.log.loggedAtLocal.month,
                      l.log.loggedAtLocal.day);
                  events.putIfAbsent(day, () => []).add(l);
                }
                final dayLogs = events[_selectedDate] ?? [];
                return Column(
                  children: [
                    TableCalendar<LogWithDetails>(
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      focusedDay: _selectedDate,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      selectedDayPredicate: (d) => isSameDay(d, _selectedDate),
                      eventLoader: (d) =>
                          events[DateTime(d.year, d.month, d.day)] ?? [],
                      onDaySelected: (selected, focused) =>
                          setState(() => _selectedDate = selected),
                    ),
                    Expanded(
                      child: dayLogs.isEmpty
                          ? const Center(child: Text('No logs for this day'))
                          : ListView.builder(
                              itemCount: dayLogs.length,
                              itemBuilder: (context, index) {
                                final item = dayLogs[index];
                                final d = item.log.loggedAtLocal;
                                final timeStr =
                                    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
                                final future = Future<double?>(() async {
                                  final svc = await ref
                                      .read(mealCalculationServiceProvider.future);
                                  final details = await ref
                                      .read(mealDetailsProvider(item.meal.id).future);
                                  if (details == null) return null;
                                  final totals =
                                      await svc.calculateMealTotals(details);
                                  final entry = totals.entries.firstWhere(
                                      (e) => e.key.name == 'Calories',
                                      orElse: () => null);
                                  return entry?.value;
                                });
                                return FutureBuilder<double?>(
                                  future: future,
                                  builder: (context, snapshot) {
                                    final cal = snapshot.data;
                                    final calStr = cal == null
                                        ? ''
                                        : ' · ${cal.toStringAsFixed(0)} kcal';
                                    return ListTile(
                                      title: Text(item.meal.name ??
                                          'Meal ${item.meal.id}'),
                                      subtitle: Text(
                                          '$timeStr · ${item.mealType.name}$calStr'),
                                      onTap: () => context
                                          .go('/logs/${item.log.id}/edit'),
                                    );
                                  },
                                );
                              },
                            ),
                    )
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
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
