import "package:flutter/material.dart";
import "../../../theme/app_spacing.dart";
import "../../../theme/app_typography.dart";

// Sample image URLs (using Unsplash for demo purposes)
const String _sampleRestaurantImage =
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=250&fit=crop";
const String _sampleFoodImage =
    "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200&h=150&fit=crop";
const String _promoBannerImage =
    "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&h=300&fit=crop";
const String _userAvatar =
    "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop&crop=face";
const String _burgerImage =
    "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&h=150&fit=crop";
const String _pizzaImage =
    "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200&h=150&fit=crop";
const String _sushiImage =
    "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=200&h=150&fit=crop";

class ModernHomeDemo extends StatefulWidget {
  const ModernHomeDemo({super.key});

  @override
  State<ModernHomeDemo> createState() => _ModernHomeDemoState();
}

class _ModernHomeDemoState extends State<ModernHomeDemo>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  final String _userName = "Hisham";
  int _bottomNavIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      "icon": Icons.local_pizza,
      "name": "Pizza",
      "color": Colors.red,
      "trending": true,
      "image": _pizzaImage,
    },
    {
      "icon": Icons.restaurant,
      "name": "Burgers",
      "color": Colors.orange,
      "trending": true,
      "image": _burgerImage,
    },
    {
      "icon": Icons.set_meal,
      "name": "Sushi",
      "color": Colors.blue,
      "trending": false,
      "image": _sushiImage,
    },
    {
      "icon": Icons.local_dining,
      "name": "Italian",
      "color": Colors.green,
      "trending": false,
      "image": _sampleFoodImage,
    },
    {
      "icon": Icons.fastfood,
      "name": "Fast Food",
      "color": Colors.purple,
      "trending": true,
      "image": _sampleFoodImage,
    },
    {
      "icon": Icons.local_cafe,
      "name": "Desserts",
      "color": Colors.pink,
      "trending": false,
      "image": _sampleFoodImage,
    },
    {
      "icon": Icons.local_bar,
      "name": "Drinks",
      "color": Colors.teal,
      "trending": false,
      "image": _sampleFoodImage,
    },
    {
      "icon": Icons.restaurant_menu,
      "name": "Healthy",
      "color": Colors.lightGreen,
      "trending": true,
      "image": _sampleFoodImage,
    },
  ];

  final List<Map<String, dynamic>> _restaurants = [
    {
      "name": "Pizza Palace",
      "cuisine": "Italian • Pizza",
      "rating": 4.5,
      "deliveryTime": "25-35 min",
      "priceRange": "\$\$\$",
      "image": _sampleRestaurantImage,
      "isOpen": true,
    },
    {
      "name": "Burger Barn",
      "cuisine": "American • Burgers",
      "rating": 4.2,
      "deliveryTime": "20-30 min",
      "priceRange": "\$\$",
      "image": _sampleRestaurantImage,
      "isOpen": true,
    },
    {
      "name": "Sushi Spot",
      "cuisine": "Japanese • Sushi",
      "rating": 4.7,
      "deliveryTime": "30-40 min",
      "priceRange": "\$\$\$\$",
      "image": _sampleRestaurantImage,
      "isOpen": false,
    },
    {
      "name": "Taco Town",
      "cuisine": "Mexican • Tacos",
      "rating": 4.3,
      "deliveryTime": "15-25 min",
      "priceRange": "\$\$",
      "image": _sampleRestaurantImage,
      "isOpen": true,
    },
  ];

  final List<Map<String, dynamic>> _promotions = [
    {
      "title": "Free Delivery",
      "subtitle": "On orders over \$25",
      "timeLeft": "2 days left",
      "cta": "Order Now",
      "gradient": [Colors.orange, Colors.red],
      "image": _promoBannerImage,
    },
    {
      "title": "50% Off",
      "subtitle": "Selected restaurants",
      "timeLeft": "1 day left",
      "cta": "View Deals",
      "gradient": [Colors.purple, Colors.pink],
      "image": _promoBannerImage,
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      "icon": Icons.restaurant_menu,
      "label": "Restaurants",
      "color": Colors.red,
    },
    {"icon": Icons.local_shipping, "label": "Orders", "color": Colors.blue},
    {"icon": Icons.favorite, "label": "Favorites", "color": Colors.pink},
    {"icon": Icons.person, "label": "Profile", "color": Colors.green},
  ];

  final List<Map<String, dynamic>> _orderAgainItems = [
    {
      "name": "Pizza Palace",
      "lastOrdered": "2 days ago",
      "price": "\$24.99",
      "rating": 4.5,
      "image": _sampleRestaurantImage,
    },
    {
      "name": "Burger Barn",
      "lastOrdered": "1 week ago",
      "price": r"$18.50",
      "rating": 4.2,
      "image": _sampleRestaurantImage,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      drawer: _buildSideMenu(context),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildLocationSearchSection(context),
                _buildGreeting(context),
                _buildTrendingNow(context),
                _buildPromotionalCarousel(context),
                _buildQuickActions(context),
                _buildOrderAgain(context),
                _buildCategoriesSection(context),
                _buildFeaturedRestaurants(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  Widget _buildAppBar(BuildContext context) => SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shadowColor: Colors.black.withOpacity(0.1),
      title: Text(
        'Home',
        style: AppTypography.displaySmall.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ],
    );

  Widget _buildLocationSearchSection(BuildContext context) => Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Deliver to: Current Location',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  // Handle location selection
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for restaurants, cuisines...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).hintColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic, color: Theme.of(context).hintColor),
                  onPressed: () {
                    // Handle voice search
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onChanged: (value) {
                // Handle search
              },
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Use filters',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.filter_list,
                color: Theme.of(context).hintColor,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildGreeting(BuildContext context) => Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Text(
        'Good , ',
        style: AppTypography.displaySmall.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

  Widget _buildTrendingNow(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Now',
                style: AppTypography.displaySmall.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle view all
                },
                child: Text(
                  'View All',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories
                  .where((category) => category['trending'] == true)
                  .map((category) {
                    return Container(
                      margin: EdgeInsets.only(right: AppSpacing.sm),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(category['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            category['name'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
    );

  Widget _buildPromotionalCarousel(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      height: 180,
      child: PageView.builder(
        itemCount: _promotions.length,
        itemBuilder: (context, index) {
          final promo = _promotions[index];
          return Container(
            margin: EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: promo['gradient'],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: NetworkImage(promo['image']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: AppSpacing.md,
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo['title'],
                        style: AppTypography.displaySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        promo['subtitle'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            promo['timeLeft'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle promo CTA
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: promo['gradient'].last,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              promo['cta'],
                              style: AppTypography.bodyMedium.copyWith(
                                color: promo['gradient'].last,
                                fontWeight: FontWeight.bold,
                              ),
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
        },
      ),
    );

  Widget _buildQuickActions(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.displaySmall.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _quickActions.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final action = _quickActions[index];
              return GestureDetector(
                onTap: () {
                  // Handle quick action tap
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(action['icon'], color: action['color'], size: 24),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        action['label'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: action['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

  Widget _buildOrderAgain(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Again',
            style: AppTypography.displaySmall.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Column(
            children: _orderAgainItems.map((item) {
              return Container(
                margin: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: AppTypography.bodyLarge.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            item['lastOrdered'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['price'],
                                style: AppTypography.bodyLarge.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  Text(
                                    item['rating'].toString(),
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

  Widget _buildCategoriesSection(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: AppTypography.displaySmall.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _categories.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: index == _selectedCategoryIndex
                        ? category['color']
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: index == _selectedCategoryIndex
                          ? Colors.transparent
                          : category['color'],
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: index == _selectedCategoryIndex
                            ? Colors.white
                            : category['color'],
                        size: 24,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        category['name'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: index == _selectedCategoryIndex
                              ? Colors.white
                              : category['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

  Widget _buildFeaturedRestaurants(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Restaurants',
            style: AppTypography.displaySmall.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Column(
            children: _restaurants.map((restaurant) {
              return Container(
                margin: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        restaurant['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant['name'],
                            style: AppTypography.bodyLarge.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                restaurant['rating'].toString(),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Text(
                                restaurant['deliveryTime'],
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            restaurant['cuisine'],
                            style: AppTypography.bodyMedium.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          restaurant['priceRange'],
                          style: AppTypography.bodyLarge.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: restaurant['isOpen']
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            restaurant['isOpen'] ? 'Open' : 'Closed',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

  Widget _buildBottomNavigation(BuildContext context) => BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          activeIcon: Icon(Icons.home_filled),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
          activeIcon: Icon(Icons.search_rounded),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
          activeIcon: Icon(Icons.notifications_active),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          activeIcon: Icon(Icons.person_outline),
        ),
      ],
    );

  Widget _buildFloatingActionButton(BuildContext context) => ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        child: Icon(Icons.add),
      ),
    );

  Widget _buildSideMenu(BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName,
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'hisham@example.com',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_userAvatar),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).primaryColor),
            title: Text(
              'Home',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
            title: Text(
              'Order History',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              // Navigate to order history
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Favorites',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              // Navigate to favorites
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Settings',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              // Navigate to settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help, color: Theme.of(context).primaryColor),
            title: Text(
              'Help & Support',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              // Navigate to help & support
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: Text(
              'Logout',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
}
