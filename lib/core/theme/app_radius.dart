import 'package:flutter/material.dart';

/// Standardized border radius values for consistent styling
/// Using a scale: sm(8), md(12), lg(16), xl(24), full(100)
class AppRadius {
  AppRadius._();

  /// 8px - Small radius (small components, minor roundness)
  static const double sm = 8.0;

  /// 12px - Medium radius (standard components)
  static const double md = 12.0;

  /// 16px - Large radius (cards, larger components)
  static const double lg = 16.0;

  /// 24px - Extra large radius (major containers)
  static const double xl = 24.0;

  /// 100px - Full radius (circles, completely rounded)
  static const double full = 100.0;

  // ─────────────────────────────────────────────
  // BORDER RADIUS OBJECTS
  // ─────────────────────────────────────────────

  /// Small rounded corners
  static BorderRadius radiusSm = BorderRadius.circular(sm);

  /// Medium rounded corners
  static BorderRadius radiusMd = BorderRadius.circular(md);

  /// Large rounded corners
  static BorderRadius radiusLg = BorderRadius.circular(lg);

  /// Extra large rounded corners
  static BorderRadius radiusXl = BorderRadius.circular(xl);

  /// Full rounded corners (circles)
  static BorderRadius radiusFull = BorderRadius.circular(full);

  // ─────────────────────────────────────────────
  // COMMON COMBINATIONS
  // ─────────────────────────────────────────────

  /// Standard card radius
  static BorderRadius cardRadius = radiusLg;

  /// Standard button radius
  static BorderRadius buttonRadius = radiusMd;

  /// Standard input field radius
  static BorderRadius inputRadius = radiusMd;

  /// Bottom sheet radius
  static BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
