export interface Unit {
  id: number;
  name: string;
  symbol?: string;
  dimension: 'MASS' | 'VOLUME' | 'ENERGY';
  factorToBase: number; // conversion factor to base unit
  isCustom: boolean;
}

export interface Category {
  id: number;
  nameKey: string;
  dimension: 'MASS' | 'VOLUME' | 'ENERGY';
  isBuiltin: boolean;
}

export interface MealType {
  id: number;
  nameKey: string;
  sortOrder: number;
  isBuiltin: boolean;
}

export interface Product {
  id: number;
  name: string;
  defaultUnitId?: number;
  defaultSize?: number;
}

export interface ProductCategoryValue {
  productId: number;
  categoryId: number;
  valueInBase: number;
  originalUnitId?: number;
}

export interface ProductUnitOverride {
  productId: number;
  unitId: number;
  factorToBase: number;
}

export interface Meal {
  id: number;
  name: string;
}

export interface MealItem {
  id: number;
  mealId: number;
  productId: number;
  quantity: number;
}

export interface MealCustomEntry {
  id: number;
  mealId: number;
  categoryId: number;
  valueInBase: number;
  originalUnitId?: number;
}

export interface LogEntry {
  id: number;
  mealId: number;
  loggedAtLocal: string;
  mealTypeId?: number;
}

export interface Goal {
  id: number;
  period: 'WEEK' | 'MONTH';
  categoryId: number;
  capValueInBase: number;
  originalUnitId?: number;
  disposition: 'GOOD' | 'BAD' | 'MIXED';
  impact: 'MILD' | 'MODERATE' | 'SEVERE';
}

// Repository interfaces
export interface IUnitRepository {
  getAll(): Promise<Unit[]>;
  getById(id: number): Promise<Unit | null>;
  create(unit: Omit<Unit, 'id'>): Promise<number>;
}

export interface ICategoryRepository {
  getAll(): Promise<Category[]>;
  getById(id: number): Promise<Category | null>;
}

export interface IMealTypeRepository {
  getAll(): Promise<MealType[]>;
  getById(id: number): Promise<MealType | null>;
  create(mealType: Omit<MealType, 'id' | 'isBuiltin'>): Promise<number>;
  update(mealType: MealType): Promise<void>;
  delete(id: number): Promise<void>;
}

export interface IProductRepository {
  getAll(): Promise<Product[]>;
  getById(id: number): Promise<Product | null>;
  create(product: Omit<Product, 'id'>): Promise<number>;
  update(product: Product): Promise<void>;
  delete(id: number): Promise<void>;
}

export interface IProductCategoryValueRepository {
  getForProduct(productId: number): Promise<ProductCategoryValue[]>;
  upsert(value: ProductCategoryValue): Promise<void>;
}

export interface IProductUnitOverrideRepository {
  getOverride(productId: number, unitId: number): Promise<number | null>;
  upsert(override: ProductUnitOverride): Promise<void>;
}

export interface IMealRepository {
  getAll(): Promise<Meal[]>;
  getById(id: number): Promise<Meal | null>;
  create(meal: Omit<Meal, 'id'>): Promise<number>;
}

export interface IMealItemRepository {
  getForMeal(mealId: number): Promise<MealItem[]>;
  add(item: Omit<MealItem, 'id'>): Promise<number>;
}

export interface IMealCustomEntryRepository {
  getForMeal(mealId: number): Promise<MealCustomEntry[]>;
  add(entry: Omit<MealCustomEntry, 'id'>): Promise<number>;
}

export interface ILogRepository {
  getAll(): Promise<LogEntry[]>;
  getById(id: number): Promise<LogEntry | null>;
  getByDate(date: string): Promise<LogEntry[]>;
  getInRange(start: string, end: string): Promise<LogEntry[]>;
  create(entry: Omit<LogEntry, 'id'>): Promise<number>;
  update(id: number, entry: Omit<LogEntry, 'id'>): Promise<void>;
  delete(id: number): Promise<void>;
}

export interface IGoalRepository {
  getAll(): Promise<Goal[]>;
  getById(id: number): Promise<Goal | null>;
  create(goal: Omit<Goal, 'id'>): Promise<number>;
  update(id: number, goal: Omit<Goal, 'id'>): Promise<void>;
  delete(id: number): Promise<void>;
}

