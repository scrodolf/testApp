import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/features/logs/controllers/log_meal_controller.dart';

/// Form used to create or edit a meal log entry.
class LogMealForm extends ConsumerStatefulWidget {
  const LogMealForm({super.key, this.logId});

  /// When provided the form edits an existing log.
  final int? logId;

  @override
  ConsumerState<LogMealForm> createState() => _LogMealFormState();
}

class _LogMealFormState extends ConsumerState<LogMealForm> {
  int? _selectedMealId;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _mealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    if (widget.logId != null) {
      ref.read(logDetailsProvider(widget.logId!).future).then((log) {
        if (log != null) {
          setState(() {
            _selectedMealId = log.meal.id;
            _date = DateTime.parse(log.log.date);
            final parts = log.log.time.split(':');
            _time = TimeOfDay(
                hour: int.parse(parts[0]), minute: int.parse(parts[1]));
            _mealType = log.log.mealType;
          });
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    final controller = ref.read(logMealControllerProvider.notifier);
    final dateStr =
        '${_date.year.toString().padLeft(4, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    await controller.saveLog(
      id: widget.logId,
      mealId: _selectedMealId!,
      date: dateStr,
      time: timeStr,
      mealType: _mealType,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mealsAsync = ref.watch(allMealsProvider);
    final state = ref.watch(logMealControllerProvider);
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.logId == null ? 'Log Meal' : 'Edit Log')),
      body: mealsAsync.when(
        data: (meals) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<int>(
                value: _selectedMealId,
                decoration: const InputDecoration(labelText: 'Meal'),
                items: [
                  for (final m in meals)
                    DropdownMenuItem(
                      value: m.meal.id,
                      child: Text(m.meal.name ?? 'Meal ${m.meal.id}'),
                    ),
                ],
                onChanged: (v) => setState(() => _selectedMealId = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Date: ${_date.day.toString().padLeft(2, '0')}-${_date.month.toString().padLeft(2, '0')}-${_date.year}'),
                  ),
                  TextButton(onPressed: _pickDate, child: const Text('Pick')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Time: ${_time.format(context)}')),
                  TextButton(onPressed: _pickTime, child: const Text('Pick')),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _mealType,
                decoration: const InputDecoration(labelText: 'Meal Type'),
                items: const [
                  DropdownMenuItem(
                      value: 'Breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                  DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                ],
                onChanged: (v) => setState(() => _mealType = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    state.isLoading || _selectedMealId == null ? null : _submit,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : Text(widget.logId == null ? 'Log Meal' : 'Save Changes'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
