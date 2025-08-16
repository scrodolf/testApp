import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Simple line chart showing cumulative monthly progress.
class MonthlyLineChart extends StatelessWidget {
  const MonthlyLineChart({super.key, required this.values, required this.cap});

  final List<double> values; // length = days in month
  final double cap;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: cap * 1.2,
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i])
            ],
            isCurved: false,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(y: cap, color: Colors.red, strokeWidth: 2),
        ]),
      ),
    );
  }
}
