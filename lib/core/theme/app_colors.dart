import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Otlob App Color System
///
/// Based on the curated color palette:
/// - Imperial Red (#FA3A46) - Primary brand color
/// - Light Coral (#F9777F) - Accents & highlights
/// - Jet (#313131) - Text & high contrast
/// - Isabelline (#F9F2ED) - Backgrounds & surfaces
/// - Platinum (#E3E3E3) - Borders & dividers
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMARY BRAND COLORS
  // ============================================================================

  /// Imperial Red (#FA3A46) - Main brand color
  ///
  /// USE FOR:
  /// - Otlob logo
  /// - Primary CTAs (Order Now, Checkout, Confirm)
  /// - Important action buttons
  /// - Active states
  /// - Selected items
  /// - Progress indicators
  static const Color logoRed = Color(0xFFFA3A46);

  /// Alias for consistency
  static const Color primary = logoRed;

  /// Light Coral (#F9777F) - Lighter variant for highlights
  ///
  /// USE FOR:
  /// - Hover states
  /// - Secondary buttons
  /// - Active selections
  /// - Highlights
  static const Color primaryLight = Color(0xFFF9777F);

  /// Darker red for pressed states
  static const Color primaryDark = Color(0xFFE82838);

  // ============================================================================
  // NEUTRAL COLORS
  // ============================================================================

  /// Jet (#313131) - Primary text color
  ///
  /// USE FOR:
  /// - Headlines and titles
  /// - Primary body text
  /// - Icons
  /// - High contrast elements
  static const Color primaryBlack = Color(0xFF313131);

  /// Text color alias
  static const Color textPrimary = primaryBlack;

  /// Isabelline (#F9F2ED) - Warm background
  ///
  /// USE FOR:
  /// - Main app background
  /// - Card backgrounds
  /// - Light surfaces
  static const Color offWhite = Color(0xFFF9F2ED);

  /// Background alias
  static const Color background = offWhite;

  /// Platinum (#E3E3E3) - Light gray
  ///
  /// USE FOR:
  /// - Borders
  /// - Dividers
  /// - Disabled states
  /// - Secondary backgrounds
  static const Color lightGray = Color(0xFFE3E3E3);

  /// Border alias
  static const Color border = lightGray;

  /// Pure white for cards and surfaces
  static const Color white = Color(0xFFFFFFFF);

  /// Secondary text (70% opacity)
  static Color get textSecondary => primaryBlack.withValues(alpha: 0.7);

  /// Tertiary text (50% opacity)
  static Color get textTertiary => primaryBlack.withValues(alpha: 0.5);

  // ============================================================================
  // ACCENT COLORS
  // ============================================================================

  /// Gold for ratings and special badges
  static const Color primaryGold = Color(0xFFF4D06F);

  /// Gold alias
  static const Color accentGold = primaryGold;

  // ============================================================================
  // DEPRECATED COLORS - For backward compatibility
  // ============================================================================

  /// @deprecated Use primaryLight or warning instead
  static const Color accentOrange = Color(0xFFE07A5F);

  /// @deprecated Use offWhite or background instead
  static const Color accentPeach = Color(0xFFF2CC8F);

  /// @deprecated Use primaryBlack instead
  static const Color primaryBase = Color(0xFF1B2A41);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Success green
  static const Color success = Color(0xFF27AE60);

  /// Warning orange
  static const Color warning = Color(0xFFF39C12);

  /// Error red (uses primary red)
  static const Color error = logoRed;

  /// Info blue
  static const Color info = Color(0xFF3498DB);

  /// Tawseya badge color (authenticity marker)
  static const Color tawseya = primaryGold;

  // ============================================================================
  // ADDITIONAL NEUTRALS
  // ============================================================================

  /// Gray - Secondary text, placeholder text, subtle icons
  static const Color gray = Color(0xFF6C757D);

  /// Dark gray - For deeper shadows and borders
  static const Color darkGray = Color(0xFF343A40);

  /// Pure black - Maximum contrast text when needed
  static const Color black = Color(0xFF000000);

  // ============================================================================
  // OPACITY VARIANTS - For overlays and shadows
  // ============================================================================

  /// Dark overlay for modals and bottom sheets (60% opacity)
  static Color get darkOverlay => black.withValues(alpha: 0.6);

  /// Light overlay for disabled states (40% opacity)
  static Color get lightOverlay => white.withValues(alpha: 0.4);

  /// Subtle overlay for hover states (8% opacity)
  static Color get hoverOverlay => primaryBlack.withValues(alpha: 0.08);

  // ============================================================================
  // CUISINE CATEGORY COLORS
  // ============================================================================

  /// Get color for a specific cuisine type
  static Color getCuisineColor(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'egyptian':
      case 'مصري':
        return const Color(0xFFE74C3C);
      case 'street food':
      case 'طعام الشارع':
        return const Color(0xFFF39C12);
      case 'grill':
      case 'مشويات':
        return const Color(0xFFD35400);
      case 'seafood':
      case 'مأكولات بحرية':
        return const Color(0xFF3498DB);
      case 'italian':
      case 'إيطالي':
        return const Color(0xFF27AE60);
      case 'asian':
      case 'آسيوي':
        return const Color(0xFFE67E22);
      case 'fast food':
      case 'وجبات سريعة':
        return const Color(0xFFC0392B);
      case 'desserts':
      case 'حلويات':
        return const Color(0xFFEC407A);
      default:
        return gray;
    }
  }

  /// Get color based on rating value
  static Color getRatingColor(double rating) {
    if (rating >= 4.5) return success;
    if (rating >= 4.0) return primaryGold;
    if (rating >= 3.5) return warning;
    return gray;
  }

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
