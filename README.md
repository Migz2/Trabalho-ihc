# 🍯 Honey — Productivity App with Pomodoro Timer & Virtual Pet

A beautiful Flutter app designed to boost productivity through Pomodoro focus sessions while caring for a virtual pet companion.

## 📋 About

Honey combines the effectiveness of the **Pomodoro Technique** with the engagement of a **virtual pet system**. Users earn coins through focused work sessions, which they can use to care for and customize their pet in an integrated shop.

### Key Features
- ⏱️ **Pomodoro Timer** with customizable durations
- 🐾 **Virtual Pet System** with hunger, hygiene, and happiness stats
- 🏪 **Shop System** for pet accessories and customizations
- 📊 **Statistics Dashboard** tracking focus sessions and productivity
- ⚙️ **Settings Panel** with notifications and preferences
- 🌓 **Dark Mode** with warm, honey-themed colors
- 🔔 **Local Notifications** for session reminders

---

## 🛠 Tech Stack

### Framework & Language
- **Flutter** 3.16+ with Null Safety
- **Dart** 3.0+

### State Management
- **Riverpod** with code generation for type-safe providers

### Navigation
- **GoRouter** for declarative routing

### Persistence
- **Hive** for fast, offline-first local storage

### UI & Design
- **Google Fonts** (Playfair Display + DM Sans)
- **Material Design 3** with custom theme
- **Flutter Animate** & **Lottie** for animations

### Additional Features
- **FL Chart** for statistics visualization
- **AudioPlayers** for sound effects
- **Flutter Local Notifications** for reminders
- **Permission Handler** for permissions
- **App Usage** for device tracking (statistics)

---

## 📦 Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or later
- Dart 3.0 or later
- Android Studio / Xcode (for emulator)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Migz2/Trabalho-ihc.git
   cd Trabalho-ihc
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Check code quality
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Build release
flutter build apk
```

---

## 📁 Project Structure

```
lib/
├── core/                 # Business logic & reusables
│   ├── constants/       # App constants & Hive keys
│   ├── theme/           # Design system (colors, typography)
│   ├── services/        # Hive initialization & CRUD
│   ├── errors/          # Exception definitions
│   ├── utils/           # Utility functions
│   └── extensions/      # Context & String helpers
│
├── shared/              # Shared across features
│   ├── widgets/         # Reusable UI components
│   └── navigation/      # GoRouter configuration
│
├── features/            # Feature modules (Clean Architecture)
│   ├── focus/           # Pomodoro timer feature
│   ├── pet/             # Virtual pet system
│   ├── shop/            # Item shop & purchases
│   ├── statistics/      # Session analytics
│   ├── settings/        # App preferences
│   └── onboarding/      # Initial setup flow
│
└── assets/              # Images, animations, fonts
```

---

## 🎨 Design System

### Color Palette
- **Primary:** #C17F3E (honey gold) / #D4924E (dark)
- **Background:** #FAF7F2 (light cream) / #1C1410 (dark warm)
- **Accent:** #F4A942 (soft orange)

### Typography
- **Display:** Playfair Display (elegant headlines)
- **Body:** DM Sans (readable, modern text)

### Spacing Scale
`4px, 8px, 16px, 24px, 32px, 48px`

### Border Radius
`8px, 12px, 16px, 24px, 100px (circular)`

---

## 🧪 Testing

Currently in **Phase 1** (Foundation). Test data and unit tests will be added in Phase 2.

```bash
flutter test
```

---

## 📝 Architecture

### Clean Architecture + Feature-Driven Design

Each feature follows:
```
feature/
├── data/
│   ├── datasources/    # API/Hive calls
│   ├── models/         # JSON serialization
│   └── repositories/   # Data access layer
├── domain/
│   ├── entities/       # Business models
│   ├── repositories/   # Abstract contracts
│   └── usecases/       # Business logic
└── presentation/
    ├── pages/          # Full screens
    ├── widgets/        # UI components
    └── providers/      # Riverpod state
```

---

## 🔄 Navigation

**Root Flow:**
1. App checks onboarding status in Hive
2. If not completed → `/onboarding`
3. Else → `/focus` (default tab)

**Bottom Navigation (4 Tabs):**
- 🎯 **Foco** (`/focus`) — Pomodoro timer
- 🐾 **Pet** (`/pet`) — Virtual pet display
- 📊 **Histórico** (`/history`) — Session analytics
- ⚙️ **Ajustes** (`/settings`) — Preferences

---

## 🚀 Roadmap

### Phase 1: ✅ Foundation (Current)
- [x] Design system implementation
- [x] Navigation infrastructure
- [x] Data persistence layer
- [x] Base UI widgets
- [x] Theme (light & dark mode)

### Phase 2: Feature Implementation
- [ ] Focus/Timer feature with sessions
- [ ] Pet entity & stats system
- [ ] Shop with items & purchases
- [ ] Statistics dashboard
- [ ] Settings & notifications
- [ ] Complete onboarding flow

### Phase 3: Polish & Release
- [ ] Animation refinements
- [ ] Sound effects & haptics
- [ ] Performance optimization
- [ ] Beta testing
- [ ] Release on Google Play Store

---

## 📱 Device Requirements

- **Android 5.0+** (API 21)
- **iOS 11.0+**
- Minimum 50MB free storage

---

## 🐛 Known Issues

None reported in Phase 1.

---

## 📄 License

MIT License — See LICENSE file

---

## 👥 Contributors

- **Miguel** — Lead Developer (IHC Project)

---

## 📞 Support

For issues and feature requests, please open an issue on GitHub.

---

**Made with 🍯 by Miguel**  
*Last updated: June 11, 2026*
