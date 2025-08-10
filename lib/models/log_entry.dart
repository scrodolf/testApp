import 'meal.dart';
import 'product.dart';

class LogEntry {
  final DateTime timestamp;
  final List<Meal> meals;
  final List<Product> products;

  LogEntry({
    required this.timestamp,
    this.meals = const [],
    this.products = const [],
  });
}
