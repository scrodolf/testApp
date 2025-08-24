import type { SQLiteDatabase } from 'react-native-sqlite-storage';

// Built-in units with conversion factors to their base dimensions.
// factor_to_base converts the unit to grams (mass), milliliters (volume), or kilocalories (energy).
interface UnitSeed {
  id: number;
  name: string;
  symbol: string;
  dimension: string;
  factor_to_base: number;
}

const UNIT_SEED_DATA: UnitSeed[] = [
  { id: 1, name: 'Gram', symbol: 'g', dimension: 'MASS', factor_to_base: 1 },
  { id: 2, name: 'Kilogram', symbol: 'kg', dimension: 'MASS', factor_to_base: 1000 },
  { id: 3, name: 'Ounce', symbol: 'oz', dimension: 'MASS', factor_to_base: 28.349523 },
  { id: 4, name: 'Pound', symbol: 'lb', dimension: 'MASS', factor_to_base: 453.59237 },
  { id: 5, name: 'Milliliter', symbol: 'mL', dimension: 'VOLUME', factor_to_base: 1 },
  { id: 6, name: 'Liter', symbol: 'L', dimension: 'VOLUME', factor_to_base: 1000 },
  { id: 7, name: 'Teaspoon', symbol: 'tsp', dimension: 'VOLUME', factor_to_base: 4.92892159375 },
  { id: 8, name: 'Tablespoon', symbol: 'tbsp', dimension: 'VOLUME', factor_to_base: 14.78676478125 },
  { id: 9, name: 'Fluid Ounce', symbol: 'fl oz', dimension: 'VOLUME', factor_to_base: 29.5735296 },
  { id: 10, name: 'Cup', symbol: 'cup', dimension: 'VOLUME', factor_to_base: 236.5882365 },
  { id: 11, name: 'Pint', symbol: 'pint', dimension: 'VOLUME', factor_to_base: 473.176473 },
  { id: 12, name: 'Quart', symbol: 'quart', dimension: 'VOLUME', factor_to_base: 946.352946 },
  { id: 13, name: 'Gallon', symbol: 'gallon', dimension: 'VOLUME', factor_to_base: 3785.411784 },
  { id: 14, name: 'Kilocalorie', symbol: 'kcal', dimension: 'ENERGY', factor_to_base: 1 }
];

interface CategorySeed {
  id: number;
  name_key: string;
  dimension: string;
  is_builtin: number;
}

// Generic bucket plus specific vitamins for vitamin mode.
const CATEGORY_SEED_DATA: CategorySeed[] = [
  { id: 1, name_key: 'calories', dimension: 'ENERGY', is_builtin: 1 },
  { id: 2, name_key: 'fat', dimension: 'MASS', is_builtin: 1 },
  { id: 3, name_key: 'protein', dimension: 'MASS', is_builtin: 1 },
  { id: 4, name_key: 'carbs', dimension: 'MASS', is_builtin: 1 },
  { id: 5, name_key: 'fiber', dimension: 'MASS', is_builtin: 1 },
  { id: 6, name_key: 'vitamins', dimension: 'MASS', is_builtin: 1 }, // generic bucket
  { id: 7, name_key: 'vitamin_a', dimension: 'MASS', is_builtin: 1 },
  { id: 8, name_key: 'vitamin_b1', dimension: 'MASS', is_builtin: 1 },
  { id: 9, name_key: 'vitamin_b2', dimension: 'MASS', is_builtin: 1 },
  { id: 10, name_key: 'vitamin_b3', dimension: 'MASS', is_builtin: 1 },
  { id: 11, name_key: 'vitamin_b5', dimension: 'MASS', is_builtin: 1 },
  { id: 12, name_key: 'vitamin_b6', dimension: 'MASS', is_builtin: 1 },
  { id: 13, name_key: 'vitamin_b7', dimension: 'MASS', is_builtin: 1 },
  { id: 14, name_key: 'vitamin_b9', dimension: 'MASS', is_builtin: 1 },
  { id: 15, name_key: 'vitamin_b12', dimension: 'MASS', is_builtin: 1 },
  { id: 16, name_key: 'vitamin_c', dimension: 'MASS', is_builtin: 1 },
  { id: 17, name_key: 'vitamin_d', dimension: 'MASS', is_builtin: 1 },
  { id: 18, name_key: 'vitamin_e', dimension: 'MASS', is_builtin: 1 },
  { id: 19, name_key: 'vitamin_k', dimension: 'MASS', is_builtin: 1 }
];

interface MealTypeSeed {
  id: number;
  name_key: string;
  sort_order: number;
  is_builtin: number;
}

const MEAL_TYPE_SEED_DATA: MealTypeSeed[] = [
  { id: 1, name_key: 'breakfast', sort_order: 0, is_builtin: 1 },
  { id: 2, name_key: 'lunch', sort_order: 1, is_builtin: 1 },
  { id: 3, name_key: 'dinner', sort_order: 2, is_builtin: 1 }
];

// Vitamin mode sample structure demonstrating generic bucket vs. specific list.
export const VITAMIN_MODE_SAMPLE = {
  genericBucket: CATEGORY_SEED_DATA.find(c => c.name_key === 'vitamins'),
  specificList: CATEGORY_SEED_DATA.filter(c => c.name_key.startsWith('vitamin_')).map(c => ({
    id: c.id,
    name_key: c.name_key,
    defaultUnit: 'µg'
  }))
};

// Inserts seed data into the provided database. Uses INSERT OR IGNORE to avoid duplicating built-in rows.
export async function seedInitialData(db: SQLiteDatabase): Promise<void> {
  await db.transaction((tx: any) => {
    UNIT_SEED_DATA.forEach(u =>
      tx.executeSql(
        `INSERT OR IGNORE INTO units (id, name, symbol, dimension, factor_to_base, is_custom) VALUES (?, ?, ?, ?, ?, 0);`,
        [u.id, u.name, u.symbol, u.dimension, u.factor_to_base]
      )
    );

    CATEGORY_SEED_DATA.forEach(c =>
      tx.executeSql(
        `INSERT OR IGNORE INTO categories (id, name_key, dimension, is_builtin) VALUES (?, ?, ?, ?);`,
        [c.id, c.name_key, c.dimension, c.is_builtin]
      )
    );

    MEAL_TYPE_SEED_DATA.forEach(m =>
      tx.executeSql(
        `INSERT OR IGNORE INTO meal_types (id, name_key, sort_order, is_builtin) VALUES (?, ?, ?, ?);`,
        [m.id, m.name_key, m.sort_order, m.is_builtin]
      )
    );
  });
}

