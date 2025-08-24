import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import {
  Preferences,
  UnitSystem,
  VitaminsMode,
  ThemeMode,
} from '../services/preferences/PreferencesManager';

const initialState: Preferences = {
  unitSystem: 'metric',
  vitaminsMode: 'bucket',
  themeMode: 'system',
  enableBarcode: false,
  enableExport: false,
  debugSampleData: false,
};

const preferencesSlice = createSlice({
  name: 'preferences',
  initialState,
  reducers: {
    setUnitSystem(state, action: PayloadAction<UnitSystem>) {
      state.unitSystem = action.payload;
    },
    setVitaminsMode(state, action: PayloadAction<VitaminsMode>) {
      state.vitaminsMode = action.payload;
    },
    setThemeMode(state, action: PayloadAction<ThemeMode>) {
      state.themeMode = action.payload;
    },
    setEnableBarcode(state, action: PayloadAction<boolean>) {
      state.enableBarcode = action.payload;
    },
    setEnableExport(state, action: PayloadAction<boolean>) {
      state.enableExport = action.payload;
    },
    setDebugSampleData(state, action: PayloadAction<boolean>) {
      state.debugSampleData = action.payload;
    },
    setAll(state, action: PayloadAction<Partial<Preferences>>) {
      Object.assign(state, action.payload);
    },
  },
});

export const {
  setUnitSystem,
  setVitaminsMode,
  setThemeMode,
  setEnableBarcode,
  setEnableExport,
  setDebugSampleData,
  setAll,
} = preferencesSlice.actions;

export default preferencesSlice.reducer;
