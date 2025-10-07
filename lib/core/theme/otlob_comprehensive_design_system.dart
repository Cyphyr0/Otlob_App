import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================================================
/// COMPREHENSIVE OTLOB DESIGN SYSTEM
/// ============================================================================
///
/// A complete design system for the Otlob food delivery app that consolidates:
/// - Egyptian Sunset color palette with cultural meanings
/// - Complete typography scale with Arabic/RTL support
/// - 8-point grid spacing system
/// - Component design tokens
/// - Animation and motion design
/// - Egyptian cultural elements and patterns
///
/// Usage:
/// ```dart
/// import 'package:otlob/core/theme/otlob_comprehensive_design_system.dart';
///
/// // Use color tokens
/// Container(color: OtlobDesignSystem.colors.primary.sunset)
///
/// // Use typography
/// Text('Hello', style: OtlobDesignSystem.typography.heading.h1)
///
/// // Use spacing
/// Padding(padding: OtlobDesignSystem.spacing.section)
/// ```
class OtlobDesignSystem {
  // Prevent instantiation
  OtlobDesignSystem._();

  // ============================================================================
  // COLOR SYSTEM - Egyptian Sunset Palette
  // ============================================================================

  static const OtlobColorSystem colors = OtlobColorSystem._();
  static const OtlobTypographySystem typography = OtlobTypographySystem._();
  static const OtlobSpacingSystem spacing = OtlobSpacingSystem._();
  static const OtlobComponentSystem components = OtlobComponentSystem._();
  static const OtlobAnimationSystem animations = OtlobAnimationSystem._();
  static const OtlobCulturalSystem cultural = OtlobCulturalSystem._();
}

/// ============================================================================
/// COLOR SYSTEM - Egyptian Sunset Palette with Cultural Meanings
/// ============================================================================

class OtlobColorSystem {
  const OtlobColorSystem._();

  // Primary Egyptian Sunset Palette
  static const Color egyptianSunset = Color(0xFFE07A5F);    // Terracotta orange
  static const Color nileBlue = Color(0xFF0D1B2A);          // Deep navy
  static const Color saharaGold = Color(0xFFF4D06F);        // Warm gold
  static const Color desertSand = Color(0xFFF8F9FA);        // Light sand
  static const Color pharaohRed = Color(0xFFFA3A46);        // Imperial red

  // Egyptian Cultural Color Meanings
  static const Color hospitality = Color(0xFFE07A5F);        // Warm welcome
  static const Color tradition = Color(0xFFD4A574);         // Ancient heritage
  static const Color celebration = Color(0xFFF4D06F);        // Joy and festivity
  static const Color purity = Color(0xFFFFFFFF);            // Clean and sacred
  static const Color power = Color(0xFF0D1B2A);             // Authority and depth

  // Semantic Colors with Egyptian Context
  static const Color success = Color(0xFF27AE60);           // Egyptian mint (prosperity)
  static const Color warning = Color(0xFFF39C12);           // Desert amber (caution)
  static const Color error = Color(0xFFE74C3C);             // Nile sunset (alert)
  static const Color info = Color(0xFF3498DB);              // Mediterranean blue

  // Food Category Colors
  static const Color egyptianCuisine = Color(0xFFD4A574);   // Traditional Egyptian
  static const Color streetFood = Color(0xFFFFA500);        // Popular street eats
  static const Color grill = Color(0xFFD2691E);             // Charcoal grilled
  static const Color seafood = Color(0xFF4A90E2);           // Mediterranean fresh
  static const Color vegetarian = Color(0xFF7CB342);        // Fresh garden
  static const Color desserts = Color(0xFFE91E63);          // Sweet celebrations

  // Badge & Status Colors
  static const Color hiddenGem = Color(0xFFFFC107);          // Tawseya badge
  static const Color localHero = Color(0xFF4CAF50);         // Community favorite
  static const Color tawseya = Color(0xFF9C27B0);           // Authenticity marker
  static const Color openNow = Color(0xFF10B981);            // Available
  static const Color closed = Color(0xFF9E9E9E);            // Unavailable

  // Rating Colors
  static const Color ratingExcellent = Color(0xFF10B981);    // Outstanding
  static const Color ratingGood = Color(0xFF7CB342);         // Very good
  static const Color ratingAverage = Color(0xFFFFA500);      // Good
  static const Color ratingBelowAverage = Color(0xFFFF6B6B); // Needs improvement

  // Light Theme Color Scheme
  static ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: egyptianSunset,
    onPrimary: Colors.white,
    primaryContainer: saharaGold,
    onPrimaryContainer: nileBlue,

    secondary: saharaGold,
    onSecondary: nileBlue,
    secondaryContainer: desertSand,
    onSecondaryContainer: nileBlue,

    tertiary: pharaohRed,
    onTertiary: Colors.white,
    tertiaryContainer: hospitality,
    onTertiaryContainer: Colors.white,

    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: error,

    surface: desertSand,
    onSurface: nileBlue,
    surfaceContainerHighest: Colors.white,
    onSurfaceVariant: Color(0xFF6C757D),

    outline: Color(0xFFE3E3E3),
    outlineVariant: Color(0xFF7F7F7F),

    shadow: Color(0x260D1B2A),
    scrim: Color(0x990D1B2A),
    inverseSurface: nileBlue,
    onInverseSurface: Colors.white,
    inversePrimary: saharaGold,
  );

  // Dark Theme Color Scheme
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: egyptianSunset,
    onPrimary: Colors.white,
    primaryContainer: saharaGold,
    onPrimaryContainer: nileBlue,

    secondary: saharaGold,
    onSecondary: nileBlue,
    secondaryContainer: Color(0xFF2A2A2A),
    onSecondaryContainer: saharaGold,

    tertiary: pharaohRed,
    onTertiary: Colors.white,
    tertiaryContainer: hospitality,
    onTertiaryContainer: Colors.white,

    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    surface: nileBlue,
    onSurface: desertSand,
    surfaceContainerHighest: Color(0xFF1E1E1E),
    onSurfaceVariant: Color(0xFFC8C8C8),

    outline: Color(0xFF4A4A4A),
    outlineVariant: Color(0xFF262626),

    shadow: Color(0x4D000000),
    scrim: Color(0xCC000000),
    inverseSurface: desertSand,
    onInverseSurface: nileBlue,
    inversePrimary: saharaGold,
  );

  // Gradient Definitions
  static LinearGradient get egyptianSunsetGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [egyptianSunset, saharaGold],
  );

  static LinearGradient get nileGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [nileBlue, Color(0xFF1E3A5F)],
  );

  static LinearGradient get hospitalityGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [hospitality, saharaGold],
  );

  // Helper Methods
  static Color getCuisineColor(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'egyptian':
      case 'مصري':
        return egyptianCuisine;
      case 'street food':
      case 'طعام الشارع':
        return streetFood;
      case 'grill':
      case 'مشويات':
        return grill;
      case 'seafood':
      case 'مأكولات بحرية':
        return seafood;
      case 'vegetarian':
      case 'نباتي':
        return vegetarian;
      case 'desserts':
      case 'حلويات':
        return desserts;
      default:
        return egyptianSunset;
    }
  }

  static Color getRatingColor(double rating) {
    if (rating >= 4.5) return ratingExcellent;
    if (rating >= 4.0) return ratingGood;
    if (rating >= 3.5) return ratingAverage;
    return ratingBelowAverage;
  }

  static Color withOpacity(Color color, double opacity) => color.withOpacity(opacity);
}

/// ============================================================================
/// TYPOGRAPHY SYSTEM - Complete Scale with Arabic/RTL Support
/// ============================================================================

class OtlobTypographySystem {
  const OtlobTypographySystem._();

  // Display Styles (Hero Headlines)
  static TextStyle get display2xl => TextStyle(
    fontSize: 72.sp,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.02,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get displayXl => TextStyle(
    fontSize: 60.sp,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.02,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get displayLg => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get displayMd => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get displaySm => TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  // Heading Styles
  static TextStyle get h1 => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get h3 => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get h4 => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get h5 => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get h6 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  // Body Styles
  static TextStyle get bodyXl => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyLg => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyMd => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: const Color(0xFF6C757D),
    fontFamily: 'Poppins',
  );

  static TextStyle get bodySm => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
    color: const Color(0xFF6C757D),
    fontFamily: 'Poppins',
  );

  // Label Styles
  static TextStyle get labelXl => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelLg => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelMd => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelSm => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
    color: const Color(0xFF6C757D),
    fontFamily: 'Poppins',
  );

  // Arabic Typography (Cairo Font)
  static TextStyle get h1Arabic => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle get h2Arabic => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle get bodyLgArabic => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: OtlobColorSystem.nileBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle get bodyMdArabic => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: const Color(0xFF6C757D),
    fontFamily: 'Cairo',
  );

  // Logo Typography (Tutano CC)
  static TextStyle logoFont({
    required LogoSize size,
    Color color = OtlobColorSystem.pharaohRed,
  }) {
    var fontSize = switch (size) {
      LogoSize.small => 24.0,
      LogoSize.medium => 32.0,
      LogoSize.large => 48.0,
      LogoSize.hero => 64.0,
    };

    return TextStyle(
      fontFamily: 'TutanoCCV2',
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: color,
      letterSpacing: 0.5,
    );
  }
}

/// ============================================================================
/// SPACING SYSTEM - 8-Point Grid
/// ============================================================================

class OtlobSpacingSystem {
  const OtlobSpacingSystem._();

  // Base Grid Units (8dp increments)
  static double get xs => 4.0.w;    // 4dp
  static double get sm => 8.0.w;    // 8dp
  static double get md => 16.0.w;   // 16dp
  static double get lg => 24.0.w;   // 24dp
  static double get xl => 32.0.w;   // 32dp
  static double get xxl => 48.0.w;  // 48dp
  static double get xxxl => 64.0.w; // 64dp

  // Component Spacing
  static double get cardPadding => md;
  static double get screenPadding => md;
  static double get sectionSpacing => lg;
  static double get itemSpacing => sm;

  // Button Padding
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: 12.0.h,
  );

  static EdgeInsets get buttonPaddingLarge => EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static EdgeInsets get buttonPaddingSmall => EdgeInsets.symmetric(
    horizontal: 12.0.w,
    vertical: sm,
  );

  // Input Padding
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: 14.0.h,
  );

  // Chip Padding
  static EdgeInsets get chipPadding => EdgeInsets.symmetric(
    horizontal: 12.0.w,
    vertical: 6.0.h,
  );

  // Dialog Padding
  static EdgeInsets get dialogPadding => EdgeInsets.all(lg);

  // Bottom Sheet Padding
  static EdgeInsets get bottomSheetPadding => EdgeInsets.all(md);

  // List Tile Padding
  static EdgeInsets get listTilePadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: 12.0.h,
  );

  // Edge Insets Presets
  static EdgeInsets get zero => EdgeInsets.zero;
  static EdgeInsets get allXs => EdgeInsets.all(xs);
  static EdgeInsets get allSm => EdgeInsets.all(sm);
  static EdgeInsets get allMd => EdgeInsets.all(md);
  static EdgeInsets get allLg => EdgeInsets.all(lg);
  static EdgeInsets get allXl => EdgeInsets.all(xl);

  // Horizontal Spacing
  static EdgeInsets get horizontalXs => EdgeInsets.symmetric(horizontal: xs);
  static EdgeInsets get horizontalSm => EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get horizontalMd => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get horizontalLg => EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get horizontalXl => EdgeInsets.symmetric(horizontal: xl);

  // Vertical Spacing
  static EdgeInsets get verticalXs => EdgeInsets.symmetric(vertical: xs);
  static EdgeInsets get verticalSm => EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get verticalMd => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get verticalLg => EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get verticalXl => EdgeInsets.symmetric(vertical: xl);

  // Gap Widgets
  static Widget get gapXs => SizedBox(width: xs);
  static Widget get gapSm => SizedBox(width: sm);
  static Widget get gapMd => SizedBox(width: md);
  static Widget get gapLg => SizedBox(width: lg);
  static Widget get gapXl => SizedBox(width: xl);

  static Widget get vGapXs => SizedBox(height: xs);
  static Widget get vGapSm => SizedBox(height: sm);
  static Widget get vGapMd => SizedBox(height: md);
  static Widget get vGapLg => SizedBox(height: lg);
  static Widget get vGapXl => SizedBox(height: xl);
}

/// ============================================================================
/// COMPONENT SYSTEM - Design Tokens
/// ============================================================================

class OtlobComponentSystem {
  const OtlobComponentSystem._();

  // Button Specifications
  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 44;
  static const double buttonHeightLarge = 52;

  static const double buttonBorderRadius = 8;
  static const double buttonBorderWidth = 1.5;

  // Card Specifications
  static const double cardBorderRadius = 12;
  static const double cardElevation = 2;
  static const double cardPadding = 16;

  // Input Field Specifications
  static const double inputHeight = 48;
  static const double inputBorderRadius = 8;
  static const double inputBorderWidth = 1;

  // Icon Specifications
  static const double iconSizeXs = 12;
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 20;
  static const double iconSizeLg = 24;
  static const double iconSizeXl = 32;
  static const double iconSizeXxl = 48;

  // Badge Specifications
  static const double badgeHeight = 20;
  static const double badgePaddingHorizontal = 8;
  static const double badgeBorderRadius = 10;

  // Chip Specifications
  static const double chipHeight = 32;
  static const double chipPaddingHorizontal = 12;
  static const double chipBorderRadius = 16;

  // Border Radius Tokens
  static BorderRadius get radiusNone => BorderRadius.zero;
  static BorderRadius get radiusXs => BorderRadius.circular(2);
  static BorderRadius get radiusSm => BorderRadius.circular(4);
  static BorderRadius get radiusMd => BorderRadius.circular(8);
  static BorderRadius get radiusLg => BorderRadius.circular(12);
  static BorderRadius get radiusXl => BorderRadius.circular(16);
  static BorderRadius get radiusXxl => BorderRadius.circular(24);
  static BorderRadius get radiusFull => BorderRadius.circular(999);

  // Shadow Tokens
  static List<BoxShadow> get shadowNone => [];
  static List<BoxShadow> get shadowXs => [
    const BoxShadow(
      color: Color(0x0A0D1B2A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowSm => [
    const BoxShadow(
      color: Color(0x140D1B2A),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    const BoxShadow(
      color: Color(0x1F0D1B2A),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    const BoxShadow(
      color: Color(0x290D1B2A),
      blurRadius: 8,
      offset: Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get shadowXl => [
    const BoxShadow(
      color: Color(0x330D1B2A),
      blurRadius: 12,
      offset: Offset(0, 8),
    ),
  ];
}

/// ============================================================================
/// ANIMATION SYSTEM - Motion Design
/// ============================================================================

class OtlobAnimationSystem {
  const OtlobAnimationSystem._();

  // Duration Scale
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationExtraSlow = Duration(milliseconds: 600);

  // Specific Use Cases
  static const Duration buttonPress = durationFast;
  static const Duration cardAnimation = durationNormal;
  static const Duration pageTransition = durationNormal;
  static const Duration bottomSheet = durationNormal;
  static const Duration dialog = durationFast;
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration toast = Duration(milliseconds: 200);
  static const Duration snackbar = Duration(milliseconds: 250);

  // Easing Curves
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeIn = Curves.easeInCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve linear = Curves.linear;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Component-Specific Curves
  static const Curve buttonCurve = easeOut;
  static const Curve pageTransitionCurve = easeInOut;
  static const Curve bottomSheetCurve = easeOut;
  static const Curve dialogCurve = fastOutSlowIn;
  static const Curve cardCurve = easeInOut;

  // Transition Builders
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) => FadeTransition(opacity: animation, child: child);

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

  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
    Alignment alignment = Alignment.center,
  }) => ScaleTransition(
    scale: CurvedAnimation(parent: animation, curve: easeOut),
    alignment: alignment,
    child: child,
  );
}

/// ============================================================================
/// EGYPTIAN CULTURAL SYSTEM - Cultural Design Elements
/// ============================================================================

class OtlobCulturalSystem {
  const OtlobCulturalSystem._();

  // Egyptian Cultural Colors
  static const Color ancientStone = Color(0xFFD4A574);      // Sandstone
  static const Color nileWater = Color(0xFF4A90E2);         // Sacred Nile
  static const Color pharaohGold = Color(0xFFF4D06F);       // Royal gold
  static const Color templeRed = Color(0xFFE53E3E);         // Temple walls
  static const Color lotusWhite = Color(0xFFFFFCF2);        // Sacred lotus

  // Ramadan/Eid Theme Colors
  static const Color ramadanGreen = Color(0xFF10B981);       // Islamic green
  static const Color eidGold = Color(0xFFFFD700);            // Celebration gold
  static const Color crescentSilver = Color(0xFFC0C0C0);     // Moon crescent

  // Cultural Pattern Colors
  static const Color mashrabiyaLight = Color(0xFFF8F9FA);   // Light wood
  static const Color mashrabiyaDark = Color(0xFF8B4513);    // Dark wood
  static const Color islamicArt = Color(0xFF1E40AF);        // Islamic blue

  // Cultural Theme Variants
  static const OtlobCulturalTheme ramadan = OtlobCulturalTheme(
    primary: ramadanGreen,
    secondary: eidGold,
    accent: crescentSilver,
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
  );

  static const OtlobCulturalTheme eid = OtlobCulturalTheme(
    primary: eidGold,
    secondary: ramadanGreen,
    accent: crescentSilver,
    background: Color(0xFFFFFBEB),
    surface: Colors.white,
  );

  static const OtlobCulturalTheme normal = OtlobCulturalTheme(
    primary: OtlobColorSystem.egyptianSunset,
    secondary: OtlobColorSystem.saharaGold,
    accent: OtlobColorSystem.pharaohRed,
    background: OtlobColorSystem.desertSand,
    surface: Colors.white,
  );

  // Geometric Pattern Definitions (Mashrabiya-inspired)
  static const List<double> mashrabiyaPattern = [
    0.0, 0.2, 0.3, 0.5, 0.7, 0.8, 1.0  // Alternating solid/void pattern
  ];

  static const List<double> islamicGeometry = [
    0.0, 0.25, 0.5, 0.75, 1.0  // 8-point star pattern
  ];

  // Cultural Motifs
  static const String lotusMotif = 'lotus';      // Sacred flower
  static const String ankhMotif = 'ankh';        // Life symbol
  static const String scarabMotif = 'scarab';    // Protection
  static const String eyeMotif = 'eye';          // Protection (Eye of Horus)
}

/// ============================================================================
/// CULTURAL THEME CLASS
/// ============================================================================

class OtlobCulturalTheme {
  const OtlobCulturalTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
}

/// ============================================================================
/// LOGO SIZE ENUM
/// ============================================================================

enum LogoSize {
  small,   // 24sp
  medium,  // 32sp
  large,   // 48sp
  hero,    // 64sp
}

/// ============================================================================
/// RESPONSIVE BREAKPOINTS
/// ============================================================================

class OtlobBreakpoints {
  static double get mobile => 480;
  static double get tablet => 768;
  static double get desktop => 1024;
  static double get wide => 1440;

  static bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < tablet;

  static bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= tablet &&
    MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= desktop;
}

/// ============================================================================
/// ACCESSIBILITY UTILITIES
/// ============================================================================

class OtlobAccessibility {
  // WCAG Contrast Ratios
  static bool hasMinimumContrast(Color background, Color foreground) {
    var contrastRatio = _calculateContrastRatio(background, foreground);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  static bool hasEnhancedContrast(Color background, Color foreground) {
    var contrastRatio = _calculateContrastRatio(background, foreground);
    return contrastRatio >= 7.0; // WCAG AAA standard
  }

  static double _calculateContrastRatio(Color a, Color b) {
    var l1 = _relativeLuminance(a);
    var l2 = _relativeLuminance(b);
    var lighter = [l1, l2].reduce((a, b) => a > b ? a : b);
    var darker = [l1, l2].reduce((a, b) => a < b ? a : b);
    return (lighter + 0.05) / (darker + 0.05);
  }

  static double _relativeLuminance(Color color) {
    var r = color.r / 255;
    var g = color.g / 255;
    var b = color.b / 255;

    r = r <= 0.03928 ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928 ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928 ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
}