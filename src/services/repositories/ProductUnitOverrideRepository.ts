import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IProductUnitOverrideRepository, ProductUnitOverride } from './types';

function mapRow(row: any): ProductUnitOverride {
  return {
    productId: row.product_id,
    unitId: row.unit_id,
    factorToBase: row.factor_to_base,
  };
}

export class ProductUnitOverrideRepository implements IProductUnitOverrideRepository {
  constructor(private db: SQLiteDatabase) {}

  async getOverride(productId: number, unitId: number): Promise<number | null> {
    const [res] = await this.db.executeSql(
      'SELECT factor_to_base FROM product_unit_overrides WHERE product_id = ? AND unit_id = ?',
      [productId, unitId]
    );
    if (res.rows.length === 0) return null;
    return res.rows.item(0).factor_to_base;
  }

  async upsert(override: ProductUnitOverride): Promise<void> {
    await this.db.executeSql(
      `INSERT OR REPLACE INTO product_unit_overrides
       (product_id, unit_id, factor_to_base)
       VALUES (?, ?, ?)`,
      [override.productId, override.unitId, override.factorToBase]
    );
  }
}

