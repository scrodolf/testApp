// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dimensionMeta =
      const VerificationMeta('dimension');
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
      'dimension', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factorToBaseMeta =
      const VerificationMeta('factorToBase');
  @override
  late final GeneratedColumn<double> factorToBase = GeneratedColumn<double>(
      'factor_to_base', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, dimension, factorToBase, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dimension')) {
      context.handle(_dimensionMeta,
          dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta));
    } else if (isInserting) {
      context.missing(_dimensionMeta);
    }
    if (data.containsKey('factor_to_base')) {
      context.handle(
          _factorToBaseMeta,
          factorToBase.isAcceptableOrUnknown(
              data['factor_to_base']!, _factorToBaseMeta));
    } else if (isInserting) {
      context.missing(_factorToBaseMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dimension: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dimension'])!,
      factorToBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}factor_to_base'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  /// Auto-incrementing identifier.
  final int id;

  /// Full name of the unit (e.g. gram).
  final String name;

  /// Dimension this unit belongs to (e.g. mass, volume).
  final String dimension;

  /// Factor to convert this unit into the base unit of its dimension.
  final double factorToBase;

  /// Whether the unit was user defined.
  final bool isCustom;
  const Unit(
      {required this.id,
      required this.name,
      required this.dimension,
      required this.factorToBase,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dimension'] = Variable<String>(dimension);
    map['factor_to_base'] = Variable<double>(factorToBase);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
      dimension: Value(dimension),
      factorToBase: Value(factorToBase),
      isCustom: Value(isCustom),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dimension: serializer.fromJson<String>(json['dimension']),
      factorToBase: serializer.fromJson<double>(json['factorToBase']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dimension': serializer.toJson<String>(dimension),
      'factorToBase': serializer.toJson<double>(factorToBase),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Unit copyWith(
          {int? id,
          String? name,
          String? dimension,
          double? factorToBase,
          bool? isCustom}) =>
      Unit(
        id: id ?? this.id,
        name: name ?? this.name,
        dimension: dimension ?? this.dimension,
        factorToBase: factorToBase ?? this.factorToBase,
        isCustom: isCustom ?? this.isCustom,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      factorToBase: data.factorToBase.present
          ? data.factorToBase.value
          : this.factorToBase,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dimension: $dimension, ')
          ..write('factorToBase: $factorToBase, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dimension, factorToBase, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.name == this.name &&
          other.dimension == this.dimension &&
          other.factorToBase == this.factorToBase &&
          other.isCustom == this.isCustom);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dimension;
  final Value<double> factorToBase;
  final Value<bool> isCustom;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dimension = const Value.absent(),
    this.factorToBase = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String dimension,
    required double factorToBase,
    this.isCustom = const Value.absent(),
  })  : name = Value(name),
        dimension = Value(dimension),
        factorToBase = Value(factorToBase);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dimension,
    Expression<double>? factorToBase,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dimension != null) 'dimension': dimension,
      if (factorToBase != null) 'factor_to_base': factorToBase,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  UnitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? dimension,
      Value<double>? factorToBase,
      Value<bool>? isCustom}) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dimension: dimension ?? this.dimension,
      factorToBase: factorToBase ?? this.factorToBase,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (factorToBase.present) {
      map['factor_to_base'] = Variable<double>(factorToBase.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dimension: $dimension, ')
          ..write('factorToBase: $factorToBase, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultServingSizeMeta =
      const VerificationMeta('defaultServingSize');
  @override
  late final GeneratedColumn<double> defaultServingSize =
      GeneratedColumn<double>('default_serving_size', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _defaultServingUnitIdMeta =
      const VerificationMeta('defaultServingUnitId');
  @override
  late final GeneratedColumn<int> defaultServingUnitId = GeneratedColumn<int>(
      'default_serving_unit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES units (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, defaultServingSize, defaultServingUnitId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_serving_size')) {
      context.handle(
          _defaultServingSizeMeta,
          defaultServingSize.isAcceptableOrUnknown(
              data['default_serving_size']!, _defaultServingSizeMeta));
    } else if (isInserting) {
      context.missing(_defaultServingSizeMeta);
    }
    if (data.containsKey('default_serving_unit_id')) {
      context.handle(
          _defaultServingUnitIdMeta,
          defaultServingUnitId.isAcceptableOrUnknown(
              data['default_serving_unit_id']!, _defaultServingUnitIdMeta));
    } else if (isInserting) {
      context.missing(_defaultServingUnitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      defaultServingSize: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_serving_size'])!,
      defaultServingUnitId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_serving_unit_id'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;

  /// Human readable product name.
  final String name;

  /// Default serving quantity for the product.
  final double defaultServingSize;

  /// Unit for the default serving quantity.
  final int defaultServingUnitId;
  const Product(
      {required this.id,
      required this.name,
      required this.defaultServingSize,
      required this.defaultServingUnitId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['default_serving_size'] = Variable<double>(defaultServingSize);
    map['default_serving_unit_id'] = Variable<int>(defaultServingUnitId);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      defaultServingSize: Value(defaultServingSize),
      defaultServingUnitId: Value(defaultServingUnitId),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      defaultServingSize:
          serializer.fromJson<double>(json['defaultServingSize']),
      defaultServingUnitId:
          serializer.fromJson<int>(json['defaultServingUnitId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'defaultServingSize': serializer.toJson<double>(defaultServingSize),
      'defaultServingUnitId': serializer.toJson<int>(defaultServingUnitId),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          double? defaultServingSize,
          int? defaultServingUnitId}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        defaultServingSize: defaultServingSize ?? this.defaultServingSize,
        defaultServingUnitId: defaultServingUnitId ?? this.defaultServingUnitId,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      defaultServingSize: data.defaultServingSize.present
          ? data.defaultServingSize.value
          : this.defaultServingSize,
      defaultServingUnitId: data.defaultServingUnitId.present
          ? data.defaultServingUnitId.value
          : this.defaultServingUnitId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultServingSize: $defaultServingSize, ')
          ..write('defaultServingUnitId: $defaultServingUnitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, defaultServingSize, defaultServingUnitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.defaultServingSize == this.defaultServingSize &&
          other.defaultServingUnitId == this.defaultServingUnitId);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> defaultServingSize;
  final Value<int> defaultServingUnitId;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultServingSize = const Value.absent(),
    this.defaultServingUnitId = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
  })  : name = Value(name),
        defaultServingSize = Value(defaultServingSize),
        defaultServingUnitId = Value(defaultServingUnitId);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? defaultServingSize,
    Expression<int>? defaultServingUnitId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (defaultServingSize != null)
        'default_serving_size': defaultServingSize,
      if (defaultServingUnitId != null)
        'default_serving_unit_id': defaultServingUnitId,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? defaultServingSize,
      Value<int>? defaultServingUnitId}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultServingSize: defaultServingSize ?? this.defaultServingSize,
      defaultServingUnitId: defaultServingUnitId ?? this.defaultServingUnitId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultServingSize.present) {
      map['default_serving_size'] = Variable<double>(defaultServingSize.value);
    }
    if (defaultServingUnitId.present) {
      map['default_serving_unit_id'] =
          Variable<int>(defaultServingUnitId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultServingSize: $defaultServingSize, ')
          ..write('defaultServingUnitId: $defaultServingUnitId')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseDimensionMeta =
      const VerificationMeta('baseDimension');
  @override
  late final GeneratedColumn<String> baseDimension = GeneratedColumn<String>(
      'base_dimension', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultDisplayUnitIdMeta =
      const VerificationMeta('defaultDisplayUnitId');
  @override
  late final GeneratedColumn<int> defaultDisplayUnitId = GeneratedColumn<int>(
      'default_display_unit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES units (id)'));
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, baseDimension, defaultDisplayUnitId, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_dimension')) {
      context.handle(
          _baseDimensionMeta,
          baseDimension.isAcceptableOrUnknown(
              data['base_dimension']!, _baseDimensionMeta));
    } else if (isInserting) {
      context.missing(_baseDimensionMeta);
    }
    if (data.containsKey('default_display_unit_id')) {
      context.handle(
          _defaultDisplayUnitIdMeta,
          defaultDisplayUnitId.isAcceptableOrUnknown(
              data['default_display_unit_id']!, _defaultDisplayUnitIdMeta));
    } else if (isInserting) {
      context.missing(_defaultDisplayUnitIdMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baseDimension: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_dimension'])!,
      defaultDisplayUnitId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_display_unit_id'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;

  /// Name of the category.
  final String name;

  /// Dimension in which this category's values are expressed (e.g. mass).
  final String baseDimension;

  /// Preferred unit to display values for this category.
  final int defaultDisplayUnitId;

  /// Whether the category was user defined.
  final bool isCustom;
  const Category(
      {required this.id,
      required this.name,
      required this.baseDimension,
      required this.defaultDisplayUnitId,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['base_dimension'] = Variable<String>(baseDimension);
    map['default_display_unit_id'] = Variable<int>(defaultDisplayUnitId);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      baseDimension: Value(baseDimension),
      defaultDisplayUnitId: Value(defaultDisplayUnitId),
      isCustom: Value(isCustom),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      baseDimension: serializer.fromJson<String>(json['baseDimension']),
      defaultDisplayUnitId:
          serializer.fromJson<int>(json['defaultDisplayUnitId']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'baseDimension': serializer.toJson<String>(baseDimension),
      'defaultDisplayUnitId': serializer.toJson<int>(defaultDisplayUnitId),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          String? baseDimension,
          int? defaultDisplayUnitId,
          bool? isCustom}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        baseDimension: baseDimension ?? this.baseDimension,
        defaultDisplayUnitId: defaultDisplayUnitId ?? this.defaultDisplayUnitId,
        isCustom: isCustom ?? this.isCustom,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      baseDimension: data.baseDimension.present
          ? data.baseDimension.value
          : this.baseDimension,
      defaultDisplayUnitId: data.defaultDisplayUnitId.present
          ? data.defaultDisplayUnitId.value
          : this.defaultDisplayUnitId,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseDimension: $baseDimension, ')
          ..write('defaultDisplayUnitId: $defaultDisplayUnitId, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, baseDimension, defaultDisplayUnitId, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.baseDimension == this.baseDimension &&
          other.defaultDisplayUnitId == this.defaultDisplayUnitId &&
          other.isCustom == this.isCustom);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> baseDimension;
  final Value<int> defaultDisplayUnitId;
  final Value<bool> isCustom;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.baseDimension = const Value.absent(),
    this.defaultDisplayUnitId = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String baseDimension,
    required int defaultDisplayUnitId,
    this.isCustom = const Value.absent(),
  })  : name = Value(name),
        baseDimension = Value(baseDimension),
        defaultDisplayUnitId = Value(defaultDisplayUnitId);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? baseDimension,
    Expression<int>? defaultDisplayUnitId,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (baseDimension != null) 'base_dimension': baseDimension,
      if (defaultDisplayUnitId != null)
        'default_display_unit_id': defaultDisplayUnitId,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? baseDimension,
      Value<int>? defaultDisplayUnitId,
      Value<bool>? isCustom}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      baseDimension: baseDimension ?? this.baseDimension,
      defaultDisplayUnitId: defaultDisplayUnitId ?? this.defaultDisplayUnitId,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseDimension.present) {
      map['base_dimension'] = Variable<String>(baseDimension.value);
    }
    if (defaultDisplayUnitId.present) {
      map['default_display_unit_id'] =
          Variable<int>(defaultDisplayUnitId.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseDimension: $baseDimension, ')
          ..write('defaultDisplayUnitId: $defaultDisplayUnitId, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $ProductCategoryValuesTable extends ProductCategoryValues
    with TableInfo<$ProductCategoryValuesTable, ProductCategoryValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCategoryValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES units (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, categoryId, value, unitId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_category_values';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductCategoryValue> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductCategoryValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCategoryValue(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id'])!,
    );
  }

  @override
  $ProductCategoryValuesTable createAlias(String alias) {
    return $ProductCategoryValuesTable(attachedDatabase, alias);
  }
}

class ProductCategoryValue extends DataClass
    implements Insertable<ProductCategoryValue> {
  final int id;

  /// Related product identifier.
  final int productId;

  /// Related category identifier.
  final int categoryId;

  /// Value converted to the category's base dimension unit.
  final double value;

  /// Measurement unit originally used when entering [value].
  final int unitId;
  const ProductCategoryValue(
      {required this.id,
      required this.productId,
      required this.categoryId,
      required this.value,
      required this.unitId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['category_id'] = Variable<int>(categoryId);
    map['value'] = Variable<double>(value);
    map['unit_id'] = Variable<int>(unitId);
    return map;
  }

  ProductCategoryValuesCompanion toCompanion(bool nullToAbsent) {
    return ProductCategoryValuesCompanion(
      id: Value(id),
      productId: Value(productId),
      categoryId: Value(categoryId),
      value: Value(value),
      unitId: Value(unitId),
    );
  }

  factory ProductCategoryValue.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCategoryValue(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      value: serializer.fromJson<double>(json['value']),
      unitId: serializer.fromJson<int>(json['unitId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'categoryId': serializer.toJson<int>(categoryId),
      'value': serializer.toJson<double>(value),
      'unitId': serializer.toJson<int>(unitId),
    };
  }

  ProductCategoryValue copyWith(
          {int? id,
          int? productId,
          int? categoryId,
          double? value,
          int? unitId}) =>
      ProductCategoryValue(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        categoryId: categoryId ?? this.categoryId,
        value: value ?? this.value,
        unitId: unitId ?? this.unitId,
      );
  ProductCategoryValue copyWithCompanion(ProductCategoryValuesCompanion data) {
    return ProductCategoryValue(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      value: data.value.present ? data.value.value : this.value,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategoryValue(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('value: $value, ')
          ..write('unitId: $unitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, categoryId, value, unitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCategoryValue &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.categoryId == this.categoryId &&
          other.value == this.value &&
          other.unitId == this.unitId);
}

class ProductCategoryValuesCompanion
    extends UpdateCompanion<ProductCategoryValue> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> categoryId;
  final Value<double> value;
  final Value<int> unitId;
  const ProductCategoryValuesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.value = const Value.absent(),
    this.unitId = const Value.absent(),
  });
  ProductCategoryValuesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int categoryId,
    required double value,
    required int unitId,
  })  : productId = Value(productId),
        categoryId = Value(categoryId),
        value = Value(value),
        unitId = Value(unitId);
  static Insertable<ProductCategoryValue> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? categoryId,
    Expression<double>? value,
    Expression<int>? unitId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (categoryId != null) 'category_id': categoryId,
      if (value != null) 'value': value,
      if (unitId != null) 'unit_id': unitId,
    });
  }

  ProductCategoryValuesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<int>? categoryId,
      Value<double>? value,
      Value<int>? unitId}) {
    return ProductCategoryValuesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      value: value ?? this.value,
      unitId: unitId ?? this.unitId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategoryValuesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('value: $value, ')
          ..write('unitId: $unitId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductCategoryValuesTable productCategoryValues =
      $ProductCategoryValuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [units, products, categories, productCategoryValues];
}

typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required String name,
  required String dimension,
  required double factorToBase,
  Value<bool> isCustom,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> dimension,
  Value<double> factorToBase,
  Value<bool> isCustom,
});

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName: $_aliasNameGenerator(
              db.units.id, db.products.defaultServingUnitId));

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.defaultServingUnitId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CategoriesTable, List<Category>>
      _categoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.categories,
              aliasName: $_aliasNameGenerator(
                  db.units.id, db.categories.defaultDisplayUnitId));

  $$CategoriesTableProcessedTableManager get categoriesRefs {
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.defaultDisplayUnitId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProductCategoryValuesTable,
      List<ProductCategoryValue>> _productCategoryValuesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productCategoryValues,
          aliasName: $_aliasNameGenerator(
              db.units.id, db.productCategoryValues.unitId));

  $$ProductCategoryValuesTableProcessedTableManager
      get productCategoryValuesRefs {
    final manager = $$ProductCategoryValuesTableTableManager(
            $_db, $_db.productCategoryValues)
        .filter((f) => f.unitId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_productCategoryValuesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get factorToBase => $composableBuilder(
      column: $table.factorToBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.defaultServingUnitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> categoriesRefs(
      Expression<bool> Function($$CategoriesTableFilterComposer f) f) {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.defaultDisplayUnitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> productCategoryValuesRefs(
      Expression<bool> Function($$ProductCategoryValuesTableFilterComposer f)
          f) {
    final $$ProductCategoryValuesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.unitId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableFilterComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get factorToBase => $composableBuilder(
      column: $table.factorToBase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<double> get factorToBase => $composableBuilder(
      column: $table.factorToBase, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.defaultServingUnitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> categoriesRefs<T extends Object>(
      Expression<T> Function($$CategoriesTableAnnotationComposer a) f) {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.defaultDisplayUnitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> productCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$ProductCategoryValuesTableAnnotationComposer a)
          f) {
    final $$ProductCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.unitId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function(
        {bool productsRefs,
        bool categoriesRefs,
        bool productCategoryValuesRefs})> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> dimension = const Value.absent(),
            Value<double> factorToBase = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            name: name,
            dimension: dimension,
            factorToBase: factorToBase,
            isCustom: isCustom,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String dimension,
            required double factorToBase,
            Value<bool> isCustom = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            name: name,
            dimension: dimension,
            factorToBase: factorToBase,
            isCustom: isCustom,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UnitsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {productsRefs = false,
              categoriesRefs = false,
              productCategoryValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsRefs) db.products,
                if (categoriesRefs) db.categories,
                if (productCategoryValuesRefs) db.productCategoryValues
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UnitsTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UnitsTableReferences(db, table, p0).productsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.defaultServingUnitId == item.id),
                        typedResults: items),
                  if (categoriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UnitsTableReferences._categoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UnitsTableReferences(db, table, p0)
                                .categoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.defaultDisplayUnitId == item.id),
                        typedResults: items),
                  if (productCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UnitsTableReferences
                            ._productCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UnitsTableReferences(db, table, p0)
                                .productCategoryValuesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.unitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function(
        {bool productsRefs,
        bool categoriesRefs,
        bool productCategoryValuesRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  required double defaultServingSize,
  required int defaultServingUnitId,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> defaultServingSize,
  Value<int> defaultServingUnitId,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _defaultServingUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias(
          $_aliasNameGenerator(db.products.defaultServingUnitId, db.units.id));

  $$UnitsTableProcessedTableManager? get defaultServingUnitId {
    if ($_item.defaultServingUnitId == null) return null;
    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.id($_item.defaultServingUnitId!));
    final item =
        $_typedResult.readTableOrNull(_defaultServingUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductCategoryValuesTable,
      List<ProductCategoryValue>> _productCategoryValuesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productCategoryValues,
          aliasName: $_aliasNameGenerator(
              db.products.id, db.productCategoryValues.productId));

  $$ProductCategoryValuesTableProcessedTableManager
      get productCategoryValuesRefs {
    final manager = $$ProductCategoryValuesTableTableManager(
            $_db, $_db.productCategoryValues)
        .filter((f) => f.productId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_productCategoryValuesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultServingSize => $composableBuilder(
      column: $table.defaultServingSize,
      builder: (column) => ColumnFilters(column));

  $$UnitsTableFilterComposer get defaultServingUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultServingUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableFilterComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productCategoryValuesRefs(
      Expression<bool> Function($$ProductCategoryValuesTableFilterComposer f)
          f) {
    final $$ProductCategoryValuesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableFilterComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultServingSize => $composableBuilder(
      column: $table.defaultServingSize,
      builder: (column) => ColumnOrderings(column));

  $$UnitsTableOrderingComposer get defaultServingUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultServingUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableOrderingComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultServingSize => $composableBuilder(
      column: $table.defaultServingSize, builder: (column) => column);

  $$UnitsTableAnnotationComposer get defaultServingUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultServingUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$ProductCategoryValuesTableAnnotationComposer a)
          f) {
    final $$ProductCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool defaultServingUnitId, bool productCategoryValuesRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> defaultServingSize = const Value.absent(),
            Value<int> defaultServingUnitId = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            defaultServingSize: defaultServingSize,
            defaultServingUnitId: defaultServingUnitId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double defaultServingSize,
            required int defaultServingUnitId,
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            defaultServingSize: defaultServingSize,
            defaultServingUnitId: defaultServingUnitId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {defaultServingUnitId = false,
              productCategoryValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productCategoryValuesRefs) db.productCategoryValues
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (defaultServingUnitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.defaultServingUnitId,
                    referencedTable: $$ProductsTableReferences
                        ._defaultServingUnitIdTable(db),
                    referencedColumn: $$ProductsTableReferences
                        ._defaultServingUnitIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productCategoryValuesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool defaultServingUnitId, bool productCategoryValuesRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required String baseDimension,
  required int defaultDisplayUnitId,
  Value<bool> isCustom,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> baseDimension,
  Value<int> defaultDisplayUnitId,
  Value<bool> isCustom,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _defaultDisplayUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias($_aliasNameGenerator(
          db.categories.defaultDisplayUnitId, db.units.id));

  $$UnitsTableProcessedTableManager? get defaultDisplayUnitId {
    if ($_item.defaultDisplayUnitId == null) return null;
    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.id($_item.defaultDisplayUnitId!));
    final item =
        $_typedResult.readTableOrNull(_defaultDisplayUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductCategoryValuesTable,
      List<ProductCategoryValue>> _productCategoryValuesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productCategoryValues,
          aliasName: $_aliasNameGenerator(
              db.categories.id, db.productCategoryValues.categoryId));

  $$ProductCategoryValuesTableProcessedTableManager
      get productCategoryValuesRefs {
    final manager = $$ProductCategoryValuesTableTableManager(
            $_db, $_db.productCategoryValues)
        .filter((f) => f.categoryId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_productCategoryValuesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseDimension => $composableBuilder(
      column: $table.baseDimension, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  $$UnitsTableFilterComposer get defaultDisplayUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultDisplayUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableFilterComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productCategoryValuesRefs(
      Expression<bool> Function($$ProductCategoryValuesTableFilterComposer f)
          f) {
    final $$ProductCategoryValuesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableFilterComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseDimension => $composableBuilder(
      column: $table.baseDimension,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  $$UnitsTableOrderingComposer get defaultDisplayUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultDisplayUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableOrderingComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseDimension => $composableBuilder(
      column: $table.baseDimension, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  $$UnitsTableAnnotationComposer get defaultDisplayUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultDisplayUnitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$ProductCategoryValuesTableAnnotationComposer a)
          f) {
    final $$ProductCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productCategoryValues,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productCategoryValues,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool defaultDisplayUnitId, bool productCategoryValuesRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> baseDimension = const Value.absent(),
            Value<int> defaultDisplayUnitId = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            baseDimension: baseDimension,
            defaultDisplayUnitId: defaultDisplayUnitId,
            isCustom: isCustom,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String baseDimension,
            required int defaultDisplayUnitId,
            Value<bool> isCustom = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            baseDimension: baseDimension,
            defaultDisplayUnitId: defaultDisplayUnitId,
            isCustom: isCustom,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {defaultDisplayUnitId = false,
              productCategoryValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productCategoryValuesRefs) db.productCategoryValues
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (defaultDisplayUnitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.defaultDisplayUnitId,
                    referencedTable: $$CategoriesTableReferences
                        ._defaultDisplayUnitIdTable(db),
                    referencedColumn: $$CategoriesTableReferences
                        ._defaultDisplayUnitIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._productCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .productCategoryValuesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool defaultDisplayUnitId, bool productCategoryValuesRefs})>;
typedef $$ProductCategoryValuesTableCreateCompanionBuilder
    = ProductCategoryValuesCompanion Function({
  Value<int> id,
  required int productId,
  required int categoryId,
  required double value,
  required int unitId,
});
typedef $$ProductCategoryValuesTableUpdateCompanionBuilder
    = ProductCategoryValuesCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int> categoryId,
  Value<double> value,
  Value<int> unitId,
});

final class $$ProductCategoryValuesTableReferences extends BaseReferences<
    _$AppDatabase, $ProductCategoryValuesTable, ProductCategoryValue> {
  $$ProductCategoryValuesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias($_aliasNameGenerator(
          db.productCategoryValues.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    if ($_item.productId == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id($_item.productId!));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.productCategoryValues.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UnitsTable _unitIdTable(_$AppDatabase db) => db.units.createAlias(
      $_aliasNameGenerator(db.productCategoryValues.unitId, db.units.id));

  $$UnitsTableProcessedTableManager? get unitId {
    if ($_item.unitId == null) return null;
    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.id($_item.unitId!));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductCategoryValuesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCategoryValuesTable> {
  $$ProductCategoryValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.unitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableFilterComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductCategoryValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCategoryValuesTable> {
  $$ProductCategoryValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.unitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableOrderingComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductCategoryValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCategoryValuesTable> {
  $$ProductCategoryValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.unitId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductCategoryValuesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductCategoryValuesTable,
    ProductCategoryValue,
    $$ProductCategoryValuesTableFilterComposer,
    $$ProductCategoryValuesTableOrderingComposer,
    $$ProductCategoryValuesTableAnnotationComposer,
    $$ProductCategoryValuesTableCreateCompanionBuilder,
    $$ProductCategoryValuesTableUpdateCompanionBuilder,
    (ProductCategoryValue, $$ProductCategoryValuesTableReferences),
    ProductCategoryValue,
    PrefetchHooks Function({bool productId, bool categoryId, bool unitId})> {
  $$ProductCategoryValuesTableTableManager(
      _$AppDatabase db, $ProductCategoryValuesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCategoryValuesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCategoryValuesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductCategoryValuesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> unitId = const Value.absent(),
          }) =>
              ProductCategoryValuesCompanion(
            id: id,
            productId: productId,
            categoryId: categoryId,
            value: value,
            unitId: unitId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            required int categoryId,
            required double value,
            required int unitId,
          }) =>
              ProductCategoryValuesCompanion.insert(
            id: id,
            productId: productId,
            categoryId: categoryId,
            value: value,
            unitId: unitId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductCategoryValuesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {productId = false, categoryId = false, unitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable: $$ProductCategoryValuesTableReferences
                        ._productIdTable(db),
                    referencedColumn: $$ProductCategoryValuesTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$ProductCategoryValuesTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$ProductCategoryValuesTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (unitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.unitId,
                    referencedTable:
                        $$ProductCategoryValuesTableReferences._unitIdTable(db),
                    referencedColumn: $$ProductCategoryValuesTableReferences
                        ._unitIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductCategoryValuesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProductCategoryValuesTable,
        ProductCategoryValue,
        $$ProductCategoryValuesTableFilterComposer,
        $$ProductCategoryValuesTableOrderingComposer,
        $$ProductCategoryValuesTableAnnotationComposer,
        $$ProductCategoryValuesTableCreateCompanionBuilder,
        $$ProductCategoryValuesTableUpdateCompanionBuilder,
        (ProductCategoryValue, $$ProductCategoryValuesTableReferences),
        ProductCategoryValue,
        PrefetchHooks Function({bool productId, bool categoryId, bool unitId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductCategoryValuesTableTableManager get productCategoryValues =>
      $$ProductCategoryValuesTableTableManager(_db, _db.productCategoryValues);
}
