# LOCKED IN

LOCKED IN is a premium dark, emerald and gold Flutter app for fitness, study, habits and the wider glow-up. It is designed as one codebase for Android, Windows and web, with local-first writes so logging remains useful without signal.

## Included

- Flutter client with clean `core/` + `features/` architecture.
- Five-tab navigation: Home, Train, Mind, Life and Squad.
- Onboarding/personalisation: name, height, weight, physique, dietary profile and lock-in intensity.
- Offline local persistence through `shared_preferences`; workouts, foods, habits, water, XP, streak and profile survive restarts.
- Workout logging: exercise, variation, sets, reps, weight, recent history and rest timer.
- Daily habits: water, creatine, AM skincare, study block and cold shower.
- Adaptive hydration and protein targets from bodyweight.
- Quick food logging with calories and protein totals.
- Pomodoro study timer, study completion XP and learn-why notes.
- Streaks, XP multipliers, levels (Iron / Steel / Titan), dashboard progress and four glow-up track cards.
- Squad leaderboard shell, private-by-design settings, and goal timeline shell.
- Roadmap stubs are explicit in the UI and `roadmap.md`; unfinished integrations are not presented as working.

## Run/build

```bash
flutter pub get
flutter run
flutter run -d chrome
flutter run -d windows
flutter build apk --release
flutter build web --release
flutter build windows --release
```

`.github/workflows/flutter.yml` analyzes/tests the code and builds Android APK, web, and Windows artifacts. This repository commit contains source and CI, not prebuilt binary files.

## Architecture

`lib/core/app_state.dart` is the local-first state/persistence boundary. Features are split into `onboarding`, `dashboard`, `glow_tracks`, `train`, `mind`, `life`, `squad`, and `settings`. A future sync adapter can observe this boundary and implement REST pull/push, per-field last-write-wins, retries and conflict prompts without rewriting feature UI.

## Full vision

The larger vision includes private invite-only squads, a self-hosted REST server, bidirectional sync, health/wearable integrations, AI coach and form check, meal plans and barcode/photo nutrition, skin and appearance systems, multi-sport activity support, study/exam planning, recovery and growth science, skill drills, arcs, competitions, feed/chat, widgets, NFC, exports, and a complete gamification economy. See `roadmap.md` for honest implementation status.

## Privacy/safety

Core state is local-first. No analytics, ads or third-party telemetry are included. Health, body-photo, supplement, fasting and growth features need careful consent, age-appropriate guidance and medical disclaimers before production expansion. Fasting, supplements and training are optional and are not medical advice.

## License

No license has been selected yet. Add one before accepting external contributions.
