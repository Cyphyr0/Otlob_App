import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/providers.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(mockRestaurantsProvider);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontFamily: 'TutanoCCV2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B3A67),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () => favoritesNotifier.toggleFavorite(restaurant),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 250.h,
              width: double.infinity,
              color: Colors.grey[300],
              child: restaurant.imageUrl.isNotEmpty
                  ? Image.asset(restaurant.imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.restaurant, size: 100, color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B3A67),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20.sp),
                          Text('${restaurant.rating}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(restaurant.address),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(restaurant.isOpen ? 'Open' : 'Closed'),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B3A67),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(restaurant.description),
                  SizedBox(height: 24.h),
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B3A67),
                    ),
                  ),
                  ...restaurant.menuCategories.map(
                    (category) => ListTile(
                      leading: const Icon(Icons.restaurant_menu),
                      title: Text(category),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navigate to menu category
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/cart'),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE84545),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
