import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { ICategoryRepository, Category } from './types';

function mapCategory(row: any): Category {
  return {
    id: row.id,
    nameKey: row.name_key,
    dimension: row.dimension,
    isBuiltin: !!row.is_builtin,
  };
}

export class CategoryRepository implements ICategoryRepository {
  constructor(private db: SQLiteDatabase) {}

  async getAll(): Promise<Category[]> {
    const [res] = await this.db.executeSql('SELECT * FROM categories');
    const categories: Category[] = [];
    for (let i = 0; i < res.rows.length; i++) {
      categories.push(mapCategory(res.rows.item(i)));
    }
    return categories;
  }

  async getById(id: number): Promise<Category | null> {
    const [res] = await this.db.executeSql('SELECT * FROM categories WHERE id = ?', [id]);
    if (res.rows.length === 0) return null;
    return mapCategory(res.rows.item(0));
  }
}

