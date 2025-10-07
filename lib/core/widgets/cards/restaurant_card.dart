import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otlob_app/core/theme/otlob_design_system.dart';

/// Modern Restaurant Card Component
/// Uses Shadcn UI inspired design with clean, modern aesthetics
class RestaurantCard extends StatefulWidget {
  final String restaurantId;
  final String name;
  final String? cuisine;
  final double rating;
  final int? deliveryTime;
  final int? reviewCount;
  final String imageUrl;
  final int? tawseyaCount;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  // Backward compatibility: accept cuisines parameter as alternative to cuisine
  final List<String>? cuisines;

  const RestaurantCard({
    super.key,
    required this.restaurantId,
    required this.name,
    this.cuisine,
    required this.rating,
    this.deliveryTime,
    this.reviewCount,
    this.imageUrl = '',
    this.tawseyaCount,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.cuisines,
  });

  // Factory method for loading state (backward compatibility)
  const factory RestaurantCard.loading() = RestaurantCard._loading;

  const RestaurantCard._loading()
      : restaurantId = '',
        name = '',
        cuisine = '',
        rating = 0.0,
        deliveryTime = null,
        reviewCount = null,
        imageUrl = '',
        tawseyaCount = null,
        isFavorite = false,
        onTap = null,
        onFavoriteTap = null,
        cuisines = null;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
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
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onTap?.call();
  }

  void _handleFavoriteTap() {
    widget.onFavoriteTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: 280,
              height: 200,
              decoration: OtlobDesignSystem.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section with Overlays
                  _ImageSection(
                    imageUrl: widget.imageUrl,
                    isFavorite: widget.isFavorite,
                    onFavoriteTap: _handleFavoriteTap,
                    tawseyaCount: widget.tawseyaCount,
                  ),

                  // Content Section
                  ContentSection(
                    name: widget.name,
                    cuisine: widget.cuisine,
                    rating: widget.rating,
                    deliveryTime: widget.deliveryTime,
                    reviewCount: widget.reviewCount,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Image section with overlays
class _ImageSection extends StatelessWidget {
  final String imageUrl;
  final bool isFavorite;
  final int? tawseyaCount;
  final VoidCallback? onFavoriteTap;

  const _ImageSection({
    required this.imageUrl,
    required this.isFavorite,
    this.tawseyaCount,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero Image
        SizedBox(
          height: 120,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(OtlobDesignSystem.radiusLg),
              topRight: Radius.circular(OtlobDesignSystem.radiusLg),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: OtlobDesignSystem.textLight.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      OtlobDesignSystem.secondary,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: OtlobDesignSystem.background,
                child: Icon(
                  Icons.restaurant,
                  color: OtlobDesignSystem.textLight,
                  size: 40,
                ),
              ),
            ),
          ),
        ),

        // Favorite Button Overlay
        Positioned(
          top: 12,
          right: 12,
          child: _FavoriteButton(
            isFavorite: isFavorite,
            onTap: onFavoriteTap,
          ),
        ),

        // Tawseya Badge Overlay
        if (tawseyaCount != null && tawseyaCount! > 0)
          Positioned(
            top: 12,
            left: 12,
            child: _TawseyaBadge(count: tawseyaCount!),
          ),
      ],
    );
  }
}

/// Animated favorite heart button
class _FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _FavoriteButton({required this.isFavorite, this.onTap});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) => _animationController.reverse());
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _scaleAnimation.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.elasticOut,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: OtlobDesignSystem.shadowSm,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? OtlobDesignSystem.error : OtlobDesignSystem.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Tawseya badge with golden theme
class _TawseyaBadge extends StatelessWidget {
  final int count;

  const _TawseyaBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: OtlobDesignSystem.accent,
        borderRadius: BorderRadius.circular(OtlobDesignSystem.radiusSm),
        boxShadow: OtlobDesignSystem.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: OtlobDesignSystem.primary,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: OtlobDesignSystem.labelSmall.copyWith(
              color: OtlobDesignSystem.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Content section with restaurant details
class ContentSection extends StatelessWidget {
  final String name;
  final String? cuisine;
  final double rating;
  final int? deliveryTime;
  final int? reviewCount;

  const ContentSection({
    super.key,
    required this.name,
    this.cuisine,
    required this.rating,
    this.deliveryTime,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OtlobDesignSystem.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name
          Text(
            name,
            style: OtlobDesignSystem.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: OtlobDesignSystem.xs),

          // Cuisine
          if (cuisine != null && cuisine!.isNotEmpty) ...[
            Text(
              cuisine!,
              style: OtlobDesignSystem.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: OtlobDesignSystem.sm),
          ] else
            const SizedBox(height: OtlobDesignSystem.sm),

          // Rating and Delivery Info
          Row(
            children: [
              // Star Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: OtlobDesignSystem.accent,
                    size: 16,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: OtlobDesignSystem.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Delivery Time (only if provided)
              if (deliveryTime != null) ...[
                const SizedBox(width: OtlobDesignSystem.md),
                Icon(
                  Icons.access_time,
                  color: OtlobDesignSystem.success,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  '$deliveryTime min',
                  style: OtlobDesignSystem.labelSmall.copyWith(
                    color: OtlobDesignSystem.success,
                  ),
                ),
              ],

              const Spacer(),

              // Reviews Count (only if provided)
              if (reviewCount != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: OtlobDesignSystem.textLight,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      reviewCount.toString(),
                      style: OtlobDesignSystem.labelSmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Loading version of RestaurantCard
class RestaurantCardLoading extends StatelessWidget {
  const RestaurantCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 200,
      decoration: BoxDecoration(
        color: OtlobDesignSystem.surface,
        borderRadius: BorderRadius.circular(OtlobDesignSystem.radiusLg),
        boxShadow: OtlobDesignSystem.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: OtlobDesignSystem.textLight.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(OtlobDesignSystem.radiusLg),
                topRight: Radius.circular(OtlobDesignSystem.radiusLg),
              ),
            ),
            child: const Icon(
              Icons.restaurant,
              color: OtlobDesignSystem.textLight,
              size: 40,
            ),
          ),
          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(OtlobDesignSystem.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 180,
                  color: OtlobDesignSystem.textLight.withOpacity(0.3),
                ),
                const SizedBox(height: OtlobDesignSystem.xs),
                Container(
                  height: 12,
                  width: 100,
                  color: OtlobDesignSystem.textLight.withOpacity(0.3),
                ),
                const SizedBox(height: OtlobDesignSystem.sm),
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 60,
                      color: OtlobDesignSystem.textLight.withOpacity(0.3),
                    ),
                    const Spacer(),
                    Container(
                      height: 12,
                      width: 40,
                      color: OtlobDesignSystem.textLight.withOpacity(0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
