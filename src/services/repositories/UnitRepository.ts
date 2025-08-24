import type { SQLiteDatabase, ResultSet } from 'react-native-sqlite-storage';
import { IUnitRepository, Unit } from './types';

function mapUnit(row: any): Unit {
  return {
    id: row.id,
    name: row.name,
    symbol: row.symbol ?? undefined,
    dimension: row.dimension,
    factorToBase: row.factor_to_base,
    isCustom: !!row.is_custom,
  };
}

export class UnitRepository implements IUnitRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<Unit[]> {
    const [res] = await this.db.executeSql('SELECT * FROM units');
    const units: Unit[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      units.push(mapUnit(res.rows.item(i)));
    }
    return units;
  }

  async getById(id: number): Promise<Unit | null> {
    const [res] = await this.db.executeSql('SELECT * FROM units WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapUnit(res.rows.item(0));
  }

  async create(unit: Omit<Unit, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO units (name, symbol, dimension, factor_to_base, is_custom) VALUES (?, ?, ?, ?, ?)',
      [unit.name, unit.symbol ?? null, unit.dimension, unit.factorToBase, unit.isCustom ? 1 : 0]
    );
    return res.insertId ?? 0;
  }
}

