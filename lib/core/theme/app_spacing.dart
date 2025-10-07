import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

/// 8-Point Grid Spacing System
///
/// Provides consistent spacing values based on an 8dp base unit.
/// All spacing multiplies of 8 for visual harmony and alignment.
/// Uses flutter_screenutil for responsive scaling across devices.
///
/// Usage:
/// ```dart
/// Padding(padding: EdgeInsets.all(AppSpacing.md))
/// SizedBox(height: AppSpacing.lg)
/// Container(margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding))
/// ```
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // ============================================================================
  // BASE GRID UNITS (8dp increments)
  // ============================================================================

  /// Extra Small - 4dp (0.5x base)
  /// Used for: Tight spacing, icon padding, badge offsets
  static double get xs => 4.0.w;

  /// Small - 8dp (1x base unit)
  /// Used for: Item spacing in lists, chip gaps, compact layouts
  static double get sm => 8.0.w;

  /// Medium - 16dp (2x base)
  /// Used for: Card padding, standard gaps, form field spacing
  static double get md => 16.0.w;

  /// Large - 24dp (3x base)
  /// Used for: Section spacing, large gaps, prominent separations
  static double get lg => 24.0.w;

  /// Extra Large - 32dp (4x base)
  /// Used for: Screen sections, major content blocks
  static double get xl => 32.0.w;

  /// 2X Large - 40dp (5x base)
  /// Used for: Hero sections, major vertical spacing
  static double get xxl => 40.0.w;

  /// 3X Large - 48dp (6x base)
  /// Used for: Maximum spacing, hero elements, major separations
  static double get xxxl => 48.0.w;

  // ============================================================================
  // COMPONENT-SPECIFIC SPACING
  // ============================================================================

  /// Standard card padding - 16dp
  /// Used for: All card interiors, content padding
  static double get cardPadding => md;

  /// Screen edge padding - 16dp
  /// Used for: Horizontal screen margins, safe area padding
  static double get screenPadding => md;

  /// Section vertical spacing - 24dp
  /// Used for: Between major sections, content groups
  static double get sectionSpacing => lg;

  /// List item spacing - 8dp
  /// Used for: Between list items, grid gaps
  static double get itemSpacing => sm;

  /// Button padding - 16dp horizontal, 12dp vertical
  /// Used for: Standard button interiors
  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: 12.0.h);

  /// Large button padding - 24dp horizontal, 16dp vertical
  /// Used for: Primary CTAs, prominent buttons
  static EdgeInsets get buttonPaddingLarge =>
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// Small button padding - 12dp horizontal, 8dp vertical
  /// Used for: Compact buttons, chips
  static EdgeInsets get buttonPaddingSmall =>
      EdgeInsets.symmetric(horizontal: 12.0.w, vertical: sm);

  /// Input field padding - 16dp horizontal, 14dp vertical
  /// Used for: Text inputs, search fields
  static EdgeInsets get inputPadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: 14.0.h);

  /// Chip padding - 12dp horizontal, 6dp vertical
  /// Used for: Filter chips, category tags
  static EdgeInsets get chipPadding =>
      EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 6.0.h);

  /// Bottom sheet padding - 16dp all sides
  /// Used for: Bottom sheet content
  static EdgeInsets get bottomSheetPadding => EdgeInsets.all(md);

  /// Dialog padding - 24dp all sides
  /// Used for: Modal dialogs, alerts
  static EdgeInsets get dialogPadding => EdgeInsets.all(lg);

  /// List tile padding - 16dp horizontal, 12dp vertical
  /// Used for: Standard list items
  static EdgeInsets get listTilePadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: 12.0.h);

  // ============================================================================
  // EDGE INSETS PRESETS
  // ============================================================================

  /// Zero padding
  static EdgeInsets get zero => EdgeInsets.zero;

  /// Extra small padding - 4dp all sides
  static EdgeInsets get allXs => EdgeInsets.all(xs);

  /// Small padding - 8dp all sides
  static EdgeInsets get allSm => EdgeInsets.all(sm);

  /// Medium padding - 16dp all sides
  static EdgeInsets get allMd => EdgeInsets.all(md);

  /// Large padding - 24dp all sides
  static EdgeInsets get allLg => EdgeInsets.all(lg);

  /// Extra large padding - 32dp all sides
  static EdgeInsets get allXl => EdgeInsets.all(xl);

  // ============================================================================
  // HORIZONTAL SPACING
  // ============================================================================

  /// Horizontal extra small - 4dp left & right
  static EdgeInsets get horizontalXs => EdgeInsets.symmetric(horizontal: xs);

  /// Horizontal small - 8dp left & right
  static EdgeInsets get horizontalSm => EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal medium - 16dp left & right
  static EdgeInsets get horizontalMd => EdgeInsets.symmetric(horizontal: md);

  /// Horizontal large - 24dp left & right
  static EdgeInsets get horizontalLg => EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal extra large - 32dp left & right
  static EdgeInsets get horizontalXl => EdgeInsets.symmetric(horizontal: xl);

  // ============================================================================
  // VERTICAL SPACING
  // ============================================================================

  /// Vertical extra small - 4dp top & bottom
  static EdgeInsets get verticalXs => EdgeInsets.symmetric(vertical: xs);

  /// Vertical small - 8dp top & bottom
  static EdgeInsets get verticalSm => EdgeInsets.symmetric(vertical: sm);

  /// Vertical medium - 16dp top & bottom
  static EdgeInsets get verticalMd => EdgeInsets.symmetric(vertical: md);

  /// Vertical large - 24dp top & bottom
  static EdgeInsets get verticalLg => EdgeInsets.symmetric(vertical: lg);

  /// Vertical extra large - 32dp top & bottom
  static EdgeInsets get verticalXl => EdgeInsets.symmetric(vertical: xl);

  // ============================================================================
  // SIZED BOX HELPERS - For quick gaps
  // ============================================================================

  /// Horizontal gap - Extra Small (4dp)
  static Widget get gapXs => SizedBox(width: xs);

  /// Horizontal gap - Small (8dp)
  static Widget get gapSm => SizedBox(width: sm);

  /// Horizontal gap - Medium (16dp)
  static Widget get gapMd => SizedBox(width: md);

  /// Horizontal gap - Large (24dp)
  static Widget get gapLg => SizedBox(width: lg);

  /// Horizontal gap - Extra Large (32dp)
  static Widget get gapXl => SizedBox(width: xl);

  /// Vertical gap - Extra Small (4dp)
  static Widget get vGapXs => SizedBox(height: xs);

  /// Vertical gap - Small (8dp)
  static Widget get vGapSm => SizedBox(height: sm);

  /// Vertical gap - Medium (16dp)
  static Widget get vGapMd => SizedBox(height: md);

  /// Vertical gap - Large (24dp)
  static Widget get vGapLg => SizedBox(height: lg);

  /// Vertical gap - Extra Large (32dp)
  static Widget get vGapXl => SizedBox(height: xl);
}
