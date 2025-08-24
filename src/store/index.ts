import { configureStore, createSlice, PayloadAction } from '@reduxjs/toolkit';
import { LogEntry } from '../services/repositories/LogRepository';
import preferencesReducer from './preferencesSlice';

const logsSlice = createSlice({
  name: 'logs',
  initialState: [] as LogEntry[],
  reducers: {
    addLog(state, action: PayloadAction<LogEntry>) {
      state.push(action.payload);
    },
  },
});

export const { addLog } = logsSlice.actions;

export const store = configureStore({
  reducer: {
    logs: logsSlice.reducer,
    preferences: preferencesReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
