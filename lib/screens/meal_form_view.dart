import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/product_repository.dart';
import '../data/meal_repository.dart';
import '../data/conversion_service.dart';
import '../data/local/app_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealItemInput {
  MealItemInput({
    required this.product,
    required this.amount,
    required this.unitId,
  });
  final ProductWithDetails product;
  double amount;
  int unitId;
}

class CustomEntryInput {
  CustomEntryInput({
    required this.categoryId,
    required this.unitId,
    required this.amount,
  });
  int categoryId;
  int unitId;
  double amount;
}

@immutable
class MealFormState {
  const MealFormState({
    this.name = '',
    this.items = const [],
    this.customEntries = const [],
    this.totals = const {},
  });

  final String name;
  final List<MealItemInput> items;
  final List<CustomEntryInput> customEntries;
  final Map<int, double> totals; // categoryId -> base amount

  MealFormState copyWith({
    String? name,
    List<MealItemInput>? items,
    List<CustomEntryInput>? customEntries,
    Map<int, double>? totals,
  }) {
    return MealFormState(
      name: name ?? this.name,
      items: items ?? this.items,
      customEntries: customEntries ?? this.customEntries,
      totals: totals ?? this.totals,
    );
  }
}

class MealFormController extends StateNotifier<MealFormState> {
  MealFormController(this.ref, this.mealId) : super(const MealFormState()) {
    _load();
  }

  final Ref ref;
  final int? mealId;
  late List<Category> categories;
  late List<Unit> units;

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    categories = await db.select(db.categories).get();
    units = await db.select(db.units).get();
    if (mealId != null) {
      final repo = ref.read(mealRepositoryProvider);
      final meal = await repo.getMealById(mealId!);
      if (meal != null) {
        final items = <MealItemInput>[];
        for (final i in meal.items) {
          final productRepo = ref.read(productRepositoryProvider);
          final p = await productRepo.getProductById(i.productId);
          if (p != null) {
            items.add(MealItemInput(
              product: p,
              amount: i.amountBase,
              unitId: i.originalUnitId ?? p.product.servingUnitId,
            ));
          }
        }
        final custom = meal.customEntries
            .map((e) => CustomEntryInput(
                  categoryId: e.categoryId,
                  unitId: e.originalUnitId ?? units.first.id,
                  amount: e.amountBase,
                ))
            .toList();
        state = state.copyWith(name: meal.meal.name, items: items, customEntries: custom);
        await _recalculateTotals();
      }
    }
  }

  Future<void> setName(String name) async {
    state = state.copyWith(name: name);
  }

  Future<void> addProduct(ProductWithDetails product) async {
    final items = [...state.items, MealItemInput(product: product, amount: 1, unitId: product.product.servingUnitId)];
    state = state.copyWith(items: items);
    await _recalculateTotals();
  }

  Future<void> removeItem(int index) async {
    final items = [...state.items]..removeAt(index);
    state = state.copyWith(items: items);
    await _recalculateTotals();
  }

  Future<void> updateItem(int index, {double? amount, int? unitId}) async {
    final items = [...state.items];
    final item = items[index];
    if (amount != null) item.amount = amount;
    if (unitId != null) item.unitId = unitId;
    state = state.copyWith(items: items);
    await _recalculateTotals();
  }

  Future<void> addCustomEntry() async {
    final custom = [
      ...state.customEntries,
      CustomEntryInput(categoryId: categories.first.id, unitId: units.first.id, amount: 0),
    ];
    state = state.copyWith(customEntries: custom);
    await _recalculateTotals();
  }

  Future<void> updateCustom(int index, {int? categoryId, int? unitId, double? amount}) async {
    final custom = [...state.customEntries];
    final entry = custom[index];
    if (categoryId != null) entry.categoryId = categoryId;
    if (unitId != null) entry.unitId = unitId;
    if (amount != null) entry.amount = amount;
    state = state.copyWith(customEntries: custom);
    await _recalculateTotals();
  }

  Future<void> removeCustom(int index) async {
    final custom = [...state.customEntries]..removeAt(index);
    state = state.copyWith(customEntries: custom);
    await _recalculateTotals();
  }

  Future<void> _recalculateTotals() async {
    final conv = ref.read(conversionServiceProvider);
    final totals = <int, double>{};
    for (final item in state.items) {
      final overrides = item.product.unitOverrides;
      final amountBase = await conv.toBase(
        unitId: item.unitId,
        amount: item.amount,
        overrides: overrides.isEmpty ? null : overrides,
      );
      final multiplier = amountBase / item.product.product.servingAmountBase;
      item.product.categoryValues.forEach((catId, value) {
        totals[catId] = (totals[catId] ?? 0) + value * multiplier;
      });
    }
    for (final entry in state.customEntries) {
      final amountBase = await conv.toBase(unitId: entry.unitId, amount: entry.amount);
      totals[entry.categoryId] = (totals[entry.categoryId] ?? 0) + amountBase;
    }
    state = state.copyWith(totals: totals);
  }

  Future<Meal?> save() async {
    final repo = ref.read(mealRepositoryProvider);
    final items = <MealItem>[];
    final custom = <MealCustomEntry>[];
    for (final item in state.items) {
      final conv = ref.read(conversionServiceProvider);
      final amountBase = await conv.toBase(
        unitId: item.unitId,
        amount: item.amount,
        overrides: item.product.unitOverrides.isEmpty ? null : item.product.unitOverrides,
      );
      items.add(MealItem(
        id: 0,
        mealId: mealId ?? 0,
        productId: item.product.product.id,
        amountBase: amountBase,
        originalUnitId: item.unitId,
      ));
    }
    for (final entry in state.customEntries) {
      final conv = ref.read(conversionServiceProvider);
      final amountBase = await conv.toBase(unitId: entry.unitId, amount: entry.amount);
      custom.add(MealCustomEntry(
        id: 0,
        mealId: mealId ?? 0,
        categoryId: entry.categoryId,
        amountBase: amountBase,
        originalUnitId: entry.unitId,
      ));
    }
    if (mealId == null) {
      final id = await repo.addMeal(name: state.name, items: items, customEntries: custom);
      final meal = await repo.getMealById(id);
      return meal?.meal;
    } else {
      await repo.updateMeal(mealId: mealId!, name: state.name, items: items, customEntries: custom);
      final meal = await repo.getMealById(mealId!);
      return meal?.meal;
    }
  }
}

final _mealIdProvider = Provider<int?>((ref) => null);
final mealFormProvider =
    StateNotifierProvider.autoDispose<MealFormController, MealFormState>((ref) {
  final id = ref.watch(_mealIdProvider);
  return MealFormController(ref, id);
});

class MealFormView extends ConsumerWidget {
  const MealFormView({super.key, this.mealId});
  final int? mealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<MealFormState>(mealFormProvider, (_, __) {});
    return ProviderScope(
      overrides: [_mealIdProvider.overrideWithValue(mealId)],
      child: const _MealFormPage(),
    );
  }
}

class _MealFormPage extends ConsumerWidget {
  const _MealFormPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealFormProvider);
    final controller = ref.read(mealFormProvider.notifier);
    final categories = controller.categories;
    final units = controller.units;
    final mealId = ref.watch(_mealIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(mealId == null
            ? AppLocalizations.of(context)!.newMealTitle
            : AppLocalizations.of(context)!.editMealTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final meal = await controller.save();
              if (meal != null && context.mounted) {
                context.pop(meal);
              }
            },
            icon: const Icon(Icons.save),
            tooltip: AppLocalizations.of(context)!.saveButton,
          )
        ],
      ),
      body: state.items.isEmpty && state.customEntries.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.emptyMealHint))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  initialValue: state.name,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.mealNameLabel),
                  onChanged: controller.setName,
                ),
                const SizedBox(height: 16),
                ...state.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final availableUnits = [item.product.product.servingUnitId, ...item.product.unitOverrides.keys];
                  return ListTile(
                    title: Text(item.product.product.name),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.amount.toString(),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => controller.updateItem(index, amount: double.tryParse(v) ?? 0),
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.qtyLabel),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: item.unitId,
                          onChanged: (u) => controller.updateItem(index, unitId: u),
                          items: availableUnits
                              .map((u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(units.firstWhere((e) => e.id == u).symbol ?? ''),
                                  ))
                              .toList(),
                        ),
                        IconButton(
                          onPressed: () => controller.removeItem(index),
                          icon: const Icon(Icons.delete),
                          tooltip: AppLocalizations.of(context)!.removeTooltip,
                        )
                      ],
                    ),
                  );
                }),
                const Divider(),
                ...state.customEntries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final e = entry.value;
                  final unitOptions = units
                      .where((u) => u.dimension == categories.firstWhere((c) => c.id == e.categoryId).dimension)
                      .toList();
                  return ListTile(
                    title: DropdownButton<int>(
                      value: e.categoryId,
                      onChanged: (v) => controller.updateCustom(index, categoryId: v),
                      items: categories
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nameKey)))
                          .toList(),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: e.amount.toString(),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => controller.updateCustom(index, amount: double.tryParse(v) ?? 0),
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.amountLabel),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: e.unitId,
                          onChanged: (u) => controller.updateCustom(index, unitId: u),
                          items: unitOptions
                              .map((u) => DropdownMenuItem(
                                    value: u.id,
                                    child: Text(u.symbol ?? ''),
                                  ))
                              .toList(),
                        ),
                        IconButton(
                          onPressed: () => controller.removeCustom(index),
                          icon: const Icon(Icons.delete),
                          tooltip: AppLocalizations.of(context)!.removeTooltip,
                        )
                      ],
                    ),
                  );
                }),
                ElevatedButton.icon(
                  onPressed: controller.addCustomEntry,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.addCustomEntry),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.totals.entries.map((e) {
                        final cat = categories.firstWhere((c) => c.id == e.key);
                        final base = e.value;
                        return Text('${cat.nameKey}: ${base.toStringAsFixed(2)}');
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final products = await ref.read(productRepositoryProvider).getProducts();
          final ProductWithDetails? selection = await showModalBottomSheet<ProductWithDetails>(
            context: context,
            builder: (ctx) {
              return ListView(
                children: products
                    .map(
                      (p) => ListTile(
                        title: Text(p.product.name),
                        onTap: () => Navigator.of(ctx).pop(p),
                      ),
                    )
                    .toList(),
              );
            },
          );
          if (selection != null) {
            await controller.addProduct(selection);
          }
        },
        tooltip: AppLocalizations.of(context)!.addProductTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}

