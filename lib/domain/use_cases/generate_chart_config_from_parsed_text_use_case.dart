import 'package:food_app/core/services/text_parsing_service.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';

/// Use case that parses a free-form chart description and returns a structured
/// [ChartConfigDto] for the presentation layer.
class GenerateChartConfigFromParsedTextUseCase {
  final TextParsingService parser;
  GenerateChartConfigFromParsedTextUseCase(this.parser);

  Future<ChartConfigDto?> execute(String rawText) {
    return parser.parseChartConfigFromText(rawText);
  }
}
