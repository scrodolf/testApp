import 'package:flutter/material.dart';

/// Supported chart types for parsed visualization requests.
enum ChartType { bar, line, pie }

/// DTO describing a parsed chart configuration that can be converted into
/// an fl_chart [BarChartData] or [LineChartData].
class ChartConfigDto {
  final ChartType chartType;
  final String dataType;
  final bool showValues;
  final bool showSafeZone;
  final Color goodColor;
  final Color mixedColor;
  final Color badColor;

  const ChartConfigDto({
    required this.chartType,
    required this.dataType,
    required this.showValues,
    required this.showSafeZone,
    required this.goodColor,
    required this.mixedColor,
    required this.badColor,
  });
}
