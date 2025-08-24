import { computeBaseTotals, MealProductItem, CustomEntry } from '../src/utils/mealTotals';

describe('computeBaseTotals', () => {
  it('sums product items and custom entries', () => {
    const items: MealProductItem[] = [
      {
        key: '1',
        product: { id: 1, name: 'Apple' },
        quantity: '2',
        categoryValues: { 1: 50, 2: 1 },
      } as any,
    ];
    const customs: CustomEntry[] = [
      { key: 'c1', categoryId: 1, unitId: 14, value: '30', valueInBase: 30 },
    ];
    const totals = computeBaseTotals(items, customs);
    expect(totals[1]).toBeCloseTo(130); // 50*2 + 30
    expect(totals[2]).toBeCloseTo(2); // 1*2
  });
});
