import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography System
///
/// Defines the complete text style hierarchy using Poppins font family.
/// All text sizes use flutter_screenutil for responsive scaling.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.displayLarge)
/// Text('World', style: AppTypography.bodyMedium)
/// ```
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // ============================================================================
  // DISPLAY STYLES - Hero Headlines & Major Titles
  // ============================================================================

  /// Display Large - 32sp, Bold (w700)
  /// Used for: Hero headlines, landing page titles, major announcements
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.primaryDark,
  );

  /// Display Medium - 28sp, Bold (w700)
  /// Used for: Section titles, feature highlights
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.3,
    color: AppColors.primaryDark,
  );

  /// Display Small - 24sp, SemiBold (w600)
  /// Used for: Screen titles, modal headers
  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.primaryDark,
  );

  // ============================================================================
  // HEADLINE STYLES - Section & Subsection Headers
  // ============================================================================

  /// Headline Large - 24sp, SemiBold (w600)
  /// Used for: Card headers, major category titles
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.primaryDark,
  );

  /// Headline Medium - 20sp, SemiBold (w600)
  /// Used for: Subsection headers, list group titles
  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primaryDark,
  );

  /// Headline Small - 18sp, Medium (w500)
  /// Used for: List headers, small section titles
  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primaryDark,
  );

  // ============================================================================
  // TITLE STYLES - Content Titles
  // ============================================================================

  /// Title Large - 18sp, Medium (w500)
  /// Used for: Restaurant names, main item titles
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.darkGray,
  );

  /// Title Medium - 16sp, Medium (w500)
  /// Used for: Dish names, product titles, card titles
  static TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.darkGray,
  );

  /// Title Small - 14sp, Medium (w500)
  /// Used for: Small titles, form labels, tab labels
  static TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.darkGray,
  );

  // ============================================================================
  // BODY STYLES - Main Content Text
  // ============================================================================

  /// Body Large - 16sp, Regular (w400)
  /// Used for: Main body text, descriptions, paragraphs
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.darkGray,
  );

  /// Body Medium - 14sp, Regular (w400)
  /// Used for: Secondary text, list items, form input text
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.gray,
  );

  /// Body Small - 12sp, Regular (w400)
  /// Used for: Captions, helper text, footnotes
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.gray,
  );

  // ============================================================================
  // LABEL STYLES - Buttons, Chips, Badges
  // ============================================================================

  /// Label Large - 14sp, Medium (w500)
  /// Used for: Buttons, CTAs, action labels
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  /// Label Medium - 12sp, Medium (w500)
  /// Used for: Chips, badges, small buttons
  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  /// Label Small - 11sp, Medium (w500)
  /// Used for: Tiny labels, status indicators, timestamps
  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.gray,
  );

  // ============================================================================
  // ARABIC TYPOGRAPHY - Cairo Font (RTL Support)
  // ============================================================================

  /// Arabic Display Large - 32sp, Bold (RTL)
  static TextStyle displayLargeArabic = GoogleFonts.cairo(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.primaryDark,
  );

  /// Arabic Display Medium - 28sp, Bold (RTL)
  static TextStyle displayMediumArabic = GoogleFonts.cairo(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.primaryDark,
  );

  /// Arabic Display Small - 24sp, SemiBold (RTL)
  static TextStyle displaySmallArabic = GoogleFonts.cairo(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.primaryDark,
  );

  /// Arabic Headline Large - 24sp, SemiBold (RTL)
  static TextStyle headlineLargeArabic = GoogleFonts.cairo(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.primaryDark,
  );

  /// Arabic Headline Medium - 20sp, SemiBold (RTL)
  static TextStyle headlineMediumArabic = GoogleFonts.cairo(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.primaryDark,
  );

  /// Arabic Headline Small - 18sp, Medium (RTL)
  static TextStyle headlineSmallArabic = GoogleFonts.cairo(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.primaryDark,
  );

  /// Arabic Title Large - 18sp, Medium (RTL)
  static TextStyle titleLargeArabic = GoogleFonts.cairo(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.darkGray,
  );

  /// Arabic Title Medium - 16sp, Medium (RTL)
  static TextStyle titleMediumArabic = GoogleFonts.cairo(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.darkGray,
  );

  /// Arabic Title Small - 14sp, Medium (RTL)
  static TextStyle titleSmallArabic = GoogleFonts.cairo(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.darkGray,
  );

  /// Arabic Body Large - 16sp, Regular (RTL)
  static TextStyle bodyLargeArabic = GoogleFonts.cairo(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.darkGray,
  );

  /// Arabic Body Medium - 14sp, Regular (RTL)
  static TextStyle bodyMediumArabic = GoogleFonts.cairo(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.gray,
  );

  /// Arabic Body Small - 12sp, Regular (RTL)
  static TextStyle bodySmallArabic = GoogleFonts.cairo(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.gray,
  );

  /// Arabic Label Large - 14sp, Medium (RTL)
  static TextStyle labelLargeArabic = GoogleFonts.cairo(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.white,
  );

  /// Arabic Label Medium - 12sp, Medium (RTL)
  static TextStyle labelMediumArabic = GoogleFonts.cairo(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.white,
  );

  /// Arabic Label Small - 11sp, Medium (RTL)
  static TextStyle labelSmallArabic = GoogleFonts.cairo(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.gray,
  );

  // ============================================================================
  // RTL-AWARE TEXT THEME - Dynamic font selection based on locale
  // ============================================================================

  /// Get appropriate text style based on current locale
  static TextStyle getResponsiveTextStyle(TextStyle englishStyle, TextStyle arabicStyle, BuildContext context) {
    var locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? arabicStyle : englishStyle;
  }

  /// Get RTL-aware text theme for Material 3
  static TextTheme getResponsiveTextTheme(BuildContext context) {
    var locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? arabicTextTheme : textTheme;
  }

  /// Arabic Material 3 TextTheme for RTL support
  static TextTheme get arabicTextTheme => TextTheme(
    displayLarge: displayLargeArabic,
    displayMedium: displayMediumArabic,
    displaySmall: displaySmallArabic,
    headlineLarge: headlineLargeArabic,
    headlineMedium: headlineMediumArabic,
    headlineSmall: headlineSmallArabic,
    titleLarge: titleLargeArabic,
    titleMedium: titleMediumArabic,
    titleSmall: titleSmallArabic,
    bodyLarge: bodyLargeArabic,
    bodyMedium: bodyMediumArabic,
    bodySmall: bodySmallArabic,
    labelLarge: labelLargeArabic,
    labelMedium: labelMediumArabic,
    labelSmall: labelSmallArabic,
  );

  // ============================================================================
  // BRANDING TYPOGRAPHY - Tutano CC Logo Font
  // ============================================================================

  /// Logo text style - Uses Tutano CC font for the "Otlob" branding
  /// Available in multiple sizes for different use cases
  ///
  /// Usage:
  /// ```dart
  /// Text('Otlob', style: AppTypography.logoFont(size: LogoSize.large))
  /// ```
  static TextStyle logoFont({
    required LogoSize size,
    Color color = AppColors.logoRed,
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

  // ============================================================================
  // UTILITY METHODS - Text Style Modifiers
  // ============================================================================

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(color: color);

  /// Make text style bold
  static TextStyle bold(TextStyle style) => style.copyWith(fontWeight: FontWeight.w700);

  /// Make text style italic
  static TextStyle italic(TextStyle style) => style.copyWith(fontStyle: FontStyle.italic);

  /// Apply underline to text style
  static TextStyle underline(TextStyle style) => style.copyWith(decoration: TextDecoration.underline);

  /// Apply line-through to text style
  static TextStyle lineThrough(TextStyle style) => style.copyWith(decoration: TextDecoration.lineThrough);

  // ============================================================================
  // MATERIAL 3 TEXT THEME - For ThemeData
  // ============================================================================

  /// Complete Material 3 TextTheme for use in ThemeData
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}

// ============================================================================
// LOGO SIZE ENUM - For logo text sizing
// ============================================================================

/// Logo size options for the Otlob branding
enum LogoSize {
  /// Small logo - 24sp (for app bars, navigation)
  small,

  /// Medium logo - 32sp (for cards, sections)
  medium,

  /// Large logo - 48sp (for splash, onboarding)
  large,

  /// Hero logo - 64sp (for landing pages, hero sections)
  hero,
}
