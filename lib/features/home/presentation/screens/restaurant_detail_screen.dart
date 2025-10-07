import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/theme/app_colors.dart';
import 'package:otlob_app/core/theme/app_typography.dart';
import 'package:otlob_app/core/theme/app_spacing.dart';
import 'package:otlob_app/core/theme/app_radius.dart';
import 'package:otlob_app/core/theme/app_shadows.dart';
import 'package:otlob_app/core/widgets/branding/otlob_logo.dart';
import 'package:otlob_app/core/widgets/badges/tawseya_badge.dart';
import 'package:otlob_app/core/providers.dart';
import 'package:otlob_app/features/home/domain/entities/restaurant.dart';
import 'package:otlob_app/features/cart/domain/entities/cart_item.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return restaurantsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading restaurant: $error')),
      ),
      data: (restaurants) {
        final restaurant = restaurants.firstWhere(
          (r) => r.id == id,
          orElse: () => const Restaurant(
            id: '',
            name: 'Not Found',
            rating: 0,
            imageUrl: '',
            tawseyaCount: 0,
            cuisine: '',
            description: 'Restaurant not found.',
            menuCategories: [],
            isOpen: false,
            distance: 0,
            address: '',
            priceLevel: 0,
            isFavorite: false,
          ),
        );

        final favoritesNotifier = ref.read(favoritesProvider.notifier);
        final isFavorite = ref
            .watch(favoritesProvider)
            .any((r) => r.id == restaurant.id);

        // Use menuCategories from restaurant entity

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, restaurant, isFavorite, favoritesNotifier),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRestaurantInfo(restaurant),
                    SizedBox(height: AppSpacing.sectionSpacing),
                    _buildMenu(
                      restaurant.menuCategories,
                      cartState,
                      cartNotifier,
                      context,
                    ),
                    SizedBox(height: 100.h), // Bottom padding for nav bar
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    Restaurant restaurant,
    bool isFavorite,
    favoritesNotifier,
  ) {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      backgroundColor: AppColors.offWhite,
      leading: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.md,
            ),
            child: Icon(Icons.arrow_back, color: AppColors.primaryBlack),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: GestureDetector(
            onTap: () => favoritesNotifier.toggleFavorite(restaurant),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: AppShadows.md,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : AppColors.primaryBlack,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Restaurant image
            restaurant.imageUrl != null && restaurant.imageUrl!.isNotEmpty
                ? (restaurant.imageUrl!.startsWith('assets/')
                      ? Image.asset(
                          restaurant.imageUrl!.replaceFirst('assets/', ''),
                          fit: BoxFit.cover,
                        )
                      : Image.network(restaurant.imageUrl!, fit: BoxFit.cover))
                : Container(
                    color: AppColors.lightGray,
                    child: Icon(
                      Icons.restaurant,
                      size: 80.sp,
                      color: AppColors.gray,
                    ),
                  ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Logo overlay
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.screenPadding,
              child: const OtlobLogo(
                size: LogoSize.medium,
                color: Colors.white,
              ),
            ),
            // Tawseya badge
            if (restaurant.tawseyaCount > 0)
              Positioned(
                top: 80.h,
                left: AppSpacing.screenPadding,
                child: TawseyaBadge(
                  count: restaurant.tawseyaCount,
                  size: BadgeSize.large,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(Restaurant restaurant) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Rating
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant.name,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 18.sp, color: AppColors.primaryGold),
                    SizedBox(width: 4.w),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),

          // Cuisine
          Text(
            restaurant.cuisine,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
          ),
          SizedBox(height: AppSpacing.md),

          // Location and Status
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: AppColors.logoRed),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  restaurant.address,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: restaurant.isOpen
                      ? AppColors.primaryGold.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: restaurant.isOpen
                          ? AppColors.primaryGold
                          : AppColors.error,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      restaurant.isOpen ? 'Open' : 'Closed',
                      style: AppTypography.bodySmall.copyWith(
                        color: restaurant.isOpen
                            ? AppColors.primaryGold
                            : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // Description
          Text(
            restaurant.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(
    List<String> menuCategories,
    List cartState,
    cartNotifier,
    BuildContext context,
  ) {
    // Create mock menu data based on categories
    final mockMenu = menuCategories
        .map(
          (category) => {
            'category': category,
            'dishes': [
              {'name': 'Grilled Chicken', 'price': 15.99, 'imageUrl': null},
              {'name': 'Beef Burger', 'price': 12.99, 'imageUrl': null},
              {'name': 'Caesar Salad', 'price': 8.99, 'imageUrl': null},
            ],
          },
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockMenu.length,
            itemBuilder: (context, categoryIndex) {
              final category = mockMenu[categoryIndex];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Header
                    Text(
                      category['category'] as String,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    // Dishes List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (category['dishes'] as List).length,
                      itemBuilder: (context, dishIndex) {
                        final dish = (category['dishes'] as List)[dishIndex];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                dishIndex <
                                    (category['dishes'] as List).length - 1
                                ? AppSpacing.md
                                : 0,
                          ),
                          child: _buildDishItem(
                            dish,
                            cartState,
                            cartNotifier,
                            context,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDishItem(
    dish,
    List cartState,
    cartNotifier,
    BuildContext context,
  ) {
    // Find if this dish is in the cart (safe)
    CartItem? cartItem;
    try {
      cartItem = cartState.firstWhere(
        (item) => item.name == dish['name'] && item.price == dish['price'],
      );
    } catch (_) {
      cartItem = null;
    }
    final quantity = cartItem != null ? cartItem.quantity : 0;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Dish Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                width: 80.w,
                height: 80.h,
                color: AppColors.lightGray,
                child: Icon(Icons.fastfood, size: 32.sp, color: AppColors.gray),
              ),
            ),
            SizedBox(width: AppSpacing.md),

            // Dish Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish['name'],
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '\$${(dish['price'] as double).toStringAsFixed(2)}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.logoRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Selector
            quantity == 0
                ? GestureDetector(
                    onTap: () {
                      cartNotifier.addItem(
                        name: dish['name'],
                        price: dish['price'],
                        imageUrl: dish['imageUrl'],
                      );
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${dish['name']} added to cart'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(milliseconds: 1500),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight + 80.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: Colors.white,
                            onPressed: () => context.go('/cart'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.logoRed,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      // Decrement button
                      GestureDetector(
                        onTap: () {
                          if (cartItem != null) {
                            final id = cartItem.id;
                            if (quantity > 1) {
                              cartNotifier.updateQuantity(id, quantity - 1);
                            } else {
                              cartNotifier.updateQuantity(id, 0);
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.gray,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.sm,
                          ),
                          child: Icon(
                            Icons.remove,
                            color: AppColors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Quantity display
                      Text(
                        '$quantity',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Increment button
                      GestureDetector(
                        onTap: () {
                          if (cartItem != null) {
                            cartNotifier.updateQuantity(
                              cartItem.id,
                              quantity + 1,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.logoRed,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.sm,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
