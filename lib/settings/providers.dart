import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/data/providers.dart';
import 'package:food_app/data/database/app_database.dart';

/// Controls the application's visual theme.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

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
