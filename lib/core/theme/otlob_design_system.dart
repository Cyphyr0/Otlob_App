import "package:flutter/material.dart";

/// Otlob Design System
/// Foundation for consistent UI/UX across the app
class OtlobDesignSystem {
  // =========================================
  // COLORS - Based on Otlob Brand Identity
  // =========================================

  static const Color primary = Color(0xFF0D1B2A);      // Dark Navy
  static const Color secondary = Color(0xFFE07A5F);    // Terracotta
  static const Color accent = Color(0xFFF4D06F);       // Warm Gold
  static const Color background = Color(0xFFF8F9FA);   // Light Gray
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1B263B);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE9ECEF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // =========================================
  // SPACING SYSTEM - 8pt Grid
  // =========================================

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // =========================================
  // BORDER RADIUS SYSTEM
  // =========================================

  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusRound = 999;

  // =========================================
  // SHADOWS - Elevation System
  // =========================================

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // =========================================
  // TYPOGRAPHY - Following Material Design 3
  // =========================================

  static TextStyle displayLarge = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle displayMedium = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle displaySmall = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle headlineLarge = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.5,
  );

  static TextStyle labelLarge = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle labelMedium = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle labelSmall = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textLight,
    height: 1.4,
  );

  // =========================================
  // COMMON DECORATIONS - Ready to use
  // =========================================

  /// Base card decoration with elevation and rounded corners
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusLg),
    boxShadow: shadowMd,
  );

  /// Primary button decoration
  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: secondary,
    borderRadius: BorderRadius.circular(radiusLg),
  );

  /// Secondary button decoration
  static BoxDecoration secondaryButtonDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: border),
  );

  /// Input field decoration
  static BoxDecoration inputDecoration = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: border),
  );

  // =========================================
  // UTILITY FUNCTIONS
  // =========================================

  /// Create a themed Text widget
  static Text themedText(String text, TextStyle style, {TextAlign? textAlign}) => Text(
      text,
      style: style,
      textAlign: textAlign,
    );

  /// Create a themed Icon
  static Icon themedIcon(IconData icon, {Color? color, double? size}) => Icon(
      icon,
      color: color ?? textSecondary,
      size: size ?? 24,
    );

  /// Standard spacing sized box
  static SizedBox spacing(double height) => SizedBox(height: height);
  static SizedBox spacingHorizontal(double width) => SizedBox(width: width);
}
