import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IMealTypeRepository, MealType } from './types';

function mapMealType(row: any): MealType {
  return {
    id: row.id,
    nameKey: row.name_key,
    sortOrder: row.sort_order,
    isBuiltin: !!row.is_builtin,
  };
}

export class MealTypeRepository implements IMealTypeRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<MealType[]> {
    const [res] = await this.db.executeSql('SELECT * FROM meal_types ORDER BY sort_order');
    const items: MealType[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapMealType(res.rows.item(i)));
    }
    return items;
  }

  async getById(id: number): Promise<MealType | null> {
    const [res] = await this.db.executeSql('SELECT * FROM meal_types WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapMealType(res.rows.item(0));
  }

  async create(mealType: Omit<MealType, 'id' | 'isBuiltin'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO meal_types (name_key, sort_order, is_builtin) VALUES (?, ?, 0)',
      [mealType.nameKey, mealType.sortOrder],
    );
    return res.insertId ?? 0;
  }

  async update(mealType: MealType): Promise<void> {
    await this.db.executeSql(
      'UPDATE meal_types SET name_key = ?, sort_order = ?, is_builtin = ? WHERE id = ?',
      [mealType.nameKey, mealType.sortOrder, mealType.isBuiltin ? 1 : 0, mealType.id],
    );
  }

  async delete(id: number): Promise<void> {
    await this.db.executeSql('DELETE FROM meal_types WHERE id = ?', [id]);
  }
}

