import 'package:flutter/material.dart';

/// Extensions for BuildContext
extension ContextExtensions on BuildContext {
  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get current text theme
  TextTheme get textTheme => theme.textTheme;

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
