import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/daos/goal_dao.dart';

/// Dialog for creating or editing a nutritional goal.
class GoalEditorDialog extends ConsumerStatefulWidget {
  const GoalEditorDialog({super.key, this.initial});

  final GoalWithDetails? initial;

  @override
  ConsumerState<GoalEditorDialog> createState() => _GoalEditorDialogState();
}

class _GoalEditorDialogState extends ConsumerState<GoalEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _categoryId;
  int? _unitId;
  GoalPeriod _period = GoalPeriod.weekly;
  GoalDisposition _disposition = GoalDisposition.good;
  GoalImpactLevel _impact = GoalImpactLevel.mild;
  String _capValue = '';

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    if (init != null) {
      _categoryId = init.category.id;
      _unitId = init.unit.id;
      _period = init.goal.period;
      _disposition = init.goal.disposition;
      _impact = init.goal.impact;
      _capValue = init.goal.capValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).maybeWhen(
          data: (c) => c,
          orElse: () => [],
        );
    final units = ref.watch(unitsProvider).maybeWhen(
          data: (u) => u,
          orElse: () => [],
        );

    return AlertDialog(
      title: Text(widget.initial == null ? 'Add Goal' : 'Edit Goal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _categoryId,
                items: [
                  for (final c in categories)
                    DropdownMenuItem(value: c.id, child: Text(c.name))
                ],
                onChanged: (v) => setState(() => _categoryId = v),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              DropdownButtonFormField<int>(
                value: _unitId,
                items: [
                  for (final u in units)
                    DropdownMenuItem(value: u.id, child: Text(u.name))
                ],
                onChanged: (v) => setState(() => _unitId = v),
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              TextFormField(
                initialValue: _capValue,
                decoration: const InputDecoration(labelText: 'Cap Value'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _capValue = v,
              ),
              DropdownButtonFormField<GoalPeriod>(
                value: _period,
                items: [
                  for (final p in GoalPeriod.values)
                    DropdownMenuItem(value: p, child: Text(p.name))
                ],
                onChanged: (v) => setState(() => _period = v!),
                decoration: const InputDecoration(labelText: 'Period'),
              ),
              DropdownButtonFormField<GoalDisposition>(
                value: _disposition,
                items: [
                  for (final d in GoalDisposition.values)
                    DropdownMenuItem(value: d, child: Text(d.name))
                ],
                onChanged: (v) => setState(() => _disposition = v!),
                decoration: const InputDecoration(labelText: 'Disposition'),
              ),
              DropdownButtonFormField<GoalImpactLevel>(
                value: _impact,
                items: [
                  for (final i in GoalImpactLevel.values)
                    DropdownMenuItem(value: i, child: Text(i.name))
                ],
                onChanged: (v) => setState(() => _impact = v!),
                decoration: const InputDecoration(labelText: 'Impact Level'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final repo = await ref.read(goalRepositoryProvider.future);
            if (widget.initial == null) {
              await repo.insertGoal(
                categoryId: _categoryId!,
                period: _period,
                capValue: double.tryParse(_capValue) ?? 0,
                unitId: _unitId!,
                disposition: _disposition,
                impact: _impact,
              );
            } else {
              await repo.updateGoal(
                id: widget.initial!.goal.id,
                categoryId: _categoryId!,
                period: _period,
                capValue: double.tryParse(_capValue) ?? 0,
                unitId: _unitId!,
                disposition: _disposition,
                impact: _impact,
              );
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
