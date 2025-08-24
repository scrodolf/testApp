import { ILogRepository, IMealItemRepository, IMealCustomEntryRepository, IProductCategoryValueRepository, Goal } from './repositories/types';
import { ConversionService } from './ConversionService';

export interface DailyTotal {
  date: string; // yyyy-mm-dd
  totalInBase: number;
}

export class StatsService {
  constructor(
    private logRepo: ILogRepository,
    private mealItemRepo: IMealItemRepository,
    private mealCustomRepo: IMealCustomEntryRepository,
    private productValueRepo: IProductCategoryValueRepository,
    private conversion: ConversionService
  ) {}

  private async mealTotals(mealId: number): Promise<Record<number, number>> {
    const items = await this.mealItemRepo.getForMeal(mealId);
    const totals: Record<number, number> = {};
    for (const item of items) {
      const values = await this.productValueRepo.getForProduct(item.productId);
      for (const val of values) {
        totals[val.categoryId] = (totals[val.categoryId] ?? 0) + val.valueInBase * item.quantity;
      }
    }
    const customs = await this.mealCustomRepo.getForMeal(mealId);
    for (const c of customs) {
      totals[c.categoryId] = (totals[c.categoryId] ?? 0) + c.valueInBase;
    }
    return totals;
  }

  private async totalsForRange(categoryId: number, start: Date, end: Date): Promise<Record<string, number>> {
    const logs = await this.logRepo.getInRange(start.toISOString(), end.toISOString());
    const totals: Record<string, number> = {};
    for (const log of logs) {
      const day = log.loggedAtLocal.substring(0, 10);
      const mealTotals = await this.mealTotals(log.mealId);
      const val = mealTotals[categoryId] ?? 0;
      totals[day] = (totals[day] ?? 0) + val;
    }
    return totals;
  }

  async getWeeklyTotals(categoryId: number, weekStart: Date): Promise<DailyTotal[]> {
    const start = new Date(weekStart);
    const end = new Date(weekStart);
    end.setDate(end.getDate() + 6);
    const totals = await this.totalsForRange(categoryId, start, end);
    const days: DailyTotal[] = [];
    for (let i = 0; i < 7; i++) {
      const d = new Date(start);
      d.setDate(start.getDate() + i);
      const key = d.toISOString().substring(0, 10);
      days.push({ date: key, totalInBase: totals[key] ?? 0 });
    }
    return days;
  }

  async getMonthlyCumulative(categoryId: number, monthStart: Date): Promise<DailyTotal[]> {
    const start = new Date(monthStart);
    const end = new Date(monthStart.getFullYear(), monthStart.getMonth() + 1, 0); // last day
    const totals = await this.totalsForRange(categoryId, start, end);
    const days: DailyTotal[] = [];
    let running = 0;
    for (let i = 0; i < end.getDate(); i++) {
      const d = new Date(start.getFullYear(), start.getMonth(), i + 1);
      const key = d.toISOString().substring(0, 10);
      running += totals[key] ?? 0;
      days.push({ date: key, totalInBase: running });
    }
    return days;
  }

  evaluateGoal(goal: Goal, consumedBase: number) {
    const ratio = consumedBase / goal.capValueInBase;
    if (ratio <= 1) return { disposition: 'GOOD', impact: 'MILD' } as const;
    if (ratio <= 1.25) return { disposition: 'MIXED', impact: 'MODERATE' } as const;
    return { disposition: 'BAD', impact: 'SEVERE' } as const;
  }

  display(valueBase: number, unitId: number, productId?: number) {
    return this.conversion.fromBase(valueBase, unitId, productId).then((v) => this.conversion.display(v));
  }
}
