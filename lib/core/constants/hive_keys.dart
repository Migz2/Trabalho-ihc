/// Centralized Hive storage keys for the Honey App
class HiveKeys {
  HiveKeys._();

  // Box names
  static const String userPreferencesBox = 'user_preferences';
  static const String petDataBox = 'pet_data';
  static const String focusSessionsBox = 'focus_sessions';
  static const String shopItemsBox = 'shop_items';
  static const String statisticsBox = 'statistics';

  // User Preferences Keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String userNameKey = 'user_name';
  static const String darkModeKey = 'dark_mode';
  static const String focusDurationKey = 'focus_duration';
  static const String shortBreakDurationKey = 'short_break_duration';
  static const String longBreakDurationKey = 'long_break_duration';
  static const String appBlockingIntensityKey = 'app_blocking_intensity';
  static const String notificationsMutedKey = 'notifications_muted';
  static const String ambientSoundKey = 'ambient_sound';

  // Pet Data Keys
  static const String petNameKey = 'pet_name';
  static const String petTypeKey = 'pet_type';
  static const String petLevelKey = 'pet_level';
  static const String petExperienceKey = 'pet_experience';
  static const String petHungerKey = 'pet_hunger';
  static const String petHygieneKey = 'pet_hygiene';
  static const String petHappinessKey = 'pet_happiness';
  static const String petLastFedKey = 'pet_last_fed';
  static const String petLastBathedKey = 'pet_last_bathed';
  static const String petLastPlayedKey = 'pet_last_played';

  // Coins & Shop Keys
  static const String coinsBalanceKey = 'coins_balance';
  static const String unlockedItemsKey = 'unlocked_items';

  // Statistics Keys
  static const String totalSessionsKey = 'total_sessions';
  static const String totalFocusTimeKey = 'total_focus_time';
  static const String currentStreakKey = 'current_streak';
  static const String longestStreakKey = 'longest_streak';
  static const String weeklyStatsKey = 'weekly_stats';
}
