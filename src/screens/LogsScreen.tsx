import React, { useCallback, useEffect, useState } from 'react';
import { View, Text, FlatList, Button, Pressable, StyleSheet } from 'react-native';
import { Swipeable } from 'react-native-gesture-handler';
import { useFocusEffect } from '@react-navigation/native';
import LogCalendar from '../components/LogCalendar';
import UndoSnackbar from '../components/UndoSnackbar';
import { useServices } from '../services/ServiceContext';
import type { LogEntry, Meal, MealType } from '../services/repositories';

const pad = (n: number) => n.toString().padStart(2, '0');
const formatTime = (d: Date) => `${pad(d.getHours())}:${pad(d.getMinutes())}`;

interface Props {
  navigation: any;
  route: any;
}

export default function LogsScreen({ navigation, route }: Props) {
  const { mealRepository, mealTypeRepository, logRepository } = useServices();
  const today = new Date();
  const todayStr = `${today.getFullYear()}-${pad(today.getMonth() + 1)}-${pad(today.getDate())}`;
  const [selectedDate, setSelectedDate] = useState<string>(todayStr);
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const [meals, setMeals] = useState<Record<number, string>>({});
  const [mealTypes, setMealTypes] = useState<Record<number, string>>({});
  const [marked, setMarked] = useState<Record<string, any>>({});
  const [snack, setSnack] = useState(false);
  const [undoLog, setUndoLog] = useState<Omit<LogEntry, 'id'> | null>(null);

  useEffect(() => {
    (async () => {
      const mealList = await mealRepository.getAll();
      const mealMap: Record<number, string> = {};
      mealList.forEach((m: Meal) => (mealMap[m.id] = m.name));
      setMeals(mealMap);
      const mtList = await mealTypeRepository.getAll();
      const mtMap: Record<number, string> = {};
      mtList.forEach((m: MealType) => (mtMap[m.id] = m.nameKey));
      setMealTypes(mtMap);
      await refreshMarks();
    })();
  }, []);

  const refreshMarks = async () => {
    const all = await logRepository.getAll();
    const m: Record<string, any> = {};
    all.forEach((l) => {
      const d = l.loggedAtLocal.slice(0, 10);
      m[d] = { marked: true };
    });
    setMarked(m);
  };

  const loadLogs = useCallback(async () => {
    const entries = await logRepository.getByDate(selectedDate);
    setLogs(entries);
  }, [selectedDate]);

  useEffect(() => {
    loadLogs();
  }, [loadLogs]);

  useFocusEffect(
    useCallback(() => {
      loadLogs();
      refreshMarks();
    }, [loadLogs])
  );

  useEffect(() => {
    if (route.params?.deletedLog) {
      setUndoLog(route.params.deletedLog);
      setSnack(true);
      navigation.setParams({ deletedLog: undefined });
    }
  }, [route.params]);

  const remove = async (id: number) => {
    const log = logs.find((l) => l.id === id);
    if (!log) return;
    await logRepository.delete(id);
    setUndoLog({ mealId: log.mealId, mealTypeId: log.mealTypeId, loggedAtLocal: log.loggedAtLocal });
    setSnack(true);
    loadLogs();
    refreshMarks();
  };

  const undo = async () => {
    if (undoLog) {
      await logRepository.create(undoLog);
      loadLogs();
      refreshMarks();
    }
    setSnack(false);
    setUndoLog(null);
  };

  const renderItem = ({ item }: { item: LogEntry }) => (
    <Swipeable
      renderRightActions={() => (
        <View style={styles.deleteBox}>
          <Text style={styles.deleteText}>Delete</Text>
        </View>
      )}
      onSwipeableOpen={() => remove(item.id)}
    >
      <Pressable
        accessibilityRole="button"
        style={styles.logItem}
        onPress={() => navigation.navigate('AddEditLog', { date: selectedDate, logId: item.id })}
      >
        <Text style={styles.logTitle}>{meals[item.mealId] || 'Meal'}</Text>
        <Text>{`${formatTime(new Date(item.loggedAtLocal))} - ${mealTypes[item.mealTypeId ?? 0] || ''}`}</Text>
      </Pressable>
    </Swipeable>
  );

  return (
    <View style={styles.container}>
      <LogCalendar selectedDate={selectedDate} markedDates={marked} onSelect={setSelectedDate} />
      <FlatList
        data={logs}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderItem}
        ListEmptyComponent={<Text>No logs for this day.</Text>}
      />
      <Button title="Add" onPress={() => navigation.navigate('AddEditLog', { date: selectedDate })} />
      <UndoSnackbar visible={snack} message="Log deleted." onUndo={undo} onDismiss={() => setSnack(false)} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  logItem: {
    padding: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#ccc',
  },
  logTitle: { fontWeight: '500', marginBottom: 4 },
  deleteBox: {
    backgroundColor: '#B00020',
    justifyContent: 'center',
    alignItems: 'flex-end',
    padding: 16,
  },
  deleteText: { color: '#fff' },
});
