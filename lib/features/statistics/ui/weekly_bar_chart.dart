import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Simple bar chart showing daily totals against a weekly cap.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.values, required this.cap});

  final List<double> values; // length 7
  final double cap;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: cap * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(show: false),
        barGroups: [
          for (int i = 0; i < values.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: values[i], color: Colors.blue, width: 14),
            ]),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: cap, color: Colors.red, strokeWidth: 2),
        ]),
      ),
    );
  }
}
