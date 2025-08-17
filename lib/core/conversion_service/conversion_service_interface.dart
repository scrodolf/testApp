import 'package:food_app/data/database/app_database.dart';

/// Central service for converting values between measurement units.
abstract class IConversionService {
  /// Converts [value] expressed in [unit] into the base representation
  /// (grams, milliliters or kilocalories).
  Future<double> toBase(double value, Unit unit, {int? productId});

  /// Converts [baseValue] into [targetUnit].
  Future<double> fromBase(double baseValue, Unit targetUnit, {int? productId});

  /// Convenience wrapper performing [toBase] followed by [fromBase].
  Future<double> convert(double value, int sourceUnitId, int targetUnitId,
      {int? productId});
}
