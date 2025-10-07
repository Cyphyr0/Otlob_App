import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Main Application Theme
///
/// Integrates all design system tokens (colors, typography, spacing, radius, shadows)
/// into a cohesive Material 3 theme implementing the Egyptian Sunset design language.
///
/// Usage in main.dart:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme, // Future implementation
/// )
/// ```
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ============================================================================
  // BACKWARD COMPATIBILITY - Deprecated color constants
  // ============================================================================

  /// @deprecated Use AppColors.primaryDark instead
  static const Color primaryColor = AppColors.primaryDark;

  /// @deprecated Use AppColors.accentOrange instead
  static const Color secondaryColor = AppColors.accentOrange;

  /// @deprecated Use AppColors.accentGold instead
  static const Color accentColor = AppColors.accentGold;

  /// @deprecated Use AppColors.offWhite instead
  static const Color backgroundColor = AppColors.offWhite;

  /// @deprecated Use AppColors.error instead
  static const Color errorColor = AppColors.error;

  // ============================================================================
  // LIGHT THEME - Egyptian Sunset
  // ============================================================================

  static ThemeData lightTheme = ThemeData(
    // Material 3 design
    useMaterial3: true,

    // Color scheme based on Egyptian Sunset palette
    colorScheme: ColorScheme.light(
      // Primary colors
      primary: AppColors.accentOrange,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.accentPeach,
      onPrimaryContainer: AppColors.primaryDark,

      // Secondary colors
      secondary: AppColors.accentGold,
      onSecondary: AppColors.primaryDark,
      secondaryContainer: AppColors.accentPeach,
      onSecondaryContainer: AppColors.primaryDark,

      // Tertiary colors
      tertiary: AppColors.primaryLight,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.primaryBase,
      onTertiaryContainer: AppColors.white,

      // Error colors
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.error.withAlpha(26),
      onErrorContainer: AppColors.error,

      // Background colors
      surface: AppColors.offWhite,
      onSurface: AppColors.darkGray,
      surfaceContainerHighest: AppColors.white,
      onSurfaceVariant: AppColors.gray,

      // Outline colors
      outline: AppColors.lightGray,
      outlineVariant: AppColors.lightGray.withAlpha(128),

      // Other colors
      shadow: AppColors.black.withAlpha(38),
      scrim: AppColors.black.withAlpha(153),
      inverseSurface: AppColors.primaryDark,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.accentPeach,
    ),

    // Typography - Poppins font family
    textTheme: AppTypography.textTheme,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.headlineSmall.copyWith(
        color: AppColors.white,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shadowColor: AppColors.black.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentOrange,
        foregroundColor: AppColors.white,
        elevation: 0,
        shadowColor: AppColors.accentOrange.withAlpha(77),
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentOrange,
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.accentOrange,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentOrange,
        side: const BorderSide(color: AppColors.accentOrange, width: 1.5),
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.accentOrange,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: AppSpacing.inputPadding,
      border: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.accentOrange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTypography.bodyMedium,
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.accentPeach,
      selectedColor: AppColors.accentOrange,
      disabledColor: AppColors.lightGray,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.primaryDark,
      ),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.white,
      ),
      padding: AppSpacing.chipPadding,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.chipRadius),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      titleTextStyle: AppTypography.headlineMedium,
      contentTextStyle: AppTypography.bodyLarge,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetRadius),
      modalBackgroundColor: AppColors.white,
      modalElevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentOrange,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.accentOrange,
      unselectedItemColor: AppColors.gray,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGray,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: AppColors.darkGray),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryDark,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: AppSpacing.listTilePadding,
      titleTextStyle: AppTypography.titleMedium,
      subtitleTextStyle: AppTypography.bodyMedium,
      iconColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentOrange;
        }
        return AppColors.gray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentOrange.withAlpha(128);
        }
        return AppColors.lightGray;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentOrange;
        }
        return AppColors.white;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentOrange;
        }
        return AppColors.gray;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accentOrange,
      circularTrackColor: AppColors.lightGray,
      linearTrackColor: AppColors.lightGray,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.accentOrange,
      inactiveTrackColor: AppColors.lightGray,
      thumbColor: AppColors.accentOrange,
      overlayColor: AppColors.accentOrange.withAlpha(51),
      valueIndicatorColor: AppColors.accentOrange,
      valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.white,
      ),
    ),

    // Scaffold Background
    scaffoldBackgroundColor: AppColors.offWhite,

    // Splash color and highlight
    splashColor: AppColors.accentOrange.withAlpha(26),
    highlightColor: AppColors.accentOrange.withAlpha(13),

    // Divider color
    dividerColor: AppColors.lightGray,
  );

  // ============================================================================
  // DARK THEME - To be implemented in Phase 2
  // ============================================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentOrange,
      secondary: AppColors.accentGold,
      error: AppColors.error,
      surface: AppColors.primaryDark,
    ),
    textTheme: AppTypography.textTheme,
    // Dark theme will be fully implemented in Phase 2
  );
}
