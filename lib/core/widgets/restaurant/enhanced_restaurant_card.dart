import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../badges/tawseya_badge.dart';
import '../buttons/modern_button_variants.dart';
import '../cards/enhanced_card.dart';

/// Enhanced Restaurant Card with Tawseya Integration
///
/// A premium restaurant card featuring:
/// - Dual-rating display (food quality + delivery experience)
/// - Enhanced Tawseya badge integration
/// - Restaurant status indicators
/// - Cultural design elements
/// - Smooth animations and interactions
/// - Photo gallery preview
///
/// Usage:
/// ```dart
/// EnhancedRestaurantCard(
///   restaurant: restaurantData,
///   onTap: () => navigateToRestaurant(restaurant.id),
///   onTawseyaTap: () => showTawseyaVoting(restaurant.id),
///   showDualRating: true,
///   culturalTheme: CulturalTheme.egyptian,
/// )
/// ```
class EnhancedRestaurantCard extends StatefulWidget {
  const EnhancedRestaurantCard({
    required this.restaurant, super.key,
    this.onTap,
    this.onFavoriteTap,
    this.onTawseyaTap,
    this.showDualRating = true,
    this.showStatusIndicator = true,
    this.culturalTheme,
    this.size = RestaurantCardSize.medium,
  });

  final RestaurantData restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTawseyaTap;
  final bool showDualRating;
  final bool showStatusIndicator;
  final CulturalTheme? culturalTheme;
  final RestaurantCardSize size;

  @override
  State<EnhancedRestaurantCard> createState() => _EnhancedRestaurantCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantData>('restaurant', restaurant));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onFavoriteTap', onFavoriteTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTawseyaTap', onTawseyaTap));
    properties.add(DiagnosticsProperty<bool>('showDualRating', showDualRating));
    properties.add(DiagnosticsProperty<bool>('showStatusIndicator', showStatusIndicator));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
    properties.add(EnumProperty<RestaurantCardSize>('size', size));
  }
}

class _EnhancedRestaurantCardState extends State<EnhancedRestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _imageScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _imageScaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final config = _getCardConfig();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: EnhancedCard(
          elevation: CardElevation.medium,
          onTap: _handleTap,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.all(AppSpacing.sm),
          width: config.width,
          height: config.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with Overlays
              _ImageSection(
                restaurant: widget.restaurant,
                animation: _imageScaleAnimation,
                onFavoriteTap: widget.onFavoriteTap,
                onTawseyaTap: widget.onTawseyaTap,
                showStatusIndicator: widget.showStatusIndicator,
                culturalTheme: widget.culturalTheme,
              ),

              // Content Section
              _ContentSection(
                restaurant: widget.restaurant,
                showDualRating: widget.showDualRating,
                culturalTheme: widget.culturalTheme,
              ),

              // Action Section
              _ActionSection(
                restaurant: widget.restaurant,
                culturalTheme: widget.culturalTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  CardConfig _getCardConfig() {
    switch (widget.size) {
      case RestaurantCardSize.small:
        return CardConfig(
          width: 240.w,
          height: 180.h,
          imageHeight: 100.h,
        );
      case RestaurantCardSize.medium:
        return CardConfig(
          width: 280.w,
          height: 220.h,
          imageHeight: 140.h,
        );
      case RestaurantCardSize.large:
        return CardConfig(
          width: 320.w,
          height: 260.h,
          imageHeight: 160.h,
        );
    }
  }
}

/// Image section with overlays and animations
class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.restaurant,
    required this.animation,
    this.onFavoriteTap,
    this.onTawseyaTap,
    this.showStatusIndicator = true,
    this.culturalTheme,
  });

  final RestaurantData restaurant;
  final Animation<double> animation;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTawseyaTap;
  final bool showStatusIndicator;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        // Hero Image with parallax effect
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Transform.scale(
            scale: animation.value,
            child: Container(
              height: 140.h, // This should come from card config
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                image: DecorationImage(
                  image: NetworkImage(restaurant.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay for better text readability
        Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Status indicator
        if (showStatusIndicator)
          Positioned(
            top: AppSpacing.md,
            left: AppSpacing.md,
            child: _StatusIndicator(
              status: restaurant.status,
              culturalTheme: culturalTheme,
            ),
          ),

        // Favorite button
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.md,
          child: _FavoriteButton(
            isFavorite: restaurant.isFavorite,
            onTap: onFavoriteTap,
          ),
        ),

        // Tawseya badge
        if (restaurant.tawseyaCount > 0)
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            child: TawseyaBadge(
              count: restaurant.tawseyaCount,
              size: BadgeSize.medium,
              animated: true,
            ),
          ),

        // Quick Tawseya action
        if (restaurant.tawseyaCount > 0)
          Positioned(
            bottom: AppSpacing.md,
            right: AppSpacing.md,
            child: GestureDetector(
              onTap: onTawseyaTap,
              child: Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.star_border,
                  color: AppColors.primaryGold,
                  size: 16.sp,
                ),
              ),
            ),
          ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantData>('restaurant', restaurant));
    properties.add(DiagnosticsProperty<Animation<double>>('animation', animation));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onFavoriteTap', onFavoriteTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTawseyaTap', onTawseyaTap));
    properties.add(DiagnosticsProperty<bool>('showStatusIndicator', showStatusIndicator));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Restaurant status indicator
class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.status,
    this.culturalTheme,
  });

  final RestaurantStatus status;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case RestaurantStatus.open:
        backgroundColor = AppColors.success;
        textColor = AppColors.white;
        icon = Icons.check_circle;
        break;
      case RestaurantStatus.busy:
        backgroundColor = AppColors.warning;
        textColor = AppColors.white;
        icon = Icons.access_time;
        break;
      case RestaurantStatus.closed:
        backgroundColor = AppColors.gray;
        textColor = AppColors.white;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            _getStatusText(status),
            style: AppTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(RestaurantStatus status) {
    switch (status) {
      case RestaurantStatus.open:
        return 'مفتوح';
      case RestaurantStatus.busy:
        return 'مشغول';
      case RestaurantStatus.closed:
        return 'مغلق';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<RestaurantStatus>('status', status));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Content section with dual rating and restaurant info
class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.restaurant,
    this.showDualRating = true,
    this.culturalTheme,
  });

  final RestaurantData restaurant;
  final bool showDualRating;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant name and cuisine
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant.name,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.primaryBlack,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (culturalTheme != null) ...[
                SizedBox(width: AppSpacing.sm),
                Icon(
                  culturalTheme!.icon,
                  color: culturalTheme!.color,
                  size: 16.sp,
                ),
              ],
            ],
          ),

          SizedBox(height: 4.h),

          // Cuisine types
          Text(
            restaurant.cuisines.join(' • '),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppSpacing.sm),

          // Dual rating display
          if (showDualRating) ...[
            _DualRatingDisplay(
              foodRating: restaurant.foodRating,
              deliveryRating: restaurant.deliveryRating,
              totalReviews: restaurant.reviewCount,
            ),
          ] else ...[
            // Single rating display
            _SingleRatingDisplay(
              rating: restaurant.overallRating,
              reviewCount: restaurant.reviewCount,
            ),
          ],

          // Additional info
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              // Delivery time
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: AppColors.logoRed,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${restaurant.deliveryTime} دقيقة',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),

              SizedBox(width: AppSpacing.md),

              // Minimum order
              Text(
                'حد أدنى ${restaurant.minimumOrder} جنيه',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.gray,
                ),
              ),

              const Spacer(),

              // Tawseya count
              if (restaurant.tawseyaCount > 0)
                TawseyaBadge(
                  count: restaurant.tawseyaCount,
                  size: BadgeSize.small,
                ),
            ],
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantData>('restaurant', restaurant));
    properties.add(DiagnosticsProperty<bool>('showDualRating', showDualRating));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Dual rating display for food quality and delivery experience
class _DualRatingDisplay extends StatelessWidget {
  const _DualRatingDisplay({
    required this.foodRating,
    required this.deliveryRating,
    required this.totalReviews,
  });

  final double foodRating;
  final double deliveryRating;
  final int totalReviews;

  @override
  Widget build(BuildContext context) => Row(
      children: [
        // Food rating
        _RatingIndicator(
          label: 'الطعام',
          rating: foodRating,
          icon: Icons.restaurant,
          color: AppColors.logoRed,
        ),

        SizedBox(width: AppSpacing.md),

        // Delivery rating
        _RatingIndicator(
          label: 'التوصيل',
          rating: deliveryRating,
          icon: Icons.delivery_dining,
          color: AppColors.info,
        ),

        const Spacer(),

        // Total reviews
        Text(
          '($totalReviews تقييم)',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('foodRating', foodRating));
    properties.add(DoubleProperty('deliveryRating', deliveryRating));
    properties.add(IntProperty('totalReviews', totalReviews));
  }
}

/// Single rating display
class _SingleRatingDisplay extends StatelessWidget {
  const _SingleRatingDisplay({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) => Row(
      children: [
        // Overall rating
        Row(
          children: [
            Icon(Icons.star, color: AppColors.primaryGold, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              rating.toStringAsFixed(1),
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
            ),
          ],
        ),

        const Spacer(),

        // Review count
        Text(
          '($reviewCount تقييم)',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('rating', rating));
    properties.add(IntProperty('reviewCount', reviewCount));
  }
}

/// Individual rating indicator
class _RatingIndicator extends StatelessWidget {
  const _RatingIndicator({
    required this.label,
    required this.rating,
    required this.icon,
    required this.color,
  });

  final String label;
  final double rating;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              rating.toStringAsFixed(1),
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.gray,
            fontSize: 10.sp,
          ),
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(DoubleProperty('rating', rating));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ColorProperty('color', color));
  }
}

/// Action section with quick buttons
class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.restaurant,
    this.culturalTheme,
  });

  final RestaurantData restaurant;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // View menu button
          Expanded(
            child: ModernButton.secondary(
              text: 'عرض القائمة',
              size: ButtonSize.small,
              leadingIcon: Icons.menu_book,
              fullWidth: true,
            ),
          ),

          SizedBox(width: AppSpacing.sm),

          // Order now button
          Expanded(
            child: ModernButton.primary(
              text: 'اطلب الآن',
              size: ButtonSize.small,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantData>('restaurant', restaurant));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Favorite button with animation
class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.isFavorite,
    this.onTap,
  });

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isFavorite', isFavorite));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.isFavorite ? AppColors.logoRed : AppColors.gray,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
}

/// Restaurant data model
class RestaurantData {
  const RestaurantData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisines,
    required this.overallRating,
    required this.foodRating,
    required this.deliveryRating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.minimumOrder,
    required this.tawseyaCount,
    required this.isFavorite,
    required this.status,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<String> cuisines;
  final double overallRating;
  final double foodRating;
  final double deliveryRating;
  final int reviewCount;
  final int deliveryTime;
  final double minimumOrder;
  final int tawseyaCount;
  final bool isFavorite;
  final RestaurantStatus status;
}

/// Restaurant status enum
enum RestaurantStatus {
  open,
  busy,
  closed,
}

/// Card size configuration
class CardConfig {
  const CardConfig({
    required this.width,
    required this.height,
    required this.imageHeight,
  });

  final double width;
  final double height;
  final double imageHeight;
}

/// Restaurant card size variants
enum RestaurantCardSize {
  small,
  medium,
  large,
}

/// Cultural theme for restaurant cards
class CulturalTheme {
  const CulturalTheme._({
    required this.name,
    required this.color,
    required this.icon,
  });

  static const CulturalTheme egyptian = CulturalTheme._(
    name: 'egyptian',
    color: Color(0xFFE74C3C),
    icon: Icons.flag,
  );

  final String name;
  final Color color;
  final IconData icon;
}