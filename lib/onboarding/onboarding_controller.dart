import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_controller.dart';
import '../data/meal_type_repository.dart';

/// SharedPreferences key to mark onboarding completion.
const kOnboardingCompleteKey = 'hasCompletedOnboarding';

/// Provides an instance of [OnboardingController].
final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  final mealRepo = ref.watch(mealTypeRepositoryProvider);
  final settings = ref.read(settingsControllerProvider.notifier);
  return OnboardingController(prefs, mealRepo, settings);
});

/// Encapsulates first-run setup logic.
class OnboardingController {
  OnboardingController(this._prefs, this._mealRepo, this._settings);

  final SharedPreferences _prefs;
  final MealTypeRepository _mealRepo;
  final SettingsNotifier _settings;

  // Expose current settings values
  UnitSystem get unitSystem => _settings.state.unitSystem;
  VitaminsMode get vitaminsMode => _settings.state.vitaminsMode;
  ThemeMode get themeMode => _settings.state.themeMode;

  void setUnitSystem(UnitSystem system) => _settings.setUnitSystem(system);
  void setVitaminsMode(VitaminsMode mode) => _settings.setVitaminsMode(mode);
  void setThemeMode(ThemeMode mode) => _settings.setThemeMode(mode);

  Stream<List<MealType>> watchMealTypes() => _mealRepo.watchMealTypes();
  Future<int> addMealType(String name) => _mealRepo.addMealType(name);
  Future<void> renameMealType(int id, String name) => _mealRepo.renameMealType(id, name);
  Future<void> deleteMealType(int id) => _mealRepo.deleteMealType(id);

  Future<void> completeOnboarding() async {
    await _prefs.setBool(kOnboardingCompleteKey, true);
  }
}

