import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IProductCategoryValueRepository, ProductCategoryValue } from './types';

function mapRow(row: any): ProductCategoryValue {
  return {
    productId: row.product_id,
    categoryId: row.category_id,
    valueInBase: row.value_in_base,
    originalUnitId: row.original_unit_id ?? undefined,
  };
}

export class ProductCategoryValueRepository implements IProductCategoryValueRepository {
  constructor(private db: SQLiteDatabase) {}

  async getForProduct(productId: number): Promise<ProductCategoryValue[]> {
    const [res] = await this.db.executeSql(
      'SELECT * FROM product_category_values WHERE product_id = ?',
      [productId]
    );
    const values: ProductCategoryValue[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      values.push(mapRow(res.rows.item(i)));
    }
    return values;
  }

  async upsert(value: ProductCategoryValue): Promise<void> {
    await this.db.executeSql(
      `INSERT OR REPLACE INTO product_category_values
       (product_id, category_id, value_in_base, original_unit_id)
       VALUES (?, ?, ?, ?)`,
      [value.productId, value.categoryId, value.valueInBase, value.originalUnitId ?? null]
    );
  }
}

