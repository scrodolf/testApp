import PreferencesManager from '../src/services/preferences/PreferencesManager';

jest.mock('@react-native-async-storage/async-storage', () =>
  require('@react-native-async-storage/async-storage/jest/async-storage-mock'),
);

describe('PreferencesManager', () => {
  it('stores and retrieves unitSystem', async () => {
    await PreferencesManager.setUnitSystem('imperial');
    const value = await PreferencesManager.getUnitSystem();
    expect(value).toBe('imperial');
  });

  it('stores and retrieves boolean flags', async () => {
    await PreferencesManager.setEnableBarcode(true);
    const v = await PreferencesManager.getEnableBarcode();
    expect(v).toBe(true);
  });

  it('handles onboarding flag', async () => {
    await PreferencesManager.setOnboardingComplete(true);
    const done = await PreferencesManager.getOnboardingComplete();
    expect(done).toBe(true);
  });
});
