/// Defines custom exceptions used across the Food App.
///
/// These exceptions extend [AppException] to provide a consistent
/// error structure while carrying additional context when needed.

/// Base class for all custom exceptions.
class AppException implements Exception {
  AppException(this.message, [this.cause]);

  /// Human readable error message.
  final String message;

  /// Optional underlying cause.
  final Object? cause;

  @override
  String toString() => message;
}

/// Thrown when a measurement unit cannot be found.
class UnitNotFoundException extends AppException {
  UnitNotFoundException.byId(this.id)
      : name = null,
        abbreviation = null,
        super('Unit with id $id not found');

  UnitNotFoundException.byName(this.name)
      : id = null,
        abbreviation = null,
        super('Unit with name "$name" not found');

  UnitNotFoundException.byAbbreviation(this.abbreviation)
      : id = null,
        name = null,
        super('Unit with abbreviation "$abbreviation" not found');

  final int? id;
  final String? name;
  final String? abbreviation;
}

/// Thrown when a conversion cannot be completed.
class InvalidConversionException extends AppException {
  InvalidConversionException(String message,
      {this.sourceUnitId, this.targetUnitId})
      : super(message);

  final int? sourceUnitId;
  final int? targetUnitId;
}

/// Thrown when an input string cannot be parsed into a valid value.
class InvalidInputFormatException extends AppException {
  InvalidInputFormatException(this.input)
      : super('Invalid input format: "$input"');

  /// The offending input string.
  final String input;
}

/// Thrown when persisting a product fails for any reason.
class ProductPersistenceException extends AppException {
  ProductPersistenceException(String message, [Object? cause])
      : super(message, cause);
}

/// Thrown when persisting a meal fails for any reason.
class MealPersistenceException extends AppException {
  MealPersistenceException(String message, [Object? cause])
      : super(message, cause);
}
