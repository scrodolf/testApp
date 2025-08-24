import React, { useEffect, useMemo, useState } from 'react';
import {
  View,
  Text,
  TextInput,
  ScrollView,
  StyleSheet,
  TouchableOpacity,
  Modal,
  FlatList,
  Button,
} from 'react-native';
import { Picker } from '@react-native-picker/picker';
import { useServices } from '../services/ServiceContext';
import { useSelector } from 'react-redux';
import { RootState } from '../store';
import { Product, Category, Unit } from '../services/repositories/types';
import { MealProductItem, CustomEntry, computeBaseTotals } from '../utils/mealTotals';

const BUILTIN_CATEGORY_KEYS = ['calories', 'fat', 'protein', 'carbs', 'fiber', 'vitamins'];

const MealBuilderScreen: React.FC = () => {
  const {
    productRepository,
    productCategoryValueRepository,
    categoryRepository,
    unitRepository,
    conversionService,
  } = useServices();
  const unitSystem = useSelector((state: RootState) => state.preferences.unitSystem);

  const [categories, setCategories] = useState<Category[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const unitsMap = useMemo(() => {
    const map = new Map<number, Unit>();
    units.forEach((u) => map.set(u.id, u));
    return map;
  }, [units]);

  const [products, setProducts] = useState<Product[]>([]);
  const [search, setSearch] = useState('');
  const [productModal, setProductModal] = useState(false);

  const [items, setItems] = useState<MealProductItem[]>([]);
  const [customs, setCustoms] = useState<CustomEntry[]>([]);
  const [totals, setTotals] = useState<{ categoryId: number; value: number; unit: string }[]>([]);

  // Load static data
  useEffect(() => {
    (async () => {
      const [cats, uns, prods] = await Promise.all([
        categoryRepository.getAll(),
        unitRepository.getAll(),
        productRepository.getAll(),
      ]);
      setCategories(cats);
      setUnits(uns);
      setProducts(prods);
    })();
  }, [categoryRepository, unitRepository, productRepository]);

  // Recompute totals whenever inputs change
  useEffect(() => {
    (async () => {
      const baseTotals = computeBaseTotals(items, customs);
      const display: { categoryId: number; value: number; unit: string }[] = [];
      for (const cat of categories.filter((c) => BUILTIN_CATEGORY_KEYS.includes(c.nameKey))) {
        const baseVal = baseTotals[cat.id] || 0;
        let unitId = 14; // energy
        if (cat.dimension === 'MASS') {
          unitId = unitSystem === 'metric' ? 1 : 3; // g or oz
        } else if (cat.dimension === 'VOLUME') {
          unitId = unitSystem === 'metric' ? 5 : 9; // mL or fl oz
        }
        const converted = await conversionService.fromBase(baseVal, unitId);
        display.push({
          categoryId: cat.id,
          value: conversionService.display(converted),
          unit: unitsMap.get(unitId)?.symbol || '',
        });
      }
      setTotals(display);
    })();
  }, [items, customs, unitSystem, categories, units, conversionService, unitsMap]);

  const filteredProducts = useMemo(
    () => products.filter((p) => p.name.toLowerCase().includes(search.toLowerCase())),
    [products, search],
  );

  const addProduct = async (product: Product) => {
    const vals = await productCategoryValueRepository.getForProduct(product.id);
    const map: Record<number, number> = {};
    vals.forEach((v) => {
      map[v.categoryId] = v.valueInBase;
    });
    setItems((prev) => [
      ...prev,
      { key: `${product.id}-${Date.now()}`, product, quantity: '1', categoryValues: map },
    ]);
    setProductModal(false);
  };

  const changeQuantity = (key: string, qty: string) => {
    setItems((prev) => prev.map((i) => (i.key === key ? { ...i, quantity: qty } : i)));
  };

  const removeItem = (key: string) => {
    setItems((prev) => prev.filter((i) => i.key !== key));
  };

  const addCustomEntry = () => {
    if (categories.length === 0 || units.length === 0) return;
    const cat = categories[0];
    const unit = units.find((u) => u.dimension === cat.dimension) || units[0];
    setCustoms((prev) => [
      ...prev,
      { key: `${Date.now()}`, categoryId: cat.id, unitId: unit.id, value: '', valueInBase: 0 },
    ]);
  };

  const updateCustom = async (key: string, patch: Partial<CustomEntry>) => {
    let updated: CustomEntry | undefined;
    setCustoms((prev) =>
      prev.map((c) => {
        if (c.key === key) {
          updated = { ...c, ...patch } as CustomEntry;
          return updated;
        }
        return c;
      }),
    );
    if (updated) {
      const num = parseFloat(updated.value);
      const base = isNaN(num) ? 0 : await conversionService.toBase(num, updated.unitId);
      setCustoms((prev) => prev.map((c) => (c.key === key ? { ...updated!, valueInBase: base } : c)));
    }
  };

  const removeCustom = (key: string) => {
    setCustoms((prev) => prev.filter((c) => c.key !== key));
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <TouchableOpacity
        style={styles.addButton}
        accessibilityRole="button"
        accessibilityLabel="Add product"
        onPress={() => setProductModal(true)}
      >
        <Text style={styles.addButtonText}>Add Product</Text>
      </TouchableOpacity>

      {items.map((item) => (
        <View key={item.key} style={styles.itemRow}>
          <Text style={styles.itemName}>{item.product.name}</Text>
          <TextInput
            style={styles.quantityInput}
            keyboardType="decimal-pad"
            accessibilityLabel={`Quantity for ${item.product.name}`}
            value={item.quantity}
            onChangeText={(t) => changeQuantity(item.key, t)}
          />
          <Text style={styles.itemUnit}>
            {item.product.defaultUnitId
              ? unitsMap.get(item.product.defaultUnitId)?.symbol || 'serv'
              : 'serv'}
          </Text>
          <TouchableOpacity
            accessibilityLabel={`Remove ${item.product.name}`}
            onPress={() => removeItem(item.key)}
            style={styles.removeButton}
          >
            <Text style={styles.removeButtonText}>Remove</Text>
          </TouchableOpacity>
        </View>
      ))}

      <Text style={styles.sectionHeader}>Custom Entries</Text>
      {customs.map((c) => (
        <View key={c.key} style={styles.itemRow}>
          <Picker
            selectedValue={c.categoryId}
            onValueChange={(v) => updateCustom(c.key, { categoryId: v as number })}
            style={styles.picker}
            accessibilityLabel="Category"
          >
            {categories.map((cat) => (
              <Picker.Item key={cat.id} label={cat.nameKey} value={cat.id} />
            ))}
          </Picker>
          <TextInput
            style={styles.quantityInput}
            keyboardType="decimal-pad"
            accessibilityLabel="Value"
            value={c.value}
            onChangeText={(t) => updateCustom(c.key, { value: t })}
          />
          <Picker
            selectedValue={c.unitId}
            onValueChange={(v) => updateCustom(c.key, { unitId: v as number })}
            style={styles.picker}
            accessibilityLabel="Unit"
          >
            {units
              .filter((u) => u.dimension === (categories.find((cat) => cat.id === c.categoryId)?.dimension || u.dimension))
              .map((u) => (
                <Picker.Item key={u.id} label={u.symbol || u.name} value={u.id} />
              ))}
          </Picker>
          <TouchableOpacity
            accessibilityLabel="Remove custom entry"
            onPress={() => removeCustom(c.key)}
            style={styles.removeButton}
          >
            <Text style={styles.removeButtonText}>Remove</Text>
          </TouchableOpacity>
        </View>
      ))}
      <TouchableOpacity
        style={styles.addButton}
        onPress={addCustomEntry}
        accessibilityRole="button"
        accessibilityLabel="Add custom entry"
      >
        <Text style={styles.addButtonText}>Add Custom Entry</Text>
      </TouchableOpacity>

      <Text style={styles.sectionHeader}>Totals</Text>
      {totals.map((t) => {
        const cat = categories.find((c) => c.id === t.categoryId);
        return (
          <View key={t.categoryId} style={styles.totalRow}>
            <Text style={styles.itemName}>{cat?.nameKey}</Text>
            <Text style={styles.totalValue}>
              {t.value} {t.unit}
            </Text>
          </View>
        );
      })}

      <Modal visible={productModal} animationType="slide">
        <View style={styles.modalContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Search"
            accessibilityLabel="Search products"
            value={search}
            onChangeText={setSearch}
          />
          <FlatList
            data={filteredProducts}
            keyExtractor={(item) => item.id.toString()}
            renderItem={({ item }) => (
              <TouchableOpacity
                style={styles.productRow}
                onPress={() => addProduct(item)}
                accessibilityLabel={`Add ${item.name}`}
              >
                <Text style={styles.itemName}>{item.name}</Text>
              </TouchableOpacity>
            )}
          />
          <Button title="Close" onPress={() => setProductModal(false)} />
        </View>
      </Modal>
    </ScrollView>
  );
};

export default MealBuilderScreen;

const styles = StyleSheet.create({
  container: { padding: 16, gap: 8 },
  addButton: {
    minHeight: 48,
    backgroundColor: '#6200ee',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 4,
    paddingHorizontal: 12,
    marginVertical: 4,
  },
  addButtonText: { color: 'white', fontWeight: 'bold' },
  itemRow: { flexDirection: 'row', alignItems: 'center', marginVertical: 4 },
  itemName: { flex: 1 },
  quantityInput: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 8,
    width: 60,
    marginHorizontal: 4,
  },
  itemUnit: { marginRight: 8 },
  removeButton: { minHeight: 48, justifyContent: 'center', padding: 8 },
  removeButtonText: { color: '#b00020' },
  sectionHeader: { marginTop: 16, fontWeight: 'bold' },
  picker: { width: 120, height: 48 },
  totalRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 4 },
  totalValue: { fontWeight: 'bold' },
  modalContainer: { flex: 1, padding: 16 },
  searchInput: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 8,
    marginBottom: 8,
  },
  productRow: { paddingVertical: 12 },
});
