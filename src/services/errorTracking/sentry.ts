import * as Sentry from '@sentry/react-native';

if (!__DEV__) {
  Sentry.init({
    dsn: 'https://examplePublicKey@o0.ingest.sentry.io/0',
    tracesSampleRate: 1.0,
  });
}
