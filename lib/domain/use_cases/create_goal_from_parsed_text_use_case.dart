import 'package:food_app/core/services/text_parsing_service.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_goal_repository.dart';

/// Use case that parses free-form text into a [GoalDataDto] and persists it
/// using the [IGoalRepository].
class CreateGoalFromParsedTextUseCase {
  final TextParsingService parser;
  final IGoalRepository repository;

  CreateGoalFromParsedTextUseCase(this.parser, this.repository);

  Future<bool> execute(
    String rawText, {
    required List<Category> categories,
    required List<Unit> units,
  }) async {
    final dto = await parser.parseGoalFromText(
      rawText,
      availableCategories: categories,
      availableUnits: units,
    );
    if (dto == null) return false;
    await repository.insertGoal(
      categoryId: dto.categoryId,
      period: dto.period,
      capValue: dto.capValueInBase,
      unitId: dto.unitId,
      disposition: dto.disposition,
      impact: dto.impact,
    );
    return true;
  }
}
