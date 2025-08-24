import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Provider } from 'react-redux';
import { store } from './store';
import LogsScreen from './screens/LogsScreen';
import { ServicesProvider } from './services/ServiceContext';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <Provider store={store}>
      <ServicesProvider>
        <NavigationContainer>
          <Stack.Navigator>
            <Stack.Screen name="Logs" component={LogsScreen} />
          </Stack.Navigator>
        </NavigationContainer>
      </ServicesProvider>
    </Provider>
  );
}

