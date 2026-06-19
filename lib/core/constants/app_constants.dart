/// App-wide constants for Honey
class AppConstants {
  // Pomodoro durations (in seconds)
  static const int focusSessionDuration = 25 * 60; // 25 minutes
  static const int shortBreakDuration = 5 * 60; // 5 minutes
  static const int longBreakDuration = 15 * 60; // 15 minutes
  static const int sessionsBeforeLongBreak = 4; // Long break every 4 sessions

  // Pet stats limits
  static const int maxHunger = 100;
  static const int maxHygiene = 100;
  static const int maxHappiness = 100;

  // Coin constants
  static const int coinsPerSession = 10; // Coins earned per focus session
  static const int coinsPerLevel = 5; // Bonus coins per completed level
  static const String coinEmoji = '🍯'; // Honey emoji

  // Experience/Level constants
  static const int xpPerSession = 50;
  static const int xpPerLevel = 500;

  // Pet decay rates (points per minute idle)
  static const double hungerDecayRate = 0.5; // Hunger increases
  static const double hygieneDecayRate = 0.3;
  static const double happinessDecayRate = 0.2;

  // Notification settings
  static const bool enableNotifications = true;
  static const bool enableSoundEffects = true;
  static const bool enableVibration = true;

  // App metadata
  static const String appName = 'Honey';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Honey Team';

  // Empty constructor to prevent instantiation
  AppConstants._();
}
