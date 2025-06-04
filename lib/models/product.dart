class Product {
  final String name;
  final String? description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  Product({
    required this.name,
    this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
