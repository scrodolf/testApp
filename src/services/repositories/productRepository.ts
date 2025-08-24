import AsyncStorage from '@react-native-async-storage/async-storage';

export interface Product {
  id: string;
  name: string;
  calories: number;
}

const KEY = 'products';

export async function addProduct(product: Product): Promise<void> {
  const existing = await AsyncStorage.getItem(KEY);
  const products: Product[] = existing ? JSON.parse(existing) : [];
  products.push(product);
  await AsyncStorage.setItem(KEY, JSON.stringify(products));
}

export async function getProducts(): Promise<Product[]> {
  const existing = await AsyncStorage.getItem(KEY);
  return existing ? JSON.parse(existing) : [];
}
