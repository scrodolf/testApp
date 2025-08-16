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
  static const VerificationMeta _customUnitRatiosMeta =
      const VerificationMeta('customUnitRatios');
  @override
  late final GeneratedColumnWithTypeConverter<Map<int, double>, String>
      customUnitRatios = GeneratedColumn<String>(
              'custom_unit_ratios', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('{}'))
          .withConverter<Map<int, double>>(
              $ProductsTable.$convertercustomUnitRatios);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, defaultServingSize, defaultServingUnitId, customUnitRatios];
=======
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
    context.handle(_customUnitRatiosMeta, const VerificationResult.success());
=======

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
      customUnitRatios: $ProductsTable.$convertercustomUnitRatios.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}custom_unit_ratios'])!),

    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<int, double>, String> $convertercustomUnitRatios =
      const IntDoubleMapConverter();

}

class Product extends DataClass implements Insertable<Product> {
  final int id;

  /// Human readable product name.
  final String name;

  /// Default serving quantity for the product.
  final double defaultServingSize;

  /// Unit for the default serving quantity.
  final int defaultServingUnitId;

  /// Optional overrides for product-specific units such as "scoop".
  ///
  /// Stored as a JSON map of `unitId -> factorToBase` allowing the same unit
  /// to have different ratios depending on the product.
  final Map<int, double> customUnitRatios;

  const Product(
      {required this.id,
      required this.name,
      required this.defaultServingSize,
      required this.defaultServingUnitId,
      required this.customUnitRatios});
=======
      required this.defaultServingUnitId});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['default_serving_size'] = Variable<double>(defaultServingSize);
    map['default_serving_unit_id'] = Variable<int>(defaultServingUnitId);
    {
      map['custom_unit_ratios'] = Variable<String>(
          $ProductsTable.$convertercustomUnitRatios.toSql(customUnitRatios));
    }

    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      defaultServingSize: Value(defaultServingSize),
      defaultServingUnitId: Value(defaultServingUnitId),
      customUnitRatios: Value(customUnitRatios),

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
      customUnitRatios:
          serializer.fromJson<Map<int, double>>(json['customUnitRatios']),

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
      'customUnitRatios': serializer.toJson<Map<int, double>>(customUnitRatios),

    };
  }

  Product copyWith(
          {int? id,
          String? name,
          double? defaultServingSize,
          int? defaultServingUnitId,
          Map<int, double>? customUnitRatios}) =>
=======
          int? defaultServingUnitId}) =>

      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        defaultServingSize: defaultServingSize ?? this.defaultServingSize,
        defaultServingUnitId: defaultServingUnitId ?? this.defaultServingUnitId,
        customUnitRatios: customUnitRatios ?? this.customUnitRatios,

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
      customUnitRatios: data.customUnitRatios.present
          ? data.customUnitRatios.value
          : this.customUnitRatios,

    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultServingSize: $defaultServingSize, ')
          ..write('defaultServingUnitId: $defaultServingUnitId, ')
          ..write('customUnitRatios: $customUnitRatios')
=======
          ..write('defaultServingUnitId: $defaultServingUnitId')

          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, defaultServingSize, defaultServingUnitId, customUnitRatios);
=======
  int get hashCode =>
      Object.hash(id, name, defaultServingSize, defaultServingUnitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.defaultServingSize == this.defaultServingSize &&
          other.defaultServingUnitId == this.defaultServingUnitId &&
          other.customUnitRatios == this.customUnitRatios);
=======
          other.defaultServingUnitId == this.defaultServingUnitId);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> defaultServingSize;
  final Value<int> defaultServingUnitId;
  final Value<Map<int, double>> customUnitRatios;

  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultServingSize = const Value.absent(),
    this.defaultServingUnitId = const Value.absent(),
    this.customUnitRatios = const Value.absent(),

  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double defaultServingSize,
    required int defaultServingUnitId,
    this.customUnitRatios = const Value.absent(),

  })  : name = Value(name),
        defaultServingSize = Value(defaultServingSize),
        defaultServingUnitId = Value(defaultServingUnitId);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? defaultServingSize,
    Expression<int>? defaultServingUnitId,
    Expression<String>? customUnitRatios,

  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (defaultServingSize != null)
        'default_serving_size': defaultServingSize,
      if (defaultServingUnitId != null)
        'default_serving_unit_id': defaultServingUnitId,
      if (customUnitRatios != null) 'custom_unit_ratios': customUnitRatios,

    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? defaultServingSize,
      Value<int>? defaultServingUnitId,
      Value<Map<int, double>>? customUnitRatios}) {
=======
      Value<int>? defaultServingUnitId}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultServingSize: defaultServingSize ?? this.defaultServingSize,
      defaultServingUnitId: defaultServingUnitId ?? this.defaultServingUnitId,
      customUnitRatios: customUnitRatios ?? this.customUnitRatios,

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

    if (customUnitRatios.present) {
      map['custom_unit_ratios'] = Variable<String>($ProductsTable
          .$convertercustomUnitRatios
          .toSql(customUnitRatios.value));
    }

    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultServingSize: $defaultServingSize, ')
          ..write('defaultServingUnitId: $defaultServingUnitId, ')
          ..write('customUnitRatios: $customUnitRatios')
=======
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

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
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
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(Insertable<Meal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;

  /// Optional descriptive name.
  final String? name;

  /// Free-form notes about the meal.
  final String? notes;
  const Meal({required this.id, this.name, this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Meal copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Meal(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        notes: notes.present ? notes.value : this.notes,
      );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> notes;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
  });
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
    });
  }

  MealsCompanion copyWith(
      {Value<int>? id, Value<String?>? name, Value<String?>? notes}) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MealEntriesTable extends MealEntries
    with TableInfo<$MealEntriesTable, MealEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES meals (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, mealId, productId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MealEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $MealEntriesTable createAlias(String alias) {
    return $MealEntriesTable(attachedDatabase, alias);
  }
}

class MealEntry extends DataClass implements Insertable<MealEntry> {
  final int id;

  /// Associated meal.
  final int mealId;

  /// Referenced product.
  final int productId;

  /// Number of servings of the product in the meal.
  final double quantity;
  const MealEntry(
      {required this.id,
      required this.mealId,
      required this.productId,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    return map;
  }

  MealEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealEntriesCompanion(
      id: Value(id),
      mealId: Value(mealId),
      productId: Value(productId),
      quantity: Value(quantity),
    );
  }

  factory MealEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealEntry(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
    };
  }

  MealEntry copyWith(
          {int? id, int? mealId, int? productId, double? quantity}) =>
      MealEntry(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );
  MealEntry copyWithCompanion(MealEntriesCompanion data) {
    return MealEntry(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealEntry(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, productId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealEntry &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.productId == this.productId &&
          other.quantity == this.quantity);
}

class MealEntriesCompanion extends UpdateCompanion<MealEntry> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> productId;
  final Value<double> quantity;
  const MealEntriesCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  MealEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int productId,
    required double quantity,
  })  : mealId = Value(mealId),
        productId = Value(productId),
        quantity = Value(quantity);
  static Insertable<MealEntry> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? productId,
    Expression<double>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  MealEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealId,
      Value<int>? productId,
      Value<double>? quantity}) {
    return MealEntriesCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealEntriesCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $MealCategoryValuesTable extends MealCategoryValues
    with TableInfo<$MealCategoryValuesTable, MealCategoryValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealCategoryValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES meals (id)'));
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
  static const VerificationMeta _originalUnitIdMeta =
      const VerificationMeta('originalUnitId');
  @override
  late final GeneratedColumn<int> originalUnitId = GeneratedColumn<int>(
      'original_unit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES units (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, mealId, categoryId, value, originalUnitId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_category_values';
  @override
  VerificationContext validateIntegrity(Insertable<MealCategoryValue> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
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
    if (data.containsKey('original_unit_id')) {
      context.handle(
          _originalUnitIdMeta,
          originalUnitId.isAcceptableOrUnknown(
              data['original_unit_id']!, _originalUnitIdMeta));
    } else if (isInserting) {
      context.missing(_originalUnitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealCategoryValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealCategoryValue(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      originalUnitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}original_unit_id'])!,
    );
  }

  @override
  $MealCategoryValuesTable createAlias(String alias) {
    return $MealCategoryValuesTable(attachedDatabase, alias);
  }
}

class MealCategoryValue extends DataClass
    implements Insertable<MealCategoryValue> {
  final int id;

  /// Meal to which this value belongs.
  final int mealId;

  /// Category of the value.
  final int categoryId;

  /// Amount converted to the category's base dimension unit.
  final double value;

  /// Unit originally used when entering [value].
  final int originalUnitId;
  const MealCategoryValue(
      {required this.id,
      required this.mealId,
      required this.categoryId,
      required this.value,
      required this.originalUnitId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['category_id'] = Variable<int>(categoryId);
    map['value'] = Variable<double>(value);
    map['original_unit_id'] = Variable<int>(originalUnitId);
    return map;
  }

  MealCategoryValuesCompanion toCompanion(bool nullToAbsent) {
    return MealCategoryValuesCompanion(
      id: Value(id),
      mealId: Value(mealId),
      categoryId: Value(categoryId),
      value: Value(value),
      originalUnitId: Value(originalUnitId),
    );
  }

  factory MealCategoryValue.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealCategoryValue(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      value: serializer.fromJson<double>(json['value']),
      originalUnitId: serializer.fromJson<int>(json['originalUnitId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'categoryId': serializer.toJson<int>(categoryId),
      'value': serializer.toJson<double>(value),
      'originalUnitId': serializer.toJson<int>(originalUnitId),
    };
  }

  MealCategoryValue copyWith(
          {int? id,
          int? mealId,
          int? categoryId,
          double? value,
          int? originalUnitId}) =>
      MealCategoryValue(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        categoryId: categoryId ?? this.categoryId,
        value: value ?? this.value,
        originalUnitId: originalUnitId ?? this.originalUnitId,
      );
  MealCategoryValue copyWithCompanion(MealCategoryValuesCompanion data) {
    return MealCategoryValue(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      value: data.value.present ? data.value.value : this.value,
      originalUnitId: data.originalUnitId.present
          ? data.originalUnitId.value
          : this.originalUnitId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealCategoryValue(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('categoryId: $categoryId, ')
          ..write('value: $value, ')
          ..write('originalUnitId: $originalUnitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mealId, categoryId, value, originalUnitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealCategoryValue &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.categoryId == this.categoryId &&
          other.value == this.value &&
          other.originalUnitId == this.originalUnitId);
}

class MealCategoryValuesCompanion extends UpdateCompanion<MealCategoryValue> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> categoryId;
  final Value<double> value;
  final Value<int> originalUnitId;
  const MealCategoryValuesCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.value = const Value.absent(),
    this.originalUnitId = const Value.absent(),
  });
  MealCategoryValuesCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int categoryId,
    required double value,
    required int originalUnitId,
  })  : mealId = Value(mealId),
        categoryId = Value(categoryId),
        value = Value(value),
        originalUnitId = Value(originalUnitId);
  static Insertable<MealCategoryValue> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? categoryId,
    Expression<double>? value,
    Expression<int>? originalUnitId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (categoryId != null) 'category_id': categoryId,
      if (value != null) 'value': value,
      if (originalUnitId != null) 'original_unit_id': originalUnitId,
    });
  }

  MealCategoryValuesCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealId,
      Value<int>? categoryId,
      Value<double>? value,
      Value<int>? originalUnitId}) {
    return MealCategoryValuesCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      categoryId: categoryId ?? this.categoryId,
      value: value ?? this.value,
      originalUnitId: originalUnitId ?? this.originalUnitId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (originalUnitId.present) {
      map['original_unit_id'] = Variable<int>(originalUnitId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealCategoryValuesCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('categoryId: $categoryId, ')
          ..write('value: $value, ')
          ..write('originalUnitId: $originalUnitId')
          ..write(')'))
        .toString();
  }
}

class $LogItemsTable extends LogItems with TableInfo<$LogItemsTable, LogItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES meals (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, mealId, date, time, mealType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_items';
  @override
  VerificationContext validateIntegrity(Insertable<LogItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
    );
  }

  @override
  $LogItemsTable createAlias(String alias) {
    return $LogItemsTable(attachedDatabase, alias);
  }
}

class LogItem extends DataClass implements Insertable<LogItem> {
  final int id;

  /// Associated meal reference.
  final int mealId;

  /// Logged date in `yyyy-MM-dd` format.
  final String date;

  /// Logged time in `HH:mm` format.
  final String time;

  /// Meal type such as Breakfast/Lunch/Dinner.
  final String mealType;
  const LogItem(
      {required this.id,
      required this.mealId,
      required this.date,
      required this.time,
      required this.mealType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['date'] = Variable<String>(date);
    map['time'] = Variable<String>(time);
    map['meal_type'] = Variable<String>(mealType);
    return map;
  }

  LogItemsCompanion toCompanion(bool nullToAbsent) {
    return LogItemsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      date: Value(date),
      time: Value(time),
      mealType: Value(mealType),
    );
  }

  factory LogItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogItem(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      mealType: serializer.fromJson<String>(json['mealType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String>(time),
      'mealType': serializer.toJson<String>(mealType),
    };
  }

  LogItem copyWith(
          {int? id,
          int? mealId,
          String? date,
          String? time,
          String? mealType}) =>
      LogItem(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        date: date ?? this.date,
        time: time ?? this.time,
        mealType: mealType ?? this.mealType,
      );
  LogItem copyWithCompanion(LogItemsCompanion data) {
    return LogItem(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogItem(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('mealType: $mealType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, date, time, mealType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogItem &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.date == this.date &&
          other.time == this.time &&
          other.mealType == this.mealType);
}

class LogItemsCompanion extends UpdateCompanion<LogItem> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<String> date;
  final Value<String> time;
  final Value<String> mealType;
  const LogItemsCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.mealType = const Value.absent(),
  });
  LogItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required String date,
    required String time,
    required String mealType,
  })  : mealId = Value(mealId),
        date = Value(date),
        time = Value(time),
        mealType = Value(mealType);
  static Insertable<LogItem> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? mealType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (mealType != null) 'meal_type': mealType,
    });
  }

  LogItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealId,
      Value<String>? date,
      Value<String>? time,
      Value<String>? mealType}) {
    return LogItemsCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      date: date ?? this.date,
      time: time ?? this.time,
      mealType: mealType ?? this.mealType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('mealType: $mealType')
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
  late final $MealsTable meals = $MealsTable(this);
  late final $MealEntriesTable mealEntries = $MealEntriesTable(this);
  late final $MealCategoryValuesTable mealCategoryValues =
      $MealCategoryValuesTable(this);
  late final $LogItemsTable logItems = $LogItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        units,
        products,
        categories,
        productCategoryValues,
        meals,
        mealEntries,
        mealCategoryValues,
        logItems
      ];
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

  static MultiTypedResultKey<$MealCategoryValuesTable, List<MealCategoryValue>>
      _mealCategoryValuesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mealCategoryValues,
              aliasName: $_aliasNameGenerator(
                  db.units.id, db.mealCategoryValues.originalUnitId));

  $$MealCategoryValuesTableProcessedTableManager get mealCategoryValuesRefs {
    final manager =
        $$MealCategoryValuesTableTableManager($_db, $_db.mealCategoryValues)
            .filter((f) => f.originalUnitId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mealCategoryValuesRefsTable($_db));
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

  Expression<bool> mealCategoryValuesRefs(
      Expression<bool> Function($$MealCategoryValuesTableFilterComposer f) f) {
    final $$MealCategoryValuesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealCategoryValues,
        getReferencedColumn: (t) => t.originalUnitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealCategoryValuesTableFilterComposer(
              $db: $db,
              $table: $db.mealCategoryValues,
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

  Expression<T> mealCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$MealCategoryValuesTableAnnotationComposer a) f) {
    final $$MealCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mealCategoryValues,
            getReferencedColumn: (t) => t.originalUnitId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MealCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mealCategoryValues,
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
        bool productCategoryValuesRefs,
        bool mealCategoryValuesRefs})> {
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
              productCategoryValuesRefs = false,
              mealCategoryValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsRefs) db.products,
                if (categoriesRefs) db.categories,
                if (productCategoryValuesRefs) db.productCategoryValues,
                if (mealCategoryValuesRefs) db.mealCategoryValues
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
                        typedResults: items),
                  if (mealCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UnitsTableReferences
                            ._mealCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UnitsTableReferences(db, table, p0)
                                .mealCategoryValuesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.originalUnitId == item.id),
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
        bool productCategoryValuesRefs,
        bool mealCategoryValuesRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  required double defaultServingSize,
  required int defaultServingUnitId,
  Value<Map<int, double>> customUnitRatios,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> defaultServingSize,
  Value<int> defaultServingUnitId,
  Value<Map<int, double>> customUnitRatios,
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

  static MultiTypedResultKey<$MealEntriesTable, List<MealEntry>>
      _mealEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.mealEntries,
          aliasName:
              $_aliasNameGenerator(db.products.id, db.mealEntries.productId));

  $$MealEntriesTableProcessedTableManager get mealEntriesRefs {
    final manager = $$MealEntriesTableTableManager($_db, $_db.mealEntries)
        .filter((f) => f.productId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_mealEntriesRefsTable($_db));
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

  ColumnWithTypeConverterFilters<Map<int, double>, Map<int, double>, String>
      get customUnitRatios => $composableBuilder(
          column: $table.customUnitRatios,
          builder: (column) => ColumnWithTypeConverterFilters(column));

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

  Expression<bool> mealEntriesRefs(
      Expression<bool> Function($$MealEntriesTableFilterComposer f) f) {
    final $$MealEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableFilterComposer(
              $db: $db,
              $table: $db.mealEntries,
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

  ColumnOrderings<String> get customUnitRatios => $composableBuilder(
      column: $table.customUnitRatios,
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

  GeneratedColumnWithTypeConverter<Map<int, double>, String>
      get customUnitRatios => $composableBuilder(
          column: $table.customUnitRatios, builder: (column) => column);

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

  Expression<T> mealEntriesRefs<T extends Object>(
      Expression<T> Function($$MealEntriesTableAnnotationComposer a) f) {
    final $$MealEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.mealEntries,
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
        {bool defaultServingUnitId,
        bool productCategoryValuesRefs,
        bool mealEntriesRefs})> {
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
            Value<Map<int, double>> customUnitRatios = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            defaultServingSize: defaultServingSize,
            defaultServingUnitId: defaultServingUnitId,
            customUnitRatios: customUnitRatios,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double defaultServingSize,
            required int defaultServingUnitId,
            Value<Map<int, double>> customUnitRatios = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            defaultServingSize: defaultServingSize,
            defaultServingUnitId: defaultServingUnitId,
            customUnitRatios: customUnitRatios,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {defaultServingUnitId = false,
              productCategoryValuesRefs = false,
              mealEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productCategoryValuesRefs) db.productCategoryValues,
                if (mealEntriesRefs) db.mealEntries
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
                        typedResults: items),
                  if (mealEntriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._mealEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .mealEntriesRefs,
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
        {bool defaultServingUnitId,
        bool productCategoryValuesRefs,
        bool mealEntriesRefs})>;
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

  static MultiTypedResultKey<$MealCategoryValuesTable, List<MealCategoryValue>>
      _mealCategoryValuesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mealCategoryValues,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.mealCategoryValues.categoryId));

  $$MealCategoryValuesTableProcessedTableManager get mealCategoryValuesRefs {
    final manager =
        $$MealCategoryValuesTableTableManager($_db, $_db.mealCategoryValues)
            .filter((f) => f.categoryId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mealCategoryValuesRefsTable($_db));
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

  Expression<bool> mealCategoryValuesRefs(
      Expression<bool> Function($$MealCategoryValuesTableFilterComposer f) f) {
    final $$MealCategoryValuesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealCategoryValues,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealCategoryValuesTableFilterComposer(
              $db: $db,
              $table: $db.mealCategoryValues,
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

  Expression<T> mealCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$MealCategoryValuesTableAnnotationComposer a) f) {
    final $$MealCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mealCategoryValues,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MealCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mealCategoryValues,
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
        {bool defaultDisplayUnitId,
        bool productCategoryValuesRefs,
        bool mealCategoryValuesRefs})> {
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
              productCategoryValuesRefs = false,
              mealCategoryValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productCategoryValuesRefs) db.productCategoryValues,
                if (mealCategoryValuesRefs) db.mealCategoryValues
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
                        typedResults: items),
                  if (mealCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._mealCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .mealCategoryValuesRefs,
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
        {bool defaultDisplayUnitId,
        bool productCategoryValuesRefs,
        bool mealCategoryValuesRefs})>;
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
=======
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
=======
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


      
  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
=======
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

    
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
=======
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
=======
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
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> notes,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> notes,
});

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealEntriesTable, List<MealEntry>>
      _mealEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.mealEntries,
          aliasName: $_aliasNameGenerator(db.meals.id, db.mealEntries.mealId));

  $$MealEntriesTableProcessedTableManager get mealEntriesRefs {
    final manager = $$MealEntriesTableTableManager($_db, $_db.mealEntries)
        .filter((f) => f.mealId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_mealEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MealCategoryValuesTable, List<MealCategoryValue>>
      _mealCategoryValuesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mealCategoryValues,
              aliasName: $_aliasNameGenerator(
                  db.meals.id, db.mealCategoryValues.mealId));

  $$MealCategoryValuesTableProcessedTableManager get mealCategoryValuesRefs {
    final manager =
        $$MealCategoryValuesTableTableManager($_db, $_db.mealCategoryValues)
            .filter((f) => f.mealId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mealCategoryValuesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LogItemsTable, List<LogItem>> _logItemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.logItems,
          aliasName: $_aliasNameGenerator(db.meals.id, db.logItems.mealId));

  $$LogItemsTableProcessedTableManager get logItemsRefs {
    final manager = $$LogItemsTableTableManager($_db, $_db.logItems)
        .filter((f) => f.mealId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_logItemsRefsTable($_db));
=======
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


      
class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
=======
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


  
  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  Expression<bool> mealEntriesRefs(
      Expression<bool> Function($$MealEntriesTableFilterComposer f) f) {
    final $$MealEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableFilterComposer(
              $db: $db,
              $table: $db.mealEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mealCategoryValuesRefs(
      Expression<bool> Function($$MealCategoryValuesTableFilterComposer f) f) {
    final $$MealCategoryValuesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealCategoryValues,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealCategoryValuesTableFilterComposer(
              $db: $db,
              $table: $db.mealCategoryValues,
=======
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

    
    return f(composer);
  }

  Expression<bool> logItemsRefs(
      Expression<bool> Function($$LogItemsTableFilterComposer f) f) {
    final $$LogItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.logItems,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LogItemsTableFilterComposer(
              $db: $db,
              $table: $db.logItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
=======
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


              
class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
=======
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


  
  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
=======
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


      
  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> mealEntriesRefs<T extends Object>(
      Expression<T> Function($$MealEntriesTableAnnotationComposer a) f) {
    final $$MealEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.mealEntries,
=======
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

    
    return f(composer);
  }

  Expression<T> mealCategoryValuesRefs<T extends Object>(
      Expression<T> Function($$MealCategoryValuesTableAnnotationComposer a) f) {
    final $$MealCategoryValuesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mealCategoryValues,
            getReferencedColumn: (t) => t.mealId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MealCategoryValuesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mealCategoryValues,
=======
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

                  

  Expression<T> logItemsRefs<T extends Object>(
      Expression<T> Function($$LogItemsTableAnnotationComposer a) f) {
    final $$LogItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.logItems,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LogItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.logItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, $$MealsTableReferences),
    Meal,
    PrefetchHooks Function(
        {bool mealEntriesRefs,
        bool mealCategoryValuesRefs,
        bool logItemsRefs})> {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
=======
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

        
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MealsCompanion(
            id: id,
            name: name,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MealsCompanion.insert(
            id: id,
            name: name,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MealsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {mealEntriesRefs = false,
              mealCategoryValuesRefs = false,
              logItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealEntriesRefs) db.mealEntries,
                if (mealCategoryValuesRefs) db.mealCategoryValues,
                if (logItemsRefs) db.logItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealEntriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MealsTableReferences._mealEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealsTableReferences(db, table, p0)
                                .mealEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
                        typedResults: items),
                  if (mealCategoryValuesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MealsTableReferences
                            ._mealCategoryValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealsTableReferences(db, table, p0)
                                .mealCategoryValuesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
                        typedResults: items),
                  if (logItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MealsTableReferences._logItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealsTableReferences(db, table, p0).logItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
=======
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


                  
typedef $$MealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, $$MealsTableReferences),
    Meal,
    PrefetchHooks Function(
        {bool mealEntriesRefs,
        bool mealCategoryValuesRefs,
        bool logItemsRefs})>;
typedef $$MealEntriesTableCreateCompanionBuilder = MealEntriesCompanion
    Function({
  Value<int> id,
  required int mealId,
  required int productId,
  required double quantity,
});
typedef $$MealEntriesTableUpdateCompanionBuilder = MealEntriesCompanion
    Function({
  Value<int> id,
  Value<int> mealId,
  Value<int> productId,
  Value<double> quantity,
});

final class $$MealEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MealEntriesTable, MealEntry> {
  $$MealEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals
      .createAlias($_aliasNameGenerator(db.mealEntries.mealId, db.meals.id));

  $$MealsTableProcessedTableManager? get mealId {
    if ($_item.mealId == null) return null;
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.id($_item.mealId!));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
=======
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


  
  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.mealEntries.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    if ($_item.productId == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id($_item.productId!));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MealEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableFilterComposer({
=======
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


      
  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
=======
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

      
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
=======
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
}

class $$MealEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableOrderingComposer({
=======
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


      
  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableOrderingComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
=======
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

      
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
=======
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


      
class $$MealEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableAnnotationComposer({
=======
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


  
  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
=======
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

      
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
=======
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
}

class $$MealEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealEntriesTable,
    MealEntry,
    $$MealEntriesTableFilterComposer,
    $$MealEntriesTableOrderingComposer,
    $$MealEntriesTableAnnotationComposer,
    $$MealEntriesTableCreateCompanionBuilder,
    $$MealEntriesTableUpdateCompanionBuilder,
    (MealEntry, $$MealEntriesTableReferences),
    MealEntry,
    PrefetchHooks Function({bool mealId, bool productId})> {
  $$MealEntriesTableTableManager(_$AppDatabase db, $MealEntriesTable table)
=======
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

        
              $$MealEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
          }) =>
              MealEntriesCompanion(
            id: id,
            mealId: mealId,
            productId: productId,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealId,
            required int productId,
            required double quantity,
          }) =>
              MealEntriesCompanion.insert(
            id: id,
            mealId: mealId,
            productId: productId,
            quantity: quantity,
=======
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

                
                    $$MealEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
=======
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
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable:
                        $$MealEntriesTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$MealEntriesTableReferences._mealIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$MealEntriesTableReferences._productIdTable(db),
                    referencedColumn:
                        $$MealEntriesTableReferences._productIdTable(db).id,
=======
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
                return [];
              },
            );
          },
        ));
}

typedef $$MealEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealEntriesTable,
    MealEntry,
    $$MealEntriesTableFilterComposer,
    $$MealEntriesTableOrderingComposer,
    $$MealEntriesTableAnnotationComposer,
    $$MealEntriesTableCreateCompanionBuilder,
    $$MealEntriesTableUpdateCompanionBuilder,
    (MealEntry, $$MealEntriesTableReferences),
    MealEntry,
    PrefetchHooks Function({bool mealId, bool productId})>;
typedef $$MealCategoryValuesTableCreateCompanionBuilder
    = MealCategoryValuesCompanion Function({
  Value<int> id,
  required int mealId,
  required int categoryId,
  required double value,
  required int originalUnitId,
});
typedef $$MealCategoryValuesTableUpdateCompanionBuilder
    = MealCategoryValuesCompanion Function({
  Value<int> id,
  Value<int> mealId,
  Value<int> categoryId,
  Value<double> value,
  Value<int> originalUnitId,
});

final class $$MealCategoryValuesTableReferences extends BaseReferences<
    _$AppDatabase, $MealCategoryValuesTable, MealCategoryValue> {
  $$MealCategoryValuesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
      $_aliasNameGenerator(db.mealCategoryValues.mealId, db.meals.id));

  $$MealsTableProcessedTableManager? get mealId {
    if ($_item.mealId == null) return null;
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.id($_item.mealId!));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
=======
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
          db.mealCategoryValues.categoryId, db.categories.id));
=======
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

  static $UnitsTable _originalUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias($_aliasNameGenerator(
          db.mealCategoryValues.originalUnitId, db.units.id));

  $$UnitsTableProcessedTableManager? get originalUnitId {
    if ($_item.originalUnitId == null) return null;
    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.id($_item.originalUnitId!));
    final item = $_typedResult.readTableOrNull(_originalUnitIdTable($_db));
=======
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

class $$MealCategoryValuesTableFilterComposer
    extends Composer<_$AppDatabase, $MealCategoryValuesTable> {
  $$MealCategoryValuesTableFilterComposer({
=======
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

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
=======
  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
=======
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

  $$UnitsTableFilterComposer get originalUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.originalUnitId,
=======
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

class $$MealCategoryValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealCategoryValuesTable> {
  $$MealCategoryValuesTableOrderingComposer({
=======
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

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
=======
  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableOrderingComposer(
              $db: $db,
              $table: $db.meals,
=======
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

  $$UnitsTableOrderingComposer get originalUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.originalUnitId,
=======
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

class $$MealCategoryValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealCategoryValuesTable> {
  $$MealCategoryValuesTableAnnotationComposer({
=======
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

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
=======
  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
=======
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

  $$UnitsTableAnnotationComposer get originalUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.originalUnitId,
=======
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

class $$MealCategoryValuesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealCategoryValuesTable,
    MealCategoryValue,
    $$MealCategoryValuesTableFilterComposer,
    $$MealCategoryValuesTableOrderingComposer,
    $$MealCategoryValuesTableAnnotationComposer,
    $$MealCategoryValuesTableCreateCompanionBuilder,
    $$MealCategoryValuesTableUpdateCompanionBuilder,
    (MealCategoryValue, $$MealCategoryValuesTableReferences),
    MealCategoryValue,
    PrefetchHooks Function(
        {bool mealId, bool categoryId, bool originalUnitId})> {
  $$MealCategoryValuesTableTableManager(
      _$AppDatabase db, $MealCategoryValuesTable table)
=======
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
              $$MealCategoryValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealCategoryValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealCategoryValuesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealId = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> originalUnitId = const Value.absent(),
          }) =>
              MealCategoryValuesCompanion(
            id: id,
            mealId: mealId,
            categoryId: categoryId,
            value: value,
            originalUnitId: originalUnitId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealId,
            required int categoryId,
            required double value,
            required int originalUnitId,
          }) =>
              MealCategoryValuesCompanion.insert(
            id: id,
            mealId: mealId,
            categoryId: categoryId,
            value: value,
            originalUnitId: originalUnitId,
=======
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
                    $$MealCategoryValuesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {mealId = false, categoryId = false, originalUnitId = false}) {
=======
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
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable:
                        $$MealCategoryValuesTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$MealCategoryValuesTableReferences._mealIdTable(db).id,
=======
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
                    referencedTable: $$MealCategoryValuesTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$MealCategoryValuesTableReferences
=======
                    referencedTable: $$ProductCategoryValuesTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$ProductCategoryValuesTableReferences

                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (originalUnitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.originalUnitId,
                    referencedTable: $$MealCategoryValuesTableReferences
                        ._originalUnitIdTable(db),
                    referencedColumn: $$MealCategoryValuesTableReferences
                        ._originalUnitIdTable(db)
=======
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

typedef $$MealCategoryValuesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealCategoryValuesTable,
    MealCategoryValue,
    $$MealCategoryValuesTableFilterComposer,
    $$MealCategoryValuesTableOrderingComposer,
    $$MealCategoryValuesTableAnnotationComposer,
    $$MealCategoryValuesTableCreateCompanionBuilder,
    $$MealCategoryValuesTableUpdateCompanionBuilder,
    (MealCategoryValue, $$MealCategoryValuesTableReferences),
    MealCategoryValue,
    PrefetchHooks Function(
        {bool mealId, bool categoryId, bool originalUnitId})>;
typedef $$LogItemsTableCreateCompanionBuilder = LogItemsCompanion Function({
  Value<int> id,
  required int mealId,
  required String date,
  required String time,
  required String mealType,
});
typedef $$LogItemsTableUpdateCompanionBuilder = LogItemsCompanion Function({
  Value<int> id,
  Value<int> mealId,
  Value<String> date,
  Value<String> time,
  Value<String> mealType,
});

final class $$LogItemsTableReferences
    extends BaseReferences<_$AppDatabase, $LogItemsTable, LogItem> {
  $$LogItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals
      .createAlias($_aliasNameGenerator(db.logItems.mealId, db.meals.id));

  $$MealsTableProcessedTableManager? get mealId {
    if ($_item.mealId == null) return null;
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.id($_item.mealId!));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LogItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LogItemsTable> {
  $$LogItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LogItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LogItemsTable> {
  $$LogItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableOrderingComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LogItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogItemsTable> {
  $$LogItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LogItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LogItemsTable,
    LogItem,
    $$LogItemsTableFilterComposer,
    $$LogItemsTableOrderingComposer,
    $$LogItemsTableAnnotationComposer,
    $$LogItemsTableCreateCompanionBuilder,
    $$LogItemsTableUpdateCompanionBuilder,
    (LogItem, $$LogItemsTableReferences),
    LogItem,
    PrefetchHooks Function({bool mealId})> {
  $$LogItemsTableTableManager(_$AppDatabase db, $LogItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String> mealType = const Value.absent(),
          }) =>
              LogItemsCompanion(
            id: id,
            mealId: mealId,
            date: date,
            time: time,
            mealType: mealType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealId,
            required String date,
            required String time,
            required String mealType,
          }) =>
              LogItemsCompanion.insert(
            id: id,
            mealId: mealId,
            date: date,
            time: time,
            mealType: mealType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LogItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mealId = false}) {
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
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable: $$LogItemsTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$LogItemsTableReferences._mealIdTable(db).id,
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

typedef $$LogItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LogItemsTable,
    LogItem,
    $$LogItemsTableFilterComposer,
    $$LogItemsTableOrderingComposer,
    $$LogItemsTableAnnotationComposer,
    $$LogItemsTableCreateCompanionBuilder,
    $$LogItemsTableUpdateCompanionBuilder,
    (LogItem, $$LogItemsTableReferences),
    LogItem,
    PrefetchHooks Function({bool mealId})>;
=======
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
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MealEntriesTableTableManager get mealEntries =>
      $$MealEntriesTableTableManager(_db, _db.mealEntries);
  $$MealCategoryValuesTableTableManager get mealCategoryValues =>
      $$MealCategoryValuesTableTableManager(_db, _db.mealCategoryValues);
  $$LogItemsTableTableManager get logItems =>
      $$LogItemsTableTableManager(_db, _db.logItems);

}
