import AsyncStorage from '@react-native-async-storage/async-storage';

export type UnitSystem = 'metric' | 'imperial';
export type VitaminsMode = 'bucket' | 'specific';
export type ThemeMode = 'light' | 'dark' | 'system';

const KEYS = {
  unitSystem: 'pref_unitSystem',
  vitaminsMode: 'pref_vitaminsMode',
  themeMode: 'pref_themeMode',
  enableBarcode: 'pref_enableBarcode',
  enableExport: 'pref_enableExport',
  debugSampleData: 'pref_debugSampleData',
  onboardingComplete: 'pref_onboardingComplete',
};

export interface Preferences {
  unitSystem: UnitSystem;
  vitaminsMode: VitaminsMode;
  themeMode: ThemeMode;
  enableBarcode: boolean;
  enableExport: boolean;
  debugSampleData: boolean;
  onboardingComplete: boolean;
}

async function getBoolean(key: string, defaultValue = false): Promise<boolean> {
  const v = await AsyncStorage.getItem(key);
  return v === 'true' ? true : v === 'false' ? false : defaultValue;
}

export const PreferencesManager = {
  async getUnitSystem(): Promise<UnitSystem> {
    const v = await AsyncStorage.getItem(KEYS.unitSystem);
    return (v as UnitSystem) || 'metric';
  },
  async setUnitSystem(value: UnitSystem): Promise<void> {
    await AsyncStorage.setItem(KEYS.unitSystem, value);
  },
  async getVitaminsMode(): Promise<VitaminsMode> {
    const v = await AsyncStorage.getItem(KEYS.vitaminsMode);
    return (v as VitaminsMode) || 'bucket';
  },
  async setVitaminsMode(value: VitaminsMode): Promise<void> {
    await AsyncStorage.setItem(KEYS.vitaminsMode, value);
  },
  async getThemeMode(): Promise<ThemeMode> {
    const v = await AsyncStorage.getItem(KEYS.themeMode);
    return (v as ThemeMode) || 'system';
  },
  async setThemeMode(value: ThemeMode): Promise<void> {
    await AsyncStorage.setItem(KEYS.themeMode, value);
  },
  async getEnableBarcode(): Promise<boolean> {
    return getBoolean(KEYS.enableBarcode, false);
  },
  async setEnableBarcode(value: boolean): Promise<void> {
    await AsyncStorage.setItem(KEYS.enableBarcode, String(value));
  },
  async getEnableExport(): Promise<boolean> {
    return getBoolean(KEYS.enableExport, false);
  },
  async setEnableExport(value: boolean): Promise<void> {
    await AsyncStorage.setItem(KEYS.enableExport, String(value));
  },
  async getDebugSampleData(): Promise<boolean> {
    return getBoolean(KEYS.debugSampleData, false);
  },
  async setDebugSampleData(value: boolean): Promise<void> {
    await AsyncStorage.setItem(KEYS.debugSampleData, String(value));
  },
  async getOnboardingComplete(): Promise<boolean> {
    return getBoolean(KEYS.onboardingComplete, false);
  },
  async setOnboardingComplete(value: boolean): Promise<void> {
    await AsyncStorage.setItem(KEYS.onboardingComplete, String(value));
  },
  async getAll(): Promise<Preferences> {
    const [unitSystem, vitaminsMode, themeMode, enableBarcode, enableExport, debugSampleData, onboardingComplete] =
      await Promise.all([
        this.getUnitSystem(),
        this.getVitaminsMode(),
        this.getThemeMode(),
        this.getEnableBarcode(),
        this.getEnableExport(),
        this.getDebugSampleData(),
        this.getOnboardingComplete(),
      ]);
    return {
      unitSystem,
      vitaminsMode,
      themeMode,
      enableBarcode,
      enableExport,
      debugSampleData,
      onboardingComplete,
    };
  },
};

export default PreferencesManager;
