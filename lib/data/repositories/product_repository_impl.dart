import 'package:drift/drift.dart';
import 'package:food_app/core/conversion_service/conversion_service_interface.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/daos/product_dao.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';

/// Concrete implementation of [IProductRepository] that persists products using
/// Drift and performs unit conversions via [IConversionService].
class ProductRepositoryImpl implements IProductRepository {
  ProductRepositoryImpl(this._dao, this._units, this._conversion);

  final ProductDao _dao;
  final IUnitRegistry _units;
  final IConversionService _conversion;

  @override
  Stream<List<ProductWithDetails>> watchAllProducts() =>
      _dao.watchAllProducts();

  @override
  Future<ProductWithDetails?> getProductById(int id) => _dao.getProductById(id);

  @override
  Future<int> insertProduct({
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
  }) async {
    try {
      final product = ProductsCompanion(
        name: Value(name),
        defaultServingSize: Value(defaultServingSize),
        defaultServingUnitId: Value(defaultServingUnitId),
      );

      final convertedValues = <ProductCategoryValuesCompanion>[];
      for (final cv in categoryValues) {
        final category = await _dao.getCategoryById(cv.categoryId);
        if (category == null) {
          throw ProductPersistenceException(
              'Unknown category id ${cv.categoryId}');
        }
        final units = await _units.getUnitsByDimension(category.baseDimension);
        final baseUnit = units.firstWhere((u) => u.factorToBase == 1,
            orElse: () => units.first);
        final converted =
            await _conversion.convert(cv.value, cv.unitId, baseUnit.id);
        convertedValues.add(ProductCategoryValuesCompanion(
          categoryId: Value(cv.categoryId),
          value: Value(converted),
          unitId: Value(cv.unitId),
        ));
      }

      return _dao.insertProduct(product, convertedValues);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ProductPersistenceException('Failed to insert product', e);
    }
  }

  @override
  Future<bool> updateProduct({
    required int id,
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    required List<CategoryValueInput> categoryValues,
  }) async {
    try {
      final product = ProductsCompanion(
        id: Value(id),
        name: Value(name),
        defaultServingSize: Value(defaultServingSize),
        defaultServingUnitId: Value(defaultServingUnitId),
      );

      final convertedValues = <ProductCategoryValuesCompanion>[];
      for (final cv in categoryValues) {
        final category = await _dao.getCategoryById(cv.categoryId);
        if (category == null) {
          throw ProductPersistenceException(
              'Unknown category id ${cv.categoryId}');
        }
        final units = await _units.getUnitsByDimension(category.baseDimension);
        final baseUnit = units.firstWhere((u) => u.factorToBase == 1,
            orElse: () => units.first);
        final converted =
            await _conversion.convert(cv.value, cv.unitId, baseUnit.id);
        convertedValues.add(ProductCategoryValuesCompanion(
          categoryId: Value(cv.categoryId),
          value: Value(converted),
          unitId: Value(cv.unitId),
        ));
      }

      return _dao.updateProduct(product, convertedValues);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ProductPersistenceException('Failed to update product', e);
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _dao.deleteProduct(id);
    } catch (e) {
      throw ProductPersistenceException('Failed to delete product', e);
    }
  }
}
