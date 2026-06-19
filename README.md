# Honey App 🍯

A Flutter-based Android productivity app featuring a Pomodoro timer and virtual pet companion.

## Quick Start

### Prerequisites
- Flutter 3.16.0+
- Dart 3.0.0+

### Setup
```bash
# Install dependencies
flutter pub get

# Generate Riverpod code
dart run build_runner build

# Generate Hive code (if needed)
dart run build_runner build

# Run the app
flutter run
```

## Project Structure

- **lib/core** - Business logic layer (constants, theme, services)
- **lib/features** - Feature modules (focus, pet, statistics, settings, onboarding)
- **lib/shared** - Shared widgets and navigation

## Stack

- **Flutter** - UI framework
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Hive** - Local storage
- **Google Fonts** - Typography
- **Playfair Display** - Display typography
- **DM Sans** - Body typography

## Color Palette

### Light Mode
- Background: #FAF7F2 (warm cream)
- Primary: #C17F3E (honey gold)
- Accent: #F4A942 (soft orange)

### Dark Mode
- Background: #1C1410 (warm dark)
- Primary: #D4924E (lighter gold)
- Text: #F5EDE4 (light cream)

## Features

- ✓ Pomodoro timer
- ✓ Virtual pet system
- ✓ Statistics and history
- ✓ Dark mode support
- ✓ Persistent storage
- ✓ Settings customization

## Development

### Available Scripts

```bash
# Build app
flutter build apk

# Run tests
flutter test

# Generate code
dart run build_runner build --delete-conflicting-outputs
```

## Documentation

See [PROGRESS.md](PROGRESS.md) for detailed architecture decisions and phase completion status.

## License

Proprietary - Honey App © 2024
