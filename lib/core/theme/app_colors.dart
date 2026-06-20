import 'package:flutter/material.dart';

/// Color palette for Honey app
/// Based on warm, honey-themed design system
class AppColors {
  // Light mode colors
  static const Color lightBackground = Color(0xFFFAF6EF); // Creme quente
  static const Color lightSurface = Color(0xFFFFFFFF); // Branco
  static const Color lightSurfaceVariant = Color(0xFFF2EBE0); // Cards
  
  static const Color lightPrimary = Color(0xFFC17F3E); // Dourado/mel
  static const Color lightPrimaryLight = Color(0xFFE8C99A); // Dourado suave
  static const Color lightSecondary = Color(0xFF8B5E3C); // Marrom
  static const Color lightAccent = Color(0xFFF4A942); // Laranja suave
  static const Color lightError = Color(0xFFE05C5C); // Vermelho suave
  
  static const Color lightTextPrimary = Color(0xFF2C1A0E); // Marrom escuro
  static const Color lightTextSecondary = Color(0xFF8A6D55); // Marrom médio
  static const Color lightTextHint = Color(0xFFBBA898); // Marrom claro
  
  static const Color lightHungerBar = Color(0xFFE8736A); // Vermelho suave
  static const Color lightHygieneBar = Color(0xFF6AB4D4); // Azul pastel
  static const Color lightHappinessBar = Color(0xFFF4A942); // Dourado
  
  static const Color lightCoinColor = Color(0xFFC17F3E); // Dourado
  static const Color lightDivider = Color(0xFFEDE5D8); // Divisor claro
  static const Color lightPetCardBackground = Color(0xFFF5EDE0); // Bege quente
  static const Color lightShimmerBase = Color(0xFFEDE5D8);
  static const Color lightShimmerHighlight = Color(0xFFFAF7F2);

  // Dark mode colors (tons quentes escuros)
  static const Color darkBackground = Color(0xFF1C1410); // Preto quente
  static const Color darkSurface = Color(0xFF2A1F18); // Cinza quente escuro
  static const Color darkSurfaceVariant = Color(0xFF332820); // Cards escuro
  
  static const Color darkPrimary = Color(0xFFD4924E); // Dourado escuro
  static const Color darkPrimaryLight = Color(0xFF8B5E3C); // Marrom dourado
  static const Color darkSecondary = Color(0xFFA67C52); // Marrom escuro
  static const Color darkAccent = Color(0xFFF4A942); // Laranja suave
  static const Color darkError = Color(0xFFE05C5C); // Vermelho

  static const Color darkTextPrimary = Color(0xFFF5EDE4); // Creme claro
  static const Color darkTextSecondary = Color(0xFFB89880); // Marrom claro
  static const Color darkTextHint = Color(0xFF7A6355); // Marrom médio escuro

  static const Color darkHungerBar = Color(0xFFE8736A); // Vermelho suave
  static const Color darkHygieneBar = Color(0xFF6AB4D4); // Azul pastel
  static const Color darkHappinessBar = Color(0xFFF4A942); // Dourado

  static const Color darkCoinColor = Color(0xFFD4924E); // Dourado escuro
  static const Color darkDivider = Color(0xFF3D2E22); // Divisor escuro
  static const Color darkPetCardBackground = Color(0xFF3D2E22); // Bege escuro quente
  static const Color darkShimmerBase = Color(0xFF2A1F18);
  static const Color darkShimmerHighlight = Color(0xFF3D2E22);

  /// Standard subtle card shadow, used on top of `surface` backgrounds.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F2C1A0E),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // Static method to get colors based on brightness
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }

  static Color getPrimaryColor(Brightness brightness) {
    return brightness == Brightness.light ? lightPrimary : darkPrimary;
  }

  static Color getTextPrimaryColor(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  // Empty constructor to prevent instantiation
  AppColors._();
}
