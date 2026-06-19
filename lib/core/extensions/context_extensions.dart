import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Context extensions for easy access to theme and screen utilities
extension ContextExtension on BuildContext {
  // ─────────────────────────────────────────────
  // SCREEN SIZE UTILITIES
  // ─────────────────────────────────────────────

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Check if screen is in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if screen is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if screen is mobile (less than 600dp width)
  bool get isMobile => screenWidth < 600;

  /// Check if screen is tablet (600dp to 900dp)
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Check if screen is desktop (900dp or more)
  bool get isDesktop => screenWidth >= 900;

  /// Get horizontal padding based on screen size
  double get horizontalPadding => isMobile ? 16 : 24;

  /// Get bottom padding (for keyboard offset)
  double get bottomPadding => MediaQuery.of(this).viewInsets.bottom;

  // ─────────────────────────────────────────────
  // THEME UTILITIES
  // ─────────────────────────────────────────────

  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Get brightness
  Brightness get brightness => theme.brightness;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get primary color
  Color get primaryColor => colorScheme.primary;

  /// Get secondary color
  Color get secondaryColor => colorScheme.secondary;

  /// Get error color
  Color get errorColor => colorScheme.error;

  /// Get surface color
  Color get surfaceColor => colorScheme.surface;

  // ─────────────────────────────────────────────
  // HONEY APP THEME COLORS
  // ─────────────────────────────────────────────

  /// Get appropriate background color based on theme
  Color get backgroundColor => isDarkMode
      ? AppColors.darkBackground
      : AppColors.lightBackground;

  /// Get appropriate text primary color
  Color get textPrimaryColor =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  /// Get appropriate text secondary color
  Color get textSecondaryColor =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  /// Get appropriate divider color
  Color get dividerColor =>
      isDarkMode ? AppColors.darkDivider : AppColors.lightDivider;

  /// Get appropriate hunger bar color
  Color get hungerBarColor =>
      isDarkMode ? AppColors.darkHungerBar : AppColors.lightHungerBar;

  /// Get appropriate hygiene bar color
  Color get hygieneBarColor =>
      isDarkMode ? AppColors.darkHygieneBar : AppColors.lightHygieneBar;

  /// Get appropriate happiness bar color
  Color get happinessBarColor =>
      isDarkMode ? AppColors.darkHappinessBar : AppColors.lightHappinessBar;

  // ─────────────────────────────────────────────
  // TEXT STYLE UTILITIES
  // ─────────────────────────────────────────────

  /// Get display large text style
  TextStyle get textDisplayLarge => AppTypography.displayLarge(this);

  /// Get headline large text style
  TextStyle get textHeadlineLarge => AppTypography.headlineLarge(this);

  /// Get headline medium text style
  TextStyle get textHeadlineMedium => AppTypography.headlineMedium(this);

  /// Get title large text style
  TextStyle get textTitleLarge => AppTypography.titleLarge(this);

  /// Get title medium text style
  TextStyle get textTitleMedium => AppTypography.titleMedium(this);

  /// Get body large text style
  TextStyle get textBodyLarge => AppTypography.bodyLarge(this);

  /// Get body medium text style
  TextStyle get textBodyMedium => AppTypography.bodyMedium(this);

  /// Get label large text style
  TextStyle get textLabelLarge => AppTypography.labelLarge(this);

  /// Get label small text style
  TextStyle get textLabelSmall => AppTypography.labelSmall(this);

  // ─────────────────────────────────────────────
  // NAVIGATION & DIALOGS
  // ─────────────────────────────────────────────

  /// Get ScaffoldMessenger for snackbars
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Show snackbar
  void showSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Push a new page
  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Push and replace current page
  void pushReplacement(Widget page) {
    Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  /// Pop the current page
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pop until first route
  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
