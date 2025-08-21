import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/product_repository.dart';
import '../widgets/button_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


double _roundTo(double value, int places) {
  final mod = math.pow(10.0, places);
  return (value * mod).round() / mod;
}

String _format(double value) => _roundTo(value, 2).toStringAsFixed(2);

/// Providers supplying units and categories for the form.
final unitsProvider = FutureProvider<List<Unit>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.units).get();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.categories).get();
});

/// A form used to create or edit a product.
class ProductFormView extends ConsumerStatefulWidget {
  const ProductFormView({super.key, this.productId});

  final int? productId;

  @override
  ConsumerState<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends ConsumerState<ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _servingCtrl = TextEditingController();
  final Map<int, TextEditingController> _categoryCtrls = {};
  final List<_OverrideEntry> _overrides = [];
  int? _selectedUnitId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final units = await ref.read(unitsProvider.future);
    final categories = await ref.read(categoriesProvider.future);
    if (widget.productId != null) {
      final repo = ref.read(productRepositoryProvider);
      final product = await repo.getProductById(widget.productId!);
      if (product != null) {
        _nameCtrl.text = product.product.name;
        _servingCtrl.text = _format(product.product.servingAmountBase);
        _selectedUnitId = product.product.servingUnitId;
        for (final cat in categories) {
          final val = product.categoryValues[cat.id];
          _categoryCtrls[cat.id] = TextEditingController(
            text: val != null ? _format(val) : '',
          );
        }
        for (final entry in product.unitOverrides.entries) {
          _overrides.add(
            _OverrideEntry(
              unitId: entry.key,
              controller: TextEditingController(text: _format(entry.value)),
            ),
          );
        }
      }
    } else {
      for (final cat in categories) {
        _categoryCtrls[cat.id] = TextEditingController();
      }
    }
    _selectedUnitId ??= units.first.id;
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingCtrl.dispose();
    for (final c in _categoryCtrls.values) {
      c.dispose();
    }
    for (final o in _overrides) {
      o.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(productRepositoryProvider);
    final name = _nameCtrl.text.trim();
    final serving = double.tryParse(_servingCtrl.text) ?? 0;
    final unitId = _selectedUnitId!;

    final catValues = <int, double>{};
    _categoryCtrls.forEach((key, ctrl) {
      final val = double.tryParse(ctrl.text);
      if (val != null && val >= 0) {
        catValues[key] = val;
      }
    });

    final overrideMap = <int, double>{};
    for (final o in _overrides) {
      if (o.unitId != null) {
        final v = double.tryParse(o.controller.text);
        if (v != null && v >= 0) {
          overrideMap[o.unitId!] = v;
        }
      }
    }

    try {
      if (widget.productId == null) {
        await repo.addProduct(
          name: name,
          defaultServingSize: serving,
          defaultUnitId: unitId,
          categoryValues: catValues,
          unitOverrides: overrideMap.isEmpty ? null : overrideMap,
        );
        final products = await repo.getProducts();
        final created = products.firstWhere((p) => p.product.name == name);
        if (mounted) Navigator.pop(context, created);
      } else {
        await repo.updateProduct(
          productId: widget.productId!,
          name: name,
          defaultServingSize: serving,
          defaultUnitId: unitId,
          categoryValues: catValues,
          unitOverrides: overrideMap,
        );
        final updated = await repo.getProductById(widget.productId!);
        if (mounted) Navigator.pop(context, updated);
      }
    } on ProductValidationException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(unitsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    if (_loading || unitsAsync.isLoading || categoriesAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final units = unitsAsync.value!;
    final categories = categoriesAsync.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null
            ? AppLocalizations.of(context)!.addProductTitle
            : AppLocalizations.of(context)!.editProductTitle),

      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.productNameLabel),
              textInputAction: TextInputAction.next,
              validator: (v) => v == null || v.trim().isEmpty
                  ? AppLocalizations.of(context)!.requiredField
                  : null,

            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _servingCtrl,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.servingSizeLabel),

                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      final d = double.tryParse(v ?? '');
                      if (d == null || d < 0) return AppLocalizations.of(context)!.enterNonNegative;

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedUnitId,
                    items: [
                      for (final u in units)
                        DropdownMenuItem(value: u.id, child: Text(u.symbol ?? u.name)),
                    ],
                    onChanged: (v) => setState(() => _selectedUnitId = v),
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.unitLabel),

                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.nutritionalValues,

                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final cat in categories)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _categoryCtrls[cat.id],
                        decoration: InputDecoration(labelText: cat.nameKey),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final d = double.tryParse(v);
                          if (d == null || d < 0) return AppLocalizations.of(context)!.nonNegative;

                          return null;
                        },
                      ),
                    ),
                    if (cat.dimension == 'mass')
                      MiniConverterButton(
                        from: units.firstWhere((u) => u.symbol == 'oz'),
                        to: units.firstWhere((u) => u.symbol == 'g'),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.unitOverrides,

                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() => _overrides.add(_OverrideEntry()));
                  },
                  icon: const Icon(Icons.add),
                  tooltip: AppLocalizations.of(context)!.addOverrideTooltip,

                ),
              ],
            ),
            for (int i = 0; i < _overrides.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _overrides[i].unitId,
                        items: [
                          for (final u in units)
                            DropdownMenuItem(
                                value: u.id, child: Text(u.symbol ?? u.name)),
                        ],
                        onChanged: (v) => setState(() => _overrides[i].unitId = v),
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.unitLabel),

                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _overrides[i].controller,
                        decoration:
                            InputDecoration(labelText: AppLocalizations.of(context)!.toBaseLabel),

                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) {
                          final d = double.tryParse(v ?? '');
                          if (d == null || d < 0) return AppLocalizations.of(context)!.nonNegative;

                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          final removed = _overrides.removeAt(i);
                          removed.controller.dispose();
                        });
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: AppLocalizations.of(context)!.removeTooltip,
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),

                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancelButton),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  style: AppButtonStyles.primary(context),
                  onPressed: _save,
                  child: Text(AppLocalizations.of(context)!.saveButton),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _OverrideEntry {
  _OverrideEntry({this.unitId, TextEditingController? controller})
      : controller = controller ?? TextEditingController();

  int? unitId;
  final TextEditingController controller;
}

class MiniConverterButton extends StatelessWidget {
  const MiniConverterButton({super.key, required this.from, required this.to});

  final Unit from;
  final Unit to;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _MiniConverterDialog(from: from, to: to),
        );
      },
      icon: const Icon(Icons.swap_horiz),
      tooltip: AppLocalizations.of(context)!
          .convertUnits(from.symbol ?? from.name, to.symbol ?? to.name),

    );
  }
}

class _MiniConverterDialog extends StatefulWidget {
  const _MiniConverterDialog({required this.from, required this.to});

  final Unit from;
  final Unit to;

  @override
  State<_MiniConverterDialog> createState() => _MiniConverterDialogState();
}

class _MiniConverterDialogState extends State<_MiniConverterDialog> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;

  @override
  void initState() {
    super.initState();
    _fromCtrl = TextEditingController();
    _toCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _convertFrom(String text) {
    final value = double.tryParse(text);
    if (value == null) {
      _toCtrl.text = '';
      return;
    }
    final base = value * widget.from.factorToBase;
    final toVal = base / widget.to.factorToBase;
    _toCtrl.text = _format(toVal);
  }

  void _convertTo(String text) {
    final value = double.tryParse(text);
    if (value == null) {
      _fromCtrl.text = '';
      return;
    }
    final base = value * widget.to.factorToBase;
    final fromVal = base / widget.from.factorToBase;
    _fromCtrl.text = _format(fromVal);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          '${widget.from.symbol ?? widget.from.name} ↔ ${widget.to.symbol ?? widget.to.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _fromCtrl,
            decoration:
                InputDecoration(labelText: widget.from.symbol ?? widget.from.name),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            onChanged: _convertFrom,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _toCtrl,
            decoration:
                InputDecoration(labelText: widget.to.symbol ?? widget.to.name),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            onChanged: _convertTo,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.closeButton),

        )
      ],
    );
  }
}

