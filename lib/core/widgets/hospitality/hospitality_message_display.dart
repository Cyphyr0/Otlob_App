import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/cultural_hospitality_service.dart';

/// Widget for displaying culturally appropriate hospitality messages
class HospitalityMessageDisplay extends StatefulWidget {
  final MessageType messageType;
  final String? customMessage;
  final String? details;
  final bool animated;
  final Duration animationDuration;

  const HospitalityMessageDisplay({
    super.key,
    required this.messageType,
    this.customMessage,
    this.details,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<HospitalityMessageDisplay> createState() => _HospitalityMessageDisplayState();
}

class _HospitalityMessageDisplayState extends State<HospitalityMessageDisplay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.customMessage ?? _getMessageForType();

    if (message.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.animated ? _fadeAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10B981), // Green
                  Color(0xFF059669), // Darker green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIconForMessageType(),
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _getTitleForMessageType(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.5,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (widget.details != null && widget.details!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      widget.details!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMessageForType() {
    switch (widget.messageType) {
      case MessageType.welcome:
        return CulturalHospitalityService.getRandomWelcomeMessage();
      case MessageType.orderConfirmation:
        return CulturalHospitalityService.getRandomOrderConfirmationMessage();
      case MessageType.deliveryGreeting:
        return CulturalHospitalityService.getRandomDeliveryGreeting();
      case MessageType.ramadan:
        return CulturalHospitalityService.getRamadanGreeting() ?? '';
      case MessageType.eid:
        return CulturalHospitalityService.getEidGreeting() ?? '';
      case MessageType.timeBased:
        return CulturalHospitalityService.getTimeBasedGreeting();
      case MessageType.waiting:
        return CulturalHospitalityService.getWaitingMessage();
      case MessageType.success:
        return CulturalHospitalityService.getSuccessMessage(widget.details ?? '');
      case MessageType.error:
        return CulturalHospitalityService.getErrorMessage(widget.details ?? '');
      case MessageType.seasonal:
        return CulturalHospitalityService.getSeasonalMessage();
      case MessageType.promotional:
        return CulturalHospitalityService.getPromotionalMessage(widget.details ?? '');
      case MessageType.celebration:
        return CulturalHospitalityService.getCelebrationMessage(widget.details ?? '');
      case MessageType.ratingRequest:
        return CulturalHospitalityService.getRatingRequestMessage();
      case MessageType.support:
        return CulturalHospitalityService.getSupportMessage();
      case MessageType.foodBlessing:
        return CulturalHospitalityService.getFoodBlessing();
      case MessageType.apology:
        return CulturalHospitalityService.getApologyMessage(widget.details ?? '');
      case MessageType.traffic:
        return CulturalHospitalityService.getTrafficMessage();
      case MessageType.newUser:
        return CulturalHospitalityService.getNewUserOnboardingMessage();
      case MessageType.reengagement:
        return CulturalHospitalityService.getReengagementMessage(
          int.tryParse(widget.details ?? '7') ?? 7,
        );
      case MessageType.hospitality:
        return CulturalHospitalityService.getRandomHospitalityPhrase();
    }
  }

  String _getTitleForMessageType() {
    switch (widget.messageType) {
      case MessageType.welcome:
        return 'أهلاً وسهلاً!';
      case MessageType.orderConfirmation:
        return 'تم الطلب بنجاح!';
      case MessageType.deliveryGreeting:
        return 'تفضل يا فندم!';
      case MessageType.ramadan:
        return 'رمضان كريم!';
      case MessageType.eid:
        return 'عيد سعيد!';
      case MessageType.timeBased:
        return 'تحية طيبة!';
      case MessageType.waiting:
        return 'لحظة واحدة...';
      case MessageType.success:
        return 'تم بنجاح!';
      case MessageType.error:
        return 'عذراً...';
      case MessageType.seasonal:
        return 'عرض خاص!';
      case MessageType.promotional:
        return 'عروض مميزة!';
      case MessageType.celebration:
        return 'تهانينا!';
      case MessageType.ratingRequest:
        return 'رأيك مهم!';
      case MessageType.support:
        return 'خدمة العملاء';
      case MessageType.foodBlessing:
        return 'بالهنا والشفا!';
      case MessageType.apology:
        return 'اعتذار';
      case MessageType.traffic:
        return 'تنبيه مروري';
      case MessageType.newUser:
        return 'مرحباً بك!';
      case MessageType.reengagement:
        return 'اشتقت لك!';
      case MessageType.hospitality:
        return 'كلمة طيبة';
    }
  }

  IconData _getIconForMessageType() {
    switch (widget.messageType) {
      case MessageType.welcome:
        return Icons.waving_hand;
      case MessageType.orderConfirmation:
        return Icons.check_circle;
      case MessageType.deliveryGreeting:
        return Icons.local_shipping;
      case MessageType.ramadan:
        return Icons.mosque;
      case MessageType.eid:
        return Icons.celebration;
      case MessageType.timeBased:
        return Icons.access_time;
      case MessageType.waiting:
        return Icons.hourglass_empty;
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.seasonal:
        return Icons.local_florist;
      case MessageType.promotional:
        return Icons.local_offer;
      case MessageType.celebration:
        return Icons.celebration;
      case MessageType.ratingRequest:
        return Icons.star_outline;
      case MessageType.support:
        return Icons.support_agent;
      case MessageType.foodBlessing:
        return Icons.restaurant;
      case MessageType.apology:
        return Icons.sentiment_dissatisfied;
      case MessageType.traffic:
        return Icons.traffic;
      case MessageType.newUser:
        return Icons.person_add;
      case MessageType.reengagement:
        return Icons.favorite;
      case MessageType.hospitality:
        return Icons.favorite;
    }
  }
}

/// Simplified hospitality message for inline use
class InlineHospitalityMessage extends StatelessWidget {
  final MessageType messageType;
  final TextStyle? style;
  final bool showIcon;

  const InlineHospitalityMessage({
    super.key,
    required this.messageType,
    this.style,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final message = _getMessageForType();
    if (message.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            _getIconForMessageType(),
            size: 16.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          message,
          style: style ?? TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  String _getMessageForType() {
    switch (messageType) {
      case MessageType.hospitality:
        return CulturalHospitalityService.getRandomHospitalityPhrase();
      case MessageType.foodBlessing:
        return CulturalHospitalityService.getFoodBlessing();
      default:
        return '';
    }
  }

  IconData _getIconForMessageType() {
    switch (messageType) {
      case MessageType.hospitality:
        return Icons.favorite;
      case MessageType.foodBlessing:
        return Icons.restaurant;
      default:
        return Icons.info;
    }
  }
}

/// Hospitality notification widget for order status updates
class HospitalityNotification extends StatelessWidget {
  final String title;
  final String message;
  final NotificationType type;
  final bool showAnimation;

  const HospitalityNotification({
    super.key,
    required this.title,
    required this.message,
    this.type = NotificationType.info,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getIconForType(),
            color: _getIconColor(),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(),
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _getTextColor().withOpacity(0.8),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFFECFDF5);
      case NotificationType.error:
        return const Color(0xFFFEF2F2);
      case NotificationType.warning:
        return const Color(0xFFFFFBEB);
      case NotificationType.info:
      default:
        return const Color(0xFFEFF6FF);
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF10B981);
      case NotificationType.error:
        return const Color(0xFFEF4444);
      case NotificationType.warning:
        return const Color(0xFFF59E0B);
      case NotificationType.info:
      default:
        return const Color(0xFF3B82F6);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF059669);
      case NotificationType.error:
        return const Color(0xFFDC2626);
      case NotificationType.warning:
        return const Color(0xFFD97706);
      case NotificationType.info:
      default:
        return const Color(0xFF2563EB);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF065F46);
      case NotificationType.error:
        return const Color(0xFF991B1B);
      case NotificationType.warning:
        return const Color(0xFF92400E);
      case NotificationType.info:
      default:
        return const Color(0xFF1E40AF);
    }
  }

  IconData _getIconForType() {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
      default:
        return Icons.info;
    }
  }
}

/// Message types for hospitality messages
enum MessageType {
  welcome,
  orderConfirmation,
  deliveryGreeting,
  ramadan,
  eid,
  timeBased,
  waiting,
  success,
  error,
  seasonal,
  promotional,
  celebration,
  ratingRequest,
  support,
  foodBlessing,
  apology,
  traffic,
  newUser,
  reengagement,
  hospitality,
}

/// Notification types for hospitality notifications
enum NotificationType {
  success,
  error,
  warning,
  info,
}