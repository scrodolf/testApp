import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Provider } from 'react-redux';
import { store } from './store';
import LogsScreen from './screens/LogsScreen';
import SettingsScreen from './screens/SettingsScreen';
import ProductListScreen from './screens/ProductListScreen';
import ProductEditorScreen from './screens/ProductEditorScreen';
import MealBuilderScreen from './screens/MealBuilderScreen';
import AddEditLogScreen from './screens/AddEditLogScreen';
import { ServicesProvider } from './services/ServiceContext';
import { PreferencesProvider } from './services/preferences/PreferencesProvider';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <Provider store={store}>
      <ServicesProvider>
        <PreferencesProvider>
          <GestureHandlerRootView style={{ flex: 1 }}>
            <NavigationContainer>
              <Stack.Navigator>
                <Stack.Screen name="Logs" component={LogsScreen} />
                <Stack.Screen name="AddEditLog" component={AddEditLogScreen} options={{ presentation: 'modal', title: 'Log' }} />
                <Stack.Screen name="Products" component={ProductListScreen} />
                <Stack.Screen name="ProductEditor" component={ProductEditorScreen} options={{ title: 'Product' }} />
                <Stack.Screen name="MealBuilder" component={MealBuilderScreen} options={{ title: 'Meal Builder' }} />
                <Stack.Screen name="Settings" component={SettingsScreen} />
              </Stack.Navigator>
            </NavigationContainer>
          </GestureHandlerRootView>
        </PreferencesProvider>
      </ServicesProvider>
    </Provider>
  );
}

