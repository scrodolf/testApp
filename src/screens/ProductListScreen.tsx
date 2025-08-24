import React, { useCallback, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  StyleSheet,
  LayoutAnimation,
  Pressable,
} from 'react-native';
import { useFocusEffect, useNavigation } from '@react-navigation/native';
import { useServices } from '../services/ServiceContext';
import UndoSnackbar from '../components/UndoSnackbar';

interface ProductListItem {
  id: number;
  name: string;
  defaultUnitId?: number;
  defaultSize?: number;
}

const ProductListScreen: React.FC = () => {
  const { productRepository, unitRepository } = useServices();
  const navigation = useNavigation<any>();
  const [products, setProducts] = useState<ProductListItem[]>([]);
  const [units, setUnits] = useState<Record<number, string>>({});
  const [deleted, setDeleted] = useState<ProductListItem | null>(null);
  const [snackbar, setSnackbar] = useState(false);

  const load = async () => {
    const [prods, allUnits] = await Promise.all([
      productRepository.getAll(),
      unitRepository.getAll(),
    ]);
    const unitMap: Record<number, string> = {};
    allUnits.forEach((u) => (unitMap[u.id] = u.symbol ?? u.name));
    setUnits(unitMap);
    setProducts(prods);
  };

  useFocusEffect(
    useCallback(() => {
      load();
    }, [])
  );

  const handleDelete = async (item: ProductListItem) => {
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    setProducts((prev) => prev.filter((p) => p.id !== item.id));
    setDeleted(item);
    setSnackbar(true);
    await productRepository.delete(item.id);
  };

  const handleUndo = async () => {
    if (!deleted) return;
    const newId = await productRepository.create({
      name: deleted.name,
      defaultUnitId: deleted.defaultUnitId,
      defaultSize: deleted.defaultSize,
    });
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    setProducts((prev) => [{ ...deleted, id: newId }, ...prev]);
    setDeleted(null);
    setSnackbar(false);
  };

  const renderItem = ({ item }: { item: ProductListItem }) => (
    <Pressable
      onLongPress={() => handleDelete(item)}
      onPress={() => navigation.navigate('ProductEditor', { productId: item.id })}
      style={({ pressed }) => [styles.item, pressed && styles.itemPressed]}
      accessibilityRole="button"
    >
      <Text style={styles.title}>{item.name}</Text>
      {item.defaultSize !== undefined && item.defaultUnitId !== undefined && (
        <Text style={styles.subtitle}>
          {item.defaultSize} {units[item.defaultUnitId]}
        </Text>
      )}
    </Pressable>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={products}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderItem}
        contentContainerStyle={styles.list}
      />
      <TouchableOpacity
        style={styles.fab}
        onPress={() => navigation.navigate('ProductEditor')}
        accessibilityRole="button"
        accessibilityLabel="Add product"
      >
        <Text style={styles.fabText}>+</Text>
      </TouchableOpacity>
      <UndoSnackbar
        visible={snackbar}
        message="Product deleted"
        onUndo={handleUndo}
        onDismiss={() => setSnackbar(false)}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1 },
  list: { padding: 16 },
  item: {
    paddingVertical: 16,
    paddingHorizontal: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderColor: '#ccc',
  },
  itemPressed: {
    backgroundColor: '#e0e0e0',
  },
  title: { fontSize: 16, fontWeight: '500' },
  subtitle: { fontSize: 14, color: '#666', marginTop: 4 },
  fab: {
    position: 'absolute',
    right: 16,
    bottom: 16,
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: '#6200ee',
    justifyContent: 'center',
    alignItems: 'center',
  },
  fabText: { color: 'white', fontSize: 24 },
});

export default ProductListScreen;
