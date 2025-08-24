import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { ILogRepository, LogEntry } from './types';

function mapRow(row: any): LogEntry {
  return {
    id: row.id,
    mealId: row.meal_id,
    loggedAtLocal: row.logged_at_local,
    mealTypeId: row.meal_type_id ?? undefined,
  };
}

export class LogRepository implements ILogRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<LogEntry[]> {
    const [res] = await this.db.executeSql('SELECT * FROM logs ORDER BY logged_at_local DESC');
    const items: LogEntry[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async getById(id: number): Promise<LogEntry | null> {
    const [res] = await this.db.executeSql('SELECT * FROM logs WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapRow(res.rows.item(0));
  }

  async getByDate(date: string): Promise<LogEntry[]> {
    const start = `${date}T00:00:00`;
    const end = `${date}T23:59:59.999`;
    const [res] = await this.db.executeSql(
      'SELECT * FROM logs WHERE logged_at_local BETWEEN ? AND ? ORDER BY logged_at_local',
      [start, end]
    );
    const items: LogEntry[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async getInRange(start: string, end: string): Promise<LogEntry[]> {
    const [res] = await this.db.executeSql(
      'SELECT * FROM logs WHERE logged_at_local BETWEEN ? AND ? ORDER BY logged_at_local',
      [start, end]
    );
    const items: LogEntry[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      items.push(mapRow(res.rows.item(i)));
    }
    return items;
  }

  async create(entry: Omit<LogEntry, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO logs (meal_id, logged_at_local, meal_type_id) VALUES (?, ?, ?)',
      [entry.mealId, entry.loggedAtLocal, entry.mealTypeId ?? null]
    );
    return res.insertId ?? 0;
  }

  async update(id: number, entry: Omit<LogEntry, 'id'>): Promise<void> {
    await this.db.executeSql(
      'UPDATE logs SET meal_id = ?, logged_at_local = ?, meal_type_id = ? WHERE id = ?',
      [entry.mealId, entry.loggedAtLocal, entry.mealTypeId ?? null, id]
    );
  }

  async delete(id: number): Promise<void> {
    await this.db.executeSql('DELETE FROM logs WHERE id = ?', [id]);
  }
}

