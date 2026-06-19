import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

/// Complete theme configuration for Honey App
/// Includes light and dark themes with Material 3 design
class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme.light(
        surface: AppColors.lightSurface,
        surfaceContainer: AppColors.lightSurfaceVariant,
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightBackground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSurface,
        tertiary: AppColors.lightAccent,
        error: AppColors.lightError,
        outline: AppColors.lightDivider,
      ),
      
      // Scaffold & Background
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightBackground,

      // Text Theme
      textTheme: AppTypography.buildTextTheme().apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(null as BuildContext).copyWith(
          color: AppColors.lightTextPrimary,
        ),
      ),

      // Bottom App Bar (Navigation)
      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.lightSurface,
        elevation: 8,
        surfaceTintColor: AppColors.lightSurface,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextSecondary,
        selectedLabelStyle: AppTypography.navLabel(null as BuildContext).copyWith(
          color: AppColors.lightPrimary,
        ),
        unselectedLabelStyle: AppTypography.navLabel(null as BuildContext).copyWith(
          color: AppColors.lightTextSecondary,
        ),
        elevation: 12,
        type: BottomNavigationBarType.fixed,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.lightSurface,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.lightPrimary,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.lightPrimary,
          ),
        ),
      ),

      // Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.lightSurfaceVariant,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.lightError),
        ),
        hintStyle: AppTypography.bodyMedium(null as BuildContext).copyWith(
          color: AppColors.lightTextHint,
        ),
        labelStyle: AppTypography.titleMedium(null as BuildContext).copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        margin: EdgeInsets.zero,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 0,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightSurface,
        elevation: 8,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        labelStyle: AppTypography.labelSmall(null as BuildContext).copyWith(
          color: AppColors.lightTextPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        surface: AppColors.darkSurface,
        surfaceContainer: AppColors.darkSurfaceVariant,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkSurface,
        tertiary: AppColors.darkAccent,
        error: AppColors.darkError,
        outline: AppColors.darkDivider,
      ),
      
      // Scaffold & Background
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkBackground,

      // Text Theme
      textTheme: AppTypography.buildTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge(null as BuildContext).copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),

      // Bottom App Bar (Navigation)
      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.darkSurface,
        elevation: 8,
        surfaceTintColor: AppColors.darkSurface,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextSecondary,
        selectedLabelStyle: AppTypography.navLabel(null as BuildContext).copyWith(
          color: AppColors.darkPrimary,
        ),
        unselectedLabelStyle: AppTypography.navLabel(null as BuildContext).copyWith(
          color: AppColors.darkTextSecondary,
        ),
        elevation: 12,
        type: BottomNavigationBarType.fixed,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.darkBackground,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.darkPrimary,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge(null as BuildContext).copyWith(
            color: AppColors.darkPrimary,
          ),
        ),
      ),

      // Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.darkSurfaceVariant,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
        hintStyle: AppTypography.bodyMedium(null as BuildContext).copyWith(
          color: AppColors.darkTextHint,
        ),
        labelStyle: AppTypography.titleMedium(null as BuildContext).copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        margin: EdgeInsets.zero,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 0,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        elevation: 8,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        labelStyle: AppTypography.labelSmall(null as BuildContext).copyWith(
          color: AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
    );
  }
}
