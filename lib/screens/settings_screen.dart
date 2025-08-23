import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../settings/debug_sample_data.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(AppLocalizations.of(context)!.unitSystemSection),
          Semantics(
            label: AppLocalizations.of(context)!.metricSemantics,
            child: RadioListTile<UnitSystem>(
              title: Text(AppLocalizations.of(context)!.unitMetric),
              subtitle: Text(AppLocalizations.of(context)!.metricUnits),

              value: UnitSystem.metric,
              groupValue: settings.unitSystem,
              onChanged: (v) {
                if (v != null) controller.setUnitSystem(v);
              },
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.imperialSemantics,
            child: RadioListTile<UnitSystem>(
              title: Text(AppLocalizations.of(context)!.unitImperial),
              subtitle: Text(AppLocalizations.of(context)!.imperialUnits),

              value: UnitSystem.imperial,
              groupValue: settings.unitSystem,
              onChanged: (v) {
                if (v != null) controller.setUnitSystem(v);
              },
            ),
          ),
          const Divider(),
          _SectionHeader(AppLocalizations.of(context)!.vitaminsModeSection),
          Semantics(
            label: AppLocalizations.of(context)!.vitaminsBucketSemantics,
            child: RadioListTile<VitaminsMode>(
              title: Text(AppLocalizations.of(context)!.vitaminsBucket),

              value: VitaminsMode.generic,
              groupValue: settings.vitaminsMode,
              onChanged: (v) {
                if (v != null) controller.setVitaminsMode(v);
              },
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.vitaminsSpecificSemantics,
            child: RadioListTile<VitaminsMode>(
              title: Text(AppLocalizations.of(context)!.vitaminsSpecific),

              value: VitaminsMode.specific,
              groupValue: settings.vitaminsMode,
              onChanged: (v) {
                if (v != null) controller.setVitaminsMode(v);
              },
            ),
          ),
          const Divider(),
          _SectionHeader(AppLocalizations.of(context)!.themeSection),
          Semantics(
            label: AppLocalizations.of(context)!.themeSystemSemantics,
            child: RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.themeSystem),

              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (v) {
                if (v != null) controller.setThemeMode(v);
              },
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.themeLightSemantics,
            child: RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.themeLight),

              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (v) {
                if (v != null) controller.setThemeMode(v);
              },
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.themeDarkSemantics,
            child: RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.themeDark),

              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (v) {
                if (v != null) controller.setThemeMode(v);
              },
            ),
          ),
          const Divider(),
          _SectionHeader(AppLocalizations.of(context)!.debugSection),
          Semantics(
            label: AppLocalizations.of(context)!.createSampleDataSemantics,
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.createSampleData),
              onTap: () async {
                await createSampleData(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.sampleDataCreated),
                    ),
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),

    );
  }
}
