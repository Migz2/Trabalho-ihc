import 'package:flutter/material.dart';

/// Complete color palette for Honey App
/// Based on design prototypes with warm, honey-themed palette
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // LIGHT MODE - Primary Palette
  // ─────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFFAF7F2); // Warm cream
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightSurfaceVariant = Color(0xFFF5F0E8); // Soft cream for cards

  // Primary & Accent
  static const Color lightPrimary = Color(0xFFC17F3E); // Honey gold
  static const Color lightPrimaryLight = Color(0xFFE8C99A); // Soft gold
  static const Color lightSecondary = Color(0xFF8B5E3C); // Dark brown
  static const Color lightAccent = Color(0xFFF4A942); // Soft orange

  // Text
  static const Color lightTextPrimary = Color(0xFF2C1A0E); // Very dark brown
  static const Color lightTextSecondary = Color(0xFF8A6D55); // Medium brown
  static const Color lightTextHint = Color(0xFFBBA898); // Muted brown

  // Status & Semantic
  static const Color lightError = Color(0xFFE05C5C); // Soft red
  static const Color lightSuccess = Color(0xFF6AB4D4); // Hygiene blue
  static const Color lightWarning = Color(0xFFF4A942); // Warning orange

  // Specific Bars (Pet Status)
  static const Color lightHungerBar = Color(0xFFE8736A); // Soft red
  static const Color lightHygieneBar = Color(0xFF6AB4D4); // Pastel blue
  static const Color lightHappinessBar = Color(0xFFF4A942); // Gold

  // Additional
  static const Color lightCoinColor = Color(0xFFC17F3E); // Same as primary
  static const Color lightDivider = Color(0xFFEDE5D8); // Light divider
  static const Color lightDisabled = Color(0xFFD4C5B9); // Disabled state

  // ─────────────────────────────────────────────
  // DARK MODE - Warm Dark Palette
  // ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1C1410); // Very dark warm
  static const Color darkSurface = Color(0xFF2A1F18); // Dark brown
  static const Color darkSurfaceVariant = Color(0xFF332820); // Slightly lighter brown

  // Primary & Accent (adjusted for dark mode)
  static const Color darkPrimary = Color(0xFFD4924E); // Lighter honey gold
  static const Color darkPrimaryLight = Color(0xFFE8C99A); // Same soft gold
  static const Color darkSecondary = Color(0xFFA67C52); // Lighter brown
  static const Color darkAccent = Color(0xFFF4A942); // Same orange (works in dark)

  // Text (inverted)
  static const Color darkTextPrimary = Color(0xFFF5EDE4); // Light cream
  static const Color darkTextSecondary = Color(0xFFB89880); // Warm tan
  static const Color darkTextHint = Color(0xFF8A7560); // Muted tan

  // Status & Semantic
  static const Color darkError = Color(0xFFFF6B6B); // Brighter red for dark
  static const Color darkSuccess = Color(0xFF4ECDC4); // Brighter cyan
  static const Color darkWarning = Color(0xFFFFA94D); // Brighter orange

  // Specific Bars (Pet Status)
  static const Color darkHungerBar = Color(0xFFFF8A80); // Brighter red
  static const Color darkHygieneBar = Color(0xFF64B5F6); // Brighter blue
  static const Color darkHappinessBar = Color(0xFFFFA726); // Brighter gold

  // Additional
  static const Color darkCoinColor = Color(0xFFD4924E); // Same as primary
  static const Color darkDivider = Color(0xFF3F3028); // Dark divider
  static const Color darkDisabled = Color(0xFF5C4E47); // Disabled state

  // ─────────────────────────────────────────────
  // UTILITY METHODS
  // ─────────────────────────────────────────────

  /// Get color based on brightness
  static Color getColor(Color light, Color dark, Brightness brightness) {
    return brightness == Brightness.light ? light : dark;
  }

  /// Gradient: Warm to cool (for decorative elements)
  static const List<Color> warmGradient = [
    lightPrimaryLight,
    lightAccent,
  ];

  /// Gradient: Dark theme warm
  static const List<Color> darkWarmGradient = [
    darkPrimaryLight,
    darkAccent,
  ];
}
