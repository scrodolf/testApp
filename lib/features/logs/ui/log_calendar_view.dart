import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:food_app/data/daos/log_dao.dart';
import 'package:food_app/data/providers.dart';

/// Calendar view for logged meals.
class LogCalendarView extends ConsumerStatefulWidget {
  const LogCalendarView({super.key});

  @override
  ConsumerState<LogCalendarView> createState() => _LogCalendarViewState();
}

class _LogCalendarViewState extends ConsumerState<LogCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(allLogsProvider);
    return logsAsync.when(
      data: (logs) {
        final events = <DateTime, List<LogWithDetails>>{};
        for (final l in logs) {
          final day = DateTime(l.log.loggedAtLocal.year, l.log.loggedAtLocal.month,
              l.log.loggedAtLocal.day);
          events.putIfAbsent(day, () => []).add(l);
        }
        final selectedEvents = events[_selectedDay] ?? [];
        return Column(
          children: [
            TableCalendar<LogWithDetails>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              locale: 'en_GB',
              eventLoader: (day) => events[day] ?? [],
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: selectedEvents.length,
                itemBuilder: (context, index) {
                  final entry = selectedEvents[index];
                  final timeStr =
                      DateFormat('HH:mm').format(entry.log.loggedAtLocal);
                  return ListTile(
                    title: Text(entry.meal.name),
                    subtitle: Text(
                        '$timeStr${entry.mealType != null ? ' • ${entry.mealType!.name}' : ''}'),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => LogEditorDialog(existing: entry.log),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
