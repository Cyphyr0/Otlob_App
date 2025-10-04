# Otlob Frontend Architecture Guide
**Version:** 2.0  
**Date:** October 4, 2025  
**Framework:** Flutter 3.35.0+ / Dart 3.9.2+

---

## Section 1: Architecture Overview

This document defines the complete frontend architecture for the Otlob Flutter application, including project structure, coding standards, state management patterns, API integration, routing, styling, testing requirements, and developer guidelines.

### Architecture Philosophy

**Clean Architecture Principles:**
- Clear separation of concerns across layers
- Business logic independent of UI and data sources
- Easy to test, maintain, and scale
- Backend-agnostic (easy transition from Firebase to .NET)

**Key Design Decisions:**
- **State Management:** Riverpod 2.6.1 (reactive, type-safe, testable)
- **Local Storage:** Drift 2.28.2 (SQLite with type-safe queries)
- **Navigation:** GoRouter (deep linking, nested navigation)
- **Architecture Pattern:** Clean Architecture with Repository abstraction
- **UI Framework:** Material Design 3 with custom theme

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| Sep 26, 2025 | 1.0 | Initial architecture draft | Tech Team |
| Oct 4, 2025 | 2.0 | Updated for current implementation | AI Agent |

---

## Section 2: Technology Stack

| Category | Technology | Version | Purpose | Rationale |
|----------|-----------|---------|---------|-----------|
| **Framework** | Flutter | 3.35.0+ | Cross-platform app framework | Latest stable, best performance |
| **Language** | Dart | 3.9.2+ | Programming language | Null-safety, strong typing |
| **State Management** | Riverpod | 2.6.1 | App state management | Reactive, testable, type-safe |
| **Local Database** | Drift | 2.28.2 | SQLite ORM | Type-safe queries, reactive streams |
| **Routing** | GoRouter | 14.7.3 | Navigation & deep linking | Official Flutter recommendation |
| **HTTP Client** | Dio | 5.7.0 | API communication | Interceptors, request/response transformation |
| **Code Generation** | Freezed | 2.5.7 | Immutable models | Reduces boilerplate, ensures immutability |
| **JSON Serialization** | json_serializable | 6.8.0 | Model serialization | Auto-generate JSON converters |
| **Local Storage** | SharedPreferences | 2.3.4 | Simple key-value storage | User preferences, auth token |
| **Testing** | flutter_test | SDK | Unit & widget tests | Built-in testing framework |
| **Integration Testing** | integration_test | SDK | E2E testing | Full user flow testing |
| **Dependency Injection** | Riverpod | 2.6.1 | Service locator | Built into Riverpod |
| **PDF Generation** | pdf | Latest | Receipt generation | Create downloadable receipts |
| **Image Loading** | cached_network_image | 3.4.1 | Optimized image loading | Caching, placeholders |
| **Animations** | flutter_animate | 4.5.0 | Declarative animations | Smooth, performant animations |

### Why Not BLoC?
We chose **Riverpod over BLoC** because:
- **Simpler API:** Less boilerplate, easier to learn
- **Better Testing:** Easier to mock and test
- **Type Safety:** Compile-time dependency resolution
- **Flexibility:** Can use Cubit-like pattern with StateNotifier when needed

---

## Section 3: Project Structure

### Directory Layout

```plaintext
flutter_application_1/
│
├── assets/
│   ├── fonts/
│   │   └── tutano-cc/
│   │       └── tutano_cc_v2.ttf
│   ├── icons/
│   ├── images/
│   └── translations/
│
├── lib/
│   │
│   ├── main.dart                           # App entry point
│   ├── firebase_options.dart               # Firebase config (auto-generated)
│   │
│   ├── core/                               # Shared across features
│   │   │
│   │   ├── config/
│   │   │   └── app_config.dart            # App configuration
│   │   │
│   │   ├── errors/
│   │   │   ├── failures.dart              # Abstract failure types
│   │   │   └── exceptions.dart            # Exception definitions
│   │   │
│   │   ├── network/
│   │   │   └── connectivity_service.dart  # Network status monitoring
│   │   │
│   │   ├── providers/
│   │   │   └── connectivity_provider.dart # Riverpod connectivity state
│   │   │
│   │   ├── routes/
│   │   │   └── app_router.dart            # GoRouter configuration
│   │   │
│   │   ├── services/
│   │   │   ├── database_service.dart      # Drift database service
│   │   │   └── notification_service.dart  # Push notifications
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Theme definition
│   │   │   ├── app_colors.dart            # Color palette
│   │   │   └── app_text_styles.dart       # Typography
│   │   │
│   │   ├── utils/
│   │   │   ├── shared_prefs_helper.dart   # SharedPreferences wrapper
│   │   │   ├── validators.dart            # Form validation
│   │   │   └── constants.dart             # App constants
│   │   │
│   │   └── widgets/                        # Reusable widgets
│   │       ├── custom_app_bar.dart
│   │       ├── loading_indicator.dart
│   │       ├── error_view.dart
│   │       └── empty_state.dart
│   │
│   └── features/                           # Feature modules
│       │
│       ├── splash/
│       │   └── presentation/
│       │       ├── screens/
│       │       │   └── splash_screen.dart
│       │       └── providers/
│       │           └── splash_provider.dart
│       │
│       ├── onboarding/
│       │   └── presentation/
│       │       ├── screens/
│       │       │   └── onboarding_screen.dart
│       │       └── widgets/
│       │           └── onboarding_page.dart
│       │
│       ├── auth/                           # Authentication feature
│       │   │
│       │   ├── domain/                     # Business logic layer
│       │   │   ├── entities/
│       │   │   │   └── user.dart          # User entity (pure Dart)
│       │   │   └── repositories/
│       │   │       └── auth_repository.dart # Abstract interface
│       │   │
│       │   ├── data/                       # Data layer
│       │   │   ├── models/
│       │   │   │   └── user_model.dart    # User model (with JSON)
│       │   │   ├── datasources/
│       │   │   │   ├── auth_remote_datasource.dart  # Firebase Auth
│       │   │   │   └── auth_local_datasource.dart   # Local storage
│       │   │   └── repositories/
│       │   │       └── auth_repository_impl.dart    # Repository implementation
│       │   │
│       │   └── presentation/               # UI layer
│       │       ├── screens/
│       │       │   ├── login_screen.dart
│       │       │   ├── signup_screen.dart
│       │       │   └── phone_verification_screen.dart
│       │       ├── widgets/
│       │       │   ├── auth_button.dart
│       │       │   └── why_otlob_section.dart
│       │       └── providers/
│       │           └── auth_provider.dart   # Riverpod state
│       │
│       ├── home/                           # Discovery feature
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── restaurant.dart
│       │   │   │   └── menu_item.dart
│       │   │   └── repositories/
│       │   │       └── restaurant_repository.dart
│       │   │
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── restaurant_model.dart
│       │   │   │   └── menu_item_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── restaurant_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── restaurant_repository_impl.dart
│       │   │
│       │   └── presentation/
│       │       ├── screens/
│       │       │   ├── home_screen.dart
│       │       │   ├── restaurant_detail_screen.dart
│       │       │   └── search_screen.dart
│       │       ├── widgets/
│       │       │   ├── restaurant_card.dart
│       │       │   ├── hidden_gems_carousel.dart
│       │       │   └── local_heroes_carousel.dart
│       │       └── providers/
│       │           └── home_provider.dart
│       │
│       ├── cart/                           # Shopping cart
│       │   ├── domain/
│       │   │   └── entities/
│       │   │       └── cart_item.dart
│       │   └── presentation/
│       │       ├── screens/
│       │       │   └── cart_screen.dart
│       │       └── providers/
│       │           └── cart_provider.dart
│       │
│       ├── favorites/                      # User favorites
│       │   └── presentation/
│       │       ├── screens/
│       │       │   └── favorites_screen.dart
│       │       └── providers/
│       │           └── favorites_provider.dart
│       │
│       └── profile/                        # User profile
│           └── presentation/
│               ├── screens/
│               │   └── profile_screen.dart
│               └── providers/
│                   └── profile_provider.dart
│
├── test/                                   # Test files
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── pubspec.yaml                            # Dependencies
├── analysis_options.yaml                   # Linter rules
└── README.md
```

### Naming Conventions

| Element Type | Convention | Example |
|--------------|-----------|---------|
| **Files (Public)** | `snake_case.dart` | `restaurant_card.dart` |
| **Files (Private)** | `_snake_case.dart` | `_private_helper.dart` |
| **Classes / Widgets** | `PascalCase` | `RestaurantCard` |
| **Variables / Functions** | `camelCase` | `getUserData()` |
| **Constants** | `lowerCamelCase` | `defaultPadding` |
| **Enums** | `PascalCase` | `OrderStatus` |
| **Enum Values** | `camelCase` | `OrderStatus.preparing` |
| **Test Files** | `*_test.dart` | `restaurant_card_test.dart` |
| **Screens** | `*_screen.dart` | `home_screen.dart` |
| **Widgets** | Descriptive name | `restaurant_card.dart` |
| **Providers** | `*_provider.dart` | `auth_provider.dart` |
| **Repositories (Abstract)** | `*_repository.dart` | `auth_repository.dart` |
| **Repositories (Impl)** | `*_repository_impl.dart` | `auth_repository_impl.dart` |
| **Data Sources** | `*_datasource.dart` | `auth_remote_datasource.dart` |
| **Models** | `*_model.dart` | `user_model.dart` |
| **Entities** | Noun | `user.dart`, `restaurant.dart` |

---

## Section 4: Clean Architecture Layers

### Layer 1: Domain (Business Logic)

**Purpose:** Contains pure business logic, independent of any framework or external dependency.

**Components:**
- **Entities:** Pure Dart classes representing business objects
- **Repositories (Abstract):** Interfaces defining data operations
- **Use Cases:** (Optional) Specific business logic operations

**Rules:**
- ✅ No Flutter dependencies
- ✅ No external library dependencies (except Dart core)
- ✅ Pure, testable Dart code
- ✅ Entities should be immutable (use Freezed or @immutable)

**Example Entity:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    required String cuisine,
    required double rating,
    required int deliveryTime,
    required String imageUrl,
    required bool isFavorite,
    int? tawseyaCount,
  }) = _Restaurant;
}
```

**Example Repository Interface:**
```dart
abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants(String location);
  Future<Restaurant> getRestaurantById(String id);
  Future<void> toggleFavorite(String restaurantId);
  Future<List<Restaurant>> searchRestaurants(String query);
}
```

### Layer 2: Data (Data Management)

**Purpose:** Implements data operations, handles data sources, and transforms data between formats.

**Components:**
- **Models:** Data transfer objects with JSON serialization
- **Data Sources:** Remote (API) and Local (Database) implementations
- **Repositories (Implementation):** Implements domain repository interfaces

**Rules:**
- ✅ Implements domain repository interfaces
- ✅ Handles data transformation (Model ↔ Entity)
- ✅ Manages caching and offline data
- ✅ Catches exceptions and converts to domain failures

**Example Model:**
```dart
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
    required String cuisine,
    required double rating,
    @JsonKey(name: 'delivery_time') required int deliveryTime,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'tawseya_count') int? tawseyaCount,
  }) = _RestaurantModel;
  
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
  
  // Convert to domain entity
  Restaurant toEntity() => Restaurant(
    id: id,
    name: name,
    cuisine: cuisine,
    rating: rating,
    deliveryTime: deliveryTime,
    imageUrl: imageUrl,
    isFavorite: isFavorite,
    tawseyaCount: tawseyaCount,
  );
}
```

**Example Data Source:**
```dart
import 'package:dio/dio.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> fetchRestaurants(String location);
  Future<RestaurantModel> fetchRestaurantById(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio dio;
  
  RestaurantRemoteDataSourceImpl(this.dio);
  
  @override
  Future<List<RestaurantModel>> fetchRestaurants(String location) async {
    try {
      final response = await dio.get('/restaurants', queryParameters: {
        'location': location,
      });
      
      final List<dynamic> data = response.data['restaurants'];
      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch restaurants');
    }
  }
  
  @override
  Future<RestaurantModel> fetchRestaurantById(String id) async {
    try {
      final response = await dio.get('/restaurants/$id');
      return RestaurantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch restaurant');
    }
  }
}
```

**Example Repository Implementation:**
```dart
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  
  RestaurantRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<List<Restaurant>> getRestaurants(String location) async {
    try {
      final models = await remoteDataSource.fetchRestaurants(location);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
  
  @override
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final model = await remoteDataSource.fetchRestaurantById(id);
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
  
  @override
  Future<void> toggleFavorite(String restaurantId) async {
    // Implementation for local storage toggle
    throw UnimplementedError();
  }
  
  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    throw UnimplementedError();
  }
}
```

### Layer 3: Presentation (UI)

**Purpose:** Displays data to user and handles user interactions.

**Components:**
- **Screens:** Full-page views
- **Widgets:** Reusable UI components
- **Providers:** Riverpod state management

**Rules:**
- ✅ No business logic (delegate to domain layer)
- ✅ No direct data source access (use repositories)
- ✅ Keep widgets small and focused
- ✅ Use Riverpod providers for state management

**Example Provider (Riverpod AsyncNotifier):**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';

part 'home_provider.g.dart';

@riverpod
class RestaurantList extends _$RestaurantList {
  @override
  Future<List<Restaurant>> build(String location) async {
    final repository = ref.read(restaurantRepositoryProvider);
    return repository.getRestaurants(location);
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(restaurantRepositoryProvider);
      return repository.getRestaurants('current_location');
    });
  }
}
```

**Example Screen:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantListProvider('Cairo'));
    
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: restaurantsAsync.when(
        data: (restaurants) => ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) => RestaurantCard(
            restaurant: restaurants[index],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

---

## Section 5: State Management with Riverpod

### When to Use What

| Scenario | Provider Type | Example |
|----------|--------------|---------|
| **Async data fetching** | `AsyncNotifierProvider` | Fetch restaurants from API |
| **Simple state** | `StateProvider` | Theme mode toggle |
| **Computed values** | `Provider` | Calculate cart total |
| **Mutable state** | `StateNotifierProvider` | Cart management |
| **Stream data** | `StreamProvider` | Real-time order updates |

### AsyncNotifier Pattern (Recommended for API calls)

```dart
@riverpod
class RestaurantDetail extends _$RestaurantDetail {
  @override
  Future<Restaurant> build(String restaurantId) async {
    final repository = ref.read(restaurantRepositoryProvider);
    return repository.getRestaurantById(restaurantId);
  }
  
  // Methods to update state
  Future<void> toggleFavorite() async {
    final restaurant = state.value;
    if (restaurant == null) return;
    
    // Optimistic update
    state = AsyncValue.data(
      restaurant.copyWith(isFavorite: !restaurant.isFavorite),
    );
    
    try {
      await ref.read(restaurantRepositoryProvider).toggleFavorite(restaurant.id);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(
        restaurant.copyWith(isFavorite: restaurant.isFavorite),
      );
    }
  }
}
```

### StateNotifier Pattern (For complex state)

```dart
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() => [];
  
  void addItem(MenuItem item) {
    final existingIndex = state.indexWhere((i) => i.menuItem.id == item.id);
    
    if (existingIndex >= 0) {
      // Update quantity
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(
          quantity: state[existingIndex].quantity + 1,
        ),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [...state, CartItem(menuItem: item, quantity: 1)];
    }
  }
  
  void removeItem(String itemId) {
    state = state.where((item) => item.menuItem.id != itemId).toList();
  }
  
  void clear() {
    state = [];
  }
}
```

### Provider Dependencies

```dart
// Repository provider
@riverpod
RestaurantRepository restaurantRepository(RestaurantRepositoryRef ref) {
  final dataSource = ref.read(restaurantRemoteDataSourceProvider);
  return RestaurantRepositoryImpl(dataSource);
}

// Data source provider
@riverpod
RestaurantRemoteDataSource restaurantRemoteDataSource(
  RestaurantRemoteDataSourceRef ref,
) {
  final dio = ref.read(dioClientProvider);
  return RestaurantRemoteDataSourceImpl(dio);
}

// Dio client provider
@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.otlob.com'));
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(LoggingInterceptor());
  return dio;
}
```

---

## Section 6: Error Handling

### Failure Types

```dart
abstract class Failure {
  final String message;
  final int? statusCode;
  
  const Failure(this.message, {this.statusCode});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
```

### Exception Types

```dart
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class NetworkException implements Exception {
  const NetworkException();
}
```

### Error Handling in Repository

```dart
@override
Future<Restaurant> getRestaurantById(String id) async {
  try {
    final model = await remoteDataSource.fetchRestaurantById(id);
    return model.toEntity();
  } on ServerException catch (e) {
    throw ServerFailure(e.message, statusCode: 500);
  } on NetworkException {
    throw const NetworkFailure();
  } catch (e) {
    throw ServerFailure('Unexpected error: $e');
  }
}
```

### Error Handling in UI

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));
  
  return restaurantAsync.when(
    data: (restaurant) => RestaurantDetailView(restaurant: restaurant),
    loading: () => const LoadingIndicator(),
    error: (error, stackTrace) {
      if (error is NetworkFailure) {
        return const ErrorView(
          message: 'No internet connection',
          icon: Icons.wifi_off,
        );
      } else if (error is ServerFailure) {
        return ErrorView(
          message: error.message,
          icon: Icons.error_outline,
        );
      }
      return ErrorView(
        message: 'Something went wrong',
        icon: Icons.error,
      );
    },
  );
}
```

---

## Section 7: API Integration with Dio

### Dio Client Setup

```dart
class DioClient {
  static Dio getInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(ErrorInterceptor());
    
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
    
    return dio;
  }
}
```

### Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPrefsHelper.getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### Error Interceptor

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired - navigate to login
      // ref.read(authProvider.notifier).logout();
    }
    handler.next(err);
  }
}
```

---

## Section 8: Routing with GoRouter

### Router Configuration

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.value?.isAuthenticated ?? false;
      final isOnAuthPage = state.matchedLocation.startsWith('/auth');
      
      // Redirect logged-in users away from auth pages
      if (isLoggedIn && isOnAuthPage) {
        return '/home';
      }
      
      // Redirect guests trying to access protected pages
      if (!isLoggedIn && state.matchedLocation.startsWith('/profile')) {
        return '/auth/login';
      }
      
      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'restaurant/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return RestaurantDetailScreen(restaurantId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
```

### Navigation Examples

```dart
// Navigate to route
context.go('/home');

// Navigate with path parameter
context.go('/home/restaurant/${restaurant.id}');

// Push (adds to stack)
context.push('/cart');

// Pop
context.pop();

// Replace current route
context.replace('/home');

// Navigate with query parameters
context.go('/search?query=pizza&cuisine=italian');
```

---

## Section 9: Styling & Theming

### Theme Setup

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: AppTextStyles.textTheme,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[100],
    ),
  );
}
```

### Color Palette

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF0D1B2A);      // Dark Navy
  static const Color secondary = Color(0xFFE07A5F);    // Terracotta
  static const Color accent = Color(0xFFF4D06F);       // Warm Gold
  
  // Text colors
  static const Color textPrimary = Color(0xFF1B263B);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);
  
  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  
  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
```

### Typography

```dart
class AppTextStyles {
  static const TextTheme textTheme = TextTheme(
    // Headings
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    
    // Body text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textLight,
    ),
    
    // Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );
}
```

### Spacing System

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### Using Theme in Widgets

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;
  
  return Text(
    'Otlob',
    style: textTheme.displayLarge?.copyWith(
      color: colorScheme.primary,
    ),
  );
}
```

---

## Section 10: Testing Strategy

### Testing Pyramid

```
          /\
         /  \  E2E Tests (5%)
        /    \
       /------\  Integration Tests (15%)
      /        \
     /----------\  Widget Tests (30%)
    /            \
   /--------------\ Unit Tests (50%)
```

### Unit Testing

**Test business logic, repositories, utilities:**

```dart
void main() {
  group('RestaurantRepositoryImpl', () {
    late RestaurantRepositoryImpl repository;
    late MockRestaurantRemoteDataSource mockDataSource;
    
    setUp(() {
      mockDataSource = MockRestaurantRemoteDataSource();
      repository = RestaurantRepositoryImpl(mockDataSource);
    });
    
    test('should return list of restaurants when API call is successful', () async {
      // Arrange
      final mockModels = [
        RestaurantModel(
          id: '1',
          name: 'Test Restaurant',
          cuisine: 'Egyptian',
          rating: 4.5,
          deliveryTime: 30,
          imageUrl: 'test.jpg',
        ),
      ];
      when(mockDataSource.fetchRestaurants(any))
          .thenAnswer((_) async => mockModels);
      
      // Act
      final result = await repository.getRestaurants('Cairo');
      
      // Assert
      expect(result, isA<List<Restaurant>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Restaurant');
      verify(mockDataSource.fetchRestaurants('Cairo')).called(1);
    });
    
    test('should throw ServerFailure when API call fails', () async {
      // Arrange
      when(mockDataSource.fetchRestaurants(any))
          .thenThrow(ServerException('Failed'));
      
      // Act & Assert
      expect(
        () => repository.getRestaurants('Cairo'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
```

### Widget Testing

**Test UI components:**

```dart
void main() {
  testWidgets('RestaurantCard displays restaurant information', (tester) async {
    // Arrange
    final restaurant = Restaurant(
      id: '1',
      name: 'Test Restaurant',
      cuisine: 'Egyptian',
      rating: 4.5,
      deliveryTime: 30,
      imageUrl: 'test.jpg',
      isFavorite: false,
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RestaurantCard(restaurant: restaurant),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Test Restaurant'), findsOneWidget);
    expect(find.text('Egyptian'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);
  });
  
  testWidgets('RestaurantCard favorite icon toggles on tap', (tester) async {
    // Test interaction
    final restaurant = Restaurant(
      id: '1',
      name: 'Test',
      cuisine: 'Egyptian',
      rating: 4.5,
      deliveryTime: 30,
      imageUrl: 'test.jpg',
      isFavorite: false,
    );
    
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: restaurant),
          ),
        ),
      ),
    );
    
    // Find favorite icon and tap
    final favoriteIcon = find.byIcon(Icons.favorite_border);
    expect(favoriteIcon, findsOneWidget);
    
    await tester.tap(favoriteIcon);
    await tester.pump();
    
    // Verify state changed (implementation depends on your favorite logic)
  });
}
```

### Integration Testing

**Test complete user flows:**

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete order flow - from browse to checkout', (tester) async {
    // Start app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    
    // Skip onboarding
    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();
    
    // Verify home screen loaded
    expect(find.text('Discover'), findsOneWidget);
    
    // Tap on a restaurant card
    await tester.tap(find.byType(RestaurantCard).first);
    await tester.pumpAndSettle();
    
    // Add item to cart
    await tester.tap(find.text('Add to Cart').first);
    await tester.pumpAndSettle();
    
    // Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();
    
    // Proceed to checkout
    await tester.tap(find.text('Proceed to Checkout'));
    await tester.pumpAndSettle();
    
    // Should show login prompt (guest blocker)
    expect(find.text('Sign In Required'), findsOneWidget);
  });
}
```

---

## Section 11: Developer Guidelines

### Critical Coding Rules

1. **State Management**
   - ✅ Use Riverpod AsyncNotifier for API calls
   - ✅ Use StateNotifier for complex mutable state
   - ✅ Keep state immutable (use Freezed or copyWith)
   - ❌ Never use setState in StatefulWidget for complex state

2. **Styling**
   - ✅ Always use `Theme.of(context)` for colors and text styles
   - ✅ Use defined spacing constants (AppSpacing)
   - ❌ Never hardcode colors or font sizes

3. **API Calls**
   - ✅ All API calls must go through Repository → DataSource
   - ✅ Handle errors and convert to domain Failures
   - ✅ Add loading states for async operations
   - ❌ Never call Dio directly from UI

4. **Widgets**
   - ✅ Prefer StatelessWidget and `const` constructors
   - ✅ Break down large widgets into smaller components
   - ✅ Extract reusable widgets to `core/widgets/`
   - ❌ Don't create widgets > 300 lines

5. **Testing**
   - ✅ All repositories must have unit tests
   - ✅ All reusable widgets must have widget tests
   - ✅ Critical flows must have integration tests
   - ❌ Don't skip testing for "simple" code

6. **Null Safety**
   - ✅ Use null-safe Dart code
   - ✅ Avoid `!` operator (use `?.` or `??`)
   - ✅ Handle null cases explicitly

7. **Code Quality**
   - ✅ Follow `analysis_options.yaml` lint rules
   - ✅ Document all public APIs with `///`
   - ✅ Use meaningful variable names
   - ❌ Don't leave TODO comments without tickets

### Pre-Commit Checklist

Before committing code:
- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all tests pass
- [ ] Format code with `dart format .`
- [ ] Check for unused imports
- [ ] Update documentation if needed
- [ ] No hardcoded values or API keys
- [ ] Added tests for new features

### Code Review Checklist

- [ ] Architecture: Follows Clean Architecture layers?
- [ ] State Management: Uses Riverpod correctly?
- [ ] Error Handling: Proper try-catch and error display?
- [ ] Testing: New tests added?
- [ ] Performance: No unnecessary rebuilds?
- [ ] Accessibility: Screen reader friendly?
- [ ] Security: No sensitive data exposed?

---

## Section 12: Performance Optimization

### Best Practices

1. **Image Optimization**
   - Use `cached_network_image` for network images
   - Provide placeholders and error widgets
   - Use appropriate image sizes (don't load 4K for thumbnail)

2. **List Performance**
   - Use `ListView.builder` for long lists
   - Implement pagination for infinite scrolls
   - Use `const` constructors where possible

3. **State Management**
   - Use `select` to listen to specific state changes
   - Avoid unnecessary provider rebuilds
   - Keep provider scope as narrow as possible

4. **Async Operations**
   - Use `debounce` for search inputs
   - Implement proper loading states
   - Cancel ongoing requests when widget disposes

### Example: Optimized List

```dart
ListView.builder(
  itemCount: restaurants.length,
  itemBuilder: (context, index) {
    final restaurant = restaurants[index];
    return RestaurantCard(
      key: ValueKey(restaurant.id), // Stable key
      restaurant: restaurant,
    );
  },
)
```

---

## Section 13: Conclusion

This architecture guide provides a solid foundation for building a scalable, maintainable Flutter application. Key takeaways:

✅ **Clean Architecture** separates concerns and makes testing easy  
✅ **Riverpod** provides type-safe, testable state management  
✅ **Repository Pattern** abstracts data sources for easy backend swapping  
✅ **GoRouter** handles navigation with deep linking support  
✅ **Material Design 3** with custom theme for consistent UI  
✅ **Comprehensive Testing** ensures code quality and reliability

By following these guidelines, the Otlob app will be robust, performant, and ready for production.

---

**Document Status:** Living Document (Updated as architecture evolves)  
**Last Updated:** October 4, 2025  
**Next Review:** As needed for major changes
