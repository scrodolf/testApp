import SQLite, { type SQLiteDatabase } from 'react-native-sqlite-storage';
import { createSchema } from './schema';
import { seedInitialData } from './seed';

SQLite.enablePromise(true);
const DB_NAME = 'food_tracker.db';

// Opens the database, creates schema if needed, and seeds initial data.
export async function initDatabase(): Promise<SQLiteDatabase> {
  const db = await SQLite.openDatabase({ name: DB_NAME, location: 'default' });
  await createSchema(db);
  await seedInitialData(db);
  return db;
}

