# Otlob Development Guidelines & Best Practices
**Version:** 3.0 (Consolidated from AI Rules + Agent Briefing)
**Date:** October 7, 2025
**Status:** Active Development Standard

---

## 🚨 CRITICAL SECURITY RULES

### Never Commit Sensitive Data
**Files that contain secrets MUST be in .gitignore:**
- ❌ `lib/firebase_options.dart` - Firebase API keys
- ❌ `android/app/google-services.json` - Google keys
- ❌ `ios/Runner/GoogleService-Info.plist` - iOS keys
- ❌ `firebase.json` - Project configs
- ❌ Any file with API keys or secrets

**Before ANY commit:**
```bash
git status
git diff --cached
git ls-files | grep -E "firebase_options|google-services"
# Should return NOTHING
```

**Immediate action if keys are exposed:**
1. Delete compromised keys in Google Cloud Console
2. Create new restricted keys
3. Rotate secrets in Firebase
4. Force push to rewrite history: `git push --force`

---

## 🏗️ ARCHITECTURE STANDARDS

### Clean Architecture Structure
```
lib/features/{feature}/
├── domain/          # Business logic - ZERO Flutter imports
│   ├── entities/    # Pure Dart entities (Freezed)
│   ├── repositories/# Abstract interfaces
│
├── data/           # Data management
│   ├── models/     # JSON serializable DTOs
│   ├── datasources/# Firebase/API implementations
│   ├── repositories/# Repository implementations
│
└── presentation/   # UI layer
    ├── screens/    # Full pages
    ├── widgets/    # Reusable components
    └── providers/  # Riverpod state management
```

### State Management with Riverpod
```dart
// ✅ Correct: Use AsyncNotifier for API calls
@riverpod
class RestaurantList extends _$RestaurantList {
  @override
  Future<List<Restaurant>> build() async {
    final repository = ref.read(restaurantRepositoryProvider);
    return repository.getRestaurants('location');
  }
}

// ✅ Correct: Use StateNotifier for complex state
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() => [];

  void addItem(CartItem item) {
    state = [...state, item];
  }
}
```

**❌ Never:**
- `setState` in complex widgets
- Global mutable state outside Riverpod
- Mix Riverpod with other state management

---

## 🔒 FIREBASE SECURITY

### API Key Restrictions (CRITICAL)
**Google Cloud Console - MUST do these:**

**Android Keys:**
```
Application restrictions: Android apps
Package: com.example.flutter_application_1
SHA-1: EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE
API restrictions: Firebase APIs only
```

**iOS Keys:**
```
Application restrictions: iOS apps
Bundle ID: com.example.flutterApplication1
API restrictions: Firebase APIs only
```

### Firestore Security Rules
**Production rules (NOT test mode!):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: Private to authenticated users
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Restaurants: Public read, admin write
    match /restaurants/{restaurantId} {
      allow read: if true;
      allow write: if request.auth != null &&
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // Orders: Private to order owner
    match /orders/{orderId} {
      allow read, write: if request.auth != null &&
                         resource.data.userId == request.auth.uid;
    }
  }
}
```

### Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profiles: Owner only
    match /users/{userId}/profile/{fileName} {
      allow read, write: if request.auth != null &&
                         request.auth.uid == userId &&
                         request.resource.size < 5 * 1024 * 1024;
    }

    // Restaurant images: Admin only
    match /restaurants/{restaurantId}/{fileName} {
      allow read, write: if request.auth != null &&
                         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

---

## 🛠️ DEVELOPMENT WORKFLOW

### Flutter Setup & Best Practices
**Always:**
- ✅ Use `.w` (width), `.h` (height), `.sp` (font size) for responsive design
- ✅ Initialize ScreenUtil: `await ScreenUtil.ensureScreenSize();`
- ✅ Test on multiple screen sizes

**Performance Rules:**
- ✅ `const` constructors everywhere possible
- ✅ `ListView.builder` for long lists
- ✅ `CachedNetworkImage` for images
- ✅ Debounce search inputs

### Error Handling Strategy
```dart
// Domain layer failures
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Repository error handling
@override
Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
  try {
    final model = await remoteDataSource.fetchRestaurant(id);
    return Right(model.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException {
    return Left(NetworkFailure());
  }
}

// UI error display
when(
  data: (restaurant) => RestaurantView(restaurant),
  loading: () => LoadingIndicator(),
  error: (error, _) => ErrorView(
    message: error is NetworkFailure
        ? 'No internet connection'
        : error.message,
  ),
)
```

### Testing Strategy
```dart
// Unit test example
@GenerateMocks([RestaurantRepository])
void main() {
  test('should return Restaurant list when API succeeds', () async {
    final mockRepo = MockRestaurantRepository();
    final useCase = GetRestaurants(mockRepo);

    when(mockRepo.getRestaurants('Cairo'))
        .thenAnswer((_) async => Right([restaurantEntity]));

    final result = await useCase('Cairo');
    expect(result, Right([restaurantEntity]));
  });
}

// Widget test example
testWidgets('RestaurantCard displays information', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: RestaurantCard(restaurant: mockRestaurant)),
      ),
    ),
  );

  expect(find.text('Test Restaurant'), findsOneWidget);
  expect(find.text('4.5 ⭐'), findsOneWidget);
});
```

---

## 📱 UI/UX STANDARDS

### Design System
```dart
class AppColors {
  static const primary = Color(0xFF0D1B2A);    // Dark Navy
  static const secondary = Color(0xFFE07A5F);  // Terracotta
  static const accent = Color(0xFFF4D06F);     // Warm Gold
  static const success = Color(0xFF10B981);    // Green
  static const error = Color(0xFFEF4444);      // Red
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
}
```

### Component Guidelines
- ✅ Prefer `StatelessWidget` with `ConsumerWidget` for state
- ✅ Extract reusable widgets to `core/widgets/`
- ✅ Use design system colors and spacing
- ✅ Implement accessibility (semantic labels, minimum touch targets)

### Animation Standards
- **Duration:** 200-300ms for micro-interactions
- **Curves:** `Curves.easeOut` for general, `Curves.elasticOut` for celebratory
- **Scaling:** 0.95 scale for button presses
- **Fade:** 150ms for transitions

---

## 🔄 GIT WORKFLOW

### Branch Strategy
```
main (protected)          # Always stable production code
├── develop               # Integration branch
│   ├── feature/auth      # New authentication features
│   ├── feature/tawseya   # Tawseya voting system
│   ├── fix/login-crash  # Bug fixes
│   └── refactor/cleanup  # Code refactoring
```

### Commit Message Format
```
<type>(<scope>): <description>

<body - optional>

<footer - optional>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Code formatting
- `refactor
