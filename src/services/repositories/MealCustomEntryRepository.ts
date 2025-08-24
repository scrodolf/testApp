import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IMealCustomEntryRepository, MealCustomEntry } from './types';

function mapRow(row: any): MealCustomEntry {
  return {
    id: row.id,
    mealId: row.meal_id,
    categoryId: row.category_id,
    valueInBase: row.value_in_base,
    originalUnitId: row.original_unit_id ?? undefined,
  };
}

export class MealCustomEntryRepository implements IMealCustomEntryRepository {
  constructor(private db: SQLiteDatabase) {}

  async getForMeal(mealId: number): Promise<MealCustomEntry[]> {
    const [res] = await this.db.executeSql('SELECT * FROM meal_custom_entries WHERE meal_id = ?', [mealId]);
    const items: MealCustomEntry[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async add(entry: Omit<MealCustomEntry, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO meal_custom_entries (meal_id, category_id, value_in_base, original_unit_id) VALUES (?, ?, ?, ?)',
      [entry.mealId, entry.categoryId, entry.valueInBase, entry.originalUnitId ?? null]
    );
    return res.insertId ?? 0;
  }
}

