import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IGoalRepository, Goal } from './types';

function mapRow(row: any): Goal {
  return {
    id: row.id,
    period: row.period,
    categoryId: row.category_id,
    capValueInBase: row.cap_value_in_base,
    originalUnitId: row.original_unit_id ?? undefined,
    disposition: row.disposition,
    impact: row.impact,
  };
}

export class GoalRepository implements IGoalRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<Goal[]> {
    const [res] = await this.db.executeSql('SELECT * FROM goals');
    const items: Goal[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async getById(id: number): Promise<Goal | null> {
    const [res] = await this.db.executeSql('SELECT * FROM goals WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapRow(res.rows.item(0));
  }

  async create(goal: Omit<Goal, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO goals (period, category_id, cap_value_in_base, original_unit_id, disposition, impact) VALUES (?, ?, ?, ?, ?, ?)',
      [
        goal.period,
        goal.categoryId,
        goal.capValueInBase,
        goal.originalUnitId ?? null,
        goal.disposition,
        goal.impact,
      ]
    );
    return res.insertId ?? 0;
  }
}

