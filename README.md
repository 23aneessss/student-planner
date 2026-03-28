# PLANORA

PLANORA is a Flutter student planner built from the spec in [`.agent/prompt.md`](/Users/mac/Desktop/CODE/student-planner/.agent/prompt.md). It is a mobile-first, offline-first study planner with tasks, calendar planning, Pomodoro focus sessions, grades, optional cloud sync, and setup documentation for Android and iOS.

## What’s Included

- Offline-first local storage with Drift
- Riverpod-powered app state and routing guards
- Auth flow with local fallback and optional remote wiring
- Task management, calendar view, templates, import/export
- Pomodoro focus timer with local notifications
- Stats and grades surfaces
- Setup guide in [`docs/setup.md`](/Users/mac/Desktop/CODE/student-planner/docs/setup.md)

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=REMOTE_SERVICES_ENABLED=false --dart-define=GOOGLE_SIGN_IN_ENABLED=false
```

## Common Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
flutter run
```

## Runtime Config

Compile-time configuration uses `--dart-define`:

- `API_BASE_URL`
- `REMOTE_SERVICES_ENABLED`
- `GOOGLE_SIGN_IN_ENABLED`

Example:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.planora.app \
  --dart-define=REMOTE_SERVICES_ENABLED=true \
  --dart-define=GOOGLE_SIGN_IN_ENABLED=true
```

## Custom Art Assets

Drop your own UI art into these exact paths:

- Background: `assets/images/backgrounds/home_shell_bg.png`
- Bottom bar icons: `assets/icons/nav/home.png`
- Bottom bar icons: `assets/icons/nav/tasks.png`
- Bottom bar icons: `assets/icons/nav/calendar.png`
- Bottom bar icons: `assets/icons/nav/stats.png`
- Bottom bar icons: `assets/icons/nav/profile.png`

The app now uses your background image on the home shell when that file exists, and falls back to the built-in gradient if it does not. The bottom action bar also prefers your icon PNGs and falls back to Flutter icons until you replace them.

## Docs

- Product spec: [`.agent/prompt.md`](/Users/mac/Desktop/CODE/student-planner/.agent/prompt.md)
- Research notes: [`.agent/reportSearch.md`](/Users/mac/Desktop/CODE/student-planner/.agent/reportSearch.md)
- Visual implementation guardrails: [`.skills/SKILL.md`](/Users/mac/Desktop/CODE/student-planner/.skills/SKILL.md)
- Full setup and environment guide: [`docs/setup.md`](/Users/mac/Desktop/CODE/student-planner/docs/setup.md)
