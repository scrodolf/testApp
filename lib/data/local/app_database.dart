import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Enumerations for goals
enum GoalPeriod { week, month }
enum GoalDisposition { good, bad, mixed }
enum GoalImpact { mild, moderate, severe }

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get symbol => text().nullable()();
  TextColumn get dimension => text()();
  RealColumn get factorToBase => real()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameKey => text()();
  TextColumn get dimension => text()();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(true))();
}

class MealTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameKey => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(true))();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get servingAmountBase => real()();
  IntColumn get servingUnitId => integer().references(Units, #id)();
}

class ProductCategoryValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amountBase => real()();
  IntColumn get originalUnitId => integer().references(Units, #id).nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{productId, categoryId}];
}

class ProductUnitOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get unitId => integer().references(Units, #id)();
  RealColumn get amountBase => real()();

  @override
  List<Set<Column>> get uniqueKeys => [{productId, unitId}];
}

class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DriftTable(indexes: [Index('meal_items_meal_id_idx', [#mealId])])
class MealItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  RealColumn get amountBase => real()();
  IntColumn get originalUnitId => integer().references(Units, #id).nullable()();
}

class MealCustomEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amountBase => real()();
  IntColumn get originalUnitId => integer().references(Units, #id).nullable()();
}

@DriftTable(indexes: [Index('logs_logged_at_local_idx', [#loggedAtLocal])])
class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id).nullable()();
  IntColumn get productId => integer().references(Products, #id).nullable()();
  RealColumn get quantity =>
      real().withDefault(const Constant(1))();
  IntColumn get mealTypeId => integer().references(MealTypes, #id)();
  DateTimeColumn get loggedAtLocal => dateTime()();
  IntColumn get timeZoneOffsetMinutes => integer()();
}

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amountBase => real()();
  IntColumn get originalUnitId => integer().references(Units, #id).nullable()();
  TextColumn get period => textEnum<GoalPeriod>()();
  TextColumn get disposition => textEnum<GoalDisposition>()();
  TextColumn get impact => textEnum<GoalImpact>()();
  DateTimeColumn get startDate => dateTime().nullable()();
}

@DriftDatabase(
  tables: [
    Units,
    Categories,
    MealTypes,
    Products,
    ProductCategoryValues,
    ProductUnitOverrides,
    Meals,
    MealItems,
    MealCustomEntries,
    Logs,
    Goals,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'food_tracker.sqlite'));
      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
        },
        onUpgrade: (m, from, to) async {
          for (var version = from; version < to; version++) {
            switch (version) {
              case 1:
                await _migrateFrom1To2(m);
                break;
            }
          }
        },
      );

  Future<void> _migrateFrom1To2(Migrator m) async {
    await m.addColumn(logs, logs.productId);
    await m.addColumn(logs, logs.quantity);
  }

  Future<void> _seed() async {
    if (await (select(units).get()).then((rows) => rows.isEmpty)) {
      await batch((b) {
        b.insertAll(units, [
          UnitsCompanion.insert(name: 'gram', symbol: const Value('g'), dimension: 'mass', factorToBase: 1, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'kilogram', symbol: const Value('kg'), dimension: 'mass', factorToBase: 1000, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'ounce', symbol: const Value('oz'), dimension: 'mass', factorToBase: 28.3495, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'pound', symbol: const Value('lb'), dimension: 'mass', factorToBase: 453.592, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'milliliter', symbol: const Value('ml'), dimension: 'volume', factorToBase: 1, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'liter', symbol: const Value('l'), dimension: 'volume', factorToBase: 1000, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'teaspoon', symbol: const Value('tsp'), dimension: 'volume', factorToBase: 4.92892, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'tablespoon', symbol: const Value('tbsp'), dimension: 'volume', factorToBase: 14.7868, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'fluid ounce', symbol: const Value('fl oz'), dimension: 'volume', factorToBase: 29.5735, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'cup', symbol: const Value('cup'), dimension: 'volume', factorToBase: 236.588, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'pint', symbol: const Value('pt'), dimension: 'volume', factorToBase: 473.176, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'quart', symbol: const Value('qt'), dimension: 'volume', factorToBase: 946.353, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'gallon', symbol: const Value('gal'), dimension: 'volume', factorToBase: 3785.41, isCustom: const Value(false)),
          UnitsCompanion.insert(name: 'kilocalorie', symbol: const Value('kcal'), dimension: 'energy', factorToBase: 1, isCustom: const Value(false)),
        ]);
      });
    }

    if (await (select(categories).get()).then((rows) => rows.isEmpty)) {
      await batch((b) {
        b.insertAll(categories, [
          CategoriesCompanion.insert(nameKey: 'calories', dimension: 'energy', isBuiltin: const Value(true)),
          CategoriesCompanion.insert(nameKey: 'protein', dimension: 'mass', isBuiltin: const Value(true)),
          CategoriesCompanion.insert(nameKey: 'carbs', dimension: 'mass', isBuiltin: const Value(true)),
          CategoriesCompanion.insert(nameKey: 'fat', dimension: 'mass', isBuiltin: const Value(true)),
          CategoriesCompanion.insert(nameKey: 'fiber', dimension: 'mass', isBuiltin: const Value(true)),
        ]);
      });
    }

    if (await (select(mealTypes).get()).then((rows) => rows.isEmpty)) {
      await batch((b) {
        b.insertAll(mealTypes, [
          MealTypesCompanion.insert(nameKey: 'breakfast', sortOrder: 0, isBuiltin: const Value(true)),
          MealTypesCompanion.insert(nameKey: 'lunch', sortOrder: 1, isBuiltin: const Value(true)),
          MealTypesCompanion.insert(nameKey: 'dinner', sortOrder: 2, isBuiltin: const Value(true)),
        ]);
      });
    }
  }
}

