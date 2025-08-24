import { StatsService } from '../src/services/StatsService';
import { ConversionService } from '../src/services/ConversionService';
import { ILogRepository, IMealItemRepository, IMealCustomEntryRepository, IProductCategoryValueRepository, Goal } from '../src/services/repositories/types';

const logRepo: ILogRepository = {
  async getAll() { return []; },
  async getById() { return null; },
  async getByDate() { return []; },
  async getInRange() {
    return [{ id:1, mealId:1, loggedAtLocal:'2025-01-01T12:00:00', mealTypeId:1 }];
  },
  async create() { return 1; },
  async update() {},
  async delete() {},
};

const mealItemRepo: IMealItemRepository = {
  async getForMeal() { return [{ id:1, mealId:1, productId:1, quantity:1 }]; },
  async add() { return 1; },
};

const mealCustomRepo: IMealCustomEntryRepository = {
  async getForMeal() { return []; },
  async add() { return 1; },
};

const productValueRepo: IProductCategoryValueRepository = {
  async getForProduct() { return [{ productId:1, categoryId:1, valueInBase:100, originalUnitId:1 }]; },
  async upsert() {},
};

const unitRepo = {
  async getAll() { return []; },
  async getById() { return null; },
  async create() { return 0; },
};
const overrideRepo = { async getOverride() { return null; }, async upsert() {} };
const conversion = new ConversionService(unitRepo as any, overrideRepo as any);
const stats = new StatsService(logRepo, mealItemRepo, mealCustomRepo, productValueRepo, conversion);

test('aggregates weekly totals and evaluates goal', async () => {
  const weekStart = new Date('2025-01-01');
  const totals = await stats.getWeeklyTotals(1, weekStart);
  expect(totals[0].totalInBase).toBe(100);
  const goal: Goal = { id:1, period:'WEEK', categoryId:1, capValueInBase:500, originalUnitId:1, disposition:'GOOD', impact:'MILD' };
  const status = stats.evaluateGoal(goal, totals[0].totalInBase);
  expect(status.disposition).toBe('GOOD');
});
