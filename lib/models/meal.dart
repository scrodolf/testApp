import 'product.dart';

class Meal {
  final String name;
  final String? description;
  final List<Product> products;

  Meal({
    required this.name,
    this.description,
    this.products = const [],
  });
}
