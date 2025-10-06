import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class ProKitHomeDemo extends StatefulWidget {
  const ProKitHomeDemo({super.key});

  @override
  State<ProKitHomeDemo> createState() => _ProKitHomeDemoState();
}

class _ProKitHomeDemoState extends State<ProKitHomeDemo> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _bottomNavIndex = 0;
  bool _isSearchFocused = false;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.local_pizza, 'name': 'Pizza', 'color': Colors.red},
    {'icon': Icons.fastfood, 'name': 'Burgers', 'color': Colors.orange},
    {'icon': Icons.restaurant, 'name': 'Sushi', 'color': Colors.pink},
    {'icon': Icons.local_dining, 'name': 'Italian', 'color': Colors.green},
    {'icon': Icons.rice_bowl, 'name': 'Asian', 'color': Colors.blue},
    {'icon': Icons.local_cafe, 'name': 'Desserts', 'color': Colors.purple},
    {'icon': Icons.local_bar, 'name': 'Drinks', 'color': Colors.teal},
    {'icon': Icons.more_horiz, 'name': 'More', 'color': Colors.grey},
  ];

  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Pizza Palace',
      'image': '🍕',
      'rating': 4.8,
      'deliveryTime': '25-35 min',
      'deliveryFee': 'Free',
      'cuisine': 'Italian',
      'distance': '1.2 km',
      'isPromoted': true,
      'discount': '20% OFF',
    },
    {
      'name': 'Burger Barn',
      'image': '🍔',
      'rating': 4.6,
      'deliveryTime': '20-30 min',
      'deliveryFee': '\$2.99',
      'cuisine': 'American',
      'distance': '0.8 km',
      'isPromoted': false,
      'discount': null,
    },
    {
      'name': 'Sushi Master',
      'image': '🍱',
      'rating': 4.9,
      'deliveryTime': '30-40 min',
      'deliveryFee': '\$3.99',
      'cuisine': 'Japanese',
      'distance': '2.1 km',
      'isPromoted': true,
      'discount': '15% OFF',
    },
    {
      'name': 'Taco Town',
      'image': '🌮',
      'rating': 4.4,
      'deliveryTime': '15-25 min',
      'deliveryFee': 'Free',
      'cuisine': 'Mexican',
      'distance': '1.5 km',
      'isPromoted': false,
      'discount': null,
    },
    {
      'name': 'Pasta Paradise',
      'image': '🍝',
      'rating': 4.7,
      'deliveryTime': '25-35 min',
      'deliveryFee': '\$1.99',
      'cuisine': 'Italian',
      'distance': '1.8 km',
      'isPromoted': true,
      'discount': '10% OFF',
    },
    {
      'name': 'Sweet Treats',
      'image': '🍰',
      'rating': 4.5,
      'deliveryTime': '20-30 min',
      'deliveryFee': '\$2.49',
      'cuisine': 'Desserts',
      'distance': '0.9 km',
      'isPromoted': false,
      'discount': null,
    },
  ];

  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Weekend Special',
      'subtitle': '50% OFF on all pizzas',
      'image': '🎉',
      'gradient': [Colors.purple, Colors.pink],
      'cta': 'Order Now',
    },
    {
      'title': 'Free Delivery',
      'subtitle': 'On orders over \$25',
      'image': '🚚',
      'gradient': [Colors.blue, Colors.cyan],
      'cta': 'Shop Now',
    },
    {
      'title': 'New Restaurants',
      'subtitle': 'Discover amazing cuisines',
      'image': '⭐',
      'gradient': [Colors.orange, Colors.red],
      'cta': 'Explore',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location & Search Section
              _buildLocationSearchSection(),

              SizedBox(height: AppSpacing.lg),

              // Promotional Banner Carousel
              _buildPromotionalCarousel(),

              SizedBox(height: AppSpacing.lg),

              // Categories Section
              _buildCategoriesSection(),

              SizedBox(height: AppSpacing.lg),

              // Featured Restaurants
              _buildFeaturedRestaurants(),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.logoRed, AppColors.primaryGold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('🍽️', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            'Otlob',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.primaryBlack,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_outlined),
          color: AppColors.primaryBlack,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(right: AppSpacing.md),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGold, width: 2),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.lightGray,
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppColors.primaryBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSearchSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.logoRed, size: 20),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Deliver to',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryBlack.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'New Cairo, Egypt',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryBlack,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSearchFocused
                    ? AppColors.primaryGold
                    : AppColors.lightGray.withValues(alpha: 0.3),
                width: _isSearchFocused ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onTap: () => setState(() => _isSearchFocused = true),
              onTapOutside: (_) => setState(() => _isSearchFocused = false),
              decoration: InputDecoration(
                hintText: 'Search for restaurants, cuisines...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryBlack.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.primaryBlack.withValues(alpha: 0.5),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_list, color: AppColors.primaryGold),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Quick Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Under 30 min', Icons.access_time, true),
                SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Free Delivery', Icons.local_shipping, false),
                SizedBox(width: AppSpacing.sm),
                _buildFilterChip('4.5+ Rating', Icons.star, false),
                SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Offers', Icons.local_offer, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    return FilterChip(
      label: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.primaryBlack,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.primaryBlack,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {},
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryGold,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryGold
              : AppColors.lightGray.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildPromotionalCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Special Offers',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: promo['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: AppSpacing.md,
                      top: AppSpacing.md,
                      child: Text(
                        promo['image'],
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promo['title'],
                            style: AppTypography.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            promo['subtitle'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: promo['gradient'][0],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                            ),
                            child: Text(
                              promo['cta'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primaryBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = index == _selectedCategoryIndex;

              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                child: Container(
                  width: 80,
                  margin: EdgeInsets.only(right: AppSpacing.md),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category['color'].withValues(alpha: 0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? category['color']
                                : AppColors.lightGray.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: category['color'].withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          category['icon'],
                          color: isSelected
                              ? category['color']
                              : AppColors.primaryBlack,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        category['name'],
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected
                              ? category['color']
                              : AppColors.primaryBlack.withValues(alpha: 0.7),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRestaurants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Restaurants',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primaryBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = _restaurants[index];
            return _buildRestaurantCard(restaurant);
          },
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image with Overlay
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      restaurant['image'],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                if (restaurant['isPromoted'])
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.logoRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PROMOTED',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                if (restaurant['discount'] != null)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        restaurant['discount'],
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Restaurant Info
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'],
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primaryBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 2),
                      Text(
                        restaurant['rating'].toString(),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryBlack.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.primaryBlack.withValues(alpha: 0.3),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        restaurant['cuisine'],
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryBlack.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.primaryBlack.withValues(alpha: 0.5),
                        size: 14,
                      ),
                      SizedBox(width: 2),
                      Text(
                        restaurant['deliveryTime'],
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryBlack.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.primaryBlack.withValues(alpha: 0.3),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        restaurant['deliveryFee'],
                        style: AppTypography.bodySmall.copyWith(
                          color: restaurant['deliveryFee'] == 'Free'
                              ? AppColors.logoRed
                              : AppColors.primaryBlack.withValues(alpha: 0.7),
                          fontWeight: restaurant['deliveryFee'] == 'Free'
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.primaryBlack.withValues(alpha: 0.5),
        selectedLabelStyle: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.bodySmall,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primaryGold,
      foregroundColor: AppColors.primaryBlack,
      elevation: 6,
      child: const Icon(Icons.add),
    );
  }
}
