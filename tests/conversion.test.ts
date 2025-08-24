import { ouncesToGrams } from '../src/utils/conversion';

test('converts ounces to grams', () => {
  expect(ouncesToGrams(1)).toBeCloseTo(28.3495);
});
