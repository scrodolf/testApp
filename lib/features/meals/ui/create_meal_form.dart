import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';
import 'package:food_app/features/meals/controllers/create_meal_controller.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/daos/product_dao.dart';
import 'package:food_app/data/daos/meal_dao.dart';

class _MealProductInput {
  _MealProductInput({this.productId, double? quantity})
      : controller = TextEditingController(text: quantity?.toString() ?? '1');

  int? productId;
  final TextEditingController controller;
}

class _MealCategoryInput {
  _MealCategoryInput({this.categoryId, this.unitId, double? value})
      : controller = TextEditingController(text: value?.toString() ?? '');

  int? categoryId;
  int? unitId;
  final TextEditingController controller;
}

/// Form allowing creation of a new meal.
class CreateMealForm extends ConsumerStatefulWidget {
  const CreateMealForm({super.key});

  @override
  ConsumerState<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends ConsumerState<CreateMealForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final List<_MealProductInput> _products = [];
  final List<_MealCategoryInput> _customValues = [];
  Map<Category, double> _totals = {};
  final _productListKey = GlobalKey<AnimatedListState>();
  final _customListKey = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    for (final p in _products) {
      p.controller.dispose();
    }
    for (final c in _customValues) {
      c.controller.dispose();
    }
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addProduct() {
    final input = _MealProductInput();
    input.controller.addListener(_triggerRecalc);
    _products.add(input);
    _productListKey.currentState?.insertItem(_products.length - 1);
    _triggerRecalc();
  }

  void _addCustomValue() {
    final input = _MealCategoryInput();
    input.controller.addListener(_triggerRecalc);
    _customValues.add(input);
    _customListKey.currentState?.insertItem(_customValues.length - 1);
    _triggerRecalc();
  }

  void _triggerRecalc() {
    final productsAsync = ref.read(allProductsProvider);
    final categoriesAsync = ref.read(categoriesProvider);
    final unitsAsync = ref.read(unitsProvider);
    if (productsAsync.hasValue &&
        categoriesAsync.hasValue &&
        unitsAsync.hasValue) {
      _recalculateTotals(
          productsAsync.value!, categoriesAsync.value!, unitsAsync.value!);
    }
  }

  Future<void> _recalculateTotals(List<ProductWithDetails> products,
      List<Category> categories, List<Unit> units) async {
    final svc = await ref.read(mealCalculationServiceProvider.future);
    final entryDetails = <MealEntryDetail>[];
    for (final p in _products) {
      if (p.productId == null) continue;
      final product = products.firstWhere((e) => e.product.id == p.productId);
      final quantity = double.tryParse(p.controller.text) ?? 0;
      entryDetails.add(MealEntryDetail(
          entry: MealEntry(
              id: 0, mealId: 0, productId: product.product.id, quantity: quantity),
          product: product));
    }
    final customDetails = <CategoryValueDetail>[];
    final conversion = await ref.read(conversionServiceProvider.future);
    for (final c in _customValues) {
      if (c.categoryId == null || c.unitId == null) continue;
      final category = categories.firstWhere((e) => e.id == c.categoryId);
      final unit = units.firstWhere((u) => u.id == c.unitId);
      final baseUnit = units
          .where((u) => u.dimension == category.baseDimension)
          .firstWhere((u) => u.factorToBase == 1, orElse: () => units.first);
      final value = double.tryParse(c.controller.text) ?? 0;
      final converted =
          await conversion.convert(value, unit.id, baseUnit.id);
      customDetails.add(
          CategoryValueDetail(category: category, value: converted, unit: unit));
    }
    final meal = MealWithDetails(
        meal: Meal(id: 0, name: '', notes: ''),
        entries: entryDetails,
        customValues: customDetails);
    final totals = await svc.calculateMealTotals(meal);
    setState(() => _totals = totals);
  }

  Widget _buildProductRow(_MealProductInput p) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: p.productId,
            items: ref
                .read(allProductsProvider)
                .value!
                .map((prod) => DropdownMenuItem(
                    value: prod.product.id, child: Text(prod.product.name)))
                .toList(),
            onChanged: (v) => setState(() {
              p.productId = v;
              _triggerRecalc();
            }),
            validator: (v) => v == null ? 'Select product' : null,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            controller: p.controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Qty'),
            validator: (v) => v == null || v.isEmpty ? 'Qty' : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final index = _products.indexOf(p);
            final removed = _products.removeAt(index);
            _productListKey.currentState?.removeItem(
                index,
                (context, animation) => SizeTransition(
                      sizeFactor: animation,
                      child: _buildProductRow(removed),
                    ));
            _triggerRecalc();
          },
        )
      ],
    );
  }

  Widget _buildCustomRow(_MealCategoryInput c, List<Category> categories,
      List<Unit> units) {
    final catUnits = c.categoryId == null
        ? units
        : units.where((u) {
            final category = categories.firstWhere((e) => e.id == c.categoryId);
            return u.dimension == category.baseDimension;
          }).toList();
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: c.categoryId,
            items: categories
                .map((cat) => DropdownMenuItem(
                    value: cat.id, child: Text(cat.name)))
                .toList(),
            onChanged: (v) => setState(() {
              c.categoryId = v;
              _triggerRecalc();
            }),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            controller: c.controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Value'),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: c.unitId,
          items: catUnits
              .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
              .toList(),
          onChanged: (v) => setState(() {
            c.unitId = v;
            _triggerRecalc();
          }),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final index = _customValues.indexOf(c);
            final removed = _customValues.removeAt(index);
            _customListKey.currentState?.removeItem(
                index,
                (context, animation) => SizeTransition(
                      sizeFactor: animation,
                      child: _buildCustomRow(removed, categories, units),
                    ));
            _triggerRecalc();
          },
        )
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final entries = <MealEntryInput>[];
    for (final p in _products) {
      if (p.productId != null) {
        entries.add(MealEntryInput(
            productId: p.productId!,
            quantity: double.parse(p.controller.text)));
      }
    }
    final customValues = <MealCategoryValueInput>[];
    for (final c in _customValues) {
      if (c.categoryId != null &&
          c.unitId != null &&
          c.controller.text.isNotEmpty) {
        customValues.add(MealCategoryValueInput(
            categoryId: c.categoryId!,
            value: double.parse(c.controller.text),
            unitId: c.unitId!));
      }
    }
    final controller = ref.read(createMealControllerProvider.notifier);
    await controller.submit(
        name: _nameController.text,
        notes: _notesController.text,
        entries: entries,
        customValues: customValues);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Meal created')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final unitsAsync = ref.watch(unitsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Meal')),
      body: productsAsync.when(
        data: (products) => categoriesAsync.when(
          data: (categories) => unitsAsync.when(
            data: (units) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Products'),
                    AnimatedList(
                      key: _productListKey,
                      initialItemCount: _products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        final p = _products[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          child: _buildProductRow(p),
                        );
                      },
                    ),
                    TextButton.icon(
                        onPressed: _addProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add product')),
                    const SizedBox(height: 16),
                    const Text('Custom categories'),
                    AnimatedList(
                      key: _customListKey,
                      initialItemCount: _customValues.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        final c = _customValues[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          child: _buildCustomRow(c, categories, units),
                        );
                      },
                    ),
                    TextButton.icon(
                        onPressed: _addCustomValue,
                        icon: const Icon(Icons.add),
                        label: const Text('Add category')),
                    const SizedBox(height: 16),
                    if (_totals.isNotEmpty) ...[
                      const Text('Totals'),
                      ..._totals.entries.map((e) {
                        final unit = units
                            .firstWhere((u) => u.id == e.key.defaultDisplayUnitId);
                        return Text(
                            '${e.key.name}: ${e.value.toStringAsFixed(2)} ${unit.abbreviation}');
                      })
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                        onPressed: _save, child: const Text('Create Meal')),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
