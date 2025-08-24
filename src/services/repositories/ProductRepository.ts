import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { IProductRepository, Product } from './types';

function mapProduct(row: any): Product {
  return {
    id: row.id,
    name: row.name,
    defaultUnitId: row.default_unit_id ?? undefined,
    defaultSize: row.default_size ?? undefined,
  };
}

export class ProductRepository implements IProductRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<Product[]> {
    const [res] = await this.db.executeSql('SELECT * FROM products');
    const products: Product[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      products.push(mapProduct(res.rows.item(i)));
    }
    return products;
  }

  async getById(id: number): Promise<Product | null> {
    const [res] = await this.db.executeSql('SELECT * FROM products WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapProduct(res.rows.item(0));
  }

  async create(product: Omit<Product, 'id'>): Promise<number> {
    const [res] = await this.db.executeSql(
      'INSERT INTO products (name, default_unit_id, default_size) VALUES (?, ?, ?)',
      [product.name, product.defaultUnitId ?? null, product.defaultSize ?? null]
    );
    return res.insertId ?? 0;
  }

  async update(product: Product): Promise<void> {
    await this.db.executeSql(
      'UPDATE products SET name = ?, default_unit_id = ?, default_size = ? WHERE id = ?',
      [product.name, product.defaultUnitId ?? null, product.defaultSize ?? null, product.id]
    );
  }

  async delete(id: number): Promise<void> {
    await this.db.executeSql('DELETE FROM products WHERE id = ?', [id]);
  }
}

