import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/unit_registry/unit_registry_interface.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/providers.dart';
import 'providers.dart';

/// Screen allowing users to create, edit and delete custom measurement units.
class CustomUnitsScreen extends ConsumerWidget {
  const CustomUnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(customUnitsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Units')),
      body: unitsAsync.when(
        data: (units) {
          if (units.isEmpty) {
            return const Center(child: Text('No custom units yet'));
          }
          return ListView.builder(
            itemCount: units.length,
            itemBuilder: (context, i) {
              final u = units[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text('${u.symbol ?? ''} = ${u.factorToBase} base'),
                onTap: () => _showEditor(context, ref, unit: u),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUnit(context, ref, u),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteUnit(BuildContext context, WidgetRef ref, Unit unit) async {
    final registry = await ref.read(unitRegistryProvider.future) as IUnitRegistry;
    await registry.deleteUnit(unit.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted ${unit.name}')),
    );
  }

  Future<void> _showEditor(BuildContext context, WidgetRef ref,
      {Unit? unit}) async {
    final nameCtrl = TextEditingController(text: unit?.name);
    final symbolCtrl = TextEditingController(text: unit?.symbol);
    final factorCtrl = TextEditingController(
        text: unit != null ? unit.factorToBase.toString() : '1');
    final dimension = ValueNotifier<String>(unit?.dimension ?? 'mass');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(unit == null ? 'Add Unit' : 'Edit Unit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: symbolCtrl,
                decoration: const InputDecoration(labelText: 'Symbol'),
              ),
              TextField(
                controller: factorCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Factor to base'),
              ),
              ValueListenableBuilder<String>(
                valueListenable: dimension,
                builder: (context, value, _) => DropdownButton<String>(
                  value: value,
                  items: const [
                    DropdownMenuItem(value: 'mass', child: Text('Mass')),
                    DropdownMenuItem(value: 'volume', child: Text('Volume')),
                    DropdownMenuItem(value: 'energy', child: Text('Energy')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (v) => dimension.value = v!,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final registry = await ref.read(unitRegistryProvider.future);
      final factor = double.tryParse(factorCtrl.text) ?? 1.0;
      final companion = UnitsCompanion(
        name: Value(nameCtrl.text),
        symbol: Value(symbolCtrl.text),
        dimension: Value(dimension.value),
        factorToBase: Value(factor),
        isCustom: const Value(true),
      );
      if (unit == null) {
        await registry.addUnit(companion);
      } else {
        await registry.deleteUnit(unit.id);
        await registry.addUnit(companion);
      }
    }
  }
}
