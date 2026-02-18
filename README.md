# REBO — Red Button

Cross-platform stress-relief app. *Nothing a button can't fix.*

## Features

- Red button with click sound and haptic feedback
- Score and high score with persistent storage
- Material Design 3, 6 platforms (iOS, Android, Web, Windows, macOS, Linux)

## Setup

```bash
cd app
flutter pub get
# If android/ios/web etc. are missing, run once:  flutter create .
# Add assets/audio/click.mp3 for sound, then:
flutter run
```

## Project structure (ready for roadmap)

```
lib/
├── main.dart
├── app.dart
├── features/
│   └── red_button/          # Phase 1
│       ├── red_button_page.dart
│       └── widgets/
│           └── red_button.dart
└── shared/
    └── services/
        └── storage_service.dart
```

Future: `features/` will grow (dual_button, food_decider, who_picker); `shared/` and optional `core/` for i18n, branding, navigation.

## License

MIT
