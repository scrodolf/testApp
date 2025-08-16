import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:food_app/data/providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(allMealLogsProvider);
    return logsAsync.when(
      data: (logs) {
        // Count logs for last 7 days
        final today = DateTime.now();
        final counts = List<int>.generate(7, (_) => 0);
        for (final l in logs) {
          final date = DateTime.parse(l.log.date);
          final diff = today.difference(date).inDays;
          if (diff >= 0 && diff < 7) {
            counts[6 - diff]++;
          }
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Logs last 7 days'),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final day = today
                                .subtract(Duration(days: 6 - value.toInt()));
                            return Text('${day.day}/${day.month}');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < 7; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                              toY: counts[i].toDouble(),
                              color: Theme.of(context).colorScheme.primary),
                        ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
=======

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Statistics Screen Content'),
            SizedBox(height: 8),
            Text(
              'Visualize your progress over time here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
