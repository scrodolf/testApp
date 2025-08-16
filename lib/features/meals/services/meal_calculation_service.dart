import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/daos/meal_dao.dart';

/// Service responsible for summing nutritional values of a meal.
///
/// All calculations are performed in base units and then converted into each
/// category's default display unit for presentation.
class MealCalculationService {
  MealCalculationService(this._conversion, this._units);

  final IConversionService _conversion;
  final IUnitRegistry _units;

  /// Calculates totals for each category in [meal].
  ///
  /// Returns a map of `Category -> value` where the value is expressed in the
  /// category's `defaultDisplayUnitId`.
  Future<Map<Category, double>> calculateMealTotals(
      MealWithDetails meal) async {
    // Aggregate all amounts in base units first
    final totals = <int, double>{};
    for (final entry in meal.entries) {
      for (final value in entry.product.values) {
        final amount = value.value * entry.entry.quantity;
        totals.update(value.category.id, (v) => v + amount,
            ifAbsent: () => amount);
      }
    }
    for (final custom in meal.customValues) {
      totals.update(custom.category.id, (v) => v + custom.value,
          ifAbsent: () => custom.value);
    }

    // Map category id to Category for quick lookup
    final categoryLookup = <int, Category>{};
    for (final entry in meal.entries) {
      for (final val in entry.product.values) {
        categoryLookup[val.category.id] = val.category;
      }
    }
    for (final custom in meal.customValues) {
      categoryLookup[custom.category.id] = custom.category;
    }

    final result = <Category, double>{};
    final baseUnits = <String, Unit>{};
    for (final entry in totals.entries) {
      final category = categoryLookup[entry.key]!;
      // Obtain base unit for dimension
      var baseUnit = baseUnits[category.baseDimension];
      if (baseUnit == null) {
        final units = await _units.getUnitsByDimension(category.baseDimension);
        baseUnit =
            units.firstWhere((u) => u.factorToBase == 1, orElse: () => units.first);
        baseUnits[category.baseDimension] = baseUnit;
      }
      // Convert base amount to the category's default display unit
      final displayUnit = await _units.getUnitById(category.defaultDisplayUnitId);
      final converted =
          await _conversion.convert(entry.value, baseUnit.id, displayUnit.id);
      result[category] = converted;
    }

    return result;
  }
}
