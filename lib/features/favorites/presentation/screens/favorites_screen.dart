import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/branding/otlob_logo.dart';
import '../../../../core/widgets/cards/restaurant_card.dart';
import '../../../../core/widgets/states/empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: favoritesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading favorites: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(favoritesProvider.notifier).refreshFavorites(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (favorites) {
          if (favorites.isEmpty) {
            return EmptyState.noFavorites(
              onAction: () {
                ref.read(navigationIndexProvider.notifier).state = 0;
                context.go('/home');
              },
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              var favorite = favorites[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < favorites.length - 1 ? AppSpacing.md : 0,
                ),
                child: RestaurantCard(
                  restaurantId: favorite.restaurantId,
                  name: favorite.restaurantName,
                  cuisines: const [], // We don't have cuisine data in favorites
                  rating: 0, // We don't have rating data in favorites
                  imageUrl: favorite.restaurantImageUrl ?? '',
                  tawseyaCount: 0, // We don't have tawseya data in favorites
                  isFavorite: true,
                  onTap: () => context.go('/restaurant/${favorite.restaurantId}'),
                  onFavoriteTap: () => ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(
                        favorite.restaurantId,
                        favorite.restaurantName,
                        favorite.restaurantImageUrl,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
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
