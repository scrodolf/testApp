import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/core/services/text_parsing_service.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/domain/models/chart_config_dto.dart';
import 'package:food_app/domain/models/goal_data_dto.dart';

/// Dialog allowing the user to paste raw text and parse it as product, goal or
/// chart configuration.
class PasteDataDialog extends ConsumerStatefulWidget {
  const PasteDataDialog({super.key});

  @override
  ConsumerState<PasteDataDialog> createState() => _PasteDataDialogState();
}

enum PasteType { goal, chart }

class _PasteDataDialogState extends ConsumerState<PasteDataDialog> {
  final _controller = TextEditingController();
  PasteType _type = PasteType.goal;
  GoalDataDto? _goalPreview;
  ChartConfigDto? _chartPreview;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Paste data'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<PasteType>(
              value: _type,
              onChanged: (v) => setState(() => _type = v!),
              items: const [
                DropdownMenuItem(
                    value: PasteType.goal, child: Text('Goal definition')),
                DropdownMenuItem(
                    value: PasteType.chart, child: Text('Chart request')),
              ],
            ),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Paste text here'),
            ),
            const SizedBox(height: 8),
            if (_goalPreview != null)
              Text(
                  'Parsed goal: ${_goalPreview!.period.name} ${_goalPreview!.capValueInBase} base units'),
            if (_chartPreview != null)
              Text('Parsed chart: ${_chartPreview!.chartType.name} for '
                  '${_chartPreview!.dataType}')
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              final service =
                  await ref.read(textParsingServiceProvider.future);
              if (_type == PasteType.goal) {
                final db = await ref.read(appDatabaseProvider.future);
                final categories = await db.select(db.categories).get();
                final units = await db.select(db.units).get();
                final dto = await service.parseGoalFromText(
                  _controller.text,
                  availableCategories: categories,
                  availableUnits: units,
                );
                setState(() {
                  _goalPreview = dto;
                  _chartPreview = null;
                });
              } else {
                final dto =
                    await service.parseChartConfigFromText(_controller.text);
                setState(() {
                  _chartPreview = dto;
                  _goalPreview = null;
                });
              }
            },
            child: const Text('Preview')),
        TextButton(
            onPressed: () async {
              if (_goalPreview != null) {
                final repo = await ref.read(goalRepositoryProvider.future);
                await repo.insertGoal(
                    categoryId: _goalPreview!.categoryId,
                    period: _goalPreview!.period,
                    capValue: _goalPreview!.capValueInBase,
                    unitId: _goalPreview!.unitId,
                    disposition: _goalPreview!.disposition,
                    impact: _goalPreview!.impact);
                if (context.mounted) Navigator.pop(context, true);
              } else if (_chartPreview != null) {
                Navigator.pop(context, _chartPreview);
              } else {
                Navigator.pop(context, false);
              }
            },
            child: const Text('Apply')),
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
      ],
    );
  }
}
