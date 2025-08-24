import React, { useEffect, useState } from 'react';
import { useDispatch } from 'react-redux';
import { setAll } from '../../store/preferencesSlice';
import PreferencesManager from './PreferencesManager';

export const PreferencesProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const dispatch = useDispatch();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    (async () => {
      const prefs = await PreferencesManager.getAll();
      dispatch(setAll(prefs));
      setReady(true);
    })();
  }, [dispatch]);

  if (!ready) {
    return null;
  }
  return <>{children}</>;
};

export default PreferencesProvider;
