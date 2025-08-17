import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/conversion_service/conversion_service_impl.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_impl.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/daos/product_dao.dart';
import 'package:food_app/data/daos/log_dao.dart';
import 'package:food_app/data/daos/meal_type_dao.dart';
import 'package:food_app/data/daos/goal_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/repositories/product_repository_impl.dart';
import 'package:food_app/data/repositories/log_repository_impl.dart';
import 'package:food_app/data/repositories/meal_type_repository_impl.dart';
import 'package:food_app/data/repositories/goal_repository_impl.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/domain/repositories/i_log_repository.dart';
import 'package:food_app/domain/repositories/i_meal_type_repository.dart';
import 'package:food_app/domain/repositories/i_goal_repository.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:food_app/data/services/nutrition_text_parser.dart';
import 'package:food_app/core/services/text_parsing_service.dart';
import 'package:food_app/domain/use_cases/create_goal_from_parsed_text_use_case.dart';
import 'package:food_app/domain/use_cases/generate_chart_config_from_parsed_text_use_case.dart';

/// Provides a lazily opened [AppDatabase] instance.
final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  try {
    final db = AppDatabase();
    ref.onDispose(db.close);
    return db;
  } catch (e) {
    throw AppException('Failed to open database', e);
  }
});

/// Provider exposing all categories.
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return db.select(db.categories).get();
});

/// Provider exposing all units.
final unitsProvider = FutureProvider<List<Unit>>((ref) async {
  final registry = await ref.watch(unitRegistryProvider.future);
  return registry.getAllUnits();
});

/// Provider for [ProductDao]. Ensures base categories exist.
final productDaoProvider = FutureProvider<ProductDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  // Ensure base units are initialised before seeding categories
  await ref.watch(unitRegistryProvider.future);
  final dao = ProductDao(db);
  await dao.ensureBaseCategories();
  return dao;
});

/// Provider for the product repository.
final productRepositoryProvider =
    FutureProvider<IProductRepository>((ref) async {
  final dao = await ref.watch(productDaoProvider.future);
  final registry = await ref.watch(unitRegistryProvider.future);
  final conversion = await ref.watch(conversionServiceProvider.future);
  return ProductRepositoryImpl(dao, registry, conversion);
});

/// Stream provider emitting all products with their details.
final allProductsProvider =
    StreamProvider<List<ProductWithDetails>>((ref) async* {
  final repo = await ref.watch(productRepositoryProvider.future);
  yield* repo.watchAllProducts();
});

/// Provider for [MealTypeDao] with default seed values.
final mealTypeDaoProvider = FutureProvider<MealTypeDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final existing = await db.select(db.mealTypes).get();
  if (existing.isEmpty) {
    await db.batch((batch) {
      batch.insertAll(db.mealTypes, [
        MealTypesCompanion(
          nameKey: const Value('Breakfast'),
          sortOrder: const Value(0),
          isBuiltin: const Value(true),
        ),
        MealTypesCompanion(
          nameKey: const Value('Lunch'),
          sortOrder: const Value(1),
          isBuiltin: const Value(true),
        ),
        MealTypesCompanion(
          nameKey: const Value('Dinner'),
          sortOrder: const Value(2),
          isBuiltin: const Value(true),
        ),
      ]);
    });
  }
  return MealTypeDao(db);
});

/// Provider for [LogDao].
final logDaoProvider = FutureProvider<LogDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return LogDao(db);
});

/// Repository provider for meal types.
final mealTypeRepositoryProvider =
    FutureProvider<IMealTypeRepository>((ref) async {
  final dao = await ref.watch(mealTypeDaoProvider.future);
  return MealTypeRepositoryImpl(dao);
});

/// Repository provider for logs.
final logRepositoryProvider = FutureProvider<ILogRepository>((ref) async {
  final dao = await ref.watch(logDaoProvider.future);
  return LogRepositoryImpl(dao);
});

/// Provider for [GoalDao].
final goalDaoProvider = FutureProvider<GoalDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return GoalDao(db);
});

/// Repository provider for goals.
final goalRepositoryProvider = FutureProvider<IGoalRepository>((ref) async {
  final dao = await ref.watch(goalDaoProvider.future);
  return GoalRepositoryImpl(dao);
});

/// Stream provider emitting all meal types.
final allMealTypesProvider = StreamProvider<List<MealType>>((ref) async* {
  final repo = await ref.watch(mealTypeRepositoryProvider.future);
  yield* repo.watchMealTypes();
});

/// Stream provider emitting all logs.
final allLogsProvider = StreamProvider<List<LogWithDetails>>((ref) async* {
  final repo = await ref.watch(logRepositoryProvider.future);
  yield* repo.watchLogs();
});

/// Stream provider emitting all goals.
final allGoalsProvider = StreamProvider<List<GoalWithDetails>>((ref) async* {
  final repo = await ref.watch(goalRepositoryProvider.future);
  yield* repo.watchGoals();
});

/// Provider for the unit registry service.
final unitRegistryProvider = FutureProvider<IUnitRegistry>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  try {
    return await UnitRegistryImpl.create(db);
  } catch (e) {
    if (e is AppException) rethrow;
    throw AppException('Failed to initialise unit registry', e);
  }
});

/// Provider for the conversion service.
final conversionServiceProvider =
    FutureProvider<IConversionService>((ref) async {
  final registry = await ref.watch(unitRegistryProvider.future);
  final db = await ref.watch(appDatabaseProvider.future);
  try {
    return ConversionServiceImpl(registry, db);
  } catch (e) {
    if (e is AppException) rethrow;
    throw AppException('Failed to initialise conversion service', e);
  }
});

/// Parser turning pasted nutritional text into structured product data.
final nutritionTextParserProvider =
    FutureProvider<NutritionTextParser>((ref) async {
  final conversion = await ref.watch(conversionServiceProvider.future);
  return NutritionTextParser(conversion);
});

/// Provider for date/time utilities.
final dateTimeUtilsProvider = Provider<DateTimeUtils>((ref) {
  try {
    return DateTimeUtils();
  } catch (e) {
    throw AppException('Failed to initialise DateTime utilities', e);
  }
});

/// General text parser for goals and charts.
final textParsingServiceProvider = FutureProvider<TextParsingService>((ref) async {
  final conversion = await ref.watch(conversionServiceProvider.future);
  return TextParsingService(conversion);
});

/// Use case to create a goal from pasted text.
final createGoalFromParsedTextUseCaseProvider =
    FutureProvider<CreateGoalFromParsedTextUseCase>((ref) async {
  final parser = await ref.watch(textParsingServiceProvider.future);
  final repo = await ref.watch(goalRepositoryProvider.future);
  return CreateGoalFromParsedTextUseCase(parser, repo);
});

/// Use case to generate chart configuration from pasted text.
final generateChartConfigFromParsedTextUseCaseProvider =
    FutureProvider<GenerateChartConfigFromParsedTextUseCase>((ref) async {
  final parser = await ref.watch(textParsingServiceProvider.future);
  return GenerateChartConfigFromParsedTextUseCase(parser);
});
