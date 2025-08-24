import AsyncStorage from '@react-native-async-storage/async-storage';
import {addProduct, getProducts} from '../src/services/repositories/productRepository';

jest.mock('@react-native-async-storage/async-storage', () => require('@react-native-async-storage/async-storage/jest/async-storage-mock'));

it('stores and retrieves products', async () => {
  await addProduct({id: '1', name: 'Apple', calories: 50});
  const products = await getProducts();
  expect(products).toHaveLength(1);
  expect(products[0].name).toBe('Apple');
});
