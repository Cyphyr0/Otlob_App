import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Border Radius System
///
/// Provides consistent border radius values for various UI components.
/// Creates visual hierarchy through different levels of roundness.
/// Uses flutter_screenutil for responsive scaling.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(AppRadius.md),
///   ),
/// )
/// ```
class AppRadius {
  // Prevent instantiation
  AppRadius._();

  // ============================================================================
  // RADIUS VALUES
  // ============================================================================

  /// Small - 8dp
  /// Used for: Chips, small buttons, tags, badges
  static double get sm => 8.0.r;

  /// Medium - 12dp
  /// Used for: Cards, input fields, standard buttons, list items
  static double get md => 12.0.r;

  /// Large - 16dp
  /// Used for: Large cards, prominent containers, feature cards
  static double get lg => 16.0.r;

  /// Extra Large - 20dp
  /// Used for: Bottom sheets, large modals, hero elements
  static double get xl => 20.0.r;

  /// 2X Large - 24dp
  /// Used for: Full-screen modals, drawer corners
  static double get xxl => 24.0.r;

  /// Pill - 999dp (fully rounded)
  /// Used for: Pills, capsule buttons, fully rounded elements
  static double get pill => 999.0.r;

  // ============================================================================
  // BORDER RADIUS PRESETS
  // ============================================================================

  /// Small border radius - 8dp all corners
  static BorderRadius get smallRadius => BorderRadius.circular(sm);

  /// Medium border radius - 12dp all corners
  static BorderRadius get mediumRadius => BorderRadius.circular(md);

  /// Large border radius - 16dp all corners
  static BorderRadius get largeRadius => BorderRadius.circular(lg);

  /// Extra large border radius - 20dp all corners
  static BorderRadius get extraLargeRadius => BorderRadius.circular(xl);

  /// 2X large border radius - 24dp all corners
  static BorderRadius get xxLargeRadius => BorderRadius.circular(xxl);

  /// Pill border radius - 999dp all corners (fully rounded)
  static BorderRadius get pillRadius => BorderRadius.circular(pill);

  // ============================================================================
  // COMPONENT-SPECIFIC RADIUS
  // ============================================================================

  /// Button radius - 12dp
  static BorderRadius get buttonRadius => mediumRadius;

  /// Card radius - 12dp
  static BorderRadius get cardRadius => mediumRadius;

  /// Input field radius - 12dp
  static BorderRadius get inputRadius => mediumRadius;

  /// Chip radius - 8dp
  static BorderRadius get chipRadius => smallRadius;

  /// Bottom sheet radius - 20dp (only top corners)
  static BorderRadius get bottomSheetRadius =>
      BorderRadius.vertical(top: Radius.circular(xl));

  /// Dialog radius - 16dp
  static BorderRadius get dialogRadius => largeRadius;

  /// Image radius - 12dp
  static BorderRadius get imageRadius => mediumRadius;

  /// Avatar radius - 999dp (fully rounded)
  static BorderRadius get avatarRadius => pillRadius;

  // ============================================================================
  // DIRECTIONAL RADIUS - For specific corners
  // ============================================================================

  /// Top only - Small (8dp)
  static BorderRadius get topSmall =>
      BorderRadius.vertical(top: Radius.circular(sm));

  /// Top only - Medium (12dp)
  static BorderRadius get topMedium =>
      BorderRadius.vertical(top: Radius.circular(md));

  /// Top only - Large (16dp)
  static BorderRadius get topLarge =>
      BorderRadius.vertical(top: Radius.circular(lg));

  /// Top only - Extra Large (20dp)
  static BorderRadius get topExtraLarge =>
      BorderRadius.vertical(top: Radius.circular(xl));

  /// Bottom only - Small (8dp)
  static BorderRadius get bottomSmall =>
      BorderRadius.vertical(bottom: Radius.circular(sm));

  /// Bottom only - Medium (12dp)
  static BorderRadius get bottomMedium =>
      BorderRadius.vertical(bottom: Radius.circular(md));

  /// Bottom only - Large (16dp)
  static BorderRadius get bottomLarge =>
      BorderRadius.vertical(bottom: Radius.circular(lg));

  /// Bottom only - Extra Large (20dp)
  static BorderRadius get bottomExtraLarge =>
      BorderRadius.vertical(bottom: Radius.circular(xl));

  /// Left only - Medium (12dp)
  static BorderRadius get leftMedium =>
      BorderRadius.horizontal(left: Radius.circular(md));

  /// Right only - Medium (12dp)
  static BorderRadius get rightMedium =>
      BorderRadius.horizontal(right: Radius.circular(md));

  // ============================================================================
  // CUSTOM RADIUS HELPERS
  // ============================================================================

  /// Create custom BorderRadius with specific value
  static BorderRadius custom(double radius) => BorderRadius.circular(radius.r);

  /// Create top-only BorderRadius with custom value
  static BorderRadius topCustom(double radius) =>
      BorderRadius.vertical(top: Radius.circular(radius.r));

  /// Create bottom-only BorderRadius with custom value
  static BorderRadius bottomCustom(double radius) =>
      BorderRadius.vertical(bottom: Radius.circular(radius.r));

  /// Create left-only BorderRadius with custom value
  static BorderRadius leftCustom(double radius) =>
      BorderRadius.horizontal(left: Radius.circular(radius.r));

  /// Create right-only BorderRadius with custom value
  static BorderRadius rightCustom(double radius) =>
      BorderRadius.horizontal(right: Radius.circular(radius.r));

  /// Create BorderRadius with different values for each corner
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft.r),
    topRight: Radius.circular(topRight.r),
    bottomLeft: Radius.circular(bottomLeft.r),
    bottomRight: Radius.circular(bottomRight.r),
  );
}
