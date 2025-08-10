# Food Tracker

A cross-platform food tracker built with Flutter. It uses local storage to keep track of products, meals and logged entries.

## Features

- Manage products with nutritional info
- Create meals from products
- Log what you eat
- View goals and simple statistics
- Bottom navigation to switch between sections

This project contains only a minimal scaffold and is intended as a starting point for development.

## Install on Android

You can build an APK and install it on an Android device:

1. [Install Flutter](https://docs.flutter.dev/get-started/install) and the Android SDK.
2. Generate the platform folders (only needed the first time):
   ```bash
   flutter create .
   ```
3. Fetch dependencies and build the release APK:
   ```bash
   flutter pub get
   flutter build apk --release
   ```
4. The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`. Transfer it to your device and install it manually or via `adb install`.
5. Alternatively, download a pre-built APK from the **Android Build** workflow artifacts available on GitHub.
