import "package:flutter/material.dart";
import "app_colors.dart";

/// Shadow & Elevation System
///
/// Provides consistent shadow definitions for creating depth hierarchy.
/// Shadows help establish visual layers and improve UI comprehension.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: AppShadows.md,
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
/// ```
class AppShadows {
  // Prevent instantiation
  AppShadows._();

  // ============================================================================
  // SHADOW DEFINITIONS
  // ============================================================================

  /// Small shadow - Subtle elevation
  /// Used for: Chips, badges, small buttons, subtle highlights
  /// Elevation equivalent: ~2dp
  static List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.black.withAlpha(20),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.black.withAlpha(10),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow - Normal elevation
  /// Used for: Cards, buttons, list items, standard containers
  /// Elevation equivalent: ~4dp
  static List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.black.withAlpha(26),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.black.withAlpha(15),
      offset: const Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Large shadow - Prominent elevation
  /// Used for: Floating action buttons, navigation bars, prominent cards
  /// Elevation equivalent: ~8dp
  static List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.black.withAlpha(31),
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.black.withAlpha(20),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow - Maximum elevation
  /// Used for: Modals, dialogs, bottom sheets, overlays
  /// Elevation equivalent: ~16dp
  static List<BoxShadow> xl = [
    BoxShadow(
      color: AppColors.black.withAlpha(38),
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.black.withAlpha(26),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // COMPONENT-SPECIFIC SHADOWS
  // ============================================================================

  /// Card shadow - Medium elevation
  static List<BoxShadow> get card => md;

  /// Button shadow - Small elevation
  static List<BoxShadow> get button => sm;

  /// Floating button shadow - Large elevation
  static List<BoxShadow> get floatingButton => lg;

  /// Bottom navigation bar shadow
  static List<BoxShadow> bottomNav = [
    BoxShadow(
      color: AppColors.black.withAlpha(20),
      offset: const Offset(0, -2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// App bar shadow
  static List<BoxShadow> appBar = [
    BoxShadow(
      color: AppColors.black.withAlpha(15),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Bottom sheet shadow - Large upward
  static List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: AppColors.black.withAlpha(38),
      offset: const Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Dialog shadow - Extra large
  static List<BoxShadow> get dialog => xl;

  /// Dropdown shadow - Medium elevation
  static List<BoxShadow> get dropdown => md;

  /// Menu shadow - Large elevation
  static List<BoxShadow> get menu => lg;

  // ============================================================================
  // COLORED SHADOWS - For accent elements
  // ============================================================================

  /// Orange accent shadow - For CTA buttons
  static List<BoxShadow> accentOrange = [
    BoxShadow(
      color: AppColors.accentOrange.withAlpha(77),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.accentOrange.withAlpha(38),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// Gold accent shadow - For premium features
  static List<BoxShadow> accentGold = [
    BoxShadow(
      color: AppColors.accentGold.withAlpha(77),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.accentGold.withAlpha(38),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // INNER SHADOWS - For pressed/inset states
  // ============================================================================

  /// Inner shadow effect (simulated with dark overlay)
  /// Use with Stack and a semi-transparent container
  static List<BoxShadow> inner = [
    BoxShadow(
      color: AppColors.black.withAlpha(26),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Create custom shadow with specific parameters
  static List<BoxShadow> custom({
    required Color color,
    required Offset offset,
    required double blurRadius,
    double spreadRadius = 0,
  }) => [
      BoxShadow(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ];

  /// No shadow - For flat designs
  static List<BoxShadow> get none => [];
}
