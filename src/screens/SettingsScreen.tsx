import React from 'react';
import {View, Button} from 'react-native';
import useOnboardingStore from '../store/onboardingStore';

const SettingsScreen = () => {
  const reset = useOnboardingStore(state => state.reset);
  return (
    <View style={{flex: 1}}>
      <Button title="Reset Onboarding" onPress={reset} />
    </View>
  );
};

export default SettingsScreen;
