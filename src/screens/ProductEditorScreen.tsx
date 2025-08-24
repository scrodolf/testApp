import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { Picker } from '@react-native-picker/picker';
import { useForm, Controller } from 'react-hook-form';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { useServices } from '../services/ServiceContext';
import { Unit, Category } from '../services/repositories';

interface FormValues {
  name: string;
  defaultSize: string;
  defaultUnitId: number;
}

const predefinedOverrides = ['scoop', 'cup', 'tsp', 'tbsp'];

type RouteParams = { productId?: number };

type Props = NativeStackScreenProps<Record<string, RouteParams>, string>;

const ProductEditorScreen: React.FC<Props> = ({ navigation, route }) => {
  const productId = route.params?.productId;
  const {
    productRepository,
    unitRepository,
    categoryRepository,
    productCategoryValueRepository,
    productUnitOverrideRepository,
    conversionService,
  } = useServices();
  const { control, handleSubmit, setValue, formState } = useForm<FormValues>({
    defaultValues: { name: '', defaultSize: '', defaultUnitId: 0 },
    mode: 'onChange',
  });
  const [units, setUnits] = useState<Unit[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [categoryValues, setCategoryValues] = useState<Record<number, { value: string; unitId: number }>>({});
  const [overrides, setOverrides] = useState<{ label: string; factor: string }[]>([]);

  useEffect(() => {
    (async () => {
      const [allUnits, cats] = await Promise.all([
        unitRepository.getAll(),
        categoryRepository.getAll(),
      ]);
      setUnits(allUnits);
      setCategories(cats);
      if (allUnits.length > 0) {
        setValue('defaultUnitId', allUnits[0].id);
      }
      if (productId) {
        const prod = await productRepository.getById(productId);
        if (prod) {
          setValue('name', prod.name);
          if (prod.defaultSize) setValue('defaultSize', String(prod.defaultSize));
          if (prod.defaultUnitId) setValue('defaultUnitId', prod.defaultUnitId);
          const vals = await productCategoryValueRepository.getForProduct(productId);
          const cv: Record<number, { value: string; unitId: number }> = {};
          for (const v of vals) {
            const converted = await conversionService.fromBase(
              v.valueInBase,
              v.originalUnitId ?? 1,
              productId
            );
            cv[v.categoryId] = {
              value: String(converted),
              unitId: v.originalUnitId ?? 1,
            };
          }
          setCategoryValues(cv);
        }
      }
      setOverrides(predefinedOverrides.map((o) => ({ label: o, factor: '' })));
    })();
  }, [productId, setValue, unitRepository, categoryRepository, productRepository, productCategoryValueRepository, conversionService]);

  const onSave = handleSubmit(async (data) => {
    const productData = {
      name: data.name,
      defaultUnitId: data.defaultUnitId,
      defaultSize: data.defaultSize ? parseFloat(data.defaultSize) : undefined,
    };
    let id = productId;
    if (productId) await productRepository.update({ id: productId, ...productData });
    else id = await productRepository.create(productData);
    if (!id) return;
    for (const cat of categories) {
      const entry = categoryValues[cat.id];
      if (entry && entry.value !== '') {
        const base = await conversionService.toBase(
          parseFloat(entry.value),
          entry.unitId,
          id
        );
        await productCategoryValueRepository.upsert({
          productId: id,
          categoryId: cat.id,
          valueInBase: base,
          originalUnitId: entry.unitId,
        });
      }
    }
    for (const o of overrides) {
      const unit = units.find((u) => u.symbol === o.label || u.name === o.label);
      if (unit && o.factor !== '') {
        await productUnitOverrideRepository.upsert({
          productId: id,
          unitId: unit.id,
          factorToBase: parseFloat(o.factor),
        });
      }
    }
    navigation.goBack();
  });

  const addOverride = () => setOverrides((prev) => [...prev, { label: '', factor: '' }]);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.header}>Product</Text>
      <Controller
        control={control}
        name="name"
        rules={{ required: 'Required' }}
        render={({ field: { onChange, value } }) => (
          <TextInput
            style={styles.input}
            value={value}
            onChangeText={onChange}
            placeholder="Name"
            accessibilityLabel="Product name"
          />
        )}
      />
      {formState.errors.name && <Text style={styles.error}>Name is required</Text>}

      <Text style={styles.label}>Serving Size</Text>
      <View style={styles.row}>
        <Controller
          control={control}
          name="defaultSize"
          rules={{
            validate: (v) => (v === '' || parseFloat(v) >= 0) || 'Must be ≥ 0',
          }}
          render={({ field: { onChange, value } }) => (
            <TextInput
              style={[styles.input, styles.flex]}
              value={value}
              onChangeText={onChange}
              keyboardType="numeric"
              placeholder="0"
              accessibilityLabel="Default size"
            />
          )}
        />
        <Controller
          control={control}
          name="defaultUnitId"
          rules={{ required: true }}
          render={({ field: { onChange, value } }) => (
            <Picker
              selectedValue={value}
              onValueChange={onChange}
              style={styles.picker}
              accessibilityLabel="Default unit"
            >
              {units.map((u) => (
                <Picker.Item key={u.id} label={u.symbol ?? u.name} value={u.id} />
              ))}
            </Picker>
          )}
        />
      </View>
      {formState.errors.defaultSize && <Text style={styles.error}>{formState.errors.defaultSize.message}</Text>}

      <Text style={styles.header}>Nutrients</Text>
      {categories.map((cat) => (
        <View key={cat.id} style={styles.row}>
          <Text style={styles.categoryLabel}>{cat.nameKey}</Text>
          <TextInput
            style={[styles.input, styles.flex]}
            value={categoryValues[cat.id]?.value ?? ''}
            onChangeText={(v) =>
              setCategoryValues((prev) => ({
                ...prev,
                [cat.id]: { value: v, unitId: categoryValues[cat.id]?.unitId ?? units[0]?.id ?? 1 },
              }))
            }
            keyboardType="numeric"
            accessibilityLabel={`${cat.nameKey} value`}
          />
          <Picker
            selectedValue={categoryValues[cat.id]?.unitId}
            onValueChange={(u) =>
              setCategoryValues((prev) => ({
                ...prev,
                [cat.id]: { value: categoryValues[cat.id]?.value ?? '', unitId: u },
              }))
            }
            style={styles.picker}
            accessibilityLabel={`${cat.nameKey} unit`}
          >
            {units
              .filter((u) => u.dimension === cat.dimension)
              .map((u) => (
                <Picker.Item key={u.id} label={u.symbol ?? u.name} value={u.id} />
              ))}
          </Picker>
        </View>
      ))}

      <Text style={styles.header}>Measure Overrides</Text>
      {overrides.map((o, idx) => (
        <View key={idx} style={styles.row}>
          <TextInput
            style={[styles.input, styles.flex]}
            value={o.label}
            onChangeText={(v) =>
              setOverrides((prev) => prev.map((p, i) => (i === idx ? { ...p, label: v } : p)))
            }
            placeholder="Unit"
            accessibilityLabel={`Override ${idx + 1} unit`}
          />
          <TextInput
            style={[styles.input, styles.flex]}
            value={o.factor}
            onChangeText={(v) =>
              setOverrides((prev) => prev.map((p, i) => (i === idx ? { ...p, factor: v } : p)))
            }
            keyboardType="numeric"
            placeholder="Factor"
            accessibilityLabel={`Override ${idx + 1} factor`}
          />
        </View>
      ))}
      <TouchableOpacity onPress={addOverride} accessibilityRole="button" style={styles.addButton}>
        <Text style={styles.addButtonText}>Add Override</Text>
      </TouchableOpacity>

      <View style={styles.actions}>
        <TouchableOpacity
          onPress={() => navigation.goBack()}
          style={[styles.actionButton, styles.cancel]}
          accessibilityRole="button"
        >
          <Text style={styles.actionText}>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={onSave}
          style={[styles.actionButton, formState.isValid ? styles.save : styles.disabled]}
          accessibilityRole="button"
          accessibilityState={{ disabled: !formState.isValid }}
          disabled={!formState.isValid}
        >
          <Text style={styles.actionText}>Save</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: { padding: 16 },
  header: { fontSize: 18, fontWeight: '600', marginVertical: 8 },
  label: { marginTop: 8, marginBottom: 4 },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 4,
    padding: 8,
    minHeight: 48,
  },
  picker: { flex: 1, minHeight: 48 },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
    columnGap: 8,
  },
  flex: { flex: 1 },
  categoryLabel: { width: 80 },
  error: { color: 'red', marginBottom: 4 },
  addButton: {
    alignSelf: 'flex-start',
    marginVertical: 8,
  },
  addButtonText: { color: '#6200ee' },
  actions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 16,
  },
  actionButton: {
    flex: 1,
    alignItems: 'center',
    padding: 12,
    marginHorizontal: 4,
    borderRadius: 4,
  },
  cancel: { backgroundColor: '#999' },
  save: { backgroundColor: '#6200ee' },
  disabled: { backgroundColor: '#bbb' },
  actionText: { color: 'white', fontWeight: '500' },
});

export default ProductEditorScreen;

