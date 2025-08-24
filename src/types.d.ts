declare module 'react-native-sqlite-storage' {
  export type SQLiteDatabase = any;
  export type ResultSet = any;
  export function enablePromise(flag: boolean): void;
  export function openDatabase(options: any): Promise<SQLiteDatabase>;
}
