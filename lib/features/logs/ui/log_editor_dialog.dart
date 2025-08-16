import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:food_app/data/providers.dart';

/// Dialog for adding or editing a log entry.
class LogEditorDialog extends ConsumerStatefulWidget {
  const LogEditorDialog({super.key, this.existing});

  final Log? existing;

  @override
  ConsumerState<LogEditorDialog> createState() => _LogEditorDialogState();
}

class _LogEditorDialogState extends ConsumerState<LogEditorDialog> {
  late DateTime _date;
  late TimeOfDay _time;
  int? _mealId;
  int? _mealTypeId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final existing = widget.existing;
    _date = existing?.loggedAtLocal ?? now;
    _time = TimeOfDay.fromDateTime(existing?.loggedAtLocal ?? now);
    _mealId = existing?.mealId;
    _mealTypeId = existing?.mealTypeId;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final repo = await ref.read(logRepositoryProvider.future);
    final dt = DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    if (widget.existing == null) {
      await repo.insertLog(
          mealId: _mealId ?? 0,
          loggedAtLocal: dt,
          mealTypeId: _mealTypeId);
    } else {
      await repo.updateLog(
          id: widget.existing!.id,
          mealId: _mealId ?? 0,
          loggedAtLocal: dt,
          mealTypeId: _mealTypeId);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mealTypesAsync = ref.watch(allMealTypesProvider);
    final dateStr = DateFormat('dd-MM-yyyy').format(_date);
    final timeStr = _time.format(context);
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Log' : 'Edit Log'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Meal ID'),
              keyboardType: TextInputType.number,
              onChanged: (v) => _mealId = int.tryParse(v),
              controller: TextEditingController(
                  text: _mealId != null ? _mealId.toString() : ''),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Date: $dateStr')),
                TextButton(onPressed: _pickDate, child: const Text('Change')),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Time: $timeStr')),
                TextButton(onPressed: _pickTime, child: const Text('Change')),
              ],
            ),
            const SizedBox(height: 12),
            mealTypesAsync.when(
              data: (types) {
                return DropdownButtonFormField<int>(
                  value: _mealTypeId,
                  items: [
                    for (final t in types)
                      DropdownMenuItem(value: t.id, child: Text(t.name))
                  ],
                  onChanged: (v) => setState(() => _mealTypeId = v),
                  decoration: const InputDecoration(labelText: 'Meal Type'),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error loading meal types: $e'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
