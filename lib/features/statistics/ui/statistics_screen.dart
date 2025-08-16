import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../goals/ui/goal_list_view.dart';
import '../../goals/ui/goal_editor_dialog.dart';
import 'weekly_bar_chart.dart';
import 'monthly_line_chart.dart';

/// Root screen for goals management and statistics visualisation.
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Statistics'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Goals'),
                  Tab(text: 'Progress'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                GoalListView(),
                _ChartsOverview(),
              ],
            ),
            floatingActionButton: controller.index == 0
                ? FloatingActionButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const GoalEditorDialog(),
                    ),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _ChartsOverview extends StatelessWidget {
  const _ChartsOverview();

  @override
  Widget build(BuildContext context) {
    final weeklyValues = [10, 12, 8, 15, 9, 11, 7];
    final monthlyValues = List<double>.generate(30, (i) => (i + 1) * 2.0);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 200,
          child: WeeklyBarChart(values: weeklyValues, cap: 20),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: MonthlyLineChart(values: monthlyValues, cap: 60),
        ),
      ],
    );
  }
}
