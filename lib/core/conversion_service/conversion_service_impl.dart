import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';

/// Implementation of [IConversionService] that delegates lookups to the
/// [IUnitRegistry].
class ConversionServiceImpl implements IConversionService {
  ConversionServiceImpl(this._registry);

  final IUnitRegistry _registry;

  @override
  Future<double> convert(
      double value, int sourceUnitId, int targetUnitId) async {
    try {
      final source = await _registry.getUnitById(sourceUnitId);
      final target = await _registry.getUnitById(targetUnitId);

      if (source.dimension != target.dimension) {
        throw InvalidConversionException(
          'Cannot convert between ${source.name} and ${target.name}: incompatible dimensions',
          sourceUnitId: sourceUnitId,
          targetUnitId: targetUnitId,
        );
      }

      if (source.factorToBase == 0 || target.factorToBase == 0) {
        throw InvalidConversionException(
          'Missing conversion factor between ${source.name} and ${target.name}',
          sourceUnitId: sourceUnitId,
          targetUnitId: targetUnitId,
        );
      }

      final baseValue = value * source.factorToBase;
      return baseValue / target.factorToBase;
    } on UnitNotFoundException catch (e) {
      throw InvalidConversionException(
        'Conversion failed due to missing unit: ${e.message}',
        sourceUnitId: sourceUnitId,
        targetUnitId: targetUnitId,
      );
    } on InvalidConversionException {
      rethrow;
    } catch (e) {
      throw InvalidConversionException(
        'Unexpected error during conversion: $e',
        sourceUnitId: sourceUnitId,
        targetUnitId: targetUnitId,
      );
    }
  }
}
