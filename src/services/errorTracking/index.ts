import * as Sentry from '@sentry/react-native';

export function initErrorTracking(): void {
  Sentry.init({
    dsn: 'https://examplePublicKey@o0.ingest.sentry.io/0',
  });
}
