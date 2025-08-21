import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used in [SharedPreferences] for persisting settings.
const _kUnitSystemKey = 'unitSystem';
const _kVitaminsModeKey = 'vitaminsMode';
const _kThemeModeKey = 'themeMode';

/// Represents the unit system used throughout the UI.
enum UnitSystem { metric, imperial }

/// Represents how vitamin information is displayed.
enum VitaminsMode { generic, specific }

/// Bundles all configurable settings.
@immutable
class SettingsState {
  const SettingsState({
    required this.unitSystem,
    required this.vitaminsMode,
    required this.themeMode,
  });

  final UnitSystem unitSystem;
  final VitaminsMode vitaminsMode;
  final ThemeMode themeMode;

  SettingsState copyWith({
    UnitSystem? unitSystem,
    VitaminsMode? vitaminsMode,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      unitSystem: unitSystem ?? this.unitSystem,
      vitaminsMode: vitaminsMode ?? this.vitaminsMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Provides access to the shared preferences instance.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

/// Manages [SettingsState] and persists changes to [SharedPreferences].
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._prefs)
      : super(
          SettingsState(
            unitSystem:
                UnitSystem.values[_prefs.getInt(_kUnitSystemKey) ?? UnitSystem.metric.index],
            vitaminsMode:
                VitaminsMode.values[_prefs.getInt(_kVitaminsModeKey) ?? VitaminsMode.generic.index],
            themeMode:
                ThemeMode.values[_prefs.getInt(_kThemeModeKey) ?? ThemeMode.system.index],
          ),
        );

  final SharedPreferences _prefs;

  void setUnitSystem(UnitSystem system) {
    if (system == state.unitSystem) return;
    state = state.copyWith(unitSystem: system);
    _prefs.setInt(_kUnitSystemKey, system.index);
  }

  void setVitaminsMode(VitaminsMode mode) {
    if (mode == state.vitaminsMode) return;
    state = state.copyWith(vitaminsMode: mode);
    _prefs.setInt(_kVitaminsModeKey, mode.index);
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == state.themeMode) return;
    state = state.copyWith(themeMode: mode);
    _prefs.setInt(_kThemeModeKey, mode.index);
  }
}

/// Exposes the [SettingsNotifier] to the widget tree.
final settingsControllerProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SettingsNotifier(prefs);
});
