import React, { useEffect, useState } from 'react';
import { View, Text, Pressable, TextInput, FlatList, StyleSheet } from 'react-native';
import { useDispatch } from 'react-redux';
import { useNavigation } from '@react-navigation/native';
import {
  setUnitSystem,
  setVitaminsMode,
  setThemeMode,
  setOnboardingComplete,
} from '../store/preferencesSlice';
import PreferencesManager, {
  UnitSystem,
  VitaminsMode,
  ThemeMode,
} from '../services/preferences/PreferencesManager';
import { useServices } from '../services/ServiceContext';
import { MealType } from '../services/repositories/types';

const OptionButton: React.FC<{
  label: string;
  selected: boolean;
  onPress: () => void;
}> = ({ label, selected, onPress }) => (
  <Pressable
    accessibilityRole="button"
    accessibilityState={{ selected }}
    onPress={onPress}
    style={[styles.optionButton, selected && styles.optionButtonSelected]}
  >
    <Text style={styles.optionButtonText}>{label}</Text>
  </Pressable>
);

const OnboardingScreen: React.FC = () => {
  const dispatch = useDispatch();
  const navigation = useNavigation();
  const { mealTypeRepository } = useServices();

  const [step, setStep] = useState(0);

  // selections
  const [unitSystem, setUnit] = useState<UnitSystem>('metric');
  const [vitaminsMode, setVitamins] = useState<VitaminsMode>('bucket');
  const [themeMode, setTheme] = useState<ThemeMode>('system');

  // meal types
  const [mealTypes, setMealTypes] = useState<MealType[]>([]);
  const [initialMealTypes, setInitialMealTypes] = useState<MealType[]>([]);

  useEffect(() => {
    (async () => {
      // Load existing preferences and meal types
      const prefs = await PreferencesManager.getAll();
      setUnit(prefs.unitSystem);
      setVitamins(prefs.vitaminsMode);
      setTheme(prefs.themeMode);
      const types = await mealTypeRepository.getAll();
      setMealTypes(types);
      setInitialMealTypes(types);
    })();
  }, [mealTypeRepository]);

  const saveMealTypes = async () => {
    const existingIds = new Set(initialMealTypes.map((m) => m.id));
    const currentIds = new Set(mealTypes.filter((m) => m.id).map((m) => m.id as number));

    // deletes
    for (const mt of initialMealTypes) {
      if (!currentIds.has(mt.id)) {
        await mealTypeRepository.delete(mt.id);
      }
    }

    // updates & creates
    for (let i = 0; i < mealTypes.length; i++) {
      const mt = mealTypes[i];
      const data = { ...mt, sortOrder: i } as MealType;
      if (mt.id && existingIds.has(mt.id)) {
        await mealTypeRepository.update({ ...data, isBuiltin: mt.isBuiltin });
      } else {
        await mealTypeRepository.create({ nameKey: mt.nameKey, sortOrder: i });
      }
    }
  };

  const next = async () => {
    if (step === 0) {
      dispatch(setUnitSystem(unitSystem));
      await PreferencesManager.setUnitSystem(unitSystem);
    } else if (step === 1) {
      dispatch(setVitaminsMode(vitaminsMode));
      await PreferencesManager.setVitaminsMode(vitaminsMode);
    } else if (step === 2) {
      await saveMealTypes();
    }

    if (step < 3) {
      setStep(step + 1);
    } else {
      dispatch(setThemeMode(themeMode));
      await PreferencesManager.setThemeMode(themeMode);
      await PreferencesManager.setOnboardingComplete(true);
      dispatch(setOnboardingComplete(true));
      navigation.reset({ index: 0, routes: [{ name: 'Logs' as never }] });
    }
  };

  const back = () => {
    if (step > 0) setStep(step - 1);
  };

  const addMealType = () => {
    setMealTypes([...mealTypes, { id: undefined as any, nameKey: '', sortOrder: mealTypes.length, isBuiltin: false }]);
  };

  const removeMealType = (index: number) => {
    setMealTypes(mealTypes.filter((_, i) => i !== index));
  };

  const renderStep = () => {
    switch (step) {
      case 0:
        return (
          <View>
            <Text style={styles.header}>Choose unit system</Text>
            <View style={styles.row}>
              <OptionButton label="Metric" selected={unitSystem === 'metric'} onPress={() => setUnit('metric')} />
              <OptionButton label="Imperial" selected={unitSystem === 'imperial'} onPress={() => setUnit('imperial')} />
            </View>
          </View>
        );
      case 1:
        return (
          <View>
            <Text style={styles.header}>Vitamins mode</Text>
            <View style={styles.row}>
              <OptionButton label="Generic bucket" selected={vitaminsMode === 'bucket'} onPress={() => setVitamins('bucket')} />
              <OptionButton label="Specific list" selected={vitaminsMode === 'specific'} onPress={() => setVitamins('specific')} />
            </View>
          </View>
        );
      case 2:
        return (
          <View>
            <Text style={styles.header}>Meal types</Text>
            <FlatList
              data={mealTypes}
              keyExtractor={(item, index) => String(item.id ?? `new-${index}`)}
              renderItem={({ item, index }) => (
                <View style={styles.listItem}>
                  <TextInput
                    style={styles.listInput}
                    value={item.nameKey}
                    onChangeText={(text) => {
                      const arr = [...mealTypes];
                      arr[index] = { ...arr[index], nameKey: text };
                      setMealTypes(arr);
                    }}
                    accessibilityLabel={`Meal type ${index + 1}`}
                  />
                  <Pressable accessibilityLabel={`Delete ${item.nameKey}`} onPress={() => removeMealType(index)} style={styles.deleteButton}>
                    <Text style={styles.deleteText}>Delete</Text>
                  </Pressable>
                </View>
              )}
            />
            <Pressable onPress={addMealType} accessibilityRole="button" style={styles.addButton}>
              <Text style={styles.addButtonText}>Add meal type</Text>
            </Pressable>
          </View>
        );
      case 3:
        return (
          <View>
            <Text style={styles.header}>Theme</Text>
            <View style={styles.row}>
              <OptionButton label="Light" selected={themeMode === 'light'} onPress={() => setTheme('light')} />
              <OptionButton label="Dark" selected={themeMode === 'dark'} onPress={() => setTheme('dark')} />
              <OptionButton label="System" selected={themeMode === 'system'} onPress={() => setTheme('system')} />
            </View>
          </View>
        );
      default:
        return null;
    }
  };

  return (
    <View style={styles.container}>
      {renderStep()}
      <View style={styles.navRow}>
        {step > 0 && (
          <Pressable onPress={back} style={styles.navButton} accessibilityLabel="Back">
            <Text style={styles.navButtonText}>Back</Text>
          </Pressable>
        )}
        <View style={{ flex: 1 }} />
        <Pressable onPress={next} style={styles.navButton} accessibilityLabel={step < 3 ? 'Next' : 'Finish'}>
          <Text style={styles.navButtonText}>{step < 3 ? 'Next' : 'Finish'}</Text>
        </Pressable>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, paddingTop: 40 },
  header: { fontSize: 24, marginBottom: 16 },
  row: { flexDirection: 'row', gap: 8 },
  optionButton: {
    padding: 12,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#777',
    minWidth: 80,
    alignItems: 'center',
    marginRight: 8,
  },
  optionButtonSelected: { backgroundColor: '#6200ee', borderColor: '#6200ee' },
  optionButtonText: { color: '#000' },
  navRow: {
    flexDirection: 'row',
    marginTop: 24,
    alignItems: 'center',
  },
  navButton: {
    padding: 12,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#777',
    minWidth: 80,
    alignItems: 'center',
  },
  navButtonText: { color: '#000' },
  listItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  listInput: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 8,
    borderRadius: 4,
  },
  deleteButton: { marginLeft: 8, padding: 8 },
  deleteText: { color: '#b00020' },
  addButton: { marginTop: 8, padding: 12, alignItems: 'center' },
  addButtonText: { color: '#6200ee' },
});

export default OnboardingScreen;
