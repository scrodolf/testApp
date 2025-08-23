import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../settings/settings_controller.dart';
import '../data/meal_type_repository.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  void _next() => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  void _back() => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider).completeOnboarding();
    if (mounted) {
      context.go('/logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(strings.onboardingTitle)),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _index = i),
        children: const [
          _UnitSystemStep(),
          _VitaminsStep(),
          _MealTypesStep(),
          _ThemeStep(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (_index > 0)
              TextButton(onPressed: _back, child: Text(strings.backButton)),
            const Spacer(),
            ElevatedButton(
              onPressed: _index == 3 ? _finish : _next,
              child: Text(_index == 3 ? strings.finishButton : strings.nextButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitSystemStep extends ConsumerWidget {
  const _UnitSystemStep();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final controller = ref.read(onboardingControllerProvider);
    final current = ref.watch(settingsControllerProvider).unitSystem;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RadioListTile<UnitSystem>(
          title: Text(strings.unitMetric),
          value: UnitSystem.metric,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setUnitSystem(v);
          },
        ),
        RadioListTile<UnitSystem>(
          title: Text(strings.unitImperial),
          value: UnitSystem.imperial,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setUnitSystem(v);
          },
        ),
      ],
    );
  }
}

class _VitaminsStep extends ConsumerWidget {
  const _VitaminsStep();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final controller = ref.read(onboardingControllerProvider);
    final current = ref.watch(settingsControllerProvider).vitaminsMode;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RadioListTile<VitaminsMode>(
          title: Text(strings.vitaminsBucket),
          value: VitaminsMode.generic,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setVitaminsMode(v);
          },
        ),
        RadioListTile<VitaminsMode>(
          title: Text(strings.vitaminsSpecific),
          value: VitaminsMode.specific,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setVitaminsMode(v);
          },
        ),
      ],
    );
  }
}

class _MealTypesStep extends ConsumerWidget {
  const _MealTypesStep();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final typesAsync = ref.watch(mealTypesProvider);
    final controller = ref.read(onboardingControllerProvider);
    return typesAsync.when(
      data: (types) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final t = types[index];
                  return ListTile(
                    title: Text(t.nameKey),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final name = await _showNameDialog(context, strings.editMealType, t.nameKey);
                            if (name != null) {
                              await controller.renameMealType(t.id, name);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteMealType(t.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(strings.addMealType),
                onPressed: () async {
                  final name = await _showNameDialog(context, strings.addMealType, '');
                  if (name != null) {
                    await controller.addMealType(name);
                  }
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${strings.errorPrefix} $e')),
    );
  }
}

Future<String?> _showNameDialog(BuildContext context, String title, String initial) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) {
      final strings = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(strings.cancelButton)),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text(strings.okButton)),
        ],
      );
    },
  );
}

class _ThemeStep extends ConsumerWidget {
  const _ThemeStep();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final controller = ref.read(onboardingControllerProvider);
    final current = ref.watch(settingsControllerProvider).themeMode;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RadioListTile<ThemeMode>(
          title: Text(strings.themeSystem),
          value: ThemeMode.system,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setThemeMode(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(strings.themeLight),
          value: ThemeMode.light,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setThemeMode(v);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(strings.themeDark),
          value: ThemeMode.dark,
          groupValue: current,
          onChanged: (v) {
            if (v != null) controller.setThemeMode(v);
          },
        ),
      ],
    );
  }
}

