import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/repositories/i_product_repository.dart';
import 'package:food_app/features/products/controllers/product_form_controller.dart';

/// Form for creating a new product with nutritional values.
class AddProductForm extends ConsumerStatefulWidget {
  const AddProductForm({super.key});

  @override
  ConsumerState<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends ConsumerState<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _servingSizeCtrl = TextEditingController();
  int? _selectedServingUnitId;

  final Map<int, TextEditingController> _categoryValueCtrls = {};
  final Map<int, int?> _categoryUnitIds = {};

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingSizeCtrl.dispose();
    for (final c in _categoryValueCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(unitsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final formState = ref.watch(productFormControllerProvider);

    return Scaffold(
      body: unitsAsync.when(
        data: (units) => categoriesAsync.when(
          data: (categories) {
            for (final cat in categories) {
              _categoryValueCtrls.putIfAbsent(
                  cat.id, () => TextEditingController());
              _categoryUnitIds.putIfAbsent(
                  cat.id, () => cat.defaultDisplayUnitId);
            }
            _selectedServingUnitId ??= units.first.id;

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
                        .map((u) =>
                            DropdownMenuItem(value: u.id, child: Text(u.name)))
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
                          decoration: const InputDecoration(labelText: 'Value'),
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
                          decoration: const InputDecoration(labelText: 'Unit'),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
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
                            await ref
                                .read(productFormControllerProvider.notifier)
                                .saveProduct(
                                  name: _nameCtrl.text,
                                  defaultServingSize:
                                      double.parse(_servingSizeCtrl.text),
                                  defaultServingUnitId: _selectedServingUnitId!,
                                  categoryValues: categoryInputs,
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
                                      content:
                                          Text('Product added successfully!')),
                                );
                                context.pop();
                              }
                            }
                          },
                    child: formState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
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
    );
  }
}
