import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/goal_repository.dart';
import 'goal_editor_dialog.dart';

Color _colorForDisposition(GoalDisposition d) {
  switch (d) {
    case GoalDisposition.good:
      return Colors.green;
    case GoalDisposition.mixed:
      return Colors.amber;
    case GoalDisposition.bad:
      return Colors.red;
  }
}

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int? _selectedGoalId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.statisticsTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.goalsTab),
            Tab(text: AppLocalizations.of(context)!.progressTab),
          ],
        ),
      ),
      body: goalsAsync.when(
        data: (goals) {
          _selectedGoalId ??= goals.isNotEmpty ? goals.first.goal.id : null;
          return TabBarView(
            controller: _tabController,
            children: [
              _buildGoalsTab(goals),
              _buildProgressTab(goals),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const GoalEditorDialog(),
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildGoalsTab(List<GoalWithDetails> goals) {
    if (goals.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context)!.goalsEmptyMessage));
    }
    final repo = ref.read(goalRepositoryProvider);
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final g = goals[index];
        return Dismissible(
          key: ValueKey(g.goal.id),
          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) {
            repo.deleteGoal(g.goal.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.goalDeleted),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.undoButton,
                  onPressed: () {
                    repo.addGoal(
                      categoryId: g.goal.categoryId,
                      period: g.goal.period,
                      amountBase: g.goal.amountBase,
                      originalUnitId: g.goal.originalUnitId!,
                    );
                  },
                ),
              ),
            );
          },
          child: ListTile(
            title: Text(g.category.nameKey),
            subtitle: Text('${g.goal.period.name} • '
                '${g.capValue.toStringAsFixed(2)} ${g.unit?.symbol ?? ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => GoalEditorDialog(goal: g),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressTab(List<GoalWithDetails> goals) {
    if (goals.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context)!.goalsEmptyMessage));
    }
    final goal = goals.firstWhere((g) => g.goal.id == _selectedGoalId);
    final progressAsync = ref.watch(goalProgressProvider(goal.goal.id));
    return progressAsync.when(
      data: (progress) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton<int>(
                value: _selectedGoalId,
                isExpanded: true,
                items: goals
                    .map((g) => DropdownMenuItem(
                          value: g.goal.id,
                          child: Text(g.category.nameKey),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGoalId = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: _WeeklyChart(progress: progress),
              ),
              const SizedBox(height: 24),
              if (progress.weeklyDisposition == GoalDisposition.good &&
                  progress.monthlyDisposition != GoalDisposition.good)
                Text(AppLocalizations.of(context)!.monthlyWarning,
                    style: TextStyle(color: _colorForDisposition(progress.monthlyDisposition))),
              SizedBox(
                height: 220,
                child: _MonthlyChart(progress: progress),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.progress});
  final GoalProgress progress;

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final bars = <BarChartGroupData>[];
    for (var i = 0; i < 7; i++) {
      final val = progress.weeklyTotals[i];
      final color = val <= progress.capValue
          ? Colors.green
          : val <= progress.capValue * 1.1
              ? Colors.amber
              : Colors.red;
      bars.add(
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: val, color: color, width: 16, borderRadius: BorderRadius.zero),
        ]),
      );
    }
    return BarChart(
      BarChartData(
        maxY: progress.capValue * 1.2,
        barGroups: bars,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Text(days[v.toInt()]),
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) {
                final idx = v.toInt();
                if (idx < 0 || idx >= progress.weeklyTotals.length) {
                  return const SizedBox.shrink();
                }
                final val = progress.weeklyTotals[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(val.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.labelSmall),
                );
              },
            ),
          ),
        ),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 0,
              y2: progress.capValue,
              color: Colors.green.withOpacity(0.2),
            )
          ],
        ),
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.progress});
  final GoalProgress progress;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < progress.monthlyTotals.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), progress.monthlyTotals[i]));
    }
    return LineChart(
      LineChartData(
        maxY: progress.capValue * 1.2,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) {
                final idx = v.toInt() - 1;
                if (idx < 0 || idx >= progress.monthlyTotals.length) {
                  return const SizedBox.shrink();
                }
                final val = progress.monthlyTotals[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(val.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.labelSmall),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(enabled: false),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 0,
              y2: progress.capValue,
              color: Colors.green.withOpacity(0.2),
            )
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 3,
            color: _colorForDisposition(progress.monthlyDisposition),
            dotData: FlDotData(show: true),
          )
        ],
      ),
    );
  }
}

