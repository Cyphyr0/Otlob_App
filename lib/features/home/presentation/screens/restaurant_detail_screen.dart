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

    final cartNotifier = ref.read(cartProvider.notifier);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFavorite = ref
        .watch(favoritesProvider)
        .any((r) => r.id == restaurant.id);

    // Mock menu data
    final mockMenu = [
      {
        'category': 'Appetizers',
        'dishes': [
          {
            'name': 'Hummus',
            'price': 5.0,
            'imageUrl': 'assets/images/hummus.jpg',
          },
          {
            'name': 'Falafel',
            'price': 4.0,
            'imageUrl': 'assets/images/falafel.jpg',
          },
        ],
      },
      {
        'category': 'Main Courses',
        'dishes': [
          {
            'name': 'Koshari',
            'price': 8.0,
            'imageUrl': 'assets/images/koshari.jpg',
          },
          {
            'name': 'Shawarma',
            'price': 7.0,
            'imageUrl': 'assets/images/shawarma.jpg',
          },
        ],
      },
      {
        'category': 'Desserts',
        'dishes': [
          {
            'name': 'Kunafa',
            'price': 6.0,
            'imageUrl': 'assets/images/kunafa.jpg',
          },
        ],
      },
    ];

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
                  SizedBox(height: 16.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mockMenu.length,
                    itemBuilder: (context, categoryIndex) {
                      final category = mockMenu[categoryIndex];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['category'] as String,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2B3A67),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ...category['dishes']!
                                  .map<Widget>(
                                    (dish) => ListTile(
                                      leading: Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: Text(dish['name']),
                                      subtitle: Text('\$${dish['price']}'),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          cartNotifier.addItem(
                                            name: dish['name'],
                                            price: dish['price'],
                                            imageUrl: dish['imageUrl'],
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${dish['name']} added to cart',
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Add'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFE84545,
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      );
                    },
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
