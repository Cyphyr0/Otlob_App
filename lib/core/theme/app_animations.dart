import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Animation System
///
/// Provides consistent animation durations and curves for smooth transitions.
/// Based on Material Design motion principles and the UI/UX redesign brief.
///
/// Usage:
/// ```dart
/// AnimatedContainer(
///   duration: AppAnimations.normal,
///   curve: AppAnimations.easeInOut,
/// )
/// ```
class AppAnimations {
  // Prevent instantiation
  AppAnimations._();

  // ============================================================================
  // DURATION CONSTANTS
  // ============================================================================

  /// Fast - 150ms
  /// Used for: Small UI changes, hover effects, ripples, micro-interactions
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal - 250ms
  /// Used for: Standard transitions, page changes, modal appearances
  static const Duration normal = Duration(milliseconds: 250);

  /// Slow - 400ms
  /// Used for: Complex animations, page transitions, major UI changes
  static const Duration slow = Duration(milliseconds: 400);

  /// Extra slow - 600ms
  /// Used for: Hero animations, dramatic reveals, special effects
  static const Duration extraSlow = Duration(milliseconds: 600);

  // ============================================================================
  // SPECIFIC USE CASE DURATIONS
  // ============================================================================

  /// Button press animation
  static const Duration buttonPress = fast;

  /// Card expansion/collapse
  static const Duration cardAnimation = normal;

  /// Page transition
  static const Duration pageTransition = normal;

  /// Bottom sheet slide
  static const Duration bottomSheet = normal;

  /// Dialog fade in/out
  static const Duration dialog = fast;

  /// Shimmer loading effect
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Toast notification
  static const Duration toast = Duration(milliseconds: 200);

  /// Snackbar animation
  static const Duration snackbar = Duration(milliseconds: 250);

  // ============================================================================
  // CURVE CONSTANTS
  // ============================================================================

  /// Ease In Out - Smooth acceleration and deceleration
  /// Used for: Most animations, general purpose
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Ease Out - Quick start, slow end
  /// Used for: Elements entering screen, expansions
  static const Curve easeOut = Curves.easeOutCubic;

  /// Ease In - Slow start, quick end
  /// Used for: Elements leaving screen, collapses
  static const Curve easeIn = Curves.easeInCubic;

  /// Spring - Bouncy, elastic motion
  /// Used for: Playful interactions, special effects
  static const Curve spring = Curves.elasticOut;

  /// Bounce - Bouncy landing
  /// Used for: Fun interactions, celebrations
  static const Curve bounce = Curves.bounceOut;

  /// Linear - Constant speed
  /// Used for: Loading indicators, progress bars
  static const Curve linear = Curves.linear;

  /// Fast Out Slow In - Material standard
  /// Used for: Material Design compliant animations
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // ============================================================================
  // COMPONENT-SPECIFIC CURVES
  // ============================================================================

  /// Button animation curve
  static const Curve buttonCurve = easeOut;

  /// Page transition curve
  static const Curve pageTransitionCurve = easeInOut;

  /// Bottom sheet curve
  static const Curve bottomSheetCurve = easeOut;

  /// Dialog curve
  static const Curve dialogCurve = fastOutSlowIn;

  /// Card curve
  static const Curve cardCurve = easeInOut;

  // ============================================================================
  // TRANSITIONS
  // ============================================================================

  /// Fade transition builder
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) => FadeTransition(opacity: animation, child: child);

  /// Slide transition builder (from bottom)
  static Widget slideTransitionFromBottom({
    required Animation<double> animation,
    required Widget child,
  }) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
      child: child,
    );

  /// Slide transition builder (from right)
  static Widget slideTransitionFromRight({
    required Animation<double> animation,
    required Widget child,
  }) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
      child: child,
    );

  /// Scale transition builder
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
    Alignment alignment = Alignment.center,
  }) => ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: easeOut),
      alignment: alignment,
      child: child,
    );

  /// Combined fade + slide transition
  static Widget fadeSlideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(0, 0.1),
  }) => SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    );

  // ============================================================================
  // PAGE ROUTE BUILDERS
  // ============================================================================

  /// Fade page route
  static PageRouteBuilder<T> fadeRoute<T>({
    required Widget page,
    Duration? duration,
  }) => PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
    );

  /// Slide page route (from right)
  static PageRouteBuilder<T> slideRoute<T>({
    required Widget page,
    Duration? duration,
    Offset begin = const Offset(1, 0),
  }) => PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
          child: child,
        ),
    );

  /// Scale page route
  static PageRouteBuilder<T> scaleRoute<T>({
    required Widget page,
    Duration? duration,
  }) => PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1,
          ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        ),
    );
}
