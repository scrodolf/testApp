import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, Button } from 'react-native';
import { Picker } from '@react-native-picker/picker';
import { useForm, Controller } from 'react-hook-form';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useServices } from '../services/ServiceContext';
import type { Goal } from '../services/repositories/types';

interface FormData {
  period: 'WEEK' | 'MONTH';
  categoryId: number;
  capValue: string;
  unitId: number;
}

export default function AddEditGoalScreen() {
  const navigation = useNavigation<any>();
  const { params } = useRoute<any>();
  const editing: Goal | undefined = params?.goal;
  const { goalRepository, categoryRepository, unitRepository, conversionService } = useServices();
  const { control, handleSubmit, setValue } = useForm<FormData>({
    defaultValues: {
      period: editing?.period ?? 'WEEK',
      categoryId: editing?.categoryId ?? 1,
      capValue: editing ? String(editing.capValueInBase) : '',
      unitId: editing?.originalUnitId ?? 1,
    },
  });
  const [categories, setCategories] = useState<any[]>([]);
  const [units, setUnits] = useState<any[]>([]);

  useEffect(() => {
    (async () => {
      setCategories(await categoryRepository.getAll());
      setUnits(await unitRepository.getAll());
      if (editing) {
        const display = await conversionService.fromBase(
          editing.capValueInBase,
          editing.originalUnitId!
        );
        setValue('capValue', String(display));
      }
    })();
  }, [editing]);

  const onSubmit = handleSubmit(async (data) => {
    const base = await conversionService.toBase(parseFloat(data.capValue), data.unitId);
    const goalData: Omit<Goal, 'id'> = {
      period: data.period,
      categoryId: data.categoryId,
      capValueInBase: base,
      originalUnitId: data.unitId,
      disposition: 'GOOD',
      impact: 'MILD',
    };
    if (editing) await goalRepository.update(editing.id, goalData);
    else await goalRepository.create(goalData);
    navigation.goBack();
  });

  return (
    <View style={{ padding: 16 }}>
      <Text>Period</Text>
      <Controller
        control={control}
        name="period"
        render={({ field: { onChange, value } }) => (
          <Picker selectedValue={value} onValueChange={onChange}>
            <Picker.Item label="Weekly" value="WEEK" />
            <Picker.Item label="Monthly" value="MONTH" />
          </Picker>
        )}
      />
      <Text>Category</Text>
      <Controller
        control={control}
        name="categoryId"
        render={({ field: { onChange, value } }) => (
          <Picker selectedValue={value} onValueChange={onChange}>
              {categories.map((c) => (
                <Picker.Item key={c.id} label={c.nameKey} value={c.id} />
              ))}
            </Picker>
          )}
        />
      <Text>Cap Value</Text>
      <Controller
        control={control}
        name="capValue"
        rules={{ required: true }}
        render={({ field: { onChange, value } }) => (
          <TextInput
            value={value}
            onChangeText={onChange}
            keyboardType="numeric"
            style={{ borderWidth: 1, padding: 8, marginBottom: 8 }}
          />
        )}
      />
      <Text>Unit</Text>
      <Controller
        control={control}
        name="unitId"
        render={({ field: { onChange, value } }) => (
          <Picker selectedValue={value} onValueChange={onChange}>
            {units.map((u) => (
              <Picker.Item key={u.id} label={u.symbol} value={u.id} />
            ))}
          </Picker>
        )}
      />
      <Button title="Save" onPress={onSubmit} />
      <Button title="Cancel" onPress={() => navigation.goBack()} />
    </View>
  );
}
