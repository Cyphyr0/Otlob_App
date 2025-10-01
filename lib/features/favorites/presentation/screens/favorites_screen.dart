import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    if (favorites.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF2B3A67),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 80.sp, color: Colors.white70),
              SizedBox(height: 16.h),
              Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Start exploring restaurants and add your favorites!',
                style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home),
                label: const Text('Explore'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84545),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: 'TutanoCCV2',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B3A67),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final restaurant = favorites[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  color: Colors.grey[300],
                  child: restaurant.imageUrl.isNotEmpty
                      ? Image.asset(restaurant.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.restaurant, size: 30),
                ),
              ),
              title: Text(restaurant.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.cuisine),
                  Text(
                    '${restaurant.rating} • ${restaurant.tawseyaCount} Tawseya',
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        favoritesNotifier.removeFavorite(restaurant.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => context.go('/restaurant/${restaurant.id}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
