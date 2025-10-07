import "package:flutter/material.dart";
import "../../theme/app_colors.dart";
import "../../theme/app_typography.dart";
import "../../theme/app_animations.dart";

/// Otlob Logo Widget
///
/// A flexible, branded logo component that displays "Otlob" (or "أطلب" for Arabic)
/// using the Tutano CC font in the brand's signature red color.
///
/// Features:
/// - Multiple size options (small, medium, large, hero)
/// - Optional pulse animation for splash/loading states
/// - Customizable color (defaults to brand red #FA3A46)
/// - Responsive sizing with flutter_screenutil
/// - RTL support for Arabic
///
/// Usage Examples:
/// ```dart
/// // Simple static logo
/// OtlobLogo(size: LogoSize.medium)
///
/// // Animated logo for splash screen
/// OtlobLogo(
///   size: LogoSize.hero,
///   animated: true,
/// )
///
/// // Custom colored logo
/// OtlobLogo(
///   size: LogoSize.small,
///   color: Colors.white,
/// )
///
/// // Arabic version
/// OtlobLogo(
///   size: LogoSize.large,
///   isArabic: true,
/// )
/// ```
class OtlobLogo extends StatefulWidget {

  const OtlobLogo({
    super.key,
    this.size = LogoSize.medium,
    this.color,
    this.animated = false,
    this.isArabic = false,
    this.animationDuration,
  });
  /// Size of the logo (small: 24sp, medium: 32sp, large: 48sp, hero: 64sp)
  final LogoSize size;

  /// Color of the logo text (defaults to brand red #FA3A46)
  final Color? color;

  /// Whether to show pulse animation (useful for splash/loading screens)
  final bool animated;

  /// Display Arabic version "أطلب" instead of "Otlob"
  final bool isArabic;

  /// Animation duration for pulse effect
  final Duration? animationDuration;

  @override
  State<OtlobLogo> createState() => _OtlobLogoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<LogoSize>('size', size));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<bool>('animated', animated));
    properties.add(DiagnosticsProperty<bool>('isArabic', isArabic));
    properties.add(DiagnosticsProperty<Duration?>('animationDuration', animationDuration));
  }
}

class _OtlobLogoState extends State<OtlobLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animated) {
      _controller = AnimationController(
        duration: widget.animationDuration ?? AppAnimations.slow,
        vsync: this,
      );

      _scaleAnimation = Tween<double>(begin: 1, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
      );

      // Start infinite pulse animation
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var logoText = widget.isArabic ? "أطلب" : "Otlob";
    var logoColor = widget.color ?? AppColors.logoRed;

    Widget logo = Text(
      logoText,
      style: AppTypography.logoFont(size: widget.size, color: logoColor),
      textAlign: TextAlign.center,
    );

    // Wrap with animation if enabled
    if (widget.animated) {
      logo = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: logo,
      );
    }

    return logo;
  }
}

/// Logo Size Entrance Animation Widget
///
/// Wraps the OtlobLogo with entrance animations for splash screens
/// and onboarding flows.
///
/// Usage:
/// ```dart
/// OtlobLogoWithEntrance(
///   size: LogoSize.hero,
///   onAnimationComplete: () {
///     // Navigate to next screen
///   },
/// )
/// ```
class OtlobLogoWithEntrance extends StatefulWidget {

  const OtlobLogoWithEntrance({
    super.key,
    this.size = LogoSize.hero,
    this.color,
    this.isArabic = false,
    this.onAnimationComplete,
  });
  final LogoSize size;
  final Color? color;
  final bool isArabic;
  final VoidCallback? onAnimationComplete;

  @override
  State<OtlobLogoWithEntrance> createState() => _OtlobLogoWithEntranceState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<LogoSize>('size', size));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<bool>('isArabic', isArabic));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAnimationComplete', onAnimationComplete));
  }
}

class _OtlobLogoWithEntranceState extends State<OtlobLogoWithEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeInOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeInOutCubic),
      ),
    );

    // Start animation
    _controller.forward().then((_) {
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: OtlobLogo(
        size: widget.size,
        color: widget.color,
        isArabic: widget.isArabic,
      ),
    );
}
