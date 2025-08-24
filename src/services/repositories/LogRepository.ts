export interface LogEntry {
  id: number;
  message: string;
}

export class LogRepository {
  private logs: LogEntry[] = [];

  getAll(): LogEntry[] {
    return this.logs;
  }

  add(entry: LogEntry): void {
    this.logs.push(entry);
  }
}
