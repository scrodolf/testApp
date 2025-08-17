import 'dart:async';

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
    String? productIdForOverrides,
  }) async {
    // Split the incoming text into separate logical lines.  Many labels use
    // Windows line endings, hence the \r?\n pattern.  Using a raw string keeps
    // the backslashes readable.
    final lines = rawText.split(RegExp(r'\r?\n'));
    final categoriesByName = _buildCategoryLookup(availableCategories);
    final unitsByToken = _buildUnitLookup(availableUnits);
    final productId = int.tryParse(productIdForOverrides ?? '');

    String? name;
    double? servingSize;
    Unit? servingUnit;
    final categoryValues = <int, ParsedCategoryValue>{};
    final unrecognized = <String>[];
    final errors = <String>[];

    // Regular expressions to capture the various components.  Units may contain
    // spaces (e.g. "fl oz"), so the pattern allows for whitespace.
    final productReg =
        RegExp(r'^\s*Product:\s*(.+)$', caseSensitive: false);
    final servingReg = RegExp(
      r'^(?:Serving Size|per)[:]?\s*([\d.,]+)\s*([a-zA-Zµ ]+)',
      caseSensitive: false,
    );
    final valueReg = RegExp(
      r'^([^:]+):\s*([\d.,]+)\s*([a-zA-Zµ ]+)',
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
        final unitToken = _normaliseUnitToken(servingMatch.group(2)!);
        final unit = unitsByToken[unitToken];
        if (amount != null && unit != null) {
          final base = await _conversion.toBase(
            amount,
            unit,
            productId: productId,
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
        final label = _normaliseLabel(valueMatch.group(1)!);
        final valueToken = valueMatch.group(2)!.replaceAll(',', '.');
        final unitToken = _normaliseUnitToken(valueMatch.group(3)!);
        final parsedValue = double.tryParse(valueToken);
        final category = categoriesByName[label];
        final unit = unitsByToken[unitToken];
        if (category != null && unit != null && parsedValue != null) {
          final base = await _conversion.toBase(
            parsedValue,
            unit,
            productId: productId,
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
      final key = _normaliseLabel(c.name);
      map[key] = c;
      switch (key) {
        case 'fat':
          map[_normaliseLabel('total fat')] = c;
          break;
        case 'carbs':
          map[_normaliseLabel('carbohydrate')] = c;
          map[_normaliseLabel('carbohydrates')] = c;
          break;
        case 'fiber':
          map[_normaliseLabel('fibre')] = c;
          map[_normaliseLabel('dietary fiber')] = c;
          break;
        case 'calories':
          map[_normaliseLabel('energy')] = c;
          break;
      }
    }
    return map;
  }

  Map<String, Unit> _buildUnitLookup(List<Unit> units) {
    final map = <String, Unit>{};
    for (final u in units) {
      final name = _normaliseUnitToken(u.name);
      map[name] = u;
      map['${name}s'] = u; // plural form
      final symbol = u.symbol;
      if (symbol != null) {
        final sym = _normaliseUnitToken(symbol);
        map[sym] = u;
        map['${sym}s'] = u; // plural symbol
        if (sym == 'µg') {
          // Common textual alternatives for micrograms.
          map['mcg'] = u;
          map['ug'] = u;
        }
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

  /// Normalises a category label for consistent lookup.
  String _normaliseLabel(String input) =>
      input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '').trim();

  /// Normalises a unit token (symbol or name) to ease lookup.
  String _normaliseUnitToken(String input) =>
      input.toLowerCase().replaceAll(RegExp(r'[^a-zµ]'), '');
}

