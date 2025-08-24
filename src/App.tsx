import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Provider, useSelector } from 'react-redux';
import { store } from './store';
import type { RootState } from './store';
import LogsScreen from './screens/LogsScreen';
import SettingsScreen from './screens/SettingsScreen';
import ProductListScreen from './screens/ProductListScreen';
import ProductEditorScreen from './screens/ProductEditorScreen';
import MealBuilderScreen from './screens/MealBuilderScreen';
import AddEditLogScreen from './screens/AddEditLogScreen';
import StatisticsScreen from './screens/StatisticsScreen';
import AddEditGoalScreen from './screens/AddEditGoalScreen';
import OnboardingScreen from './screens/OnboardingScreen';
import { ServicesProvider } from './services/ServiceContext';
import { PreferencesProvider } from './services/preferences/PreferencesProvider';

const Stack = createNativeStackNavigator();

function RootNavigator() {
  const onboardingComplete = useSelector((state: RootState) => state.preferences.onboardingComplete);
  return (
    <NavigationContainer>
      <Stack.Navigator>
        {onboardingComplete ? (
          <>
            <Stack.Screen name="Logs" component={LogsScreen} />
            <Stack.Screen name="AddEditLog" component={AddEditLogScreen} options={{ presentation: 'modal', title: 'Log' }} />
            <Stack.Screen name="Statistics" component={StatisticsScreen} />
            <Stack.Screen name="AddEditGoal" component={AddEditGoalScreen} options={{ presentation: 'modal', title: 'Goal' }} />
            <Stack.Screen name="Products" component={ProductListScreen} />
            <Stack.Screen name="ProductEditor" component={ProductEditorScreen} options={{ title: 'Product' }} />
            <Stack.Screen name="MealBuilder" component={MealBuilderScreen} options={{ title: 'Meal Builder' }} />
            <Stack.Screen name="Settings" component={SettingsScreen} />
          </>
        ) : (
          <Stack.Screen name="Onboarding" component={OnboardingScreen} options={{ headerShown: false }} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default function App() {
  return (
    <Provider store={store}>
      <ServicesProvider>
        <PreferencesProvider>
          <GestureHandlerRootView style={{ flex: 1 }}>
            <RootNavigator />
          </GestureHandlerRootView>
        </PreferencesProvider>
      </ServicesProvider>
    </Provider>
  );
}
