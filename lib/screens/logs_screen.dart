import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/log_repository.dart';
import 'log_entry_dialog.dart';

/// Displays a calendar and chronological list of log entries for the selected
/// day.
class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(logsByDateProvider(_selectedDay));
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.logsTitle)),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: const CalendarStyle(
              markersAlignment: Alignment.bottomCenter,
            ),
          ),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context)!.logsEmpty)),
                }
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final entry = logs[index];
                    final name = entry.meal?.name ??
                        entry.product?.name ??
                        AppLocalizations.of(context)!.unknown;
                    final dateStr =
                        DateFormat('dd-MM-yyyy HH:mm').format(entry.log.loggedAtLocal);
                    final qty = entry.log.quantity.toStringAsFixed(2);
                    return Dismissible(
                      key: ValueKey(entry.log.id),
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (_) {
                        final repo = ref.read(logRepositoryProvider);
                        repo.deleteLog(entry.log.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.logDeleted),
                            action: SnackBarAction(
                              label:
                                  AppLocalizations.of(context)!.undoButton,
                              onPressed: () {
                                repo.addLog(
                                  mealId: entry.log.mealId,
                                  productId: entry.log.productId,
                                  quantity: entry.log.quantity,
                                  loggedAtLocal: entry.log.loggedAtLocal,
                                  mealTypeId: entry.log.mealTypeId,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(dateStr),
                        trailing: Text(qty),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => LogEntryDialog(entry: entry),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => LogEntryDialog(initialDate: _selectedDay),
        ),
        tooltip: AppLocalizations.of(context)!.logsAddTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}


