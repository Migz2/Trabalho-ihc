import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for Honey App using Google Fonts
/// Display: Playfair Display (elegant, headers)
/// Body: DM Sans (clean, readable)
class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────────
  // DISPLAY & HEADLINE STYLES
  // ─────────────────────────────────────────────

  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.3,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 1.3,
      letterSpacing: -0.2,
    );
  }

  // ─────────────────────────────────────────────
  // TITLE STYLES (UI elements, buttons)
  // ─────────────────────────────────────────────

  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0,
    );
  }

  // ─────────────────────────────────────────────
  // BODY STYLES (main content)
  // ─────────────────────────────────────────────

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.25,
    );
  }

  // ─────────────────────────────────────────────
  // LABEL STYLES (buttons, badges, small text)
  // ─────────────────────────────────────────────

  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.3,
      letterSpacing: 0.3,
    );
  }

  // ─────────────────────────────────────────────
  // CUSTOM STYLES
  // ─────────────────────────────────────────────

  /// Large timer/focus display (e.g., 24:13)
  static TextStyle timerDisplay(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 64,
      fontWeight: FontWeight.w600,
      height: 1.0,
      letterSpacing: -1,
    );
  }

  /// Medium timer for secondary displays
  static TextStyle timerMedium(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      height: 1.0,
      letterSpacing: -0.5,
    );
  }

  /// Small timer for notifications/badges
  static TextStyle timerSmall(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.0,
      letterSpacing: 0,
    );
  }

  /// Bottom navigation label
  static TextStyle navLabel(BuildContext context) {
    return GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.3,
      letterSpacing: 0,
    );
  }

  // ─────────────────────────────────────────────
  // TEXT THEME (for Material 3 integration)
  // ─────────────────────────────────────────────

  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }
}
