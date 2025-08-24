import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Provider } from 'react-redux';
import { store } from './store';
import LogsScreen from './screens/LogsScreen';
import SettingsScreen from './screens/SettingsScreen';
import { ServicesProvider } from './services/ServiceContext';
import { PreferencesProvider } from './services/preferences/PreferencesProvider';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <Provider store={store}>
      <ServicesProvider>
        <PreferencesProvider>
          <NavigationContainer>
            <Stack.Navigator>
              <Stack.Screen name="Logs" component={LogsScreen} />
              <Stack.Screen name="Settings" component={SettingsScreen} />
            </Stack.Navigator>
          </NavigationContainer>
        </PreferencesProvider>
      </ServicesProvider>
    </Provider>
  );
}

