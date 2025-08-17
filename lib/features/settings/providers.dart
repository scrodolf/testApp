import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/core/unit_system.dart';
=======

/// Exposes a singleton [SharedPreferences] instance.
final sharedPrefsProvider =
    FutureProvider<SharedPreferences>((ref) async => SharedPreferences.getInstance());

/// Controls the application's visual theme, persisted via [SharedPreferences].
final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  late SharedPreferences _prefs;

  @override
  Future<ThemeMode> build() async {
    _prefs = await ref.watch(sharedPrefsProvider.future);
    final saved = _prefs.getString('themeMode');
    return ThemeMode.values
        .firstWhere((m) => m.name == saved, orElse: () => ThemeMode.system);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await _prefs.setString('themeMode', mode.name);
  }
}

/// Preferred measurement system (metric or imperial).
final unitSystemProvider =
    AsyncNotifierProvider<UnitSystemNotifier, UnitSystem>(UnitSystemNotifier.new);

class UnitSystemNotifier extends AsyncNotifier<UnitSystem> {
  late SharedPreferences _prefs;

  @override
  Future<UnitSystem> build() async {
    _prefs = await ref.watch(sharedPrefsProvider.future);
    final saved = _prefs.getString('unitSystem');
    return UnitSystem.values
        .firstWhere((u) => u.name == saved, orElse: () => UnitSystem.metric);
  }

  Future<void> setSystem(UnitSystem system) async {
    state = AsyncData(system);
    await _prefs.setString('unitSystem', system.name);
  }
}

=======
/// Toggle for detailed vitamin tracking; stored in [SharedPreferences].
final vitaminsModeProvider = AsyncNotifierProvider<VitaminsModeNotifier, bool>(
    VitaminsModeNotifier.new);

class VitaminsModeNotifier extends AsyncNotifier<bool> {
  late SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await ref.watch(sharedPrefsProvider.future);
    return _prefs.getBool('vitaminsSpecific') ?? false;
  }

  Future<void> setEnabled(bool value) async {
    state = AsyncData(value);
    await _prefs.setBool('vitaminsSpecific', value);
  }
}

/// Watches all user defined measurement units.
final customUnitsProvider = StreamProvider<List<Unit>>((ref) async* {
  final db = await ref.watch(appDatabaseProvider.future);
  yield* (db.select(db.units)..where((u) => u.isCustom.equals(true))).watch();
});

/// Stream of meal types for settings management.
final editableMealTypesProvider = StreamProvider<List<MealType>>((ref) async* {
  final repo = await ref.watch(mealTypeRepositoryProvider.future);
  yield* repo.watchMealTypes();
});
