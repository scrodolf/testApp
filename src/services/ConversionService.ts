import { IUnitRepository, IProductUnitOverrideRepository } from './repositories/types';

function round(value: number, decimals: number): number {
  const factor = Math.pow(10, decimals);
  return Math.round(value * factor) / factor;
}

export class ConversionService {
  constructor(
    private units: IUnitRepository,
    private overrides: IProductUnitOverrideRepository
  ) {}

  private async factorFor(unitId: number, productId?: number): Promise<number> {
    if (productId) {
      const override = await this.overrides.getOverride(productId, unitId);
      if (override != null) return override;
    }
    const unit = await this.units.getById(unitId);
    if (!unit) throw new Error(`Unit ${unitId} not found`);
    return unit.factorToBase;
  }

  // Converts a value in the given unit to the base unit (g, mL, or kcal).
  async toBase(value: number, unitId: number, productId?: number): Promise<number> {
    const factor = await this.factorFor(unitId, productId);
    return round(value * factor, 4);
  }

  // Converts a base value to the target unit.
  async fromBase(baseValue: number, targetUnitId: number, productId?: number): Promise<number> {
    const factor = await this.factorFor(targetUnitId, productId);
    return round(baseValue / factor, 4);
  }

  // Rounds for display purposes (2 decimals).
  display(value: number): number {
    return round(value, 2);
  }

  // Mini converters for common editors.
  async ozToG(oz: number): Promise<number> {
    // unit id 3 in seed data
    return this.toBase(oz, 3);
  }

  async gToOz(g: number): Promise<number> {
    return this.fromBase(g, 3);
  }

  async cupToMl(cups: number, productId?: number): Promise<number> {
    // unit id 10 in seed data
    return this.toBase(cups, 10, productId);
  }

  async mlToCup(ml: number, productId?: number): Promise<number> {
    return this.fromBase(ml, 10, productId);
  }
}

