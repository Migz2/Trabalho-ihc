/// Centralized Hive box keys for Honey app
class HiveKeys {
  // Box names
  static const String userBox = 'userBox';
  static const String petBox = 'petBox';
  static const String sessionBox = 'sessionBox';
  static const String shopBox = 'shopBox';
  static const String settingsBox = 'settingsBox';
  static const String statisticsBox = 'statisticsBox';
  static const String onboardingBox = 'onboardingBox';

  // User keys
  static const String userIdKey = 'userId';
  static const String userNameKey = 'userName';
  static const String userAvatarKey = 'userAvatar';
  static const String totalCoinsKey = 'totalCoins';
  static const String totalXpKey = 'totalXp';
  static const String levelKey = 'level';
  static const String streakDaysKey = 'streakDays';
  static const String lastSessionDateKey = 'lastSessionDate';

  // Pet keys
  static const String petNameKey = 'petName';
  static const String petTypeKey = 'petType';
  static const String petHungerKey = 'petHunger';
  static const String petHygieneKey = 'petHygiene';
  static const String petHappinessKey = 'petHappiness';
  static const String petLevelKey = 'petLevel';
  static const String petAgeKey = 'petAge';
  static const String petSkinKey = 'petSkin';
  static const String petAccessoriesKey = 'petAccessories';

  // Session keys
  static const String sessionsListKey = 'sessionsList';
  static const String todaySessionsKey = 'todaySessions';
  static const String weekSessionsKey = 'weekSessions';
  static const String monthSessionsKey = 'monthSessions';

  // Shop keys
  static const String ownedItemsKey = 'ownedItems';
  static const String purchaseHistoryKey = 'purchaseHistory';
  static const String favoriteItemsKey = 'favoriteItems';

  // Settings keys
  static const String themeModeKey = 'themeMode'; // 'light', 'dark', 'system'
  static const String enableNotificationsKey = 'enableNotifications';
  static const String enableSoundKey = 'enableSound';
  static const String enableVibrationKey = 'enableVibration';
  static const String languageKey = 'language'; // 'pt', 'en'
  static const String focusSessionDurationKey = 'focusSessionDuration';
  static const String shortBreakDurationKey = 'shortBreakDuration';
  static const String longBreakDurationKey = 'longBreakDuration';

  // Statistics keys
  static const String totalSessionsKey = 'totalSessions';
  static const String totalFocusTimeKey = 'totalFocusTime';
  static const String bestStreakKey = 'bestStreak';
  static const String averageSessionKey = 'averageSession';
  static const String dailyStatsKey = 'dailyStats'; // Map<date, sessions>
  static const String weeklyStatsKey = 'weeklyStats';
  static const String monthlyStatsKey = 'monthlyStats';

  // Onboarding keys
  static const String onboardingCompletedKey = 'onboardingCompleted';
  static const String firstLaunchKey = 'firstLaunch';
  static const String tutorialSeenKey = 'tutorialSeen';

  // Empty constructor to prevent instantiation
  HiveKeys._();
}
