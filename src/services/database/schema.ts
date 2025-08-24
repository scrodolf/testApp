import type { SQLiteDatabase } from 'react-native-sqlite-storage';

// SQL statements defining the database schema for the food tracking app.
// Each table mirrors the structure from the original Drift/SQLite setup.
export const CREATE_TABLE_QUERIES: string[] = [
  `CREATE TABLE IF NOT EXISTS units (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    symbol TEXT,
    dimension TEXT NOT NULL,
    factor_to_base REAL NOT NULL,
    is_custom INTEGER NOT NULL DEFAULT 0
  );`,
  `CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY,
    name_key TEXT NOT NULL UNIQUE,
    dimension TEXT NOT NULL,
    is_builtin INTEGER NOT NULL DEFAULT 1
  );`,
  `CREATE TABLE IF NOT EXISTS meal_types (
    id INTEGER PRIMARY KEY,
    name_key TEXT NOT NULL UNIQUE,
    sort_order INTEGER NOT NULL,
    is_builtin INTEGER NOT NULL DEFAULT 1
  );`,
  `CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    default_unit_id INTEGER REFERENCES units(id),
    default_size REAL
  );`,
  `CREATE TABLE IF NOT EXISTS product_category_values (
    product_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    value_in_base REAL NOT NULL,
    original_unit_id INTEGER REFERENCES units(id),
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
  );`,
  `CREATE TABLE IF NOT EXISTS product_unit_overrides (
    product_id INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    factor_to_base REAL NOT NULL,
    PRIMARY KEY (product_id, unit_id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE CASCADE
  );`,
  `CREATE TABLE IF NOT EXISTS meals (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
  );`,
  `CREATE TABLE IF NOT EXISTS meal_items (
    id INTEGER PRIMARY KEY,
    meal_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity REAL NOT NULL,
    FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
  );`,
  `CREATE TABLE IF NOT EXISTS meal_custom_entries (
    id INTEGER PRIMARY KEY,
    meal_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    value_in_base REAL NOT NULL,
    original_unit_id INTEGER REFERENCES units(id),
    FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (original_unit_id) REFERENCES units(id)
  );`,
  `CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY,
    meal_id INTEGER NOT NULL,
    logged_at_local INTEGER NOT NULL,
    meal_type_id INTEGER NOT NULL,
    FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE,
    FOREIGN KEY (meal_type_id) REFERENCES meal_types(id) ON DELETE SET NULL
  );`,
  `CREATE TABLE IF NOT EXISTS goals (
    id INTEGER PRIMARY KEY,
    period TEXT NOT NULL CHECK (period IN ('WEEK','MONTH')),
    category_id INTEGER NOT NULL,
    cap_value_in_base REAL NOT NULL,
    original_unit_id INTEGER REFERENCES units(id),
    disposition TEXT NOT NULL CHECK (disposition IN ('GOOD','BAD','MIXED')),
    impact TEXT NOT NULL CHECK (impact IN ('MILD','MODERATE','SEVERE')),
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (original_unit_id) REFERENCES units(id)
  );`
];

// Recommended indexes to optimize frequent queries and lookups.
export const CREATE_INDEX_QUERIES: string[] = [
  `CREATE UNIQUE INDEX IF NOT EXISTS idx_units_name ON units(name);`,
  `CREATE INDEX IF NOT EXISTS idx_products_default_unit ON products(default_unit_id);`,
  `CREATE INDEX IF NOT EXISTS idx_pcv_product ON product_category_values(product_id);`,
  `CREATE INDEX IF NOT EXISTS idx_pcv_category ON product_category_values(category_id);`,
  `CREATE INDEX IF NOT EXISTS idx_puo_product ON product_unit_overrides(product_id);`,
  `CREATE INDEX IF NOT EXISTS idx_meal_items_meal ON meal_items(meal_id);`,
  `CREATE INDEX IF NOT EXISTS idx_meal_items_product ON meal_items(product_id);`,
  `CREATE INDEX IF NOT EXISTS idx_meal_custom_entries_meal ON meal_custom_entries(meal_id);`,
  `CREATE INDEX IF NOT EXISTS idx_meal_custom_entries_category ON meal_custom_entries(category_id);`,
  `CREATE INDEX IF NOT EXISTS idx_logs_meal ON logs(meal_id);`,
  `CREATE INDEX IF NOT EXISTS idx_logs_meal_type ON logs(meal_type_id);`,
  `CREATE INDEX IF NOT EXISTS idx_logs_logged_at ON logs(logged_at_local);`,
  `CREATE INDEX IF NOT EXISTS idx_goals_category ON goals(category_id);`
];

// Helper that executes the schema definition against the provided database.
export async function createSchema(db: SQLiteDatabase): Promise<void> {
  await db.transaction(tx => {
    CREATE_TABLE_QUERIES.forEach(query => tx.executeSql(query));
    CREATE_INDEX_QUERIES.forEach(query => tx.executeSql(query));
  });
}

// Example TypeScript interfaces representing rows of each table. These
// can be used with an ORM like WatermelonDB or for type checking.
export interface Unit {
  id: number;
  name: string;
  symbol: string;
  dimension: string; // e.g. 'MASS', 'VOLUME', 'ENERGY'
  factor_to_base: number;
  is_custom: number; // 0 = built-in, 1 = user-defined
}

export interface Category {
  id: number;
  name_key: string;
  dimension: string;
  is_builtin: number;
}

export interface MealType {
  id: number;
  name_key: string;
  sort_order: number;
  is_builtin: number;
}

export interface Product {
  id: number;
  name: string;
  default_unit_id?: number;
  default_size?: number;
}

export interface ProductCategoryValue {
  product_id: number;
  category_id: number;
  value_in_base: number;
  original_unit_id?: number;
}

export interface ProductUnitOverride {
  product_id: number;
  unit_id: number;
  factor_to_base: number;
}

export interface Meal {
  id: number;
  name: string;
}

export interface MealItem {
  id: number;
  meal_id: number;
  product_id: number;
  quantity: number;
}

export interface MealCustomEntry {
  id: number;
  meal_id: number;
  category_id: number;
  value_in_base: number;
  original_unit_id?: number;
}

export interface LogEntry {
  id: number;
  meal_id: number;
  logged_at_local: number; // Unix epoch milliseconds
  meal_type_id: number;
}

export interface Goal {
  id: number;
  period: 'WEEK' | 'MONTH';
  category_id: number;
  cap_value_in_base: number;
  original_unit_id?: number;
  disposition: 'GOOD' | 'BAD' | 'MIXED';
  impact: 'MILD' | 'MODERATE' | 'SEVERE';
}

