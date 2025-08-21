import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/local/app_database.dart';
import '../data/goal_repository.dart';
import '../widgets/button_styles.dart';
import '../data/conversion_service.dart';

final _unitsProvider = FutureProvider<List<Unit>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.units).get();
});

final _categoriesProvider = FutureProvider<List<Category>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.categories).get();
});

class GoalEditorDialog extends ConsumerStatefulWidget {
  const GoalEditorDialog({super.key, this.goal});
  final GoalWithDetails? goal;

  @override
  ConsumerState<GoalEditorDialog> createState() => _GoalEditorDialogState();
}

class _GoalEditorDialogState extends ConsumerState<GoalEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _categoryId;
  int? _unitId;
  GoalPeriod _period = GoalPeriod.week;
  final _capCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      final g = widget.goal!;
      _categoryId = g.goal.categoryId;
      _unitId = g.goal.originalUnitId;
      _period = g.goal.period;
      _capCtrl.text = g.capValue.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(_unitsProvider);
    final catsAsync = ref.watch(_categoriesProvider);
    return AlertDialog(
      title: Text(widget.goal == null
          ? AppLocalizations.of(context)!.addGoal
          : AppLocalizations.of(context)!.editGoal),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            catsAsync.when(
              data: (cats) => DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.categoryLabel),
                items: cats
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nameKey)))
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v),
                validator: (v) => v == null
                    ? AppLocalizations.of(context)!.fieldRequired
                    : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) =>
                  Text('${AppLocalizations.of(context)!.errorPrefix} $e'),
            ),
            const SizedBox(height: 8),
            unitsAsync.when(
              data: (units) => DropdownButtonFormField<int>(
                value: _unitId,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.unitLabel),
                items: units
                    .map((u) => DropdownMenuItem(value: u.id, child: Text(u.symbol ?? u.name)))
                    .toList(),
                onChanged: (v) => setState(() => _unitId = v),
                validator: (v) => v == null
                    ? AppLocalizations.of(context)!.fieldRequired
                    : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) =>
                  Text('${AppLocalizations.of(context)!.errorPrefix} $e'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _capCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.capLabel),
              validator: (v) {
                final val = double.tryParse(v ?? '');
                if (val == null || val < 0) {
                  return AppLocalizations.of(context)!.invalidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                RadioListTile<GoalPeriod>(
                  title: Text(AppLocalizations.of(context)!.weekly),
                  value: GoalPeriod.week,
                  groupValue: _period,
                  onChanged: (v) => setState(() => _period = v!),
                ),
                RadioListTile<GoalPeriod>(
                  title: Text(AppLocalizations.of(context)!.monthly),
                  value: GoalPeriod.month,
                  groupValue: _period,
                  onChanged: (v) => setState(() => _period = v!),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
        FilledButton(
          style: AppButtonStyles.primary(context),
          onPressed: _save,
          child: Text(AppLocalizations.of(context)!.saveButton),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(goalRepositoryProvider);
    final conv = ref.read(conversionServiceProvider);
    final cap = double.parse(_capCtrl.text);
    final amountBase =
        await conv.toBase(unitId: _unitId!, amount: cap);
    if (widget.goal == null) {
      await repo.addGoal(
        categoryId: _categoryId!,
        period: _period,
        amountBase: amountBase,
        originalUnitId: _unitId!,
      );
    } else {
      await repo.updateGoal(
        goalId: widget.goal!.goal.id,
        categoryId: _categoryId,
        period: _period,
        amountBase: amountBase,
        originalUnitId: _unitId,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }
}

