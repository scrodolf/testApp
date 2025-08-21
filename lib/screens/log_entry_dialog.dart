import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/log_repository.dart';

enum _LogTarget { meal, product }

/// Dialog for adding or editing a log entry.
class LogEntryDialog extends ConsumerStatefulWidget {
  const LogEntryDialog({super.key, this.entry, this.initialDate});

  final LogWithDetails? entry;
  final DateTime? initialDate;

  @override
  ConsumerState<LogEntryDialog> createState() => _LogEntryDialogState();
}

class _LogEntryDialogState extends ConsumerState<LogEntryDialog> {
  int? _mealId;
  int? _productId;
  double _quantity = 1;
  late DateTime _date;
  late TimeOfDay _time;
  int? _mealTypeId;
  _LogTarget _target = _LogTarget.meal;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      final e = widget.entry!;
      _mealId = e.log.mealId;
      _productId = e.log.productId;
      _quantity = e.log.quantity;
      _date = e.log.loggedAtLocal;
      _time = TimeOfDay.fromDateTime(e.log.loggedAtLocal);
      _mealTypeId = e.log.mealTypeId;
      _target = e.log.mealId != null ? _LogTarget.meal : _LogTarget.product;
    } else {
      _date = widget.initialDate ?? DateTime.now();
      _time = TimeOfDay.now();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _save() {
    final dt = DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    final repo = ref.read(logRepositoryProvider);
    if (widget.entry == null) {
      repo.addLog(
        mealId: _target == _LogTarget.meal ? _mealId : null,
        productId: _target == _LogTarget.product ? _productId : null,
        quantity: _quantity,
        loggedAtLocal: dt,
        mealTypeId: _mealTypeId!,
      );
    } else {
      repo.updateLog(
        logId: widget.entry!.log.id,
        mealId: _target == _LogTarget.meal ? _mealId : null,
        productId: _target == _LogTarget.product ? _productId : null,
        quantity: _quantity,
        loggedAtLocal: dt,
        mealTypeId: _mealTypeId,
      );
    }
    Navigator.of(context).pop();
  }

  Widget _buildPicker() {
    if (_target == _LogTarget.meal) {
      final meals = ref.watch(mealsProvider);
      return meals.when(
        data: (items) => DropdownButton<int>(
          isExpanded: true,
          value: _mealId,
          hint: Text(AppLocalizations.of(context)!.selectMeal),
          items: items
              .map((m) => DropdownMenuItem(value: m.id, child: Text(m.name)))
              .toList(),
          onChanged: (v) => setState(() => _mealId = v),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('${AppLocalizations.of(context)!.errorPrefix} $e'),
      );
    } else {
      final products = ref.watch(productsProvider);
      return products.when(
        data: (items) => DropdownButton<int>(
          isExpanded: true,
          value: _productId,
          hint: Text(AppLocalizations.of(context)!.selectProduct),
          items: items
              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
              .toList(),
          onChanged: (v) => setState(() => _productId = v),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('${AppLocalizations.of(context)!.errorPrefix} $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealTypes = ref.watch(mealTypesProvider);
    final dateStr = DateFormat('dd.MM.yyyy').format(_date);
    final timeStr =
        DateFormat('HH:mm').format(DateTime(0, 1, 1, _time.hour, _time.minute));
    return AlertDialog(
      title: Text(widget.entry == null
          ? AppLocalizations.of(context)!.logAddTitle
          : AppLocalizations.of(context)!.logEditTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_LogTarget>(
              segments: [
                ButtonSegment(
                    value: _LogTarget.meal,
                    label: Text(AppLocalizations.of(context)!.meal)),
                ButtonSegment(
                    value: _LogTarget.product,
                    label: Text(AppLocalizations.of(context)!.product)),
              ],
              selected: {_target},
              onSelectionChanged: (s) {
                setState(() {
                  _target = s.first;
                  _mealId = null;
                  _productId = null;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPicker(),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.quantityLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: TextEditingController(
                  text: _quantity.toStringAsFixed(2))
                ..selection = TextSelection.fromPosition(
                    TextPosition(offset: _quantity.toString().length)),
              onChanged: (v) => _quantity = double.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(dateStr),
              leading: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(timeStr),
              leading: const Icon(Icons.access_time),
              trailing: TextButton(
                onPressed: () {
                  setState(() => _time = TimeOfDay.now());
                },
                child: Text(AppLocalizations.of(context)!.nowButton),
              ),
              onTap: _pickTime,
            ),
            const SizedBox(height: 12),
            mealTypes.when(
              data: (types) => DropdownButton<int>(
                value: _mealTypeId,
                hint: Text(AppLocalizations.of(context)!.mealType),
                isExpanded: true,
                items: types
                    .map((t) =>
                        DropdownMenuItem(value: t.id, child: Text(t.nameKey)))
                    .toList(),
                onChanged: (v) => setState(() => _mealTypeId = v),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('${AppLocalizations.of(context)!.errorPrefix} $e'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
        TextButton(
          onPressed: (_mealTypeId != null &&
                  ((_target == _LogTarget.meal && _mealId != null) ||
                      (_target == _LogTarget.product && _productId != null)))
              ? _save
              : null,
          child: Text(AppLocalizations.of(context)!.saveButton),
        ),
      ],
    );
  }
}

