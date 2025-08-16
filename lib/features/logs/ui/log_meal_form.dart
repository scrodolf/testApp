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
  DateTime _loggedAt = DateTime.now();
  int? _mealTypeId;

  @override
  void initState() {
    super.initState();
    if (widget.logId != null) {
      ref.read(logDetailsProvider(widget.logId!).future).then((log) {
        if (log != null) {
          setState(() {
            _selectedMealId = log.meal.id;
            _loggedAt = log.log.loggedAtLocal;
            _mealTypeId = log.mealType.id;
          });
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _loggedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(_loggedAt);
      setState(() => _loggedAt =
          DateTime(picked.year, picked.month, picked.day, time.hour, time.minute));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_loggedAt),
    );
    if (picked != null) {
      setState(() => _loggedAt = DateTime(_loggedAt.year, _loggedAt.month,
          _loggedAt.day, picked.hour, picked.minute));
    }
  }

  Future<void> _submit() async {
    final controller = ref.read(logMealControllerProvider.notifier);
    await controller.saveLog(
      id: widget.logId,
      mealId: _selectedMealId!,
      loggedAtLocal: _loggedAt,
      mealTypeId: _mealTypeId!,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mealsAsync = ref.watch(allMealsProvider);
    final mealTypesAsync = ref.watch(allMealTypesProvider);
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
                        'Date: ${_loggedAt.day.toString().padLeft(2, '0')}-${_loggedAt.month.toString().padLeft(2, '0')}-${_loggedAt.year}'),
                  ),
                  TextButton(onPressed: _pickDate, child: const Text('Pick')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                          'Time: ${_loggedAt.hour.toString().padLeft(2, '0')}:${_loggedAt.minute.toString().padLeft(2, '0')}')),
                  TextButton(onPressed: _pickTime, child: const Text('Pick')),
                ],
              ),
              const SizedBox(height: 16),
              mealTypesAsync.when(
                data: (types) {
                  if (_mealTypeId == null && types.isNotEmpty) {
                    _mealTypeId = types.first.id;
                  }
                  return DropdownButtonFormField<int>(
                    value: _mealTypeId,
                    decoration: const InputDecoration(labelText: 'Meal Type'),
                    items: [
                      for (final t in types)
                        DropdownMenuItem(value: t.id, child: Text(t.name)),
                    ],
                    onChanged: (v) => setState(() => _mealTypeId = v),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Error: $e'),
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
