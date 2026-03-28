# PLANORA Setup Guide

This guide covers the full local environment, platform prerequisites, compile-time configuration, and the commands needed to build and run PLANORA.

## Current Environment Truth

The machine used during implementation currently has:

- Flutter `3.41.6`
- Dart `3.11.4`
- Java `17.0.18`
- Xcode `26.2`
- CocoaPods `1.16.2`

It does **not** currently have an Android SDK configured, so Android setup requires Android Studio + SDK installation and a `flutter config --android-sdk ...` step.

## 1. Required Tooling

Install these before running the app:

- Flutter stable
- Dart SDK matching the bundled Flutter version
- JDK 17
- Xcode + Command Line Tools + CocoaPods for iOS
- Android Studio with Android SDK + platform tools for Android

Useful checks:

```bash
flutter --version
dart --version
java -version
xcodebuild -version
flutter doctor -v
```

## 2. Clone And Enter The Project

```bash
cd /Users/mac/Desktop/CODE/student-planner
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Generate Freezed / JSON / Drift Code

Run codegen whenever domain models, DAOs, or Drift tables change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

During active development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 5. Android Setup

### Install Android Studio And SDK

1. Install Android Studio from the official Android site.
2. Open Android Studio once and install:
   - Android SDK
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools
   - At least one recent Android platform image
3. Create an emulator from the Device Manager.

### Point Flutter To The SDK

If Flutter does not find the SDK automatically:

```bash
flutter config --android-sdk /Users/<your-user>/Library/Android/sdk
```

Then accept licenses:

```bash
flutter doctor --android-licenses
flutter doctor -v
```

### Run On Android

```bash
flutter emulators
flutter emulators --launch <emulator-id>
flutter run
```

## 6. iOS Setup

### Xcode And CocoaPods

Make sure these work:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
pod --version
```

Install pods after the first `flutter pub get`:

```bash
cd ios
pod install
cd ..
```

### Run On iOS Simulator

```bash
open -a Simulator
flutter devices
flutter run -d ios
```

## 7. Runtime Environment Flags

PLANORA uses compile-time `dart-define` flags rather than a runtime `.env` package.

### Supported Flags

- `API_BASE_URL`
  - Default: `https://api.planora.app`
  - Use your own API host for remote auth/sync.
- `REMOTE_SERVICES_ENABLED`
  - Default: `false`
  - Enables remote auth/sync network calls.
- `GOOGLE_SIGN_IN_ENABLED`
  - Default: `false`
  - Enables the Google sign-in flow in the UI.

### Local-Only Development

Recommended while no backend is connected:

```bash
flutter run \
  --dart-define=REMOTE_SERVICES_ENABLED=false \
  --dart-define=GOOGLE_SIGN_IN_ENABLED=false
```

### Remote-Connected Development

```bash
flutter run \
  --dart-define=API_BASE_URL=https://your-api-host.example.com \
  --dart-define=REMOTE_SERVICES_ENABLED=true \
  --dart-define=GOOGLE_SIGN_IN_ENABLED=true
```

## 8. Google Sign-In Platform Setup

`GOOGLE_SIGN_IN_ENABLED=true` is not enough by itself. You must also configure native platform credentials.

### Android

1. Create an OAuth client for Android in Google Cloud Console.
2. Use the correct package name and SHA-1/SHA-256 signing keys.
3. Add the required Google configuration for the `google_sign_in` package if your backend flow expects it.

### iOS

1. Create an OAuth client for iOS in Google Cloud Console.
2. Add the reversed client ID to `Info.plist` URL schemes if required by your sign-in flow.
3. Make sure the iOS bundle identifier matches the one registered in Google Cloud.

If platform config is missing, the app is expected to fail gracefully instead of crashing.

## 9. Notifications

PLANORA uses local notifications for:

- task reminders
- Pomodoro completion alerts

Android permissions and notification channel wiring are already included in the app project. On iOS, the app requests notification permissions on startup.

## 10. Import / Export

The app supports:

- CSV import/export
- ICS import/export
- Share sheet export

No extra setup is required for local usage beyond platform file-picker/share permissions provided by Flutter packages.

## 11. Verification Commands

Use this sequence before shipping changes:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
```

## 12. CI Secrets

The GitHub Actions workflow expects:

- `API_BASE_URL`

If you later enforce remote-connected release builds, keep the same secret name in repository settings.

## 13. Troubleshooting

### Flutter finds no Android SDK

```bash
flutter doctor -v
flutter config --android-sdk /Users/<your-user>/Library/Android/sdk
flutter doctor --android-licenses
```

### iOS pods fail

```bash
cd ios
rm -rf Pods Podfile.lock
pod repo update
pod install
cd ..
```

### Codegen files are stale

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Remote auth/sync feels broken locally

Start with:

```bash
flutter run \
  --dart-define=REMOTE_SERVICES_ENABLED=false \
  --dart-define=GOOGLE_SIGN_IN_ENABLED=false
```

Then enable remote flags only after API and Google platform credentials are confirmed.
