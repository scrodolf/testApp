import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/conversion_service/conversion_service_impl.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_impl.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/daos/product_dao.dart';
 
import 'package:food_app/data/daos/meal_dao.dart';
import 'package:food_app/data/daos/meal_log_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/repositories/product_repository_impl.dart';
import 'package:food_app/data/repositories/meal_repository_impl.dart';
import 'package:food_app/data/repositories/meal_log_repository_impl.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';
import 'package:food_app/domain/repositories/i_meal_log_repository.dart';
import 'package:food_app/utils/date_time_utils.dart';
import 'package:food_app/features/meals/services/meal_calculation_service.dart';
=======
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/repositories/product_repository_impl.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/utils/date_time_utils.dart';
 

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

 
/// Provider for [MealDao].
final mealDaoProvider = FutureProvider<MealDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final productDao = await ref.watch(productDaoProvider.future);
  return MealDao(db, productDao);
});

/// Provider for the meal repository.
final mealRepositoryProvider = FutureProvider<IMealRepository>((ref) async {
  final dao = await ref.watch(mealDaoProvider.future);
  final productDao = await ref.watch(productDaoProvider.future);
  final registry = await ref.watch(unitRegistryProvider.future);
  final conversion = await ref.watch(conversionServiceProvider.future);
  return MealRepositoryImpl(dao, productDao, registry, conversion);
});

/// Provider for [MealLogDao].
final mealLogDaoProvider = FutureProvider<MealLogDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return MealLogDao(db);
});

/// Provider for the meal log repository.
final mealLogRepositoryProvider =
    FutureProvider<IMealLogRepository>((ref) async {
  final dao = await ref.watch(mealLogDaoProvider.future);
  return MealLogRepositoryImpl(dao);
});

/// Stream provider emitting all meals with their details.
final allMealsProvider = StreamProvider<List<MealWithDetails>>((ref) async* {
  final repo = await ref.watch(mealRepositoryProvider.future);
  yield* repo.watchAllMeals();
});

/// Stream provider emitting all logged meals.
final allMealLogsProvider = StreamProvider<List<LogWithMeal>>((ref) async* {
  final repo = await ref.watch(mealLogRepositoryProvider.future);
  yield* repo.watchAllLogs();
});

/// Watches a single log entry by id.
final logDetailsProvider =
    StreamProvider.family<LogWithMeal?, int>((ref, id) async* {
  final repo = await ref.watch(mealLogRepositoryProvider.future);
  yield* repo.watchLogById(id);
});

/// Provides detailed information for a single meal.
final mealDetailsProvider =
    StreamProvider.family<MealWithDetails?, int>((ref, mealId) async* {
  final repo = await ref.watch(mealRepositoryProvider.future);
  yield* repo.watchMealById(mealId);
});

/// Service used to calculate meal totals.
final mealCalculationServiceProvider =
    FutureProvider<MealCalculationService>((ref) async {
  final conversion = await ref.watch(conversionServiceProvider.future);
  return MealCalculationService(conversion);
});

=======
 
/// Stream provider emitting all products with their details.
final allProductsProvider =
    StreamProvider<List<ProductWithDetails>>((ref) async* {
  final repo = await ref.watch(productRepositoryProvider.future);
  yield* repo.watchAllProducts();
});

 
/// Provides detailed information for a single product identified by [productId].
final productDetailsProvider =
    StreamProvider.family<ProductWithDetails?, int>((ref, productId) async* {
  final repo = await ref.watch(productRepositoryProvider.future);
  yield* repo.watchProductById(productId);
});

=======
 
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
  try {
    return ConversionServiceImpl(registry);
  } catch (e) {
    if (e is AppException) rethrow;
    throw AppException('Failed to initialise conversion service', e);
  }
});

/// Provider for date/time utilities.
final dateTimeUtilsProvider = Provider<DateTimeUtils>((ref) {
  try {
    return DateTimeUtils();
  } catch (e) {
    throw AppException('Failed to initialise DateTime utilities', e);
  }
});
