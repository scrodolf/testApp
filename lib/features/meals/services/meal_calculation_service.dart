import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/data/daos/meal_dao.dart';

/// Service responsible for summing nutritional values of a meal.
class MealCalculationService {
  MealCalculationService(this._conversion);

  final IConversionService _conversion;

  /// Calculates totals for each category in [meal].
  ///
  /// Returns a map of `categoryId -> totalValue` expressed in the category's
  /// base unit.
  Future<Map<int, double>> calculateMealTotals(MealWithDetails meal) async {
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
    return totals;
  }
}
