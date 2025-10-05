import 'package:flutter/material.dart';
import '../branding/otlob_logo.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../buttons/icon_button_custom.dart';
import '../cards/restaurant_card.dart';
import '../cards/dish_card.dart';
import '../badges/tawseya_badge.dart';
import '../badges/cuisine_tag.dart';
import '../inputs/search_bar_widget.dart';
import '../inputs/custom_text_field.dart';
import '../states/loading_indicator.dart';
import '../states/empty_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class ComponentShowcaseScreen extends StatefulWidget {
  const ComponentShowcaseScreen({super.key});

  @override
  State<ComponentShowcaseScreen> createState() =>
      _ComponentShowcaseScreenState();
}

class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen> {
  final _searchController = TextEditingController();
  final _textController = TextEditingController();
  bool _primaryLoading = false;
  bool _secondaryLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        ...children,
        SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Component Showcase'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xl),
        children: [
          // 1. Logo Variants
          _buildSection(
            title: '1. Logo Variants',
            children: [
              _buildCard(
                Column(
                  children: [
                    const Text('Small Logo (24)'),
                    SizedBox(height: AppSpacing.xs),
                    const OtlobLogo(size: LogoSize.small),
                    SizedBox(height: AppSpacing.md),
                    const Text('Medium Logo (32)'),
                    SizedBox(height: AppSpacing.xs),
                    const OtlobLogo(size: LogoSize.medium),
                    SizedBox(height: AppSpacing.md),
                    const Text('Large Logo (48)'),
                    SizedBox(height: AppSpacing.xs),
                    const OtlobLogo(size: LogoSize.large),
                    SizedBox(height: AppSpacing.md),
                    const Text('Hero Logo (64)'),
                    SizedBox(height: AppSpacing.xs),
                    const OtlobLogo(size: LogoSize.hero),
                    SizedBox(height: AppSpacing.md),
                    const Text('Animated Logo with Pulse'),
                    SizedBox(height: AppSpacing.xs),
                    const OtlobLogo(size: LogoSize.large, animated: true),
                  ],
                ),
              ),
            ],
          ),

          // 2. Buttons
          _buildSection(
            title: '2. Buttons',
            children: [
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Primary Button'),
                    SizedBox(height: AppSpacing.xs),
                    PrimaryButton(
                      text: 'Primary Button',
                      onPressed: () {
                        setState(() => _primaryLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _primaryLoading = false);
                        });
                      },
                      isLoading: _primaryLoading,
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Primary Button (Disabled)'),
                    SizedBox(height: AppSpacing.xs),
                    const PrimaryButton(
                      text: 'Disabled Button',
                      onPressed: null,
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Secondary Button'),
                    SizedBox(height: AppSpacing.xs),
                    SecondaryButton(
                      text: 'Secondary Button',
                      onPressed: () {
                        setState(() => _secondaryLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() => _secondaryLoading = false);
                          }
                        });
                      },
                      isLoading: _secondaryLoading,
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Icon Button with Badge'),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButtonCustom(
                          icon: Icons.shopping_cart,
                          onPressed: () {},
                          badgeCount: 3,
                        ),
                        IconButtonCustom(
                          icon: Icons.favorite,
                          onPressed: () {},
                          badgeCount: 12,
                        ),
                        IconButtonCustom(
                          icon: Icons.notifications,
                          onPressed: () {},
                          badgeCount: 99,
                        ),
                        IconButtonCustom(
                          icon: Icons.settings,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 3. Cards
          _buildSection(
            title: '3. Cards',
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Restaurant Card'),
                    SizedBox(height: AppSpacing.xs),
                    RestaurantCard(
                      imageUrl: 'https://via.placeholder.com/400x200',
                      name: 'Al Tazaj Restaurant',
                      cuisines: const ['Saudi Arabian', 'Grill'],
                      distance: '2.5 km',
                      rating: 4.5,
                      hasTawseya: true,
                      tawseyaCount: 156,
                      isFavorite: false,
                      onTap: () {},
                      onFavoritePressed: () {},
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Restaurant Card (Loading)'),
                    SizedBox(height: AppSpacing.xs),
                    const RestaurantCard.loading(),
                    SizedBox(height: AppSpacing.md),
                    const Text('Dish Card'),
                    SizedBox(height: AppSpacing.xs),
                    DishCard(
                      imageUrl: 'https://via.placeholder.com/300x200',
                      name: 'Grilled Chicken',
                      price: 45.00,
                      specialTag: 'Popular',
                      onTap: () {},
                      onAddToCart: () {},
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Dish Card (Loading)'),
                    SizedBox(height: AppSpacing.xs),
                    const DishCard.loading(),
                  ],
                ),
              ),
            ],
          ),

          // 4. Badges
          _buildSection(
            title: '4. Badges',
            children: [
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tawseya Badge'),
                    SizedBox(height: AppSpacing.xs),
                    const Row(
                      children: [
                        TawseyaBadge(size: BadgeSize.small),
                        SizedBox(width: 8),
                        TawseyaBadge(size: BadgeSize.medium),
                        SizedBox(width: 8),
                        TawseyaBadge(size: BadgeSize.large),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Tawseya Badge with Count'),
                    SizedBox(height: AppSpacing.xs),
                    const TawseyaBadge(size: BadgeSize.medium, count: 156),
                    SizedBox(height: AppSpacing.md),
                    const Text('Tawseya Badge (Animated)'),
                    SizedBox(height: AppSpacing.xs),
                    const TawseyaBadge(
                      size: BadgeSize.medium,
                      count: 234,
                      animated: true,
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Cuisine Tags'),
                    SizedBox(height: AppSpacing.xs),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CuisineTag(name: 'Italian'),
                        CuisineTag(name: 'Chinese'),
                        CuisineTag(name: 'Mexican'),
                        CuisineTag(name: 'Indian'),
                        CuisineTag(name: 'Japanese'),
                        CuisineTag(name: 'Thai'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 5. Inputs
          _buildSection(
            title: '5. Inputs',
            children: [
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search Bar'),
                    SizedBox(height: AppSpacing.xs),
                    SearchBarWidget(
                      controller: _searchController,
                      hintText: 'Search restaurants or dishes...',
                      onSearch: (value) {
                        print('Search: $value');
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Custom Text Field'),
                    SizedBox(height: AppSpacing.xs),
                    CustomTextField(
                      controller: _textController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    CustomTextField(
                      controller: TextEditingController(),
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      errorText: 'Enter a valid email',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    CustomTextField(
                      controller: TextEditingController(),
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 6. States
          _buildSection(
            title: '6. States',
            children: [
              _buildCard(
                Column(
                  children: [
                    const Text('Loading Indicators'),
                    SizedBox(height: AppSpacing.md),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('Small', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 8),
                            LoadingIndicator(size: LoadingSize.small),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Medium', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 8),
                            LoadingIndicator(size: LoadingSize.medium),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Large', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 8),
                            LoadingIndicator(size: LoadingSize.large),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    const Text('Logo Loading Indicator'),
                    SizedBox(height: AppSpacing.xs),
                    const LogoLoadingIndicator(message: 'Loading...'),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              _buildCard(
                Column(
                  children: [
                    const Text('Empty States'),
                    SizedBox(height: AppSpacing.md),
                    EmptyState(
                      icon: Icons.restaurant,
                      title: 'No restaurants found',
                      message: 'Try adjusting your search filters',
                      actionText: 'Browse Restaurants',
                      onAction: () {},
                    ),
                    SizedBox(height: AppSpacing.md),
                    const EmptyState(
                      icon: Icons.favorite_border,
                      title: 'No favorites yet',
                      message: 'Start adding restaurants to your favorites',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
