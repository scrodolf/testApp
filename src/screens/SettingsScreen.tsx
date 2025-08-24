import React, { useState } from 'react';
import {
  ScrollView,
  View,
  Text,
  Switch,
  TextInput,
  FlatList,
  Pressable,
  Button,
  StyleSheet,
} from 'react-native';
import { useSelector, useDispatch } from 'react-redux';
import { RootState } from '../store';
import {
  setUnitSystem,
  setVitaminsMode,
  setThemeMode,
  setEnableBarcode,
  setEnableExport,
  setDebugSampleData,
} from '../store/preferencesSlice';
import PreferencesManager, {
  UnitSystem,
  VitaminsMode,
  ThemeMode,
} from '../services/preferences/PreferencesManager';

const OptionButton: React.FC<{ label: string; selected: boolean; onPress: () => void }>= ({ label, selected, onPress }) => (
  <Pressable
    accessibilityRole="button"
    accessibilityState={{ selected }}
    onPress={onPress}
    style={[styles.optionButton, selected && styles.optionButtonSelected]}
  >
    <Text style={styles.optionButtonText}>{label}</Text>
  </Pressable>
);

const SettingsScreen: React.FC = () => {
  const prefs = useSelector((state: RootState) => state.preferences);
  const dispatch = useDispatch();

  const updateUnitSystem = async (value: UnitSystem) => {
    dispatch(setUnitSystem(value));
    await PreferencesManager.setUnitSystem(value);
  };
  const updateVitaminsMode = async (value: VitaminsMode) => {
    dispatch(setVitaminsMode(value));
    await PreferencesManager.setVitaminsMode(value);
  };
  const updateThemeMode = async (value: ThemeMode) => {
    dispatch(setThemeMode(value));
    await PreferencesManager.setThemeMode(value);
  };

  const onToggleBarcode = async (value: boolean) => {
    dispatch(setEnableBarcode(value));
    await PreferencesManager.setEnableBarcode(value);
  };
  const onToggleExport = async (value: boolean) => {
    dispatch(setEnableExport(value));
    await PreferencesManager.setEnableExport(value);
  };

  const createSampleData = async () => {
    dispatch(setDebugSampleData(true));
    await PreferencesManager.setDebugSampleData(true);
    // Placeholder for generating sample data
  };

  const [customUnits, setCustomUnits] = useState<string[]>([]);
  const [newUnit, setNewUnit] = useState('');
  const [mealTypes, setMealTypes] = useState<string[]>([]);
  const [newMeal, setNewMeal] = useState('');

  const addUnit = () => {
    if (newUnit.trim()) {
      setCustomUnits([...customUnits, newUnit.trim()]);
      setNewUnit('');
    }
  };
  const removeUnit = (index: number) => {
    setCustomUnits(customUnits.filter((_, i) => i !== index));
  };

  const addMealType = () => {
    if (newMeal.trim()) {
      setMealTypes([...mealTypes, newMeal.trim()]);
      setNewMeal('');
    }
  };
  const removeMealType = (index: number) => {
    setMealTypes(mealTypes.filter((_, i) => i !== index));
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.header}>Settings</Text>

      <Text style={styles.section}>Unit System</Text>
      <View style={styles.row}>
        <OptionButton
          label="Metric"
          selected={prefs.unitSystem === 'metric'}
          onPress={() => updateUnitSystem('metric')}
        />
        <OptionButton
          label="Imperial"
          selected={prefs.unitSystem === 'imperial'}
          onPress={() => updateUnitSystem('imperial')}
        />
      </View>

      <Text style={styles.section}>Vitamins Mode</Text>
      <View style={styles.row}>
        <OptionButton
          label="Generic bucket"
          selected={prefs.vitaminsMode === 'bucket'}
          onPress={() => updateVitaminsMode('bucket')}
        />
        <OptionButton
          label="Specific list"
          selected={prefs.vitaminsMode === 'specific'}
          onPress={() => updateVitaminsMode('specific')}
        />
      </View>

      <Text style={styles.section}>Theme</Text>
      <View style={styles.row}>
        <OptionButton
          label="Light"
          selected={prefs.themeMode === 'light'}
          onPress={() => updateThemeMode('light')}
        />
        <OptionButton
          label="Dark"
          selected={prefs.themeMode === 'dark'}
          onPress={() => updateThemeMode('dark')}
        />
        <OptionButton
          label="System"
          selected={prefs.themeMode === 'system'}
          onPress={() => updateThemeMode('system')}
        />
      </View>

      <View style={styles.toggleRow}>
        <Text style={styles.toggleLabel}>Enable barcode</Text>
        <Switch
          accessibilityLabel="Enable barcode scanning"
          value={prefs.enableBarcode}
          onValueChange={onToggleBarcode}
        />
      </View>

      <View style={styles.toggleRow}>
        <Text style={styles.toggleLabel}>Enable export</Text>
        <Switch
          accessibilityLabel="Enable data export"
          value={prefs.enableExport}
          onValueChange={onToggleExport}
        />
      </View>

      <Button title="Create sample data" onPress={createSampleData} />

      <Text style={styles.section}>Custom Units</Text>
      <FlatList
        data={customUnits}
        keyExtractor={(item, index) => item + index}
        renderItem={({ item, index }) => (
          <View style={styles.listItem}>
            <TextInput
              style={styles.listInput}
              value={item}
              onChangeText={(text) => {
                const arr = [...customUnits];
                arr[index] = text;
                setCustomUnits(arr);
              }}
              accessibilityLabel={`Custom unit ${index + 1}`}
            />
            <Pressable
              accessibilityLabel={`Delete ${item}`}
              onPress={() => removeUnit(index)}
              style={styles.deleteButton}
            >
              <Text style={styles.deleteText}>Delete</Text>
            </Pressable>
          </View>
        )}
      />
      <View style={styles.addRow}>
        <TextInput
          style={styles.listInput}
          placeholder="Add unit"
          value={newUnit}
          onChangeText={setNewUnit}
          accessibilityLabel="New custom unit"
        />
        <Button title="Add" onPress={addUnit} />
      </View>

      <Text style={styles.section}>Meal Types</Text>
      <FlatList
        data={mealTypes}
        keyExtractor={(item, index) => item + index}
        renderItem={({ item, index }) => (
          <View style={styles.listItem}>
            <TextInput
              style={styles.listInput}
              value={item}
              onChangeText={(text) => {
                const arr = [...mealTypes];
                arr[index] = text;
                setMealTypes(arr);
              }}
              accessibilityLabel={`Meal type ${index + 1}`}
            />
            <Pressable
              accessibilityLabel={`Delete ${item}`}
              onPress={() => removeMealType(index)}
              style={styles.deleteButton}
            >
              <Text style={styles.deleteText}>Delete</Text>
            </Pressable>
          </View>
        )}
      />
      <View style={styles.addRow}>
        <TextInput
          style={styles.listInput}
          placeholder="Add meal type"
          value={newMeal}
          onChangeText={setNewMeal}
          accessibilityLabel="New meal type"
        />
        <Button title="Add" onPress={addMealType} />
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
  },
  header: {
    fontSize: 24,
    marginBottom: 16,
  },
  section: {
    fontSize: 18,
    marginTop: 24,
    marginBottom: 8,
  },
  row: {
    flexDirection: 'row',
    gap: 8,
  },
  optionButton: {
    padding: 12,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#777',
    minWidth: 64,
    alignItems: 'center',
    marginRight: 8,
  },
  optionButtonSelected: {
    backgroundColor: '#6200ee',
    borderColor: '#6200ee',
  },
  optionButtonText: {
    color: '#000',
  },
  toggleRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
  },
  toggleLabel: {
    fontSize: 16,
  },
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
  deleteButton: {
    marginLeft: 8,
    padding: 12,
  },
  deleteText: {
    color: '#b00020',
  },
  addRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
    marginBottom: 16,
    gap: 8,
  },
});

export default SettingsScreen;
