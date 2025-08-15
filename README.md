# Food App

A starter Flutter project providing the basic UI structure and navigation for the **Food App**.

## Prerequisites
- [Flutter SDK 3.x](https://docs.flutter.dev/get-started/install)
- Android Studio with Android SDK or Xcode
- Java Development Kit (JDK 11 or later)

## Getting Started
1. Clone the repository and open it in your IDE:
   ```bash
   git clone <repo-url>
   cd food_app
   ```
2. Fetch the dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on an emulator or physical device:
   ```bash
   flutter run
   ```

## Project Structure
```plaintext
lib/
├── app.dart
├── main.dart
├── routing/
│   └── app_router.dart
├── widgets/
│   └── app_scaffold.dart
└── features/
    ├── logs/ui/logs_screen.dart
    ├── meals/ui/meals_screen.dart
    ├── products/ui/products_screen.dart
    ├── statistics/ui/statistics_screen.dart
    └── settings/ui/settings_screen.dart
```

## Notes
- The current build focuses solely on UI and navigation.
- Features such as data import/export, QR scanning, and other business logic are **not** implemented in this phase.
