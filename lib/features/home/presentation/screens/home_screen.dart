import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCuisine = 'All';
  double _minRating = 0.0;
  String _priceRange = 'All';

  // Mock data for curated carousels with cuisine
  List<RestaurantCardModel> _getAllRestaurants() {
    return [
      RestaurantCardModel(
        name: 'Mama\'s Kitchen',
        rating: 4.8,
        image: 'assets/images/mamas_kitchen.jpg',
        tawseyaCount: 25,
        cuisine: 'Egyptian',
      ),
      RestaurantCardModel(
        name: 'Street Food Haven',
        rating: 4.6,
        image: 'assets/images/street_food.jpg',
        tawseyaCount: 18,
        cuisine: 'Street Food',
      ),
      RestaurantCardModel(
        name: 'Local Spice House',
        rating: 4.9,
        image: 'assets/images/spice_house.jpg',
        tawseyaCount: 32,
        cuisine: 'Indian',
      ),
      RestaurantCardModel(
        name: 'Grandma\'s Bakery',
        rating: 4.7,
        image: 'assets/images/bakery.jpg',
        tawseyaCount: 22,
        cuisine: 'Bakery',
      ),
      RestaurantCardModel(
        name: 'River Side Grill',
        rating: 4.5,
        image: 'assets/images/grill.jpg',
        tawseyaCount: 15,
        cuisine: 'Grill',
      ),
      RestaurantCardModel(
        name: 'Authentic Falafel Spot',
        rating: 4.8,
        image: 'assets/images/falafel.jpg',
        tawseyaCount: 28,
        cuisine: 'Egyptian',
      ),
      RestaurantCardModel(
        name: 'Nile View Cafe',
        rating: 4.4,
        image: 'assets/images/cafe.jpg',
        tawseyaCount: 12,
        cuisine: 'Cafe',
      ),
      RestaurantCardModel(
        name: 'Desert Rose Restaurant',
        rating: 4.7,
        image: 'assets/images/desert_rose.jpg',
        tawseyaCount: 20,
        cuisine: 'Mediterranean',
      ),
    ];
  }

  List<RestaurantCardModel> get _filteredRestaurants {
    var restaurants = _getAllRestaurants();
    if (_selectedCuisine != 'All') {
      restaurants = restaurants
          .where((r) => r.cuisine == _selectedCuisine)
          .toList();
    }
    if (_minRating > 0) {
      restaurants = restaurants.where((r) => r.rating >= _minRating).toList();
    }
    if (_priceRange != 'All') {
      // Mock price filtering - assume price ranges map to ratings or something simple
      switch (_priceRange) {
        case 'Budget':
          restaurants = restaurants.where((r) => r.rating <= 4.5).toList();
          break;
        case 'Premium':
          restaurants = restaurants.where((r) => r.rating > 4.5).toList();
          break;
      }
    }
    return restaurants;
  }

  List<RestaurantCardModel> get _hiddenGems {
    return _filteredRestaurants
        .where((r) => ['Egyptian', 'Street Food'].contains(r.cuisine))
        .take(3)
        .toList();
  }

  List<RestaurantCardModel> get _localHeroes {
    return _filteredRestaurants
        .where((r) => r.tawseyaCount > 20)
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filteredRestaurants;
    final hiddenGems = _hiddenGems;
    final localHeroes = _localHeroes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover Local Gems',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          if (_selectedCuisine != 'All' ||
              _minRating > 0 ||
              _priceRange != 'All')
            Container(
              padding: EdgeInsets.all(8.w),
              child: Wrap(
                spacing: 8.w,
                children: [
                  if (_selectedCuisine != 'All') ...[
                    Chip(
                      label: Text(_selectedCuisine),
                      onDeleted: () => setState(() => _selectedCuisine = 'All'),
                    ),
                  ],
                  if (_minRating > 0) ...[
                    Chip(
                      label: Text('Rating >= $_minRating'),
                      onDeleted: () => setState(() => _minRating = 0.0),
                    ),
                  ],
                  if (_priceRange != 'All') ...[
                    Chip(
                      label: Text(_priceRange),
                      onDeleted: () => setState(() => _priceRange = 'All'),
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.clear_all, size: 20),
                    onPressed: () => setState(() {
                      _selectedCuisine = 'All';
                      _minRating = 0.0;
                      _priceRange = 'All';
                    }),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search restaurants or dishes...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () => _showFilterBottomSheet(context),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onSubmitted: (value) {
                        // TODO: Perform search
                        context.go('/search?q=$value');
                      },
                    ),
                  ),
                  // Surprise Me Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Surprise Me logic - random recommendation
                        if (restaurants.isNotEmpty) {
                          final randomRestaurant =
                              restaurants[restaurants.length ~/ 2];
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Surprise! Try ${randomRestaurant.name} today!',
                              ),
                              action: SnackBarAction(
                                label: 'View',
                                onPressed: () => context.go(
                                  '/home/restaurant/${randomRestaurant.name}',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Surprise Me!'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Hidden Gems Carousel
                  _buildCarouselSection(
                    context,
                    title: 'Hidden Gems',
                    restaurants: hiddenGems,
                    subtitle: 'Undiscovered local favorites',
                  ),
                  SizedBox(height: 24.h),
                  // Local Heroes Carousel
                  _buildCarouselSection(
                    context,
                    title: 'Local Heroes',
                    restaurants: localHeroes,
                    subtitle: 'Community favorites with Tawseya votes',
                  ),
                  SizedBox(height: 24.h),
                  // All Restaurants List
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'All Restaurants (${restaurants.length})',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showFilterBottomSheet(context),
                              child: const Text('Filters'),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (restaurants.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No restaurants match your filters. Try adjusting them.',
                              ),
                            ),
                          )
                        else
                          ...restaurants.map(
                            (restaurant) =>
                                _buildRestaurantCard(context, restaurant),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.h), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

  Widget _buildCarouselSection(
    BuildContext context, {
    required String title,
    required List<RestaurantCardModel> restaurants,
    required String subtitle,
  }) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full category
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _buildCarouselCard(context, restaurants[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(
    BuildContext context,
    RestaurantCardModel restaurant,
  ) {
    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Container(
              height: 120.h,
              width: double.infinity,
              color: Colors.grey[300],
              child: restaurant.image.isNotEmpty
                  ? Image.asset(restaurant.image, fit: BoxFit.cover)
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text('${restaurant.rating}'),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${restaurant.tawseyaCount} Tawseya',
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
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

  Widget _buildRestaurantCard(
    BuildContext context,
    RestaurantCardModel restaurant,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 60.w,
            height: 60.h,
            color: Colors.grey[300],
            child: restaurant.image.isNotEmpty
                ? Image.asset(restaurant.image, fit: BoxFit.cover)
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(),
                  ),
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14.sp),
                SizedBox(width: 4.w),
                Text('${restaurant.rating}'),
                SizedBox(width: 16.w),
                Text(restaurant.cuisine),
              ],
            ),
            Text('${restaurant.tawseyaCount} Tawseya'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.go('/home/restaurant/${restaurant.name}');
        },
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list),
              SizedBox(width: 8.w),
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Cuisine Filter
          Text('Cuisine', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
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
                        selected: _selectedCuisine == cuisine,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCuisine = selected ? cuisine : 'All';
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 16.h),
          // Rating Filter
          Text(
            'Minimum Rating',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Slider(
            value: _minRating,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label: _minRating.toStringAsFixed(1),
            onChanged: (value) => setState(() => _minRating = value),
          ),
          SizedBox(height: 16.h),
          // Price Range Filter
          Text('Price Range', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: ['All', 'Budget', 'Premium']
                .map(
                  (price) => FilterChip(
                    label: Text(price),
                    selected: _priceRange == price,
                    onSelected: (selected) {
                      setState(() {
                        _priceRange = selected ? price : 'All';
                      });
                    },
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    widget.onCuisineChanged('All');
                    widget.onRatingChanged(0.0);
                    widget.onPriceChanged('All');
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCuisineChanged(_selectedCuisine);
                    widget.onRatingChanged(_minRating);
                    widget.onPriceChanged(_priceRange);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RestaurantCardModel {
  final String name;
  final double rating;
  final String image;
  final int tawseyaCount;
  final String cuisine;

  const RestaurantCardModel({
    required this.name,
    required this.rating,
    required this.image,
    required this.tawseyaCount,
    required this.cuisine,
  });
}
