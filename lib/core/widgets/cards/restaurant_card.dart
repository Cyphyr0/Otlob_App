import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_animations.dart';
import '../badges/tawseya_badge.dart';
import '../badges/cuisine_tag.dart';

/// Restaurant Card Component
///
/// A featured card component displaying restaurant information with:
/// - Image with gradient overlay
/// - Restaurant name and rating
/// - Tawseya badge
/// - Cuisine tags
/// - Distance indicator
/// - Favorite button overlay
/// - Tap animation
/// - Shimmer loading state
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// RestaurantCard(
///   imageUrl: 'https://example.com/restaurant.jpg',
///   name: 'El Shabrawy',
///   cuisines: ['Egyptian', 'Grill'],
///   distance: '2.5 km',
///   rating: 4.5,
///   onTap: () => _openRestaurant(restaurant),
/// )
///
/// // With Tawseya badge
/// RestaurantCard(
///   imageUrl: imageUrl,
///   name: name,
///   cuisines: cuisines,
///   hasTawseya: true,
///   tawseyaCount: 156,
///   onTap: onTap,
/// )
///
/// // With favorite button
/// RestaurantCard(
///   imageUrl: imageUrl,
///   name: name,
///   cuisines: cuisines,
///   isFavorite: true,
///   onFavoritePressed: _toggleFavorite,
///   onTap: onTap,
/// )
///
/// // Loading state
/// RestaurantCard.loading()
/// ```
class RestaurantCard extends StatefulWidget {
  /// Restaurant image URL
  final String? imageUrl;

  /// Restaurant name
  final String name;

  /// List of cuisine types
  final List<String> cuisines;

  /// Distance from user
  final String? distance;

  /// Restaurant rating (0-5)
  final double? rating;

  /// Whether restaurant has Tawseya
  final bool hasTawseya;

  /// Number of Tawseya recommendations
  final int? tawseyaCount;

  /// Whether restaurant is favorited
  final bool isFavorite;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when favorite button is pressed
  final VoidCallback? onFavoritePressed;

  /// Show loading shimmer state
  final bool isLoading;

  const RestaurantCard({
    super.key,
    this.imageUrl,
    required this.name,
    required this.cuisines,
    this.distance,
    this.rating,
    this.hasTawseya = false,
    this.tawseyaCount,
    this.isFavorite = false,
    this.onTap,
    this.onFavoritePressed,
    this.isLoading = false,
  });

  /// Loading state constructor
  const RestaurantCard.loading({super.key})
    : imageUrl = null,
      name = '',
      cuisines = const [],
      distance = null,
      rating = null,
      hasTawseya = false,
      tawseyaCount = null,
      isFavorite = false,
      onTap = null,
      onFavoritePressed = null,
      isLoading = true;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.cardAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.cardCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      _controller.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      _controller.reverse();
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.cardRadius,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            // Make the details area flexible so it can shrink when the
            // parent gives limited height (prevents small RenderFlex overflow)
            children: [
              _buildImage(),
              Flexible(child: _buildDetails()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        // Restaurant image with gradient overlay
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.lg),
            topRight: Radius.circular(AppRadius.lg),
          ),
          child: Stack(
            children: [
              // Image
              Container(
                height: 160.h,
                width: double.infinity,
                color: AppColors.lightGray,
                child: widget.imageUrl != null
                    ? (widget.imageUrl!.startsWith('assets/')
                          ? Image.asset(
                              widget.imageUrl!.replaceFirst('assets/', ''),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: AppColors.gray,
                                );
                              },
                            )
                          : Image.network(
                              widget.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: AppColors.gray,
                                );
                              },
                            ))
                    : const Icon(
                        Icons.restaurant,
                        size: 48,
                        color: AppColors.gray,
                      ),
              ),
              // Gradient overlay (Egyptian Sunset inspired)
              Container(
                height: 160.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tawseya badge (top-left)
        if (widget.hasTawseya)
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: TawseyaBadge(
              count: widget.tawseyaCount,
              size: BadgeSize.small,
            ),
          ),

        // Favorite button (top-right)
        if (widget.onFavoritePressed != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: GestureDetector(
              onTap: widget.onFavoritePressed,
              child: Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.sm,
                ),
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite
                      ? AppColors.error
                      : AppColors.primaryDark,
                  size: 20.sp,
                ),
              ),
            ),
          ),

        // Distance indicator (bottom-right on image)
        if (widget.distance != null)
          Positioned(
            bottom: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14.sp,
                    color: AppColors.logoRed,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    widget.distance!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 70.h, maxHeight: 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Restaurant name and rating
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.rating != null) ...[
                  SizedBox(width: AppSpacing.sm),
                  Icon(Icons.star, size: 16.sp, color: AppColors.primaryGold),
                  SizedBox(width: 2.w),
                  Text(
                    widget.rating!.toStringAsFixed(1),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: widget.cuisines
                  .take(3)
                  .map((cuisine) => CuisineTag(name: cuisine))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGray,
      highlightColor: AppColors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 280.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.cardRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      topRight: Radius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 150.w,
                          color: AppColors.lightGray,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Container(
                              height: 24.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Container(
                              height: 24.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
