import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';
import '../../goals/ui/goal_list_view.dart';
import '../../goals/ui/goal_editor_dialog.dart';
import '../../shared/widgets/paste_data_dialog.dart';
import 'weekly_bar_chart.dart';
import 'monthly_line_chart.dart';
import 'parsed_bar_chart.dart';

/// Root screen for goals management and statistics visualisation.
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  ChartConfigDto? _customChart;

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
              actions: [
                if (controller.index == 1)
                  IconButton(
                    icon: const Icon(Icons.paste),
                    onPressed: () async {
                      final config = await showDialog<ChartConfigDto>(
                        context: context,
                        builder: (_) => const PasteDataDialog(),
                      );
                      setState(() => _customChart = config);
                    },
                  )
              ],
            ),
            body: TabBarView(
              children: [
                const GoalListView(),
                _ChartsOverview(config: _customChart),
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
  final ChartConfigDto? config;
  const _ChartsOverview({this.config});

  @override
  Widget build(BuildContext context) {
    final weeklyValues = [10, 12, 8, 15, 9, 11, 7];
    final monthlyValues = List<double>.generate(30, (i) => (i + 1) * 2.0);
    final children = <Widget>[
      SizedBox(
        height: 200,
        child: WeeklyBarChart(values: weeklyValues, cap: 20),
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: 200,
        child: MonthlyLineChart(values: monthlyValues, cap: 60),
      ),
    ];
    if (config != null) {
      children.add(const SizedBox(height: 24));
      if (config!.chartType == ChartType.bar) {
        children.add(
          SizedBox(
            height: 200,
            child: ParsedBarChart(
              config: config!,
              values: weeklyValues,
              cap: 20,
            ),
          ),
        );
      } else {
        children.add(
          Text('Custom chart: ${config!.chartType.name} for ${config!.dataType}'),
        );
      }
    }
    return ListView(padding: const EdgeInsets.all(16), children: children);
  }
}
