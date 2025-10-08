import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Shadcn-Inspired Design System for Otlob App
///
/// Creates Shadcn UI-inspired components using Flutter's Material Design
/// while maintaining the Otlob 3-color branding system and Egyptian Sunset aesthetic.
/// This provides a consistent, modern design language without external dependencies.
class ShadcnTheme {
  // Prevent instantiation
  ShadcnTheme._();

  /// Get the Shadcn-inspired theme data configured for Otlob
  static ThemeData get shadcnTheme => ThemeData(
      // Use Material 3
      useMaterial3: true,

      // Color scheme based on Otlob's branding
      colorScheme: ColorScheme.light(
        primary: AppColors.logoRed,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.logoRed.withAlpha(26),
        onPrimaryContainer: AppColors.logoRed,

        secondary: AppColors.primaryGold,
        onSecondary: AppColors.primaryBlack,
        secondaryContainer: AppColors.primaryGold.withAlpha(26),
        onSecondaryContainer: AppColors.primaryGold,

        tertiary: AppColors.primaryBlack,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.primaryBlack.withAlpha(26),
        onTertiaryContainer: AppColors.primaryBlack,

        error: AppColors.primaryBlack,
        onError: AppColors.white,
        errorContainer: AppColors.primaryBlack.withAlpha(26),
        onErrorContainer: AppColors.primaryBlack,

        surface: AppColors.white,
        onSurface: AppColors.primaryBlack,
        surfaceContainerHighest: AppColors.offWhite,
        onSurfaceVariant: AppColors.gray,

        outline: AppColors.lightGray,
        outlineVariant: AppColors.lightGray.withAlpha(128),

        shadow: AppColors.primaryBlack.withAlpha(38),
        scrim: AppColors.primaryBlack.withAlpha(153),
        inverseSurface: AppColors.primaryBlack,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.primaryGold,
      ),

      // Typography using Poppins
      textTheme: AppTypography.textTheme,

      // Custom component themes
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      cardTheme: cardTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: appBarTheme,
    );

  /// Elevated Button Theme (Primary buttons)
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.logoRed,
              foregroundColor: AppColors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: AppSpacing.buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
              textStyle: AppTypography.labelLarge,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.primaryBlack.withAlpha(26);
                }
                return null;
              }),
            ),
      );

  /// Outlined Button Theme (Secondary buttons)
  static OutlinedButtonThemeData get outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: AppColors.logoRed,
              side: const BorderSide(color: AppColors.logoRed, width: 1.5),
              padding: AppSpacing.buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
              textStyle: AppTypography.labelLarge,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.logoRed.withAlpha(26);
                }
                return null;
              }),
            ),
      );

  /// Text Button Theme
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style:
        TextButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryGold.withAlpha(26);
            }
            return null;
          }),
        ),
  );

  /// Card Theme
  static CardThemeData get cardTheme => const CardThemeData(
    color: null, // Will use theme's surface color
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: null, // Will be set by individual cards
    margin: EdgeInsets.zero,
  );

  /// Input Decoration Theme
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
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
      borderSide: const BorderSide(color: AppColors.logoRed, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primaryBlack),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primaryBlack, width: 2),
    ),
    labelStyle: AppTypography.bodyMedium,
    hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
    errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.primaryBlack),
  );

  /// App Bar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: AppColors.primaryBlack,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.headlineSmall.copyWith(
      color: AppColors.white,
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  /// Utility method to create primary buttons
  static Widget primaryButton({
    required Widget child,
    VoidCallback? onPressed,
    bool enabled = true,
    EdgeInsets? padding,
  }) => ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.logoRed : AppColors.lightGray,
        foregroundColor: AppColors.white,
        padding: padding ?? AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge,
      ),
      child: child,
    );

  /// Utility method to create secondary buttons
  static Widget secondaryButton({
    required Widget child,
    VoidCallback? onPressed,
    bool enabled = true,
    EdgeInsets? padding,
  }) => ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.primaryGold : AppColors.lightGray,
        foregroundColor: AppColors.primaryBlack,
        padding: padding ?? AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge,
      ),
      child: child,
    );

  /// Utility method to create outline buttons
  static Widget outlineButton({
    required Widget child,
    VoidCallback? onPressed,
    bool enabled = true,
    EdgeInsets? padding,
  }) => OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.logoRed,
        side: const BorderSide(color: AppColors.logoRed, width: 1.5),
        padding: padding ?? AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: AppTypography.labelLarge,
      ),
      child: child,
    );

  /// Utility method to create Shadcn-style cards
  static Widget shadcnCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) => Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
        side: const BorderSide(color: AppColors.lightGray, width: 1),
      ),
      margin: margin ?? EdgeInsets.zero,
      child: Padding(padding: padding ?? AppSpacing.allMd, child: child),
    );

  /// Utility method to create Shadcn-style text fields
  static Widget shadcnTextField({
    TextEditingController? controller,
    String? hintText,
    String? label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
          borderSide: const BorderSide(color: AppColors.logoRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primaryBlack),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primaryBlack, width: 2),
        ),
        labelStyle: AppTypography.bodyMedium,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.primaryBlack,
        ),
      ),
    );
}
