import 'package:drift/drift.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/database/app_database.dart';

/// Concrete implementation of [IUnitRegistry] backed by Drift.
class UnitRegistryImpl implements IUnitRegistry {
  UnitRegistryImpl._(this._db);

  /// Creates an instance and ensures default units exist.
  static Future<UnitRegistryImpl> create(AppDatabase db) async {
    final impl = UnitRegistryImpl._(db);
    await impl._ensureBaseUnits();
    return impl;
  }

  final AppDatabase _db;

  Future<void> _ensureBaseUnits() async {
    try {
      final existing = await _db.select(_db.units).get();
      if (existing.isEmpty) {
        await _db.batch((batch) {
          batch.insertAll(_db.units, [
            // Base units
            UnitsCompanion(
              name: const Value('gram'),
              symbol: const Value('g'),
              dimension: const Value('mass'),
              factorToBase: const Value(1),
            ),
            UnitsCompanion(
              name: const Value('milliliter'),
              symbol: const Value('mL'),
              dimension: const Value('volume'),
              factorToBase: const Value(1),
            ),
            UnitsCompanion(
              name: const Value('kilocalorie'),
              symbol: const Value('kcal'),
              dimension: const Value('energy'),
              factorToBase: const Value(1),
            ),
            // Common imperial units
            UnitsCompanion(
              name: const Value('ounce'),
              symbol: const Value('oz'),
              dimension: const Value('mass'),
              factorToBase: const Value(28.349523),
            ),
            UnitsCompanion(
              name: const Value('US fluid ounce'),
              symbol: const Value('fl oz'),
              dimension: const Value('volume'),
              factorToBase: const Value(29.5735296),
            ),
            UnitsCompanion(
              name: const Value('cup'),
              symbol: const Value('cup'),
              dimension: const Value('volume'),
              factorToBase: const Value(236.5882365),
            ),
          ]);
        });
      }
    } catch (e) {
      throw AppException('Failed to initialize base units', e);
    }
  }

  @override
  Future<Unit> getUnitById(int id) async {
    final query = _db.select(_db.units)..where((u) => u.id.equals(id));
    final unit = await query.getSingleOrNull();
    if (unit == null) {
      throw UnitNotFoundException.byId(id);
    }
    return unit;
  }

  @override
  Future<Unit> getUnitByName(String name) async {
    final query = _db.select(_db.units)..where((u) => u.name.equals(name));
    final unit = await query.getSingleOrNull();
    if (unit == null) {
      throw UnitNotFoundException.byName(name);
    }
    return unit;
  }

  @override
  Future<List<Unit>> getAllUnits() {
    return _db.select(_db.units).get();
  }

  @override
  Future<List<Unit>> getUnitsByDimension(String dimension) {
    final query = _db.select(_db.units)
      ..where((u) => u.dimension.equals(dimension));
    return query.get();
  }

  /// Adds a custom unit to the registry.
  Future<int> addUnit(UnitsCompanion unit) async {
    try {
      return await _db.into(_db.units).insert(unit);
    } catch (e) {
      throw AppException('Failed to add unit', e);
    }
  }

  /// Deletes a unit by [id].
  Future<void> deleteUnit(int id) async {
    try {
      final deleted =
          await (_db.delete(_db.units)..where((u) => u.id.equals(id))).go();
      if (deleted == 0) {
        throw UnitNotFoundException.byId(id);
      }
    } catch (e) {
      if (e is UnitNotFoundException) rethrow;
      throw AppException('Failed to delete unit', e);
    }
  }
}
