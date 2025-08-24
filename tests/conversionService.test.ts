import { ConversionService } from '../src/services/ConversionService';
import { IUnitRepository, IProductUnitOverrideRepository, Unit } from '../src/services/repositories/types';

test('converts ounces to grams and back', async () => {
  const units: Record<number, Unit> = {
    1: { id: 1, name: 'Gram', symbol: 'g', dimension: 'MASS', factorToBase: 1, isCustom: false },
    3: { id: 3, name: 'Ounce', symbol: 'oz', dimension: 'MASS', factorToBase: 28.349523, isCustom: false },
    10: { id: 10, name: 'Cup', symbol: 'cup', dimension: 'VOLUME', factorToBase: 236.5882365, isCustom: false },
  };
  const unitRepo: IUnitRepository = {
    async getAll() { return Object.values(units); },
    async getById(id: number) { return units[id] ?? null; },
    async create() { return 0; },
  };
  const overrideRepo: IProductUnitOverrideRepository = {
    async getOverride() { return null; },
    async upsert() { },
  };
  const service = new ConversionService(unitRepo, overrideRepo);
  const grams = await service.ozToG(1);
  expect(grams).toBeCloseTo(28.3495);
  const ounces = await service.gToOz(grams);
  expect(ounces).toBeCloseTo(1);
});

test('handles display rounding separately from storage precision', async () => {
  const units: Record<number, Unit> = {
    3: { id: 3, name: 'Ounce', symbol: 'oz', dimension: 'MASS', factorToBase: 28.349523, isCustom: false },
  };
  const unitRepo: IUnitRepository = {
    async getAll() { return Object.values(units); },
    async getById(id: number) { return units[id] ?? null; },
    async create() { return 0; },
  };
  const overrideRepo: IProductUnitOverrideRepository = {
    async getOverride() { return null; },
    async upsert() {},
  };
  const service = new ConversionService(unitRepo, overrideRepo);
  const base = await service.toBase(0.12, 3);
  expect(base).toBeCloseTo(3.4019); // 0.12 * 28.349523 rounded to 4 decimals
  expect(service.display(base)).toBeCloseTo(3.4); // display rounding to 2 decimals
});

test('applies per-product unit overrides', async () => {
  const units: Record<number, Unit> = {
    100: { id: 100, name: 'Scoop', symbol: 'scoop', dimension: 'MASS', factorToBase: 5, isCustom: true },
  };
  const unitRepo: IUnitRepository = {
    async getAll() { return Object.values(units); },
    async getById(id: number) { return units[id] ?? null; },
    async create() { return 0; },
  };
  const overrideRepo: IProductUnitOverrideRepository = {
    async getOverride(productId: number, unitId: number) {
      if (productId === 1 && unitId === 100) return 7; // 1 scoop = 7 g for product 1
      return null;
    },
    async upsert() {},
  };
  const service = new ConversionService(unitRepo, overrideRepo);
  const gramsDefault = await service.toBase(1, 100); // generic scoop 5g
  expect(gramsDefault).toBe(5);
  const gramsOverride = await service.toBase(1, 100, 1); // product-specific override
  expect(gramsOverride).toBe(7);
});
