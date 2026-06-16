import 'package:flutter/material.dart';

/// Standardized border radius values for Honey app
class AppRadius {
  // Base radius scale
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 100.0;

  // BorderRadius constants
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // Aliases for common patterns
  static const double none = 0.0;
  static const double small = sm;
  static const double medium = md;
  static const double large = lg;
  static const double extraLarge = xl;
  static const double circular = full;

  // Empty constructor to prevent instantiation
  AppRadius._();
}
