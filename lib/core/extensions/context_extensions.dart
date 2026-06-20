import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Extensions for BuildContext
extension ContextExtensions on BuildContext {
  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Short alias for colorScheme
  ColorScheme get colors => theme.colorScheme;

  /// Short alias for textTheme
  TextTheme get texts => theme.textTheme;

  /// Whether the *resolved* app theme is dark (respects an explicit
  /// light/dark override in settings, not just the OS brightness).
  bool get isDark => theme.brightness == Brightness.dark;

  /// Theme-aware surface color (card backgrounds, etc).
  Color get surface => isDark ? AppColors.darkSurface : AppColors.lightSurface;

  /// Theme-aware secondary surface color (e.g. for variant cards).
  Color get surfaceVariant =>
      isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;

  /// Theme-aware divider color.
  Color get dividerColor => isDark ? AppColors.darkDivider : AppColors.lightDivider;

  /// Theme-aware primary text color.
  Color get textPrimary => isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  /// Theme-aware secondary text color.
  Color get textSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  /// Theme-aware hint/placeholder text color.
  Color get textHint => isDark ? AppColors.darkTextHint : AppColors.lightTextHint;

  /// Get device size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get device padding (safe area)
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;

  /// Check if device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device is small (phone)
  bool get isSmallDevice => screenWidth < 600;

  /// Check if device is medium (tablet)
  bool get isMediumDevice => screenWidth >= 600 && screenWidth < 900;

  /// Check if device is large (tablet)
  bool get isLargeDevice => screenWidth >= 900;

  /// Get brightness
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// Check if dark mode is enabled
  bool get isDarkMode => brightness == Brightness.dark;

  /// Check if light mode is enabled
  bool get isLightMode => brightness == Brightness.light;

  /// Show a SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Show an error SnackBar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show a success SnackBar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Navigate to a named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// Replace current route
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Pop until a route
  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }
}
