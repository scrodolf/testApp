import { Product } from '../services/repositories/types';

export interface MealProductItem {
  key: string;
  product: Product;
  quantity: string; // user entered quantity
  categoryValues: Record<number, number>; // per serving base values
}

export interface CustomEntry {
  key: string;
  categoryId: number;
  unitId: number;
  value: string;
  valueInBase: number;
}

// Computes totals in base units for all categories.
export function computeBaseTotals(
  items: MealProductItem[],
  customs: CustomEntry[],
): Record<number, number> {
  const totals: Record<number, number> = {};
  items.forEach((item) => {
    const qty = parseFloat(item.quantity) || 0;
    Object.entries(item.categoryValues).forEach(([cid, base]) => {
      const id = Number(cid);
      totals[id] = (totals[id] || 0) + base * qty;
    });
  });
  customs.forEach((c) => {
    totals[c.categoryId] = (totals[c.categoryId] || 0) + c.valueInBase;
  });
  return totals;
}
