import AsyncStorage from '@react-native-async-storage/async-storage';

export interface Log {
  id: string;
  meal: string;
  date: string;
}

const KEY = 'logs';

export async function addLog(log: Log): Promise<void> {
  const existing = await AsyncStorage.getItem(KEY);
  const logs: Log[] = existing ? JSON.parse(existing) : [];
  logs.push(log);
  await AsyncStorage.setItem(KEY, JSON.stringify(logs));
}

export async function getLogs(): Promise<Log[]> {
  const existing = await AsyncStorage.getItem(KEY);
  return existing ? JSON.parse(existing) : [];
}
