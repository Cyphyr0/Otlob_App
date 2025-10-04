# Advanced Flutter Architecture Patterns
**Project:** Otlob  
**Date:** October 4, 2025  
**Purpose:** Extracted best practices from previous architecture documents

---

## 📚 OVERVIEW

This document compiles advanced architectural patterns, coding standards, and best practices extracted from previous Otlob project iterations. Use these patterns to maintain code quality and scalability.

---

## 🏗️ CLEAN ARCHITECTURE IMPLEMENTATION

### Three-Layer Architecture

```
Presentation Layer (UI)
    ↓ (depends on)
Domain Layer (Business Logic)
    ↑ (implemented by)
Data Layer (Repositories & Data Sources)
```

### Layer Responsibilities

#### 1. Domain Layer (Business Logic Core)

**Entities** - Pure business objects
```dart
// domain/entities/restaurant.dart
class Restaurant {
  final String id;
  final String name;
  final String cuisineType;
  final double rating;
  final int deliveryTimeMinutes;
  final bool hasTawseya;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.hasTawseya,
  });
}
```

**Repository Interfaces** - Define contracts
```dart
// domain/repositories/restaurant_repository.dart
abstract class RestaurantRepository {
  Future<Either<Failure, List<Restaurant>>> getRestaurants({
    required String locationId,
    String? searchQuery,
    List<String>? cuisineFilters,
  });
  
  Future<Either<Failure, Restaurant>> getRestaurantById(String id);
  
  Future<Either<Failure, List<Dish>>> getRestaurantMenu(String restaurantId);
}
```

**Use Cases** - Single-purpose business actions
```dart
// domain/usecases/get_restaurants.dart
class GetRestaurants {
  final RestaurantRepository repository;

  GetRestaurants(this.repository);

  Future<Either<Failure, List<Restaurant>>> call({
    required String locationId,
    String? searchQuery,
    List<String>? cuisineFilters,
  }) async {
    return await repository.getRestaurants(
      locationId: locationId,
      searchQuery: searchQuery,
      cuisineFilters: cuisineFilters,
    );
  }
}
```

#### 2. Data Layer (Implementation)

**Models** - Serializable data objects
```dart
// data/models/restaurant_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/restaurant.dart';

part 'restaurant_model.freezed.dart';
part 'restaurant_model.g.dart';

@freezed
class RestaurantModel with _$RestaurantModel {
  const RestaurantModel._();

  const factory RestaurantModel({
    required String id,
    required String name,
    @JsonKey(name: 'cuisine_type') required String cuisineType,
    required double rating,
    @JsonKey(name: 'delivery_time') required int deliveryTimeMinutes,
    @JsonKey(name: 'has_tawseya') required bool hasTawseya,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  // Convert to domain entity
  Restaurant toEntity() {
    return Restaurant(
      id: id,
      name: name,
      cuisineType: cuisineType,
      rating: rating,
      deliveryTimeMinutes: deliveryTimeMinutes,
      hasTawseya: hasTawseya,
    );
  }
}
```

**Data Sources** - API/Database access
```dart
// data/datasources/restaurant_remote_datasource.dart
abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants({
    required String locationId,
    String? searchQuery,
    List<String>? cuisineFilters,
  });
  
  Future<RestaurantModel> getRestaurantById(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio dio;

  RestaurantRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RestaurantModel>> getRestaurants({
    required String locationId,
    String? searchQuery,
    List<String>? cuisineFilters,
  }) async {
    try {
      final queryParams = {
        'location_id': locationId,
        if (searchQuery != null) 'search': searchQuery,
        if (cuisineFilters != null) 'cuisines': cuisineFilters.join(','),
      };

      final response = await dio.get(
        '/restaurants',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data['data'] as List)
            .map((json) => RestaurantModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          'Failed to load restaurants',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    // Implementation...
  }
}
```

**Repository Implementation**
```dart
// data/repositories/restaurant_repository_impl.dart
class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  final RestaurantLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RestaurantRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants({
    required String locationId,
    String? searchQuery,
    List<String>? cuisineFilters,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getRestaurants(
          locationId: locationId,
          searchQuery: searchQuery,
          cuisineFilters: cuisineFilters,
        );
        
        // Cache locally
        await localDataSource.cacheRestaurants(models);
        
        // Convert to entities
        final entities = models.map((model) => model.toEntity()).toList();
        
        return Right(entities);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      }
    } else {
      // Try to load from cache
      try {
        final models = await localDataSource.getCachedRestaurants();
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on CacheException {
        return Left(CacheFailure('No cached data available'));
      }
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
    // Implementation...
  }

  @override
  Future<Either<Failure, List<Dish>>> getRestaurantMenu(String restaurantId) async {
    // Implementation...
  }
}
```

#### 3. Presentation Layer (UI)

**Riverpod Providers**
```dart
// features/home/providers/restaurant_providers.dart

// Repository provider
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepositoryImpl(
    remoteDataSource: ref.watch(restaurantRemoteDataSourceProvider),
    localDataSource: ref.watch(restaurantLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// Use case provider
final getRestaurantsUseCaseProvider = Provider<GetRestaurants>((ref) {
  return GetRestaurants(ref.watch(restaurantRepositoryProvider));
});

// State notifier provider
final restaurantListProvider = 
    StateNotifierProvider<RestaurantListNotifier, RestaurantListState>((ref) {
  return RestaurantListNotifier(
    getRestaurants: ref.watch(getRestaurantsUseCaseProvider),
    locationId: ref.watch(currentLocationProvider).value?.id ?? '',
  );
});
```

**State Notifier**
```dart
// features/home/providers/restaurant_list_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_list_notifier.freezed.dart';

@freezed
class RestaurantListState with _$RestaurantListState {
  const factory RestaurantListState.initial() = _Initial;
  const factory RestaurantListState.loading() = _Loading;
  const factory RestaurantListState.loaded(List<Restaurant> restaurants) = _Loaded;
  const factory RestaurantListState.error(String message) = _Error;
}

class RestaurantListNotifier extends StateNotifier<RestaurantListState> {
  final GetRestaurants getRestaurants;
  final String locationId;

  RestaurantListNotifier({
    required this.getRestaurants,
    required this.locationId,
  }) : super(const RestaurantListState.initial());

  Future<void> loadRestaurants({
    String? searchQuery,
    List<String>? cuisineFilters,
  }) async {
    state = const RestaurantListState.loading();

    final result = await getRestaurants(
      locationId: locationId,
      searchQuery: searchQuery,
      cuisineFilters: cuisineFilters,
    );

    result.fold(
      (failure) => state = RestaurantListState.error(failure.message),
      (restaurants) => state = RestaurantListState.loaded(restaurants),
    );
  }

  void clearFilters() {
    loadRestaurants();
  }
}
```

**UI Widget**
```dart
// features/home/widgets/restaurant_list.dart
class RestaurantList extends ConsumerWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantListProvider);

    return state.when(
      initial: () => const Center(child: Text('Pull to refresh')),
      loading: () => const RestaurantListSkeleton(),
      loaded: (restaurants) {
        if (restaurants.isEmpty) {
          return const EmptyRestaurantsView();
        }
        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return RestaurantCard(restaurant: restaurants[index]);
          },
        );
      },
      error: (message) => ErrorView(
        message: message,
        onRetry: () => ref.read(restaurantListProvider.notifier).loadRestaurants(),
      ),
    );
  }
}
```

---

## 🔥 RIVERPOD STATE MANAGEMENT PATTERNS

### Pattern 1: Simple State with Provider

```dart
// For immutable, globally-shared data
final themeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});
```

### Pattern 2: Mutable State with StateProvider

```dart
// For simple mutable values
final counterProvider = StateProvider<int>((ref) => 0);

// Usage in widget:
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).state++;
```

### Pattern 3: Complex State with StateNotifier

```dart
// For complex state logic
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState.empty());

  void addItem(CartItem item) {
    state = state.copyWith(
      items: [...state.items, item],
      totalPrice: state.totalPrice + item.price,
    );
  }

  void removeItem(String itemId) {
    final updatedItems = state.items.where((i) => i.id != itemId).toList();
    final newTotal = updatedItems.fold<double>(
      0, 
      (sum, item) => sum + item.price,
    );
    
    state = state.copyWith(
      items: updatedItems,
      totalPrice: newTotal,
    );
  }

  void clear() {
    state = CartState.empty();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
```

### Pattern 4: Async State with FutureProvider

```dart
// For one-time async operations
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserProfile(userId);
});

// Usage in widget:
final profileAsync = ref.watch(userProfileProvider);
profileAsync.when(
  data: (profile) => ProfileView(profile: profile),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorView(error: err.toString()),
);
```

### Pattern 5: Streaming State with StreamProvider

```dart
// For real-time data streams
final orderStatusProvider = StreamProvider.family<OrderStatus, String>((ref, orderId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchOrderStatus(orderId);
});

// Usage in widget:
final statusAsync = ref.watch(orderStatusProvider('order-123'));
statusAsync.when(
  data: (status) => OrderStatusWidget(status: status),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorView(error: err.toString()),
);
```

### Pattern 6: Dependent Providers

```dart
// Provider that depends on another
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final allRestaurants = ref.watch(restaurantListProvider).maybeWhen(
    loaded: (restaurants) => restaurants,
    orElse: () => <Restaurant>[],
  );
  
  final filters = ref.watch(restaurantFiltersProvider);
  
  return allRestaurants.where((restaurant) {
    if (filters.cuisineTypes.isNotEmpty && 
        !filters.cuisineTypes.contains(restaurant.cuisineType)) {
      return false;
    }
    if (filters.minRating != null && restaurant.rating < filters.minRating!) {
      return false;
    }
    return true;
  }).toList();
});
```

### Pattern 7: Family Providers (Parameterized)

```dart
// Provider that takes a parameter
final dishDetailProvider = FutureProvider.family<Dish, String>((ref, dishId) async {
  final repository = ref.watch(dishRepositoryProvider);
  return await repository.getDishById(dishId);
});

// Usage:
final dish = ref.watch(dishDetailProvider('dish-123'));
```

---

## 🎯 ERROR HANDLING PATTERNS

### Failure Types

```dart
// core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message) : super(statusCode: null);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message) : super(statusCode: null);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(statusCode: null);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.statusCode});
}
```

### Exception Types

```dart
// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}
```

### Error Handling in Repository

```dart
@override
Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
  try {
    if (await networkInfo.isConnected) {
      final model = await remoteDataSource.getRestaurantById(id);
      return Right(model.toEntity());
    } else {
      final model = await localDataSource.getCachedRestaurant(id);
      return Right(model.toEntity());
    }
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message, statusCode: e.statusCode));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } catch (e) {
    return Left(UnknownFailure('An unexpected error occurred: $e'));
  }
}
```

---

## 🌐 API CLIENT ARCHITECTURE

### Dio Configuration with Interceptors

```dart
// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      if (kDebugMode) LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      AuthInterceptor(),
      RetryInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Dio get instance => _dio;
}

// Auth interceptor - adds token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await TokenStorage.getAccessToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
}

// Retry interceptor - retries failed requests
class RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    if (retries < maxRetries && _shouldRetry(err)) {
      await Future.delayed(retryDelay * (retries + 1));
      
      err.requestOptions.extra['retries'] = retries + 1;
      
      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}

// Error interceptor - handles errors globally
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      // Token expired - attempt refresh
      final refreshed = await _attemptTokenRefresh();
      
      if (refreshed) {
        // Retry the request with new token
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Refresh worked but retry failed
        }
      }
      
      // Refresh failed - logout user
      await _handleUnauthorized();
    }

    handler.next(err);
  }

  Future<bool> _attemptTokenRefresh() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      // Call refresh endpoint
      final response = await Dio().post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
        await TokenStorage.saveAccessToken(newAccessToken);
        await TokenStorage.saveRefreshToken(newRefreshToken);
        
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    
    return false;
  }

  Future<void> _handleUnauthorized() async {
    await TokenStorage.clearTokens();
    // Navigate to login screen
    // (This requires access to navigation context)
  }
}
```

---

## 🧪 TESTING STRATEGIES

### Unit Testing - Repository

```dart
// test/data/repositories/restaurant_repository_impl_test.dart
void main() {
  late RestaurantRepositoryImpl repository;
  late MockRestaurantRemoteDataSource mockRemoteDataSource;
  late MockRestaurantLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRestaurantRemoteDataSource();
    mockLocalDataSource = MockRestaurantLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    
    repository = RestaurantRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getRestaurants', () {
    const tLocationId = 'location-123';
    final tRestaurantModels = [
      RestaurantModel(
        id: '1',
        name: 'Test Restaurant',
        cuisineType: 'Italian',
        rating: 4.5,
        deliveryTimeMinutes: 30,
        hasTawseya: true,
      ),
    ];
    final tRestaurants = tRestaurantModels.map((m) => m.toEntity()).toList();

    test('should return restaurants when connected and call succeeds', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRestaurants(locationId: tLocationId))
          .thenAnswer((_) async => tRestaurantModels);

      // act
      final result = await repository.getRestaurants(locationId: tLocationId);

      // assert
      expect(result, Right(tRestaurants));
      verify(mockRemoteDataSource.getRestaurants(locationId: tLocationId));
      verify(mockLocalDataSource.cacheRestaurants(tRestaurantModels));
    });

    test('should return cached restaurants when offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedRestaurants())
          .thenAnswer((_) async => tRestaurantModels);

      // act
      final result = await repository.getRestaurants(locationId: tLocationId);

      // assert
      expect(result, Right(tRestaurants));
      verify(mockLocalDataSource.getCachedRestaurants());
      verifyNever(mockRemoteDataSource.getRestaurants(locationId: any));
    });

    test('should return ServerFailure when remote call fails', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRestaurants(locationId: tLocationId))
          .thenThrow(ServerException('Server error', statusCode: 500));

      // act
      final result = await repository.getRestaurants(locationId: tLocationId);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (restaurants) => fail('Should return failure'),
      );
    });
  });
}
```

### Widget Testing

```dart
// test/features/home/widgets/restaurant_card_test.dart
void main() {
  testWidgets('RestaurantCard displays restaurant information', (tester) async {
    // arrange
    const restaurant = Restaurant(
      id: '1',
      name: 'Test Restaurant',
      cuisineType: 'Italian',
      rating: 4.5,
      deliveryTimeMinutes: 30,
      hasTawseya: true,
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RestaurantCard(restaurant: restaurant),
        ),
      ),
    );

    // assert
    expect(find.text('Test Restaurant'), findsOneWidget);
    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget); // Tawseya badge
  });

  testWidgets('RestaurantCard navigates on tap', (tester) async {
    // arrange
    const restaurant = Restaurant(
      id: '1',
      name: 'Test Restaurant',
      cuisineType: 'Italian',
      rating: 4.5,
      deliveryTimeMinutes: 30,
      hasTawseya: false,
    );

    bool navigationCalled = false;

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RestaurantCard(
            restaurant: restaurant,
            onTap: () => navigationCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(RestaurantCard));
    await tester.pumpAndSettle();

    // assert
    expect(navigationCalled, true);
  });
}
```

### Integration Testing

```dart
// integration_test/order_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete order flow', (tester) async {
    // Start app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // 1. Navigate to restaurant
    await tester.tap(find.text('Test Restaurant'));
    await tester.pumpAndSettle();

    // 2. Add dish to cart
    await tester.tap(find.text('Margherita Pizza'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // 3. Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // 4. Verify cart contents
    expect(find.text('Margherita Pizza'), findsOneWidget);

    // 5. Proceed to checkout
    await tester.tap(find.text('Proceed to Checkout'));
    await tester.pumpAndSettle();

    // 6. Select payment method
    await tester.tap(find.text('Cash on Delivery'));
    await tester.pumpAndSettle();

    // 7. Place order
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    // 8. Verify order tracking screen
    expect(find.text('Order Placed'), findsOneWidget);
  });
}
```

---

## 🎨 COMPONENT DEVELOPMENT STANDARDS

### Component Template

```dart
import 'package:flutter/material.dart';

/// A card widget that displays restaurant information.
/// 
/// This widget follows Material Design 3 principles and includes:
/// - Restaurant image with gradient overlay
/// - Name, cuisine type, and ratings
/// - Tawseya badge (if applicable)
/// - Tap gesture handling
/// 
/// Example:
/// ```dart
/// RestaurantCard(
///   restaurant: myRestaurant,
///   onTap: () => Navigator.push(...),
/// )
/// ```
class RestaurantCard extends StatelessWidget {
  /// The restaurant data to display
  final Restaurant restaurant;
  
  /// Callback invoked when the card is tapped
  final VoidCallback? onTap;
  
  /// Whether to show a shadow under the card
  final bool showShadow;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    this.onTap,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: showShadow ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.md),
          ),
          child: CachedNetworkImage(
            imageUrl: restaurant.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ImagePlaceholder(),
            errorWidget: (context, url, error) => const ImageError(),
          ),
        ),
        if (restaurant.hasTawseya)
          Positioned(
            top: 8,
            right: 8,
            child: TawseyaBadge(count: restaurant.tawseyaCount),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: AppTypography.headlineSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                restaurant.cuisineType,
                style: AppTypography.bodyMedium,
              ),
              const Spacer(),
              const Icon(Icons.star, size: 16, color: AppColors.rating),
              const SizedBox(width: 4),
              Text('${restaurant.rating}'),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.delivery_dining, size: 16),
              const SizedBox(width: 4),
              Text('${restaurant.deliveryTimeMinutes} min'),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Naming Conventions

| Element Type | Convention | Example |
|--------------|------------|---------|
| Files | `snake_case.dart` | `restaurant_card.dart` |
| Private Files | `_snake_case.dart` | `_private_helper.dart` |
| Classes/Widgets | `PascalCase` | `RestaurantCard` |
| Functions/Variables | `camelCase` | `loadRestaurants()` |
| Constants | `lowerCamelCase` | `defaultTimeout` |
| Enums | `PascalCase` | `OrderStatus` |
| Enum Values | `camelCase` | `OrderStatus.pending` |

---

## 🚀 PERFORMANCE OPTIMIZATION

### Image Loading

```dart
// Use cached_network_image for all network images
CachedNetworkImage(
  imageUrl: imageUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => const ShimmerPlaceholder(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: 800, // Resize for memory efficiency
  maxWidthDiskCache: 1000, // Resize for disk cache
)
```

### List Performance

```dart
// Use ListView.builder for long lists (not ListView with all items)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// Use AutomaticKeepAliveClientMixin for expensive widgets
class ExpensiveWidget extends StatefulWidget {
  @override
  _ExpensiveWidgetState createState() => _ExpensiveWidgetState();
}

class _ExpensiveWidgetState extends State<ExpensiveWidget> 
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Must call super
    return ExpensiveContent();
  }
}
```

### Const Constructors

```dart
// Always use const for widgets when possible
const SizedBox(height: 16),
const Divider(),
const CircularProgressIndicator(),

// Define const values outside build method
static const _padding = EdgeInsets.all(16.0);
static const _borderRadius = BorderRadius.all(Radius.circular(8.0));
```

---

## 📚 REFERENCES

- Clean Architecture by Robert C. Martin
- Flutter & Dart Best Practices
- Riverpod Documentation
- Material Design 3 Guidelines

---

**Remember:** These patterns are not rigid rules. Adapt them to fit your specific use case while maintaining the core architectural principles.
