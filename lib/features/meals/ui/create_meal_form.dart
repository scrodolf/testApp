import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_meal_repository.dart';
import 'package:food_app/features/meals/controllers/create_meal_controller.dart';

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

  void _addProduct() {
    setState(() => _products.add(_MealProductInput()));
  }

  void _addCustomValue() {
    setState(() => _customValues.add(_MealCategoryInput()));
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
                    ..._products.map((p) {
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: p.productId,
                              items: products
                                  .map((prod) => DropdownMenuItem(
                                      value: prod.product.id,
                                      child: Text(prod.product.name)))
                                  .toList(),
                              onChanged: (v) => setState(() => p.productId = v),
                              validator: (v) =>
                                  v == null ? 'Select product' : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: p.controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration:
                                  const InputDecoration(labelText: 'Qty'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Qty' : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                setState(() => _products.remove(p)),
                          )
                        ],
                      );
                    }),
                    TextButton.icon(
                        onPressed: _addProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add product')),
                    const SizedBox(height: 16),
                    const Text('Custom categories'),
                    ..._customValues.map((c) {
                      final catUnits = c.categoryId == null
                          ? units
                          : units.where((u) {
                              final category = categories
                                  .firstWhere((e) => e.id == c.categoryId);
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
                              onChanged: (v) =>
                                  setState(() => c.categoryId = v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: c.controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration:
                                  const InputDecoration(labelText: 'Value'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: c.unitId,
                            items: catUnits
                                .map((u) => DropdownMenuItem(
                                    value: u.id, child: Text(u.name)))
                                .toList(),
                            onChanged: (v) => setState(() => c.unitId = v),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                setState(() => _customValues.remove(c)),
                          )
                        ],
                      );
                    }),
                    TextButton.icon(
                        onPressed: _addCustomValue,
                        icon: const Icon(Icons.add),
                        label: const Text('Add category')),
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
