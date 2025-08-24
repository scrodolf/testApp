import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, Button } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useServices } from '../services/ServiceContext';
import type { Goal } from '../services/repositories/types';
import StatsChart from '../components/StatsChart';
import UndoSnackbar from '../components/UndoSnackbar';
import { startOfWeek, format } from 'date-fns';

export default function StatisticsScreen() {
  const nav = useNavigation<any>();
  const {
    goalRepository,
    categoryRepository,
    unitRepository,
    statsService,
  } = useServices();
  const [goals, setGoals] = useState<Goal[]>([]);
  const [categories, setCategories] = useState<Record<number, string>>({});
  const [units, setUnits] = useState<Record<number, string>>({});
  const [displayCaps, setDisplayCaps] = useState<Record<number, number>>({});
  const [selected, setSelected] = useState<Goal | undefined>();
  const [chartData, setChartData] = useState<{ labels: string[]; data: number[]; cap: number }>({ labels: [], data: [], cap: 0 });
  const [deleted, setDeleted] = useState<Goal | null>(null);

  useEffect(() => {
    (async () => {
      const g = await goalRepository.getAll();
      setGoals(g);
      const capMap: Record<number, number> = {};
      for (const goal of g) {
        capMap[goal.id] = await statsService.display(
          goal.capValueInBase,
          goal.originalUnitId!
        );
      }
      setDisplayCaps(capMap);
      const cats = await categoryRepository.getAll();
      const catMap: Record<number, string> = {};
      cats.forEach((c) => (catMap[c.id] = c.nameKey));
      setCategories(catMap);
      const us = await unitRepository.getAll();
      const unitMap: Record<number, string> = {};
      us.forEach((u) => (unitMap[u.id] = u.symbol || u.name));
      setUnits(unitMap);
    })();
  }, []);

  useEffect(() => {
    (async () => {
      if (!selected) return;
      const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });
      const totals = await statsService.getWeeklyTotals(selected.categoryId, weekStart);
      const labels = totals.map((t) => format(new Date(t.date), 'dd-MM'));
      const data = await Promise.all(
        totals.map((t) => statsService.display(t.totalInBase, selected.originalUnitId!))
      );
      const cap = await statsService.display(
        selected.capValueInBase,
        selected.originalUnitId!
      );
      setChartData({ labels, data, cap });
    })();
  }, [selected]);

  const onDelete = async (goal: Goal) => {
    setGoals((prev) => prev.filter((g) => g.id !== goal.id));
    setDeleted(goal);
    await goalRepository.delete(goal.id);
  };

  const undo = async () => {
    if (deleted) {
      await goalRepository.create({ ...deleted, id: undefined! } as any);
      const g = await goalRepository.getAll();
      setGoals(g);
      setDeleted(null);
    }
  };

  const renderItem = ({ item }: { item: Goal }) => (
    <TouchableOpacity
      onPress={() => setSelected(item)}
      onLongPress={() => onDelete(item)}
      style={{ padding: 12, backgroundColor: selected?.id === item.id ? '#eee' : '#fff' }}
    >
      <Text>{categories[item.categoryId]}</Text>
      <Text>
        {item.period} - {displayCaps[item.id]?.toFixed(2)} {units[item.originalUnitId!]}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={{ flex: 1 }}>
      <FlatList
        data={goals}
        keyExtractor={(g) => String(g.id)}
        renderItem={renderItem}
        ListEmptyComponent={<Text style={{ padding: 16 }}>No goals set yet.</Text>}
      />
      {selected && (
        <StatsChart
          data={chartData.data}
          labels={chartData.labels}
          cap={chartData.cap}
          type="bar"
          color="#4caf50"
        />
      )}
      <Button title="Add Goal" onPress={() => nav.navigate('AddEditGoal')} />
      <UndoSnackbar visible={!!deleted} message="Goal deleted." onUndo={undo} onDismiss={() => setDeleted(null)} />
    </View>
  );
}
