class ParsedCategoryValue {
  /// Value already converted to the base unit of its dimension.
  final double value;
  /// Identifier of the base unit used to express [value].
  final int unitId;

  const ParsedCategoryValue({required this.value, required this.unitId});
}

/// DTO returned by [NutritionTextParser.parsePastedNutritionData].
///
/// [name] and serving information may be `null` if not present in the input.
/// [categoryValues] stores parsed nutrition amounts keyed by category id.
/// [unrecognizedItems] lists lines that could not be mapped to any category or
/// unit, while [parsingErrors] surfaces lines where numeric parsing failed.
class ParsedProductData {
  final String? name;
  final double? defaultServingSize;
  final int? defaultServingUnitId;
  final Map<int, ParsedCategoryValue> categoryValues;
  final List<String> unrecognizedItems;
  final List<String> parsingErrors;

  const ParsedProductData({
    this.name,
    this.defaultServingSize,
    this.defaultServingUnitId,
    this.categoryValues = const {},
    this.unrecognizedItems = const [],
    this.parsingErrors = const [],
  });

  @override
  String toString() {
    return 'ParsedProductData(name: $name, defaultServingSize: '
        '$defaultServingSize, defaultServingUnitId: $defaultServingUnitId, '
        'categoryValues: $categoryValues, unrecognizedItems: '
        '$unrecognizedItems, parsingErrors: $parsingErrors)';
  }
}
