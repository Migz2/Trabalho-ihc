/// Core constants for the Honey App
class AppConstants {
  AppConstants._();

  // Pomodoro Durations (in seconds)
  static const int focusSessionDuration = 25 * 60; // 25 minutes
  static const int shortBreakDuration = 5 * 60; // 5 minutes
  static const int longBreakDuration = 15 * 60; // 15 minutes
  static const int sessionsBeforeLongBreak = 4;

  // Pet-related
  static const int maxPetHunger = 100;
  static const int maxPetHygiene = 100;
  static const int maxPetHappiness = 100;

  // Shop & Currency
  static const int startingCoins = 248;
  static const String currencySymbol = '🍯';

  // Limits & Thresholds
  static const int maxHistoryDays = 365;
  static const int minFocusTimeMinutes = 1;
  static const int maxFocusTimeMinutes = 120;

  // Onboarding
  static const bool showOnboardingByDefault = true;

  // App info
  static const String appName = 'Honey';
  static const String appVersion = '1.0.0';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration veryLongAnimationDuration = Duration(milliseconds: 1000);
}
