# TestApp React Native Rebuild

This project is a React Native rewrite of the previous Flutter application. It preserves functionality for onboarding, managing food products, meals, logs, and basic statistics.

## Requirements
- Node.js 18+
- Android SDK

## Installation
```bash
npm install
```

## Running
```bash
npm run android
```

## Testing
```bash
npm test
```

## Building APK
```bash
npm run build:apk
```

## Error Tracking
Sentry is configured to capture errors in production builds. Set your DSN in `src/services/errorTracking/sentry.ts`.

## Architecture
See `src/` for modular organization: screens, services, repositories, and stores.
