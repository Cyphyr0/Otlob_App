import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';

/// Enhanced Card Component with Modern Design
///
/// A sophisticated card component featuring:
/// - Multiple elevation levels with smooth transitions
/// - Hover effects with scale and shadow animations
/// - Egyptian cultural styling with warm colors
/// - Customizable content sections
/// - Accessibility features
///
/// Usage:
/// ```dart
/// EnhancedCard(
///   elevation: CardElevation.medium,
///   onTap: () => navigateToDetails(),
///   child: Column(
///     children: [
///       EnhancedCard.header(
///         title: 'Restaurant Name',
///         subtitle: 'Egyptian • Fast Food',
///       ),
///       EnhancedCard.content(
///         child: Text('Restaurant description...'),
///       ),
///       EnhancedCard.footer(
///         actions: [
///           ModernButton.ghost(text: 'View Menu'),
///           ModernButton.primary(text: 'Order Now'),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
class EnhancedCard extends StatefulWidget {
  const EnhancedCard({
    super.key,
    this.child,
    this.header,
    this.content,
    this.footer,
    this.elevation = CardElevation.medium,
    this.borderRadius,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.onHover,
    this.semanticLabel,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
    this.enableHover = true,
    this.enableScale = true,
    this.customShadow,
  });

  /// Card content - alternative to using child
  final Widget? child;

  /// Optional card sections
  final Widget? header;
  final Widget? content;
  final Widget? footer;

  /// Visual styling
  final CardElevation elevation;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final bool enableHover;
  final bool enableScale;
  final List<BoxShadow>? customShadow;

  /// Interaction callbacks
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(bool)? onHover;

  /// Accessibility
  final String? semanticLabel;

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<CardElevation>('elevation', elevation));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<EdgeInsets?>('margin', margin));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<bool>('enableHover', enableHover));
    properties.add(DiagnosticsProperty<bool>('enableScale', enableScale));
    properties.add(IterableProperty<BoxShadow>('customShadow', customShadow));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<Function(bool p1)?>.has('onHover', onHover));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class _EnhancedCardState extends State<EnhancedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(
      begin: _getElevationValue(widget.elevation),
      end: _getElevationValue(CardElevation.high),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getElevationValue(CardElevation elevation) {
    switch (elevation) {
      case CardElevation.none:
        return 0;
      case CardElevation.low:
        return 2;
      case CardElevation.medium:
        return 4;
      case CardElevation.high:
        return 8;
      case CardElevation.extra:
        return 12;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      _animationController.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      _animationController.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleHover(bool isHovered) {
    if (widget.enableHover && widget.onTap != null) {
      setState(() => _isHovered = isHovered);
      widget.onHover?.call(isHovered);

      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardRadius = widget.borderRadius ??
        BorderRadius.circular(16.r);

    final shadows = widget.customShadow ??
        _getShadows(_isHovered || _isPressed);

    Widget card = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: widget.enableScale ? _scaleAnimation.value : 1.0,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin ?? EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.white,
            borderRadius: cardRadius,
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1)
                : null,
            boxShadow: shadows,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: cardRadius,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onHover: _handleHover,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Container(
                padding: widget.padding ?? EdgeInsets.all(AppSpacing.md),
                child: _buildCardContent(),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.semanticLabel != null) {
      card = Semantics(
        label: widget.semanticLabel,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCardContent() {
    if (widget.child != null) {
      return widget.child!;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null) widget.header!,
        if (widget.content != null) widget.content!,
        if (widget.footer != null) widget.footer!,
      ],
    );
  }

  List<BoxShadow> _getShadows(bool isElevated) {
    if (widget.elevation == CardElevation.none) {
      return [];
    }

    final baseElevation = isElevated
        ? _getElevationValue(CardElevation.high)
        : _getElevationValue(widget.elevation);

    return [
      BoxShadow(
        color: AppColors.black.withOpacity(0.1),
        blurRadius: baseElevation * 2,
        offset: Offset(0, baseElevation * 0.5),
      ),
      if (isElevated)
        BoxShadow(
          color: AppColors.logoRed.withOpacity(0.1),
          blurRadius: baseElevation * 3,
          offset: Offset(0, baseElevation),
          spreadRadius: -1,
        ),
    ];
  }
}

/// Card elevation levels
enum CardElevation {
  none,
  low,
  medium,
  high,
  extra,
}

/// Pre-built card sections for consistent styling
class EnhancedCardSection extends StatelessWidget {
  const EnhancedCardSection._({
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  /// Card header section
  factory EnhancedCardSection.header({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) => EnhancedCardSection._(
      padding: padding ?? EdgeInsets.only(bottom: AppSpacing.sm),
      margin: margin,
      child: Row(
        children: [
          if (leading != null) ...[
            leading,
            SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlack,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );

  /// Card content section
  factory EnhancedCardSection.content({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
  }) => EnhancedCardSection._(
      padding: padding ?? EdgeInsets.symmetric(vertical: AppSpacing.sm),
      margin: margin,
      backgroundColor: backgroundColor,
      child: child,
    );

  /// Card footer section
  factory EnhancedCardSection.footer({
    Widget? child,
    List<Widget>? actions,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) => EnhancedCardSection._(
      padding: padding ?? EdgeInsets.only(top: AppSpacing.sm),
      margin: margin,
      child: child ??
          (actions != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                )
              : null),
    );

  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (child == null) return const SizedBox.shrink();

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsets?>('margin', margin));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
  }
}

/// Convenience methods for creating card sections
extension EnhancedCardExtensions on EnhancedCard {
  static Widget header({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
  }) => EnhancedCardSection.header(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
    );

  static Widget content({required Widget child}) => EnhancedCardSection.content(child: child);

  static Widget footer({Widget? child, List<Widget>? actions}) => EnhancedCardSection.footer(actions: actions, child: child);
}