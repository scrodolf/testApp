import AsyncStorage from '@react-native-async-storage/async-storage';

export interface Meal {
  id: string;
  name: string;
  productIds: string[];
}

const KEY = 'meals';

export async function addMeal(meal: Meal): Promise<void> {
  const existing = await AsyncStorage.getItem(KEY);
  const meals: Meal[] = existing ? JSON.parse(existing) : [];
  meals.push(meal);
  await AsyncStorage.setItem(KEY, JSON.stringify(meals));
}

export async function getMeals(): Promise<Meal[]> {
  const existing = await AsyncStorage.getItem(KEY);
  return existing ? JSON.parse(existing) : [];
}
