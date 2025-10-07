import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/providers.dart';
import 'package:otlob_app/core/theme/app_colors.dart';
import 'package:otlob_app/core/theme/app_radius.dart';
import 'package:otlob_app/core/theme/app_shadows.dart';
import 'package:otlob_app/core/theme/app_spacing.dart';
import 'package:otlob_app/core/theme/app_typography.dart';
import 'package:otlob_app/core/theme/otlob_design_system.dart';
import 'package:otlob_app/core/widgets/branding/otlob_logo.dart';
import 'package:otlob_app/core/widgets/buttons/primary_button.dart';
import 'package:otlob_app/core/widgets/buttons/secondary_button.dart';
import 'package:otlob_app/core/widgets/cards/restaurant_card.dart';
import 'package:otlob_app/core/widgets/inputs/search_bar_widget.dart';
import 'package:otlob_app/features/home/domain/entities/restaurant.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _currentAddress;
  bool _isLocating = false;
  String? _locationError;
  String _selectedCuisine = 'All';
  double _minRating = 0.0;
  String _priceRange = 'All';

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  Future<void> _fetchLocation() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permissions are denied.';
            _isLocating = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permissions are permanently denied.';
          _isLocating = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street}, ${placemarks.first.subAdministrativeArea ?? placemarks.first.locality}, ${placemarks.first.country}'
          : 'Unknown location';
      setState(() {
        _currentAddress = address;
        _isLocating = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Failed to get location: $e';
        _isLocating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(filteredRestaurantsProvider);
    final hiddenGemsAsync = ref.watch(hiddenGemsProvider);
    final localHeroesAsync = ref.watch(localHeroesProvider);

    return restaurantsAsync.when(
      loading: () => _buildLoadingState(),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading restaurants: $error')),
      ),
      data: (restaurants) {
        // Apply client-side filters
        var filtered = restaurants;
        if (_selectedCuisine != 'All') {
          filtered = filtered
              .where((r) => r.cuisine == _selectedCuisine)
              .toList();
        }
        if (_minRating > 0) {
          filtered = filtered.where((r) => r.rating >= _minRating).toList();
        }
        if (_priceRange != 'All') {
          switch (_priceRange) {
            case 'Budget':
              filtered = filtered.where((r) => r.priceLevel <= 1.5).toList();
              break;
            case 'Premium':
              filtered = filtered.where((r) => r.priceLevel > 1.5).toList();
              break;
          }
        }

        return hiddenGemsAsync.when(
          loading: () => _buildLoadingState(),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error loading hidden gems: $error')),
          ),
          data: (hiddenGems) {
            return localHeroesAsync.when(
              loading: () => _buildLoadingState(),
              error: (error, stack) => Scaffold(
                body: Center(child: Text('Error loading local heroes: $error')),
              ),
              data: (localHeroes) {
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: CustomScrollView(
                    slivers: [
                      // App Bar
                      _buildAppBar(),

                      // Content
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppSpacing.md),

                            // Search Bar
                            _buildSearchSection(),

                            SizedBox(height: AppSpacing.md),

                            // Filter & Surprise Me Buttons
                            _buildActionButtons(filtered),

                            SizedBox(height: AppSpacing.sectionSpacing),

                            // Hidden Gems Section
                            if (hiddenGems.isNotEmpty) ...[
                              _buildHiddenGemsSection(hiddenGems),
                              SizedBox(height: AppSpacing.sectionSpacing),
                            ],

                            // Local Heroes Section
                            if (localHeroes.isNotEmpty) ...[
                              _buildLocalHeroesSection(localHeroes),
                              SizedBox(height: AppSpacing.sectionSpacing),
                            ],

                            // All Restaurants Section
                            _buildAllRestaurantsSection(filtered),

                            SizedBox(
                              height: 100.h,
                            ), // Bottom padding for nav bar
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final currentPage = ref.read(restaurantsPageProvider);
      final nextPage = currentPage + 1;

      final repository = ref.read(homeRepositoryProvider);
      final newData = await repository.getRestaurantsPaginated(
        page: nextPage,
        limit: 20,
      );

      if (mounted) {
        if (newData.isEmpty) {
          setState(() => _hasMoreData = false);
        } else {
          ref.read(restaurantsPageProvider.notifier).state = nextPage;
        }
      }
    } catch (e) {
      // Handle error - could show snackbar
      debugPrint('Error loading more data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      pinned: true,
      expandedHeight: 70.h,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: AppShadows.sm,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                // Otlob Logo
                const OtlobLogo(size: LogoSize.small),

                SizedBox(width: AppSpacing.md),

                // Location Selector
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _fetchLocation();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        boxShadow: AppShadows.sm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16.sp,
                            color: AppColors.logoRed,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: _isLocating
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Locating...',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  )
                                : (_locationError != null
                                      ? Text(
                                          _locationError!,
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          _currentAddress ??
                                              'Tap to detect location',
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: SearchBarWidget(
        hintText: 'Search restaurants or dishes...',
        debounceDuration: const Duration(milliseconds: 500),
        onSearch: (query) {
          ref.read(searchQueryProvider.notifier).state = query;
        },
        onClear: () {
          ref.read(searchQueryProvider.notifier).state = '';
        },
      ),
    );
  }

  Widget _buildActionButtons(List<Restaurant> restaurants) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          // Filter Button
          Expanded(
            child: SecondaryButton(
              text: 'Filter',
              icon: Icons.tune,
              onPressed: () => _showFilterBottomSheet(context),
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Surprise Me Button
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: 'Surprise Me!',
              icon: Icons.casino,
              onPressed: restaurants.isEmpty
                  ? null
                  : () {
                      final random = List<Restaurant>.from(restaurants)
                        ..shuffle();
                      final selected = random.first;
                      context.go('/restaurant/${selected.id}');
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenGemsSection(List<Restaurant> restaurants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Hidden Gems 💎',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full category
                },
                child: Text(
                  'See All',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Horizontal Carousel
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < restaurants.length - 1 ? AppSpacing.md : 0,
                ),
                child: SizedBox(
                  width: 260.w,
                  child: RestaurantCard(
                    restaurantId: restaurant.id,
                    imageUrl: restaurant.imageUrl,
                    name: restaurant.name,
                    cuisine: restaurant.cuisine,
                    rating: restaurant.rating,
                    deliveryTime: null,
                    reviewCount: 0,
                    tawseyaCount: restaurant.tawseyaCount,
                    isFavorite: ref
                        .watch(favoritesProvider)
                        .any((r) => r.id == restaurant.id),
                    onTap: () => context.go('/restaurant/${restaurant.id}'),
                    onFavoriteTap: () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(restaurant),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocalHeroesSection(List<Restaurant> restaurants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Local Heroes 🏆',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full category
                },
                child: Text(
                  'See All',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Horizontal Carousel
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < restaurants.length - 1 ? AppSpacing.md : 0,
                ),
                child: RestaurantCard(
                  restaurantId: restaurant.id,
                  imageUrl: restaurant.imageUrl!,
                  name: restaurant.name,
                  cuisine: restaurant.cuisine,
                  rating: restaurant.rating,
                  deliveryTime: null,
                  reviewCount: null,
                  tawseyaCount: restaurant.tawseyaCount,
                  isFavorite: ref
                      .watch(favoritesProvider)
                      .any((r) => r.id == restaurant.id),
                  onTap: () => context.go('/restaurant/${restaurant.id}'),
                  onFavoriteTap: () => ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(restaurant),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllRestaurantsSection(List<Restaurant> restaurants) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Restaurants',
                      style: AppTypography.headlineMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${restaurants.length} restaurant${restaurants.length != 1 ? 's' : ''}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Restaurant List
          if (restaurants.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64.sp, color: AppColors.gray),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'No restaurants found',
                      style: AppTypography.titleLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Try adjusting your filters',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < restaurants.length - 1 ? AppSpacing.md : 0,
                  ),
                  child: _buildCompactRestaurantCard(restaurant),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCompactRestaurantCard(Restaurant restaurant) {
    final isFavorite = ref
        .watch(favoritesProvider)
        .any((r) => r.id == restaurant.id);

    return GestureDetector(
      onTap: () => context.go('/restaurant/${restaurant.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  color: AppColors.lightGray,
                  child:
                      restaurant.imageUrl != null &&
                          restaurant.imageUrl!.isNotEmpty
                      ? (restaurant.imageUrl!.startsWith('assets/')
                            ? Image.asset(
                                restaurant.imageUrl!.replaceFirst(
                                  'assets/',
                                  '',
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.restaurant,
                                    size: 32.sp,
                                    color: AppColors.gray,
                                  );
                                },
                              )
                            : Image.network(
                                restaurant.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.restaurant,
                                    size: 32.sp,
                                    color: AppColors.gray,
                                  );
                                },
                              ))
                      : Icon(
                          Icons.restaurant,
                          size: 32.sp,
                          color: AppColors.gray,
                        ),
                ),
              ),

              SizedBox(width: AppSpacing.md),

              // Restaurant Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: AppTypography.titleMedium.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.star,
                          size: 14.sp,
                          color: AppColors.primaryGold,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xs),

                    // Cuisine
                    Text(
                      restaurant.cuisine,
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: AppSpacing.xs),

                    // Distance and Tawseya
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            '${restaurant.distance.toStringAsFixed(1)} km',
                            style: AppTypography.bodySmall.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (restaurant.tawseyaCount > 0) ...[
                          SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.diamond,
                            size: 12.sp,
                            color: AppColors.primaryGold,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${restaurant.tawseyaCount}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.sm),

              // Favorite Button
              GestureDetector(
                onTap: () => ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(restaurant),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => FilterBottomSheet(
        selectedCuisine: _selectedCuisine,
        minRating: _minRating,
        priceRange: _priceRange,
        onCuisineChanged: (cuisine) =>
            setState(() => _selectedCuisine = cuisine),
        onRatingChanged: (rating) => setState(() => _minRating = rating),
        onPriceChanged: (price) => setState(() => _priceRange = price),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          _buildAppBar(),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),

                // Search Bar Placeholder
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: AppShadows.sm,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Action Buttons Placeholder
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: AppShadows.sm,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: AppShadows.sm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.sectionSpacing),

                // Hidden Gems Section Placeholder
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24.h,
                        width: 150.w,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 280.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              right: index < 2 ? AppSpacing.md : 0,
                            ),
                            child: SizedBox(
                              width: 260.w,
                              child: Container(
                                width: 260.w,
                                height: 280.h,
                                decoration: BoxDecoration(
                                  color: OtlobDesignSystem.background,
                                  borderRadius: BorderRadius.circular(
                                    OtlobDesignSystem.radiusLg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.sectionSpacing),

                // Local Heroes Section Placeholder
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24.h,
                        width: 140.w,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 280.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              right: index < 2 ? AppSpacing.md : 0,
                            ),
                            child: SizedBox(
                              width: 260.w,
                              child: const RestaurantCardLoading(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.sectionSpacing),

                // All Restaurants Section Placeholder
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24.h,
                        width: 180.w,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      SizedBox(height: AppSpacing.md),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index < 4 ? AppSpacing.md : 0,
                          ),
                          child: Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppRadius.cardRadius,
                              boxShadow: AppShadows.card,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 100.h), // Bottom padding for nav bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String selectedCuisine;
  final double minRating;
  final String priceRange;
  final Function(String) onCuisineChanged;
  final Function(double) onRatingChanged;
  final Function(String) onPriceChanged;

  const FilterBottomSheet({
    super.key,
    required this.selectedCuisine,
    required this.minRating,
    required this.priceRange,
    required this.onCuisineChanged,
    required this.onRatingChanged,
    required this.onPriceChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedCuisine;
  late double _minRating;
  late String _priceRange;

  @override
  void initState() {
    super.initState();
    _selectedCuisine = widget.selectedCuisine;
    _minRating = widget.minRating;
    _priceRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.tune,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Filters',
                style: AppTypography.headlineSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Cuisine Filter
          Text(
            'Cuisine',
            style: AppTypography.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children:
                [
                      'All',
                      'Egyptian',
                      'Indian',
                      'Grill',
                      'Cafe',
                      'Bakery',
                      'Street Food',
                      'Mediterranean',
                    ]
                    .map(
                      (cuisine) => FilterChip(
                        label: Text(cuisine),
                        labelStyle: AppTypography.bodyMedium.copyWith(
                          color: _selectedCuisine == cuisine
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        selected: _selectedCuisine == cuisine,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCuisine = selected ? cuisine : 'All';
                          });
                        },
                      ),
                    )
                    .toList(),
          ),

          SizedBox(height: AppSpacing.lg),

          // Rating Filter
          Text(
            'Minimum Rating',
            style: AppTypography.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _minRating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: _minRating.toStringAsFixed(1),
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  onChanged: (value) => setState(() => _minRating = value),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  _minRating.toStringAsFixed(1),
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Price Range Filter
          Text(
            'Price Range',
            style: AppTypography.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ['All', 'Budget', 'Premium']
                .map(
                  (price) => FilterChip(
                    label: Text(price),
                    labelStyle: AppTypography.bodyMedium.copyWith(
                      color: _priceRange == price
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    selected: _priceRange == price,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                    onSelected: (selected) {
                      setState(() {
                        _priceRange = selected ? price : 'All';
                      });
                    },
                  ),
                )
                .toList(),
          ),

          SizedBox(height: AppSpacing.xl),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Clear All',
                  onPressed: () {
                    widget.onCuisineChanged('All');
                    widget.onRatingChanged(0.0);
                    widget.onPriceChanged('All');
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    widget.onCuisineChanged(_selectedCuisine);
                    widget.onRatingChanged(_minRating);
                    widget.onPriceChanged(_priceRange);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
