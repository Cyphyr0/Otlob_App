import 'package:flutter/material.dart';

/// Otlob App Color Palette
/// Based on the curated color scheme for modern food delivery UI
class OtlobColors {
  // Private constructor to prevent instantiation
  OtlobColors._();

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// Imperial Red - Main brand color
  /// Use for: Primary buttons, app bar, key branding elements
  static const Color primary = Color(0xFFFA3A46);

  /// Light Coral - Lighter variant of primary
  /// Use for: Hover states, active selections, highlights
  static const Color primaryLight = Color(0xFFF9777F);

  /// Dark Red - Darker variant of primary
  /// Use for: Pressed states, shadows, depth
  static const Color primaryDark = Color(0xFFE82838);

  // ============================================================================
  // NEUTRAL COLORS
  // ============================================================================

  /// Jet Black - Deep black for text and high contrast elements
  /// Use for: Headlines, primary text, icons
  static const Color jet = Color(0xFF313131);

  /// Isabelline - Warm off-white
  /// Use for: Backgrounds, cards in light mode
  static const Color isabelline = Color(0xFFF9F2ED);

  /// Platinum - Light gray
  /// Use for: Secondary backgrounds, dividers, borders
  static const Color platinum = Color(0xFFE3E3E3);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Success Green
  static const Color success = Color(0xFF10B981);

  /// Warning Orange
  static const Color warning = Color(0xFFF59E0B);

  /// Error Red
  static const Color error = Color(0xFFEF4444);

  /// Info Blue
  static const Color info = Color(0xFF3B82F6);

  // ============================================================================
  // FOOD CATEGORY COLORS
  // ============================================================================

  /// Egyptian Cuisine
  static const Color egyptian = Color(0xFFD4A574);

  /// Street Food
  static const Color streetFood = Color(0xFFFFA500);

  /// Grill & BBQ
  static const Color grill = Color(0xFFD2691E);

  /// Seafood
  static const Color seafood = Color(0xFF4A90E2);

  /// Vegetarian
  static const Color vegetarian = Color(0xFF7CB342);

  /// Desserts
  static const Color desserts = Color(0xFFE91E63);

  // ============================================================================
  // BADGE & STATUS COLORS
  // ============================================================================

  /// Hidden Gem Badge
  static const Color hiddenGem = Color(0xFFFFC107);

  /// Local Hero Badge
  static const Color localHero = Color(0xFF4CAF50);

  /// Tawseya (Recommendation) Badge
  static const Color tawseya = Color(0xFF9C27B0);

  /// Open Now
  static const Color openNow = Color(0xFF10B981);

  /// Closed
  static const Color closed = Color(0xFF9E9E9E);

  // ============================================================================
  // RATING COLORS
  // ============================================================================

  /// Excellent (4.5+)
  static const Color ratingExcellent = Color(0xFF10B981);

  /// Good (4.0-4.4)
  static const Color ratingGood = Color(0xFF7CB342);

  /// Average (3.5-3.9)
  static const Color ratingAverage = Color(0xFFFFA500);

  /// Below Average (<3.5)
  static const Color ratingBelowAverage = Color(0xFFFF6B6B);

  // ============================================================================
  // GRADIENT DEFINITIONS
  // ============================================================================

  /// Primary gradient (top to bottom)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );

  /// Accent gradient for special elements
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  /// Success gradient
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  /// Light shadow for cards
  static Color shadowLight = jet.withOpacity(0.05);

  /// Medium shadow for elevated elements
  static Color shadowMedium = jet.withOpacity(0.1);

  /// Heavy shadow for modals
  static Color shadowHeavy = jet.withOpacity(0.15);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Primary text color (dark mode)
  static const Color textPrimary = jet;

  /// Secondary text color (muted)
  static Color textSecondary = jet.withOpacity(0.7);

  /// Tertiary text color (hints, placeholders)
  static Color textTertiary = jet.withOpacity(0.5);

  /// Text on primary color (white)
  static const Color textOnPrimary = Colors.white;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get color for cuisine type
  static Color getCuisineColor(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'egyptian':
        return egyptian;
      case 'street food':
        return streetFood;
      case 'grill':
      case 'bbq':
        return grill;
      case 'seafood':
        return seafood;
      case 'vegetarian':
      case 'vegan':
        return vegetarian;
      case 'desserts':
      case 'bakery':
        return desserts;
      default:
        return primary;
    }
  }

  /// Get color for rating value
  static Color getRatingColor(double rating) {
    if (rating >= 4.5) return ratingExcellent;
    if (rating >= 4.0) return ratingGood;
    if (rating >= 3.5) return ratingAverage;
    return ratingBelowAverage;
  }

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) => color.withOpacity(opacity);
}

// ============================================================================
// MATERIAL THEME INTEGRATION
// ============================================================================

/// Light Theme ColorScheme
ColorScheme otlobLightColorScheme = const ColorScheme.light(
  primary: OtlobColors.primary,
  onPrimary: OtlobColors.textOnPrimary,
  secondary: OtlobColors.primaryLight,
  onSecondary: OtlobColors.textOnPrimary,
  error: OtlobColors.error,
  onError: Colors.white,
  surface: OtlobColors.isabelline,
  onSurface: OtlobColors.textPrimary,
  surfaceContainerHighest: OtlobColors.platinum,
);

/// Dark Theme ColorScheme (optional)
ColorScheme otlobDarkColorScheme = const ColorScheme.dark(
  primary: OtlobColors.primary,
  onPrimary: OtlobColors.textOnPrimary,
  secondary: OtlobColors.primaryLight,
  onSecondary: OtlobColors.textOnPrimary,
  error: OtlobColors.error,
  onError: Colors.white,
  surface: OtlobColors.jet,
  onSurface: Colors.white,
  surfaceContainerHighest: Color(0xFF424242),
);
