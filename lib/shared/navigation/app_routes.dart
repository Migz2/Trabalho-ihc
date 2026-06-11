/// Route constants for Honey app
class AppRoutes {
  // Root routes
  static const String root = '/';
  static const String onboarding = '/onboarding';

  // Shell routes (bottom navigation)
  static const String shell = '/shell';
  static const String focus = '/focus';
  static const String pet = '/pet';
  static const String history = '/history';
  static const String settings = '/settings';

  // Feature routes
  static const String focusSession = '/focus/session';
  static const String petDetails = '/pet/details';
  static const String shop = '/shop';
  static const String shopCategory = '/shop/:category';
  static const String settingsProfile = '/settings/profile';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsTheme = '/settings/theme';

  // Empty constructor to prevent instantiation
  AppRoutes._();
}
