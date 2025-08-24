import React, {useEffect} from 'react';
import {View, Text, Button} from 'react-native';
import {useTranslation} from 'react-i18next';
import useOnboardingStore from '../store/onboardingStore';

const OnboardingScreen = () => {
  const {t} = useTranslation();
  const complete = useOnboardingStore(state => state.complete);
  const hydrate = useOnboardingStore(state => state.hydrate);

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  return (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
      <Text>{t('onboarding.welcome')}</Text>
      <Button title={t('onboarding.getStarted')} onPress={complete} />
    </View>
  );
};

export default OnboardingScreen;
