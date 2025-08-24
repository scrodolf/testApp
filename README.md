# Food Tracker React Native

This project rebuilds the original Flutter prototype into a React Native application.

## Prerequisites
- Node.js ≥ 18
- Android Studio and Android SDK
- Java JDK 11+
- Yarn or npm

## Setup
```bash
npm install
```

## Running
```bash
npx react-native start
npx react-native run-android
```

## Building APK
```bash
cd android && ./gradlew assembleRelease
```

## Testing
```bash
npm test
```

## Architecture
- `src/App.tsx` root component with React Navigation
- `src/screens` feature screens
- `src/services` data and integration layers
- `src/services/database` SQLite schema, migrations, and seeders
- `src/store` Redux Toolkit store
- `src/localization` i18next setup
- `src/theme` theming utilities

## Database
SQLite is used for offline-first persistence. The schema and seed data live in `src/services/database`. Call `initDatabase()` during app startup to ensure tables and built-in rows exist.

## Error Tracking
Sentry is initialized in `src/services/errorTracking`. Configure the DSN via environment variables for production.
