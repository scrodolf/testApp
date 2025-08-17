# Food App

A foundational Flutter project showcasing the basic UI layout for a future food tracking application. It features a bottom navigation bar with screens for Logs, Meals, Products, Statistics, and an extended Settings area.

## Prerequisites
- Flutter SDK (version 3.x)
- Android Studio or another Flutter-friendly IDE
- Android SDK and platform tools
- Java Development Kit (JDK)

## Getting Started
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd testApp
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app** on an emulator or connected device
   ```bash
   flutter run
   ```

## Features
- Manage custom measurement units and convert between metric and imperial systems.
- Edit the list of meal types (Breakfast, Lunch, Dinner by default).
- Light/Dark/System theme toggle.
- Experimental placeholders for QR code scanning and JSON data export/import.
- Optional detailed vitamin tracking mode.


## Building
- **Debug APK**
  ```bash
  flutter build apk --debug
  ```
- **Release APK**
  ```bash
  flutter build apk --release
  ```

## Notes
- Data export/import and QR scanning are stubbed; toggles are stored in SharedPreferences and opening the pages only displays explanatory placeholders. QR scanning requests camera permission.
- When running for the first time, the database seeds base units (gram, milliliter, kilocalorie) and meal types.
- If schema changes occur (e.g., after updating Drift tables), run `flutter pub run build_runner build` to regenerate database code.

## Troubleshooting
- Ensure that the Android emulator or device meets the minimum SDK level (API 24).
- If database migrations fail, delete the local `food_app.sqlite` in the app's documents directory and restart the app.
