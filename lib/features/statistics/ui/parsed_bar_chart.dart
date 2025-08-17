import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';

/// Builds a bar chart preview based on a [ChartConfigDto].
///
/// This demonstrates how dynamic chart requests parsed from text can be
/// translated into fl_chart configuration. Values are rendered using the
/// application's brand colour while optional safe-zone annotations are
/// coloured according to the disposition colours in [config].
class ParsedBarChart extends StatelessWidget {
  final ChartConfigDto config;
  final List<double> values;
  final double cap;

  const ParsedBarChart({super.key, required this.config, required this.values, required this.cap});

  @override
  Widget build(BuildContext context) {
    final brand = const Color(0xFF58ACFF);
    final groups = <BarChartGroupData>[
      for (int i = 0; i < values.length; i++)
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: values[i], color: brand, width: 14),
        ]),
    ];

    return BarChart(
      BarChartData(
        barGroups: groups,
        titlesData: FlTitlesData(show: config.showValues),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            if (config.showSafeZone)
              HorizontalRangeAnnotation(
                y1: 0,
                y2: cap,
                color: config.goodColor.withOpacity(0.15),
              ),
          ],
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
