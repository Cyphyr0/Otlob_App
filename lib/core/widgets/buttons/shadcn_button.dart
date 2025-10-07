import 'package:flutter/material.dart';
import 'package:otlob_app/core/theme/otlob_design_system.dart';

/// Shadcn UI inspired Button Component
/// Provides consistent button styling with various variants and states
enum ShadcnButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum ShadcnButtonSize {
  sm,
  default_,
  lg,
}

/// Modern Button widget inspired by Shadcn UI
class ShadcnButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final IconData? icon;
  final ShadcnButtonVariant variant;
  final ShadcnButtonSize size;
  final bool enabled;
  final bool loading;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ShadcnButton({
    super.key,
    this.child,
    this.text,
    this.icon,
    this.variant = ShadcnButtonVariant.primary,
    this.size = ShadcnButtonSize.default_,
    this.enabled = true,
    this.loading = false,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(child != null || text != null, 'Either child or text must be provided');

  @override
  State<ShadcnButton> createState() => _ShadcnButtonState();
}

class _ShadcnButtonState extends State<ShadcnButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled && !widget.loading && widget.onPressed != null) {
      _animationController.forward().then((_) => _animationController.reverse());
      widget.onPressed!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = _getButtonStyle(colorScheme);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              decoration: buttonStyle.decoration,
              padding: buttonStyle.padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.loading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          buttonStyle.foregroundColor,
                        ),
                      ),
                    )
                  else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: buttonStyle.iconSize,
                      color: buttonStyle.foregroundColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  widget.child ??
                      Text(
                        widget.text!,
                        style: buttonStyle.textStyle.copyWith(
                          color: buttonStyle.foregroundColor,
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _ButtonStyleData _getButtonStyle(ColorScheme colorScheme) {
    final baseColors = _getVariantColors(colorScheme);
    final sizeData = _getSizeData();

    return _ButtonStyleData(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? baseColors.backgroundColor,
        borderRadius: BorderRadius.circular(OtlobDesignSystem.radiusLg),
        border: baseColors.borderColor != null
            ? Border.all(color: baseColors.borderColor!)
            : null,
        boxShadow: widget.variant == ShadcnButtonVariant.primary
            ? OtlobDesignSystem.shadowMd
            : null,
      ),
      foregroundColor: widget.foregroundColor ?? baseColors.foregroundColor,
      textStyle: sizeData.textStyle,
      padding: sizeData.padding,
      iconSize: sizeData.iconSize,
    );
  }

  _ButtonColors _getVariantColors(ColorScheme colorScheme) {
    final disabledOpacity = widget.enabled ? 1.0 : 0.6;

    switch (widget.variant) {
      case ShadcnButtonVariant.primary:
        return _ButtonColors(
          backgroundColor: (widget.backgroundColor ?? OtlobDesignSystem.secondary).withOpacity(disabledOpacity),
          foregroundColor: widget.foregroundColor ?? Colors.white,
        );

      case ShadcnButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: (widget.backgroundColor ?? OtlobDesignSystem.surface).withOpacity(disabledOpacity),
          foregroundColor: widget.foregroundColor ?? OtlobDesignSystem.textPrimary,
        );

      case ShadcnButtonVariant.outline:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.foregroundColor ?? OtlobDesignSystem.textPrimary,
          borderColor: OtlobDesignSystem.border.withOpacity(disabledOpacity),
        );

      case ShadcnButtonVariant.ghost:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.foregroundColor ?? OtlobDesignSystem.textPrimary,
        );

      case ShadcnButtonVariant.destructive:
        return _ButtonColors(
          backgroundColor: OtlobDesignSystem.error.withOpacity(disabledOpacity),
          foregroundColor: widget.foregroundColor ?? Colors.white,
        );
    }
  }

  _ButtonSizeData _getSizeData() {
    switch (widget.size) {
      case ShadcnButtonSize.sm:
        return _ButtonSizeData(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: OtlobDesignSystem.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          iconSize: 14,
        );

      case ShadcnButtonSize.default_:
        return _ButtonSizeData(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: OtlobDesignSystem.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          iconSize: 16,
        );

      case ShadcnButtonSize.lg:
        return _ButtonSizeData(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: OtlobDesignSystem.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          iconSize: 18,
        );
    }
  }
}

/// Helper classes for button styling
class _ButtonStyleData {
  final BoxDecoration decoration;
  final Color foregroundColor;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double iconSize;

  const _ButtonStyleData({
    required this.decoration,
    required this.foregroundColor,
    required this.textStyle,
    required this.padding,
    required this.iconSize,
  });
}

class _ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}

class _ButtonSizeData {
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double iconSize;

  const _ButtonSizeData({
    required this.padding,
    required this.textStyle,
    required this.iconSize,
  });
}
