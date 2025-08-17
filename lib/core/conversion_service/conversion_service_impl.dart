import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/database/app_database.dart';

/// Implementation of [IConversionService] that delegates lookups to the
/// [IUnitRegistry].
class ConversionServiceImpl implements IConversionService {
  ConversionServiceImpl(this._registry, this._db);

  final IUnitRegistry _registry;
  final AppDatabase _db;

  Future<double> _factorFor(Unit unit, int? productId) async {
    if (productId == null) return unit.factorToBase;
    final overrideQuery = _db.select(_db.productUnitOverrides)
      ..where((o) =>
          o.productId.equals(productId) & o.unitId.equals(unit.id));
    final override = await overrideQuery.getSingleOrNull();
    return override?.factorToBase ?? unit.factorToBase;
  }

  @override
  Future<double> toBase(double value, Unit unit, {int? productId}) async {
    final factor = await _factorFor(unit, productId);
    return double.parse((value * factor).toStringAsFixed(4));
  }

  @override
  Future<double> fromBase(double baseValue, Unit targetUnit,
      {int? productId}) async {
    final factor = await _factorFor(targetUnit, productId);
    if (factor == 0) {
      throw InvalidConversionException('Invalid factor for ${targetUnit.name}');
    }
    return double.parse((baseValue / factor).toStringAsFixed(4));
  }

  @override
  Future<double> convert(double value, int sourceUnitId, int targetUnitId,
      {int? productId}) async {
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

      final baseValue = await toBase(value, source, productId: productId);
      return fromBase(baseValue, target, productId: productId);
    } on UnitNotFoundException catch (e) {
      throw InvalidConversionException(
        'Conversion failed due to missing unit: ${e.message}',
        sourceUnitId: sourceUnitId,
        targetUnitId: targetUnitId,
      );
    }
  }
}
