import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for Honey app
/// Uses Playfair Display for headings and DM Sans for body
class AppTypography {
  static TextTheme buildTextTheme({required Brightness brightness}) {
    final baseColor = brightness == Brightness.light
        ? const Color(0xFF2C1A0E) // Light primary text
        : const Color(0xFFF5EDE4); // Dark primary text

    final secondaryColor = brightness == Brightness.light
        ? const Color(0xFF8A6D55) // Light secondary text
        : const Color(0xFFB89880); // Dark secondary text

    return TextTheme(
      // Display styles - Playfair Display
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),

      // Headline styles - Playfair Display
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: baseColor,
      ),

      // Title styles - DM Sans
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: baseColor,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: baseColor,
      ),

      // Body styles - DM Sans
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: baseColor,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryColor,
      ),

      // Label styles - DM Sans
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        color: baseColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: baseColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }

  // Empty constructor to prevent instantiation
  AppTypography._();
}
