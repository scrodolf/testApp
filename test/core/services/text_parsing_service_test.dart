import 'package:test/test.dart';
import 'package:food_app/core/services/text_parsing_service.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';

class _FakeConversionService implements IConversionService {
  @override
  Future<double> convert(double value, int sourceUnitId, int targetUnitId,
          {int? productId}) async => value;

  @override
  Future<double> fromBase(double baseValue, Unit targetUnit,
          {int? productId}) async => baseValue / targetUnit.factorToBase;

  @override
  Future<double> toBase(double value, Unit unit, {int? productId}) async =>
      value * unit.factorToBase;
}

void main() {
  final service = TextParsingService(_FakeConversionService());
  final categories = [
    Category(id: 1, name: 'protein', dimension: 'mass', isBuiltin: true)
  ];
  final units = [
    Unit(
        id: 1,
        name: 'gram',
        symbol: 'g',
        dimension: 'mass',
        factorToBase: 1,
        isCustom: false)
  ];

  test('parse goal from text', () async {
    final dto = await service.parseGoalFromText(
      'Set a monthly goal for Protein: 150g. Exceeding this is Mixed impact, Mild.',
      availableCategories: categories,
      availableUnits: units,
    );
    expect(dto, isNotNull);
    expect(dto!.period, GoalPeriod.monthly);
    expect(dto.categoryId, 1);
    expect(dto.capValueInBase, closeTo(150.0, 0.0001));
    expect(dto.disposition, GoalDisposition.mixed);
    expect(dto.impact, GoalImpactLevel.mild);
  });

  test('parse chart config from text', () async {
    final config = await service.parseChartConfigFromText(
        'Show a weekly bar chart for daily Carb totals. Always display numbers. Use green for good, amber for mixed, red for bad disposition, with a safe zone band up to the goal cap.');
    expect(config, isNotNull);
    expect(config!.chartType, ChartType.bar);
    expect(config.showValues, isTrue);
    expect(config.showSafeZone, isTrue);
  });
}
