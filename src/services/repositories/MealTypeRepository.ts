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
}

