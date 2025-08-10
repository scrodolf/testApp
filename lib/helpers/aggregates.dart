import '../models/meal.dart';

class NutrientSummary {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  NutrientSummary({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

NutrientSummary aggregateMealNutrients(Meal meal) {
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;

  for (final product in meal.products) {
    calories += product.calories;
    protein += product.protein;
    carbs += product.carbs;
    fat += product.fat;
  }

  return NutrientSummary(
    calories: calories,
    protein: protein,
    carbs: carbs,
    fat: fat,
  );
}
