/// Central service for converting values between measurement units.
abstract class IConversionService {
  /// Converts [value] from [sourceUnitId] to [targetUnitId].
  ///
  /// Implementations may look up conversion ratios from persistent storage.
  Future<double> convert(double value, int sourceUnitId, int targetUnitId,
      {Map<int, double>? customUnitFactors});
=======
  Future<double> convert(double value, int sourceUnitId, int targetUnitId);
}
