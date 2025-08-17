import 'package:flutter/material.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';
import 'package:food_app/domain/models/goal_data_dto.dart';

/// Parses free-form user text into structured domain objects.
class TextParsingService {
  final ConversionService conversionService;

  TextParsingService(this.conversionService);

  /// Parses a goal definition from [rawText]. Returns `null` when mandatory
  /// parts are missing or unrecognized.
  Future<GoalDataDto?> parseGoalFromText(
    String rawText, {
    required List<Category> availableCategories,
    required List<Unit> availableUnits,
  }) async {
    final lower = rawText.toLowerCase();

    final periodMatch = RegExp(r'(weekly|monthly)').firstMatch(lower);
    final categoryMatch =
        RegExp(r'goal for ([a-zA-Z ]+):').firstMatch(lower);
    final valueMatch =
        RegExp(r':\s*([0-9]+(?:\.[0-9]+)?)\s*([a-zµ]+)').firstMatch(lower);
    final dispositionMatch =
        RegExp(r'(good|bad|mixed)').firstMatch(lower);
    final impactMatch =
        RegExp(r'(mild|moderate|severe)').firstMatch(lower);

    if (periodMatch == null ||
        categoryMatch == null ||
        valueMatch == null ||
        dispositionMatch == null ||
        impactMatch == null) {
      return null;
    }

    final period = periodMatch.group(0) == 'weekly'
        ? GoalPeriod.weekly
        : GoalPeriod.monthly;
    final categoryName = categoryMatch.group(1)!.trim();
    final category = availableCategories.firstWhere(
        (c) => c.name.toLowerCase() == categoryName,
        orElse: () => Category(
              id: -1,
              name: categoryName,
              dimension: '',
              isBuiltin: false,
            ));
    if (category.id == -1) return null;

    final value = double.parse(valueMatch.group(1)!);
    final unitSymbol = valueMatch.group(2)!.trim();
    final unit = availableUnits.firstWhere(
        (u) => u.symbol.toLowerCase() == unitSymbol,
        orElse: () => Unit(
              id: -1,
              name: unitSymbol,
              symbol: unitSymbol,
              dimension: '',
              factorToBase: 1,
              isCustom: false,
            ));
    if (unit.id == -1) return null;

    final capValueInBase = await conversionService.toBase(value, unit);

    final disposition = {
      'good': GoalDisposition.good,
      'bad': GoalDisposition.bad,
      'mixed': GoalDisposition.mixed,
    }[dispositionMatch.group(0)!]!;

    final impact = {
      'mild': GoalImpactLevel.mild,
      'moderate': GoalImpactLevel.moderate,
      'severe': GoalImpactLevel.severe,
    }[impactMatch.group(0)!]!;

    return GoalDataDto(
      period: period,
      categoryId: category.id,
      capValueInBase: double.parse(capValueInBase.toStringAsFixed(4)),
      unitId: unit.id,
      disposition: disposition,
      impact: impact,
    );
  }

  /// Parses a visualization specification from [rawText]. Returns `null` when
  /// nothing meaningful can be extracted.
  Future<ChartConfigDto?> parseChartConfigFromText(String rawText) async {
    final lower = rawText.toLowerCase();

    ChartType? type;
    if (lower.contains('bar chart')) {
      type = ChartType.bar;
    } else if (lower.contains('line chart')) {
      type = ChartType.line;
    } else if (lower.contains('pie chart')) {
      type = ChartType.pie;
    }
    if (type == null) return null;

    final dataTypeMatch = RegExp(r'for ([a-z ]+)\.').firstMatch(lower);
    final dataType = dataTypeMatch?.group(1)?.trim() ?? '';

    final showValues = lower.contains('always display numbers') ||
        lower.contains('always show numbers');
    final showSafeZone = lower.contains('safe zone');

    Color parseColor(String name, Color fallback) {
      switch (name) {
        case 'green':
          return Colors.green;
        case 'amber':
          return Colors.amber;
        case 'red':
          return Colors.red;
        default:
          return fallback;
      }
    }

    final goodColor = parseColor(RegExp(r'use ([a-z]+) for good')
            .firstMatch(lower)
            ?.group(1) ??
        'green', Colors.green);
    final mixedColor = parseColor(RegExp(r', ([a-z]+) for mixed')
            .firstMatch(lower)
            ?.group(1) ??
        'amber', Colors.amber);
    final badColor = parseColor(RegExp(r', ([a-z]+) for bad')
            .firstMatch(lower)
            ?.group(1) ??
        'red', Colors.red);

    return ChartConfigDto(
      chartType: type,
      dataType: dataType,
      showValues: showValues,
      showSafeZone: showSafeZone,
      goodColor: goodColor,
      mixedColor: mixedColor,
      badColor: badColor,
    );
  }
}
