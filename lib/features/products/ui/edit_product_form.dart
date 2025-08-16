import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/features/products/controllers/product_form_controller.dart';
import 'package:food_app/data/daos/product_dao.dart';
import 'package:food_app/data/database/app_database.dart';

/// Form for editing an existing product.
class EditProductForm extends ConsumerStatefulWidget {
  const EditProductForm({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends ConsumerState<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _servingSizeCtrl = TextEditingController();
  int? _selectedServingUnitId;
  bool _initialised = false;

  final Map<int, TextEditingController> _categoryValueCtrls = {};
  final Map<int, int?> _categoryUnitIds = {};

  final List<TextEditingController> _overrideCtrls = [];
  final List<int?> _overrideUnitIds = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingSizeCtrl.dispose();
    for (final c in _categoryValueCtrls.values) {
      c.dispose();
    }
    for (final c in _overrideCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _initialise(ProductWithDetails product, List<Unit> units,
      List<Category> categories) async {
    final conversion = await ref.read(conversionServiceProvider.future);
    final registry = await ref.read(unitRegistryProvider.future);
    _nameCtrl.text = product.product.name;
    _servingSizeCtrl.text = product.product.defaultServingSize.toString();
    _selectedServingUnitId = product.defaultUnit.id;

    for (final cat in categories) {
      _categoryValueCtrls.putIfAbsent(cat.id, () => TextEditingController());
      _categoryUnitIds.putIfAbsent(cat.id, () => cat.defaultDisplayUnitId);
    }

    for (final detail in product.values) {
      final unitsForDim =
          await registry.getUnitsByDimension(detail.category.baseDimension);
      final baseUnit = unitsForDim.firstWhere((u) => u.factorToBase == 1,
          orElse: () => unitsForDim.first);
      final original = await conversion.convert(
          detail.value, baseUnit.id, detail.unit.id, customUnitFactors: {
        for (final o in product.unitOverrides) o.unit.id: o.factorToBase
      });
      _categoryValueCtrls[detail.category.id]!.text = original.toString();
      _categoryUnitIds[detail.category.id] = detail.unit.id;
    }

    for (final o in product.unitOverrides) {
      _overrideCtrls
          .add(TextEditingController(text: o.factorToBase.toString()));
      _overrideUnitIds.add(o.unit.id);
    }
    _initialised = true;
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(unitsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final productAsync = ref.watch(productDetailsProvider(widget.productId));
    final formState = ref.watch(productFormControllerProvider);

    return Scaffold(
      body: unitsAsync.when(
        data: (units) => categoriesAsync.when(
          data: (categories) => productAsync.when(
            data: (product) {
              if (product == null) {
                return const Center(child: Text('Product not found'));
              }
              if (!_initialised) {
                _initialise(product, units, categories).then((_) {
                  if (mounted) setState(() {});
                });
                return const Center(child: CircularProgressIndicator());
              }
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Product name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _servingSizeCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Default serving size'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final value = double.tryParse(v);
                        if (value == null || value < 0) return 'Invalid';
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedServingUnitId,
                      decoration: const InputDecoration(
                          labelText: 'Default serving unit'),
                      items: units
                          .map((u) => DropdownMenuItem(
                              value: u.id, child: Text(u.name)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedServingUnitId = v),
                    ),
                    const SizedBox(height: 16),
                    ...categories.map((cat) {
                      final filteredUnits = units
                          .where((u) => u.dimension == cat.baseDimension)
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          TextFormField(
                            controller: _categoryValueCtrls[cat.id],
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Value'),
                          ),
                          DropdownButtonFormField<int>(
                            value: _categoryUnitIds[cat.id],
                            items: filteredUnits
                                .map((u) => DropdownMenuItem(
                                      value: u.id,
                                      child: Text(u.name),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _categoryUnitIds[cat.id] = v),
                            decoration:
                                const InputDecoration(labelText: 'Unit'),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    Text('Unit overrides',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...List.generate(_overrideCtrls.length, (i) {
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _overrideUnitIds[i],
                              items: units
                                  .map((u) => DropdownMenuItem(
                                        value: u.id,
                                        child: Text(u.name),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _overrideUnitIds[i] = v),
                              decoration:
                                  const InputDecoration(labelText: 'Unit'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _overrideCtrls[i],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Factor to base'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                _overrideCtrls.removeAt(i).dispose();
                                _overrideUnitIds.removeAt(i);
                              });
                            },
                          )
                        ],
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _overrideCtrls.add(TextEditingController());
                            _overrideUnitIds.add(null);
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add override'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: formState.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() != true ||
                                  _selectedServingUnitId == null) {
                                return;
                              }
                              final categoryInputs = <CategoryValueInput>[];
                              for (final cat in categories) {
                                final text =
                                    _categoryValueCtrls[cat.id]!.text.trim();
                                if (text.isEmpty) continue;
                                final value = double.tryParse(text);
                                final unitId = _categoryUnitIds[cat.id];
                                if (value == null || unitId == null) continue;
                                categoryInputs.add(CategoryValueInput(
                                    categoryId: cat.id,
                                    value: value,
                                    unitId: unitId));
                              }
                              final overrides = <UnitOverrideInput>[];
                              for (var i = 0; i < _overrideCtrls.length; i++) {
                                final unitId = _overrideUnitIds[i];
                                final text = _overrideCtrls[i].text.trim();
                                if (unitId == null || text.isEmpty) continue;
                                final factor = double.tryParse(text);
                                if (factor == null) continue;
                                overrides.add(UnitOverrideInput(
                                    unitId: unitId, factorToBase: factor));
                              }

                              await ref
                                  .read(productFormControllerProvider.notifier)
                                  .updateProduct(
                                    id: widget.productId,
                                    name: _nameCtrl.text,
                                    defaultServingSize:
                                        double.parse(_servingSizeCtrl.text),
                                    defaultServingUnitId:
                                        _selectedServingUnitId!,
                                    categoryValues: categoryInputs,
                                    unitOverrides: overrides,
                                  );
                              final state =
                                  ref.read(productFormControllerProvider);
                              if (state.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${state.error}')),
                                );
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Product updated successfully!')),
                                  );
                                  context.pop();
                                }
                              }
                            },
                      child: formState.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Save Changes'),
                    ),
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
