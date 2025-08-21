import 'package:drift/drift.dart';
import 'package:riverpod/riverpod.dart';

import 'local/app_database.dart';
import 'product_repository.dart' show appDatabaseProvider;

/// Riverpod provider exposing a [MealTypeRepository].
final mealTypeRepositoryProvider = Provider<MealTypeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MealTypeRepository(db);
});

/// Provides the ordered list of meal types.
final mealTypesProvider =
    StreamProvider<List<MealType>>((ref) => ref.watch(mealTypeRepositoryProvider).watchMealTypes());

/// Thrown when validation fails for meal type operations.
class MealTypeValidationException implements Exception {
  MealTypeValidationException(this.message);
  final String message;
  @override
  String toString() => 'MealTypeValidationException: $message';
}

class MealTypeRepository {
  MealTypeRepository(this._db);
  final AppDatabase _db;

  Stream<List<MealType>> watchMealTypes() {
    return (_db.select(_db.mealTypes)
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
        ).watch();
  }

  Future<int> addMealType(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw MealTypeValidationException('Name must not be empty');
    }
    final existing = await _db.select(_db.mealTypes).get();
    final nextOrder = existing.isEmpty
        ? 0
        : (existing.map((e) => e.sortOrder).reduce((a, b) => a > b ? a : b) + 1);
    return _db.into(_db.mealTypes).insert(MealTypesCompanion.insert(
          nameKey: trimmed,
          sortOrder: nextOrder,
          isBuiltin: const Value(false),
        ));
  }

  Future<void> renameMealType(int id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw MealTypeValidationException('Name must not be empty');
    }
    final query = _db.update(_db.mealTypes)..where((t) => t.id.equals(id));
    await query.write(MealTypesCompanion(nameKey: Value(trimmed)));
  }

  Future<void> deleteMealType(int id) async {
    await (_db.delete(_db.mealTypes)..where((t) => t.id.equals(id))).go();
  }
}

