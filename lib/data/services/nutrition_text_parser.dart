import 'dart:async';

import 'package:collection/collection.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/models/parsed_product_data.dart';

/// Utility responsible for turning pasted nutritional text into structured
/// [ParsedProductData].
class NutritionTextParser {
  NutritionTextParser(this._conversion);

  final IConversionService _conversion;

  /// Parses [rawText] containing nutrition facts.
  Future<ParsedProductData> parsePastedNutritionData(
    String rawText, {
    required List<Category> availableCategories,
    required List<Unit> availableUnits,
    int? productIdForOverrides,
  }) async {
    final lines = rawText.split(RegExp(r'\\r?\\n'));
    final categoriesByName = _buildCategoryLookup(availableCategories);
    final unitsByToken = _buildUnitLookup(availableUnits);

    String? name;
    double? servingSize;
    Unit? servingUnit;
    final categoryValues = <int, ParsedCategoryValue>{};
    final unrecognized = <String>[];
    final errors = <String>[];

    final productReg =
        RegExp(r'^\\s*Product:\\s*(.+)\\$', caseSensitive: false);
    final servingReg = RegExp(
      r'^(?:Serving Size|per)[:]?\\s*([\\d.,]+)\\s*([a-zA-Zµ]+)',
      caseSensitive: false,
    );
    final valueReg = RegExp(
      r'^([^:]+):\\s*([\\d.,]+)\\s*([a-zA-Zµ]+)',
      caseSensitive: false,
    );

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      final productMatch = productReg.firstMatch(trimmed);
      if (productMatch != null) {
        name = productMatch.group(1)!.trim();
        continue;
      }

      final servingMatch = servingReg.firstMatch(trimmed);
      if (servingMatch != null) {
        final amount =
            double.tryParse(servingMatch.group(1)!.replaceAll(',', '.'));
        final unitToken = servingMatch.group(2)!.toLowerCase();
        final unit = unitsByToken[unitToken];
        if (amount != null && unit != null) {
          final base = await _conversion.toBase(
            amount,
            unit,
            productId: productIdForOverrides,
          );
          servingSize = double.parse(base.toStringAsFixed(4));
          servingUnit = _findBaseUnit(unit, availableUnits);
        } else {
          unrecognized.add(trimmed);
        }
        continue;
      }

      final valueMatch = valueReg.firstMatch(trimmed);
      if (valueMatch != null) {
        final label = valueMatch.group(1)!.trim().toLowerCase();
        final valueToken = valueMatch.group(2)!.replaceAll(',', '.');
        final unitToken = valueMatch.group(3)!.toLowerCase();
        final parsedValue = double.tryParse(valueToken);
        final category = categoriesByName[label];
        final unit = unitsByToken[unitToken];
        if (category != null && unit != null && parsedValue != null) {
          final base = await _conversion.toBase(
            parsedValue,
            unit,
            productId: productIdForOverrides,
          );
          final baseUnit = _findBaseUnit(unit, availableUnits);
          categoryValues[category.id] = ParsedCategoryValue(
            value: double.parse(base.toStringAsFixed(4)),
            unitId: baseUnit.id,
          );
        } else {
          if (parsedValue == null) {
            errors.add('Could not parse number in ' + trimmed);
          } else {
            unrecognized.add(trimmed);
          }
        }
      } else {
        unrecognized.add(trimmed);
      }
    }

    return ParsedProductData(
      name: name,
      defaultServingSize: servingSize,
      defaultServingUnitId: servingUnit?.id,
      categoryValues: categoryValues,
      unrecognizedItems: unrecognized,
      parsingErrors: errors,
    );
  }

  Map<String, Category> _buildCategoryLookup(List<Category> categories) {
    final map = <String, Category>{};
    for (final c in categories) {
      final key = c.name.toLowerCase();
      map[key] = c;
      switch (key) {
        case 'fat':
          map['total fat'] = c;
          break;
        case 'carbs':
          map['carbohydrates'] = c;
          break;
        case 'fiber':
          map['fibre'] = c;
          map['dietary fiber'] = c;
          break;
        case 'calories':
          map['energy'] = c;
          break;
      }
    }
    return map;
  }

  Map<String, Unit> _buildUnitLookup(List<Unit> units) {
    final map = <String, Unit>{};
    for (final u in units) {
      map[u.name.toLowerCase()] = u;
      final symbol = u.symbol?.toLowerCase();
      if (symbol != null) {
        map[symbol] = u;
      }
    }
    return map;
  }

  Unit _findBaseUnit(Unit unit, List<Unit> units) {
    return units.firstWhere(
      (u) => u.dimension == unit.dimension && u.factorToBase == 1,
      orElse: () => unit,
    );
  }
}

