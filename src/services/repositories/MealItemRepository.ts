import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IMealItemRepository, MealItem } from './types';

function mapRow(row: any): MealItem {
  return {
    id: row.id,
    mealId: row.meal_id,
    productId: row.product_id,
    quantity: row.quantity,
  };
}

export class MealItemRepository implements IMealItemRepository {
  constructor(private db: SQLiteDatabase) {}

  async getForMeal(mealId: number): Promise<MealItem[]> {
    const [res] = await this.db.executeSql('SELECT * FROM meal_items WHERE meal_id = ?', [mealId]);
    const items: MealItem[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async add(item: Omit<MealItem, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO meal_items (meal_id, product_id, quantity) VALUES (?, ?, ?)',
      [item.mealId, item.productId, item.quantity]
    );
    return res.insertId ?? 0;
  }
}

