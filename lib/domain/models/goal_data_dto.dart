/// Data Transfer Object representing a parsed nutritional goal.
///
/// Values are stored in base units (grams, milliliters, kilocalories)
/// so they can be inserted directly into the database.
import 'package:food_app/data/database/app_database.dart';

class GoalDataDto {
  final GoalPeriod period;
  final int categoryId;
  final double capValueInBase;
  final int unitId;
  final GoalDisposition disposition;
  final GoalImpactLevel impact;

  const GoalDataDto({
    required this.period,
    required this.categoryId,
    required this.capValueInBase,
    required this.unitId,
    required this.disposition,
    required this.impact,
  });
}
