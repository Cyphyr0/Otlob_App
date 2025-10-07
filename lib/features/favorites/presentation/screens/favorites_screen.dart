import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/branding/otlob_logo.dart';
import '../../../../core/widgets/cards/restaurant_card.dart';
import '../../../../core/widgets/states/empty_state.dart';
import '../../../../core/providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: favorites.isEmpty
          ? EmptyState.noFavorites(
              onAction: () {
                ref.read(navigationIndexProvider.notifier).state = 0;
                context.go('/home');
              },
            )
          : ListView.builder(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < favorites.length - 1 ? AppSpacing.md : 0,
                  ),
                  child: RestaurantCard(
                    imageUrl: restaurant.imageUrl,
                    name: restaurant.name,
                    cuisines: restaurant.cuisine.split(', '),
                    rating: restaurant.rating,
                    distance: '${restaurant.distance.toStringAsFixed(1)} km',
                    hasTawseya: restaurant.tawseyaCount > 0,
                    tawseyaCount: restaurant.tawseyaCount,
                    isFavorite: true,
                    onTap: () => context.go('/restaurant/${restaurant.id}'),
                    onFavoritePressed: () =>
                        favoritesNotifier.toggleFavorite(restaurant),
                  ),
                );
              },
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.offWhite,
      elevation: 0,
      title: Row(
        children: [
          const OtlobLogo(size: LogoSize.small),
          SizedBox(width: AppSpacing.md),
          Text(
            'Favorites',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
