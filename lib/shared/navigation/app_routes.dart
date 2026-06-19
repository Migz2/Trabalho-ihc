/// Centralized route constants for the Honey App
class AppRoutes {
  AppRoutes._();

  // Root routes
  static const String root = '/';
  static const String onboarding = '/onboarding';

  // Main shell routes
  static const String focus = '/focus';
  static const String pet = '/pet';
  static const String history = '/history';
  static const String settings = '/settings';

  // Feature routes
  static const String timerDetail = '/focus/detail';
  static const String petDetail = '/pet/detail';
  static const String shop = '/pet/shop';
  static const String shopItemDetail = '/pet/shop/:itemId';
  static const String statisticsDetail = '/history/detail';
  static const String settingsDetail = '/settings/:section';

  // Auth & Onboarding
  static const String onboardingName = '/onboarding/name';
  static const String onboardingPet = '/onboarding/pet';
  static const String onboardingSettings = '/onboarding/settings';

  // Helper to extract route name for UI
  static String getRouteName(String route) {
    return route.replaceAll('/', ' ').trim().capitalizeWords;
  }
}

extension StringHelper on String {
  String get capitalizeWords {
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
