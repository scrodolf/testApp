import React, { useEffect, useState } from 'react';
import { View, Text, Button, StyleSheet, Platform } from 'react-native';
import { Picker } from '@react-native-picker/picker';
import DateTimePicker from '@react-native-community/datetimepicker';
import { useServices } from '../services/ServiceContext';
import type { Meal, MealType, LogEntry } from '../services/repositories';

interface Props {
  navigation: any;
  route: { params: { date: string; logId?: number } };
}

const pad = (n: number) => n.toString().padStart(2, '0');
const formatDate = (d: Date) => `${pad(d.getDate())}-${pad(d.getMonth() + 1)}-${d.getFullYear()}`;

export default function AddEditLogScreen({ navigation, route }: Props) {
  const { mealRepository, mealTypeRepository, logRepository } = useServices();
  const { date, logId } = route.params;
  const [meals, setMeals] = useState<Meal[]>([]);
  const [mealTypes, setMealTypes] = useState<MealType[]>([]);
  const [mealId, setMealId] = useState<number | undefined>();
  const [mealTypeId, setMealTypeId] = useState<number | undefined>();
  const [time, setTime] = useState(new Date(`${date}T12:00:00`));
  const [showPicker, setShowPicker] = useState(false);

  useEffect(() => {
    (async () => {
      setMeals(await mealRepository.getAll());
      setMealTypes(await mealTypeRepository.getAll());
      if (logId) {
        const log = await logRepository.getById(logId);
        if (log) {
          setMealId(log.mealId);
          setMealTypeId(log.mealTypeId);
          setTime(new Date(log.loggedAtLocal));
        }
      }
    })();
  }, [logId]);

  const save = async () => {
    if (!mealId) return;
    const loggedAtLocal = `${date}T${pad(time.getHours())}:${pad(time.getMinutes())}:00`;
    const entry = { mealId, mealTypeId, loggedAtLocal };
    if (logId) {
      await logRepository.update(logId, entry);
    } else {
      await logRepository.create(entry);
    }
    navigation.goBack();
  };

  const deleteLog = async () => {
    if (!logId) return;
    const log = await logRepository.getById(logId);
    if (!log) return;
    await logRepository.delete(logId);
    const deleted: Omit<LogEntry, 'id'> = {
      mealId: log.mealId,
      mealTypeId: log.mealTypeId,
      loggedAtLocal: log.loggedAtLocal,
    };
    navigation.navigate('Logs', { deletedLog: deleted });
  };

  return (
    <View style={styles.container}>
      <Text accessibilityRole="header">{formatDate(new Date(date))}</Text>
      {Platform.OS === 'android' && (
        <>
          <Button title={`${pad(time.getHours())}:${pad(time.getMinutes())}`} onPress={() => setShowPicker(true)} />
          {showPicker && (
            <DateTimePicker
              value={time}
              mode="time"
              onChange={(_, d) => {
                setShowPicker(false);
                if (d) setTime(d);
              }}
              is24Hour
            />
          )}
        </>
      )}
      <Button title="Now" onPress={() => setTime(new Date())} />
      <Picker selectedValue={mealId} onValueChange={(v) => setMealId(v)}>
        {meals.length === 0 && (
          <Picker.Item label="No meals yet. Create your first meal." value={undefined} />
        )}
        {meals.map((m) => (
          <Picker.Item key={m.id} label={m.name} value={m.id} />
        ))}
      </Picker>
      <Picker selectedValue={mealTypeId} onValueChange={(v) => setMealTypeId(v)}>
        {mealTypes.map((m) => (
          <Picker.Item key={m.id} label={m.nameKey} value={m.id} />
        ))}
      </Picker>
      <Button title="Save" onPress={save} disabled={!mealId} />
      {logId && <Button title="Delete" color="red" onPress={deleteLog} />}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    gap: 12,
  },
});
