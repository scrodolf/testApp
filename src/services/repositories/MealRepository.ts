import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IMealRepository, Meal } from './types';

function mapRow(row: any): Meal {
  return {
    id: row.id,
    name: row.name,
  };
}

export class MealRepository implements IMealRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<Meal[]> {
    const [res] = await this.db.executeSql('SELECT * FROM meals');
    const items: Meal[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async getById(id: number): Promise<Meal | null> {
    const [res] = await this.db.executeSql('SELECT * FROM meals WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapRow(res.rows.item(0));
  }

  async create(meal: Omit<Meal, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql('INSERT INTO meals (name) VALUES (?)', [meal.name]);
    return res.insertId ?? 0;
  }
}

