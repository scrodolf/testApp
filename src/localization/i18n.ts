import i18n from 'i18next';
import {initReactI18next} from 'react-i18next';
import * as RNLocalize from 'react-native-localize';

const resources = {
  en: {
    translation: {
      onboarding: {
        welcome: 'Welcome to TestApp',
        getStarted: 'Get Started',
      },
    },
  },
};

const language = RNLocalize.getLocales()[0]?.languageCode || 'en';

i18n.use(initReactI18next).init({
  compatibilityJSON: 'v3',
  resources,
  lng: language,
  fallbackLng: 'en',
  interpolation: {escapeValue: false},
});

export default i18n;
