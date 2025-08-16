import 'package:food_app/data/database/app_database.dart';

/// Provides access to measurement units used across the app.
abstract class IUnitRegistry {
  /// Retrieves a unit by its unique identifier.
  ///
  /// Throws a [UnitNotFoundException] if the unit does not exist.
  Future<Unit> getUnitById(int id);

  /// Looks up a unit by name.
  ///
  /// Throws a [UnitNotFoundException] if the unit does not exist.
  Future<Unit> getUnitByName(String name);

  /// Returns all available units.
  Future<List<Unit>> getAllUnits();

  /// Returns units that belong to the given [dimension] (e.g. mass or volume).
  Future<List<Unit>> getUnitsByDimension(String dimension);

  /// Adds a custom unit to the registry.
  Future<int> addUnit(UnitsCompanion unit);

  /// Removes a unit by its [id].
  Future<void> deleteUnit(int id);
}
