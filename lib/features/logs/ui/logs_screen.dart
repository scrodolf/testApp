import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'log_list_view.dart';
import 'log_calendar_view.dart';
import 'log_editor_dialog.dart';
import 'meal_type_manager_screen.dart';

/// Root screen for viewing meal logs.
class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logs'),
          bottom: const TabBar(tabs: [
            Tab(text: 'List'),
            Tab(text: 'Calendar'),
          ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.label),
              tooltip: 'Manage Meal Types',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const MealTypeManagerScreen()),
                );
              },
            )
          ],
        ),
        body: const TabBarView(
          children: [
            LogListView(),
            LogCalendarView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const LogEditorDialog(),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
