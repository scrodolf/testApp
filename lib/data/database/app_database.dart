import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Provides access to the local SQLite database using Drift.
@DriftDatabase(tables: [Units, Products, Categories, ProductCategoryValues])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

/// Opens a connection to the database stored in the application's documents
/// directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'food_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Table storing measurement units like grams or milliliters.
///
/// Units belong to a specific [dimension] (for example `mass` or `volume`).
/// The [factorToBase] represents how to convert a value of this unit to the
/// dimension's base unit. For instance, grams have a `factorToBase` of `1`
/// while kilograms would have `1000`.
class Units extends Table {
  /// Auto-incrementing identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Full name of the unit (e.g. gram).
  TextColumn get name => text()();

  /// Dimension this unit belongs to (e.g. mass, volume).
  TextColumn get dimension => text()();

  /// Factor to convert this unit into the base unit of its dimension.
  RealColumn get factorToBase => real()();

  /// Whether the unit was user defined.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Table storing food products available to the user.
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Human readable product name.
  TextColumn get name => text()();

  /// Default serving quantity for the product.
  RealColumn get defaultServingSize => real()();

  /// Unit for the default serving quantity.
  IntColumn get defaultServingUnitId => integer().references(Units, #id)();
}

/// Table defining nutritional categories such as calories or fat.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Name of the category.
  TextColumn get name => text()();

  /// Dimension in which this category's values are expressed (e.g. mass).
  TextColumn get baseDimension => text()();

  /// Preferred unit to display values for this category.
  IntColumn get defaultDisplayUnitId => integer().references(Units, #id)();

  /// Whether the category was user defined.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Links products with nutritional categories and their values.
class ProductCategoryValues extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Related product identifier.
  IntColumn get productId => integer().references(Products, #id)();

  /// Related category identifier.
  IntColumn get categoryId => integer().references(Categories, #id)();

  /// Value converted to the category's base dimension unit.
  RealColumn get value => real()();

  /// Measurement unit originally used when entering [value].
  IntColumn get unitId => integer().references(Units, #id)();
}
