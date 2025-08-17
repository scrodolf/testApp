import 'dart:async';

import 'package:collection/collection.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';

/// Represents a fully parsed product extracted from raw nutritional text.
///
/// All numeric values are converted to the base unit of their dimension
/// (g, mL, kcal) with four decimal precision. Any pieces of information that
/// could not be mapped to a known [Category] or [Unit] are returned in
/// [unmappedItems] so the UI can prompt the user for manual input.
class ParsedProductData {
  ParsedProductData({
    required this.name,
    this.defaultServingSize,
    this.defaultServingUnitId,
    required this.categoryValues,
    this.unmappedItems = const [],
  });

  final String name;
  final double? defaultServingSize;
  final int? defaultServingUnitId;
  final List<CategoryValueInput> categoryValues;
  final List<String> unmappedItems;
}

/// Utility responsible for turning pasted nutritional text into structured
/// product data.
///
/// The parser looks for tokens of the form `Label: value unit` (case
/// insensitive). Examples:
///
/// ```
/// Product: Vegan Protein Blend
/// Serving Size: 30 g
/// Protein: 22.5 g
/// Calories: 110 kcal
/// ```
///
/// Unknown categories or units are collected and exposed via
/// [ParsedProductData.unmappedItems].
class NutritionTextParser {
  NutritionTextParser(this._conversion);

  final IConversionService _conversion;

  /// Parses [rawText] and produces structured product data.
  Future<ParsedProductData> parsePastedNutritionData(
    String rawText, {
    required List<Category> availableCategories,
    required List<Unit> availableUnits,
    int? productId,
  }) async {
    final lines = rawText.split(RegExp(r'\r?\n'));
    final categoryValues = <CategoryValueInput>[];
    final unmapped = <String>[];

    // Build lookup tables for quick name → entity resolution.
    final categoriesByName = {
      for (final c in availableCategories) c.name.toLowerCase(): c,
    };
    final unitsByToken = <String, Unit>{};
    for (final u in availableUnits) {
      unitsByToken[u.name.toLowerCase()] = u;
      final symbol = u.symbol?.toLowerCase();
      if (symbol != null) {
        unitsByToken[symbol] = u;
      }
    }

    String name = 'Unnamed product';
    double? servingSize;
    Unit? servingUnit;

    final productReg = RegExp(r'^\s*Product:\s*(.+)$', caseSensitive: false);
    final servingReg = RegExp(
      r'^\s*Serving Size:\s*([\d.,]+)\s*([a-zA-Zµ]+)',
      caseSensitive: false,
    );
    final valueReg = RegExp(
      r'^\s*([A-Za-zµ ]+):\s*([\d.,]+)\s*([a-zA-Zµ]+)',
      caseSensitive: false,
    );

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (productReg.hasMatch(trimmed)) {
        name = productReg.firstMatch(trimmed)!.group(1)!.trim();
        continue;
      }

      final servingMatch = servingReg.firstMatch(trimmed);
      if (servingMatch != null) {
        final amount =
            double.tryParse(servingMatch.group(1)!.replaceAll(',', '.'));
        final unitToken = servingMatch.group(2)!.toLowerCase();
        final unit = unitsByToken[unitToken];
        if (amount != null && unit != null) {
          final baseValue =
              await _conversion.toBase(amount, unit, productId: productId);
          servingSize = double.parse(baseValue.toStringAsFixed(4));
          servingUnit =
              availableUnits.firstWhereOrNull((u) => u.dimension == unit.dimension && u.factorToBase == 1) ?? unit;
        } else {
          unmapped.add(trimmed);
        }
        continue;
      }

      final valueMatch = valueReg.firstMatch(trimmed);
      if (valueMatch != null) {
        final label = valueMatch.group(1)!.trim().toLowerCase();
        final value =
            double.tryParse(valueMatch.group(2)!.replaceAll(',', '.'));
        final unitToken = valueMatch.group(3)!.toLowerCase();
        final category = categoriesByName[label];
        final unit = unitsByToken[unitToken];
        if (category != null && unit != null && value != null) {
          final baseValue =
              await _conversion.toBase(value, unit, productId: productId);
          final baseUnit = availableUnits.firstWhereOrNull(
                (u) =>
                    u.dimension == unit.dimension && u.factorToBase == 1,
              ) ??
              unit;
          categoryValues.add(CategoryValueInput(
            categoryId: category.id,
            value: double.parse(baseValue.toStringAsFixed(4)),
            unitId: baseUnit.id,
          ));
        } else {
          unmapped.add(trimmed);
        }
      }
    }

    return ParsedProductData(
      name: name,
      defaultServingSize: servingSize,
      defaultServingUnitId: servingUnit?.id,
      categoryValues: categoryValues,
      unmappedItems: unmapped,
    );
  }
}

