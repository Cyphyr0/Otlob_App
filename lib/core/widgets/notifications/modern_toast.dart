import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Modern Toast and Snackbar Notifications
///
/// A sophisticated notification system featuring:
/// - Egyptian cultural design elements
/// - Smooth animations and transitions
/// - Multiple notification types
/// - Customizable positioning and styling
/// - Auto-dismiss with progress indicator
/// - Accessibility features
///
/// Usage:
/// ```dart
/// // Success toast
/// ModernToast.show(
///   context,
///   type: ToastType.success,
///   title: 'Order Placed!',
///   message: 'Your delicious meal is being prepared',
///   icon: Icons.check_circle,
/// )
///
/// // Error toast with action
/// ModernToast.show(
///   context,
///   type: ToastType.error,
///   title: 'Payment Failed',
///   message: 'Please try again or use another payment method',
///   actionText: 'Retry',
///   onActionPressed: () => retryPayment(),
/// )
///
/// // Cultural themed toast
/// ModernToast.show(
///   context,
///   type: ToastType.info,
///   title: 'Ramadan Special',
///   message: 'Enjoy 20% off on all Iftar meals',
///   culturalTheme: CulturalTheme.ramadan,
/// )
/// ```
class ModernToast extends StatefulWidget {
  const ModernToast._({
    required this.type,
    required this.title,
    required this.message,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.duration = const Duration(seconds: 4),
    this.position = ToastPosition.bottom,
    this.culturalTheme,
    this.customColor,
  });

  /// Show toast notification
  static void show(
    BuildContext context, {
    required ToastType type,
    required String title,
    required String message,
    IconData? icon,
    String? actionText,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
    CulturalTheme? culturalTheme,
    Color? customColor,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => ModernToast._(
        type: type,
        title: title,
        message: message,
        icon: icon,
        actionText: actionText,
        onActionPressed: onActionPressed,
        duration: duration,
        position: position,
        culturalTheme: culturalTheme,
        customColor: customColor,
      ),
    );

    overlay.insert(entry);

    // Auto remove after duration
    Future.delayed(duration + const Duration(milliseconds: 300), entry.remove);
  }

  final ToastType type;
  final String title;
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Duration duration;
  final ToastPosition position;
  final CulturalTheme? culturalTheme;
  final Color? customColor;

  @override
  State<ModernToast> createState() => _ModernToastState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ToastType>('type', type));
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('message', message));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(StringProperty('actionText', actionText));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onActionPressed', onActionPressed));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(EnumProperty<ToastPosition>('position', position));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
    properties.add(ColorProperty('customColor', customColor));
  }
}

class _ModernToastState extends State<ModernToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: _getSlideBegin(),
      end: 0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _progressAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getSlideBegin() {
    switch (widget.position) {
      case ToastPosition.top:
        return -100.h;
      case ToastPosition.bottom:
        return 100.h;
      case ToastPosition.center:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getToastConfig();

    return Positioned(
      top: widget.position == ToastPosition.top ? AppSpacing.lg : null,
      bottom: widget.position == ToastPosition.bottom ? AppSpacing.lg : null,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: config.borderColor != null
                      ? Border.all(color: config.borderColor!, width: 1)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Progress indicator
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        child: SizedBox(
                          height: 3.h,
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              config.progressColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Toast content
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: config.iconBackgroundColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              widget.icon ?? config.defaultIcon,
                              color: config.iconColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: config.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  widget.message,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: config.textColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action button
                          if (widget.actionText != null) ...[
                            SizedBox(width: AppSpacing.md),
                            GestureDetector(
                              onTap: widget.onActionPressed,
                              child: Text(
                                widget.actionText!,
                                style: AppTypography.labelLarge.copyWith(
                                  color: config.actionColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ToastConfig _getToastConfig() {
    switch (widget.type) {
      case ToastType.success:
        return ToastConfig(
          backgroundColor: AppColors.success.withOpacity(0.9),
          textColor: AppColors.white,
          iconColor: AppColors.white,
          iconBackgroundColor: AppColors.success.withOpacity(0.2),
          actionColor: AppColors.white,
          progressColor: AppColors.white.withOpacity(0.3),
          borderColor: null,
          defaultIcon: Icons.check_circle,
        );
      case ToastType.error:
        return ToastConfig(
          backgroundColor: AppColors.error.withOpacity(0.9),
          textColor: AppColors.white,
          iconColor: AppColors.white,
          iconBackgroundColor: AppColors.error.withOpacity(0.2),
          actionColor: AppColors.white,
          progressColor: AppColors.white.withOpacity(0.3),
          borderColor: null,
          defaultIcon: Icons.error,
        );
      case ToastType.warning:
        return ToastConfig(
          backgroundColor: AppColors.warning.withOpacity(0.9),
          textColor: AppColors.white,
          iconColor: AppColors.white,
          iconBackgroundColor: AppColors.warning.withOpacity(0.2),
          actionColor: AppColors.white,
          progressColor: AppColors.white.withOpacity(0.3),
          borderColor: null,
          defaultIcon: Icons.warning,
        );
      case ToastType.info:
        return ToastConfig(
          backgroundColor: AppColors.info.withOpacity(0.9),
          textColor: AppColors.white,
          iconColor: AppColors.white,
          iconBackgroundColor: AppColors.info.withOpacity(0.2),
          actionColor: AppColors.white,
          progressColor: AppColors.white.withOpacity(0.3),
          borderColor: null,
          defaultIcon: Icons.info,
        );
      case ToastType.cultural:
        return ToastConfig(
          backgroundColor: (widget.culturalTheme?.backgroundColor ??
              AppColors.primaryGold).withOpacity(0.9),
          textColor: AppColors.primaryBlack,
          iconColor: AppColors.primaryBlack,
          iconBackgroundColor: AppColors.primaryGold.withOpacity(0.2),
          actionColor: AppColors.logoRed,
          progressColor: AppColors.primaryBlack.withOpacity(0.3),
          borderColor: AppColors.primaryGold,
          defaultIcon: widget.culturalTheme?.icon ?? Icons.star,
        );
    }
  }
}

/// Toast configuration for different types
class ToastConfig {
  const ToastConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.actionColor,
    required this.progressColor,
    required this.borderColor,
    required this.defaultIcon,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color actionColor;
  final Color progressColor;
  final Color? borderColor;
  final IconData defaultIcon;
}

/// Toast types
enum ToastType {
  success,
  error,
  warning,
  info,
  cultural,
}

/// Toast positioning
enum ToastPosition {
  top,
  bottom,
  center,
}

/// Cultural theme variants
enum CulturalTheme {
  /// Ramadan theme
  ramadan._(
    name: 'ramadan',
    backgroundColor: AppColors.primaryGold,
    icon: Icons.star,
  ),

  /// Eid theme
  eid._(
    name: 'eid',
    backgroundColor: Color(0xFF27AE60),
    icon: Icons.celebration,
  ),

  /// Egyptian theme
  egyptian._(
    name: 'egyptian',
    backgroundColor: Color(0xFFE74C3C),
    icon: Icons.flag,
  );

  const CulturalTheme._({
    required this.name,
    required this.backgroundColor,
    required this.icon,
  });

  final String name;
  final Color backgroundColor;
  final IconData icon;
}

/// Snackbar extension for backward compatibility
extension SnackbarExtension on BuildContext {
  /// Show modern toast as snackbar
  void showToast({
    required ToastType type,
    required String title,
    required String message,
    IconData? icon,
    String? actionText,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ModernToast.show(
      this,
      type: type,
      title: title,
      message: message,
      icon: icon,
      actionText: actionText,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  /// Show success toast
  void showSuccessToast(String message, {String? title}) {
    showToast(
      type: ToastType.success,
      title: title ?? 'Success',
      message: message,
      icon: Icons.check_circle,
    );
  }

  /// Show error toast
  void showErrorToast(String message, {String? title}) {
    showToast(
      type: ToastType.error,
      title: title ?? 'Error',
      message: message,
      icon: Icons.error,
    );
  }

  /// Show warning toast
  void showWarningToast(String message, {String? title}) {
    showToast(
      type: ToastType.warning,
      title: title ?? 'Warning',
      message: message,
      icon: Icons.warning,
    );
  }

  /// Show info toast
  void showInfoToast(String message, {String? title}) {
    showToast(
      type: ToastType.info,
      title: title ?? 'Info',
      message: message,
      icon: Icons.info,
    );
  }
}