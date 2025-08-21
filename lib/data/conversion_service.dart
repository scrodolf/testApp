import 'package:riverpod/riverpod.dart';
import 'local/app_database.dart';
import 'product_repository.dart' show appDatabaseProvider;

/// Provides conversion utilities using units stored in the database.
class ConversionService {
  ConversionService(this._db);

  final AppDatabase _db;

  /// Converts [amount] of a unit to base units. If [overrides] contains the
  /// [unitId], that factor is used instead of the database factor.
  Future<double> toBase({
    required int unitId,
    required double amount,
    Map<int, double>? overrides,
  }) async {
    if (overrides != null && overrides.containsKey(unitId)) {
      return amount * overrides[unitId]!;
    }
    final unit = await (_db.select(_db.units)
          ..where((u) => u.id.equals(unitId)))
        .getSingle();
    return amount * unit.factorToBase;
  }

  /// Converts [amount] in base units to [unitId].
  Future<double> fromBase({required int unitId, required double amount}) async {
    final unit = await (_db.select(_db.units)
          ..where((u) => u.id.equals(unitId)))
        .getSingle();
    return amount / unit.factorToBase;
  }
}

/// Riverpod provider for [ConversionService].
final conversionServiceProvider = Provider<ConversionService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ConversionService(db);
});

