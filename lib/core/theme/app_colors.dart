import 'package:flutter/material.dart';

/// Otlob App Unified Color System
///
/// A cohesive 3-color system designed for consistency across all screens.
/// Every color has a clear, specific purpose.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMARY BRAND COLORS - The Core 3-Color System
  // ============================================================================

  /// Logo Red (#FA3A46) - Primary brand color
  ///
  /// USE FOR:
  /// - Otlob logo
  /// - Primary CTAs (Order Now, Checkout, Confirm)
  /// - Important action buttons
  /// - Active navigation states
  /// - Selected items and borders
  /// - Progress indicators
  ///
  /// DO NOT USE FOR: Success or error states
  static const Color logoRed = Color(0xFFFA3A46);

  /// Primary Gold (#F4D06F) - Success & Value color
  ///
  /// USE FOR:
  /// - Success messages and backgrounds
  /// - Completed actions
  /// - Tawseya badges (authenticity marker)
  /// - Premium features
  /// - Star ratings
  /// - Secondary action buttons (Apply, Save)
  ///
  /// DO NOT USE FOR: Primary CTAs or errors
  static const Color primaryGold = Color(0xFFF4D06F);

  /// Primary Black (#0D1B2A) - Error & Text color
  ///
  /// USE FOR:
  /// - Error messages and backgrounds
  /// - Failed actions
  /// - Primary body text
  /// - Headers and titles
  /// - Navigation bars
  ///
  /// DO NOT USE FOR: Success states
  static const Color primaryBlack = Color(0xFF0D1B2A);

  // ============================================================================
  // DEPRECATED - Legacy colors (to be phased out)
  // ============================================================================

  /// @deprecated Use primaryBlack instead
  static const Color primaryDark = primaryBlack;

  /// @deprecated Use logoRed for CTAs or primaryGold for secondary actions
  static const Color accentOrange = Color(0xFFE07A5F);

  /// @deprecated Use primaryGold instead
  static const Color accentGold = primaryGold;

  /// @deprecated No replacement - avoid using
  static const Color primaryBase = Color(0xFF1B2A41);

  /// @deprecated No replacement - avoid using
  static const Color primaryLight = Color(0xFF415A77);

  /// @deprecated No replacement - avoid using
  static const Color accentPeach = Color(0xFFF2CC8F);

  // ============================================================================
  // SEMANTIC COLORS - Mapped to 3-Color System
  // ============================================================================

  /// Success states - Uses primaryGold
  static const Color success = primaryGold;

  /// Warning states - Uses logoRed
  static const Color warning = logoRed;

  /// Error states - Uses primaryBlack
  static const Color error = primaryBlack;

  /// Info states - Uses primaryBlack with lower opacity
  static Color get info => primaryBlack.withAlpha(179);

  // ============================================================================
  // NEUTRAL COLORS - Text & Backgrounds
  // ============================================================================

  /// Pure white - Primary text on dark backgrounds, card surfaces
  static const Color white = Color(0xFFFFFFFF);

  /// Off-white - Main app background, subtle card backgrounds
  /// Reduces eye strain compared to pure white
  static const Color offWhite = Color(0xFFFAF9F7);

  /// Light gray - Dividers, borders, disabled state backgrounds
  static const Color lightGray = Color(0xFFE5E5E5);

  /// Gray - Secondary text, placeholder text, subtle icons
  static const Color gray = Color(0xFF6C757D);

  /// Dark gray - Primary body text on light backgrounds
  static const Color darkGray = Color(0xFF343A40);

  /// Pure black - Maximum contrast text when needed
  static const Color black = Color(0xFF000000);

  // ============================================================================
  // OPACITY VARIANTS - For overlays and shadows
  // ============================================================================

  /// Dark overlay for modals and bottom sheets (60% opacity)
  static Color get darkOverlay => black.withAlpha(153);

  /// Light overlay for disabled states (40% opacity)
  static Color get lightOverlay => white.withAlpha(102);

  /// Subtle overlay for hover states (8% opacity)
  static Color get hoverOverlay => primaryBlack.withAlpha(20);

  // ============================================================================
  // GRADIENTS - DEPRECATED (Use solid colors instead)
  // ============================================================================

  /// @deprecated Use solid logoRed instead for consistency
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [logoRed, primaryGold],
  );

  /// @deprecated Use solid logoRed instead for consistency
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [logoRed, logoRed],
  );

  /// @deprecated Use solid primaryBlack instead for consistency
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlack, primaryBlack],
  );
}
