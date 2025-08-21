import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Unit System'),
          Semantics(
            label: 'Metric unit system',
            child: RadioListTile<UnitSystem>(
              title: const Text('Metric'),
              subtitle: const Text('g, mL, kcal'),
              value: UnitSystem.metric,
              groupValue: settings.unitSystem,
              onChanged: (v) => controller.setUnitSystem(v!),
            ),
          ),
          Semantics(
            label: 'Imperial unit system',
            child: RadioListTile<UnitSystem>(
              title: const Text('Imperial'),
              subtitle: const Text('oz, fl oz, kcal'),
              value: UnitSystem.imperial,
              groupValue: settings.unitSystem,
              onChanged: (v) => controller.setUnitSystem(v!),
            ),
          ),
          const Divider(),
          const _SectionHeader('Vitamins Mode'),
          Semantics(
            label: 'Generic vitamin bucket',
            child: RadioListTile<VitaminsMode>(
              title: const Text('Generic bucket'),
              value: VitaminsMode.generic,
              groupValue: settings.vitaminsMode,
              onChanged: (v) => controller.setVitaminsMode(v!),
            ),
          ),
          Semantics(
            label: 'Specific vitamin list',
            child: RadioListTile<VitaminsMode>(
              title: const Text('Specific list'),
              value: VitaminsMode.specific,
              groupValue: settings.vitaminsMode,
              onChanged: (v) => controller.setVitaminsMode(v!),
            ),
          ),
          const Divider(),
          const _SectionHeader('Theme'),
          Semantics(
            label: 'Use system theme',
            child: RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (v) => controller.setThemeMode(v!),
            ),
          ),
          Semantics(
            label: 'Use light theme',
            child: RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (v) => controller.setThemeMode(v!),
            ),
          ),
          Semantics(
            label: 'Use dark theme',
            child: RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (v) => controller.setThemeMode(v!),
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
