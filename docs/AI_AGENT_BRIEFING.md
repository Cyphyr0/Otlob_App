# 🤖 AI AGENT DEVELOPMENT BRIEFING
**Project:** Otlob - Egyptian Food Discovery App  
**Date:** October 4, 2025  
**Current Phase:** Authentication Complete → Backend Integration Next

---

## 📋 CRITICAL: READ THESE FILES FIRST

Before making ANY code changes, you MUST read and understand:

1. **`docs/brief.md`** - Full product vision, architecture, and requirements
2. **`docs/CURRENT_STATUS.md`** - Current implementation status and what's working
3. **This file** - Development plan and context
4. Run **`flutter analyze`** - Verify code compiles with no errors

---

## 🎯 PROJECT OVERVIEW

### What is Otlob?
Otlob is a **premium food discovery app** for Egypt that solves "choice paralysis" by providing:
- **Curated Discovery**: "Hidden Gems" and "Local Heroes" carousels
- **Tawseya System**: Monthly limited endorsements (not fake reviews)
- **Dual Rating System**: Separate ratings for food quality vs delivery
- **Guest Mode**: Browse without sign-in, authenticate at checkout

### Tech Stack
- **Flutter 3.35.0+** / Dart 3.9.2+
- **State Management**: Riverpod 2.6.1
- **Architecture**: Clean Architecture (Domain/Data/Presentation layers)
- **Local Storage**: Drift 2.28.2 (SQLite)
- **Backend**: Firebase (currently) → .NET/MySQL (future)
- **Navigation**: GoRouter with bottom navigation

### Key Differentiators
- NOT another generic food delivery app
- Focuses on **authentic local restaurants** over chains
- **Community-driven** recommendations (Tawseya system)
- **Trust & quality** over paid promotions

---

## 📊 CURRENT PROJECT STATE

### ✅ What's Working (100% Functional)

#### 1. App Foundation
- ✅ **Runs successfully** on Android emulator (Pixel 3a API 34)
- ✅ **Clean architecture** implemented with feature-first organization
- ✅ **No compilation errors** - `flutter analyze` passes
- ✅ **All dependencies** resolved and up-to-date
- ✅ **Git repository** synced with GitHub (Cyphyr0/Otlob_App)

#### 2. UI/UX Screens
- ✅ **Splash Screen** - Logo animation
- ✅ **Onboarding** - 4 swipeable intro screens
- ✅ **Home Screen** - Restaurant carousels (Hidden Gems, Local Heroes)
- ✅ **Restaurant Detail** - Menu display, add to cart
- ✅ **Cart Screen** - Item management, payment selection, checkout blocker
- ✅ **Favorites Screen** - Saved restaurants
- ✅ **Profile Screen** - Basic UI
- ✅ **Login Screen** - Phone OTP, Google, Facebook sign-in UI
- ✅ **Signup Screen** - User registration UI
- ✅ **Bottom Navigation** - Smooth transitions between main screens

#### 3. Features Implemented
- ✅ **Local Guest Mode** - Users can browse without authentication
- ✅ **Checkout Blocker** - Prompts guests to sign in at checkout
- ✅ **Cart Management** - Add/remove items, quantity control
- ✅ **Favorites** - Toggle favorite restaurants (local storage)
- ✅ **Navigation** - Deep linking ready with GoRouter
- ✅ **Theme System** - Light/dark mode support

#### 4. Authentication System
- ✅ **Guest Mode**: "Skip for now" button on login/signup → browse without auth
- ✅ **Phone OTP**: Mock implementation (sends hardcoded OTP: 123456)
- ✅ **Google Sign-in**: Stubbed (returns mock user)
- ✅ **Facebook Sign-in**: Stubbed (returns mock user)
- ❌ **Apple Sign-in**: Commented out (iOS only, not implemented)
- ❌ **Anonymous Sign-in**: Removed (not needed for guest mode)

#### 5. Data Management
- ✅ **Mock Restaurant Data** - Hardcoded in `home_provider.dart`
- ✅ **Local Cart Storage** - Riverpod state management
- ✅ **SharedPreferences** - User authentication state
- ❌ **Firebase Integration** - Not connected yet (see below)

### ⏳ What Needs Firebase (Not Working Yet)

1. **Real Authentication** - Currently returns mock users
2. **Restaurant Data** - Need Firestore queries instead of hardcoded data
3. **Order Placement** - No backend to receive orders
4. **User Profiles** - Can't save user data persistently
5. **Image Loading** - Need Firebase Storage for restaurant images
6. **Push Notifications** - Not configured

---

## 🏗️ CODEBASE ARCHITECTURE

### Clean Architecture Layers

```
lib/
├── main.dart                           # App entry, Firebase init, routing
├── firebase_options.dart               # Firebase configuration (exists)
│
├── core/                               # Shared across features
│   ├── config/
│   │   └── app_config.dart            # App-wide configuration
│   ├── errors/
│   │   └── failures.dart              # Error handling
│   ├── network/
│   │   └── connectivity_service.dart  # Network status
│   ├── providers/
│   │   └── connectivity_provider.dart # Riverpod providers
│   ├── routes/
│   │   └── app_router.dart            # GoRouter navigation config
│   ├── services/
│   │   └── database_service.dart      # Drift database service
│   ├── theme/
│   │   └── app_theme.dart             # Material theme configuration
│   ├── utils/
│   │   └── shared_prefs_helper.dart   # Persistent storage helper
│   └── widgets/                        # Reusable widgets
│
└── features/                           # Feature-first organization
    │
    ├── splash/
    │   └── presentation/
    │       ├── screens/splash_screen.dart
    │       └── providers/splash_provider.dart
    │
    ├── onboarding/
    │   └── presentation/
    │       ├── screens/onboarding_screen.dart
    │       └── widgets/onboarding_page.dart
    │
    ├── auth/                           # 🔥 AUTHENTICATION FEATURE
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart          # User entity (id, email, name, phone, isVerified, isAnonymous)
    │   │   └── repositories/
    │   │       └── auth_repository.dart # Abstract auth interface
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── firebase_auth_datasource.dart  # Firebase Auth implementation
    │   │   └── repositories/
    │   │       └── firebase_auth_repository.dart  # Repository implementation
    │   └── presentation/
    │       ├── screens/
    │       │   ├── login_screen.dart   # Phone OTP, Social sign-in, "Skip" button
    │       │   ├── signup_screen.dart  # User registration, "Skip" button
    │       │   └── phone_verification_screen.dart # OTP input
    │       ├── widgets/
    │       │   └── why_otlob_section.dart
    │       └── providers/
    │           └── auth_provider.dart   # Riverpod auth state management
    │
    ├── home/                           # 🏠 HOME FEATURE
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── restaurant.dart     # Restaurant entity
    │   │   │   └── menu_item.dart      # Menu item entity
    │   │   └── repositories/
    │   │       └── restaurant_repository.dart
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── restaurant_datasource.dart
    │   │   └── repositories/
    │   │       └── restaurant_repository_impl.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── home_screen.dart           # Main discover screen
    │       │   ├── restaurant_detail_screen.dart
    │       │   └── search_screen.dart
    │       ├── widgets/
    │       │   ├── restaurant_card.dart
    │       │   ├── hidden_gems_carousel.dart
    │       │   └── local_heroes_carousel.dart
    │       └── providers/
    │           └── home_provider.dart   # Currently returns MOCK data
    │
    ├── cart/                           # 🛒 CART FEATURE
    │   ├── domain/
    │   │   └── entities/
    │   │       └── cart_item.dart      # Freezed model
    │   └── presentation/
    │       ├── screens/
    │       │   └── cart_screen.dart    # ✅ Has checkout blocker for guests
    │       └── providers/
    │           └── cart_provider.dart   # Riverpod cart state
    │
    ├── favorites/                      # ⭐ FAVORITES FEATURE
    │   └── presentation/
    │       ├── screens/
    │       │   └── favorites_screen.dart
    │       └── providers/
    │           └── favorites_provider.dart
    │
    └── profile/                        # 👤 PROFILE FEATURE
        └── presentation/
            └── screens/
                └── profile_screen.dart  # Basic UI placeholder
```

### Key Files to Understand

#### 1. **`lib/main.dart`**
- App entry point
- Firebase initialization (currently commented out)
- GoRouter configuration
- Material app setup

#### 2. **`lib/features/auth/presentation/providers/auth_provider.dart`**
- Handles authentication state (AsyncNotifier<User?>)
- Methods: `sendOTP()`, `verifyOTP()`, `signInWithGoogle()`, `signInWithFacebook()`, `logout()`
- Apple & Anonymous sign-in methods are **commented out**

#### 3. **`lib/features/auth/data/datasources/firebase_auth_datasource.dart`**
- Firebase authentication implementation
- Currently returns **mock users** (no real Firebase calls yet)
- Apple & Anonymous methods are **commented out** in multi-line comments

#### 4. **`lib/features/home/presentation/providers/home_provider.dart`**
- Returns **hardcoded restaurant data**
- Methods: `getHiddenGems()`, `getLocalHeroes()`, `getRestaurantById()`
- ⚠️ **TODO**: Replace with Firestore queries

#### 5. **`lib/features/cart/presentation/screens/cart_screen.dart`**
- ✅ **Guest blocker implemented**: Lines 335-370
- Checks `SharedPrefsHelper.isAuthenticated()` before checkout
- Shows "Sign In Required" dialog for guests

#### 6. **`lib/core/utils/shared_prefs_helper.dart`**
- Manages local storage with SharedPreferences
- Methods: `isAuthenticated()`, `setAuthenticated()`, `getCart()`, `saveCart()`

#### 7. **`lib/core/routes/app_router.dart`**
- GoRouter configuration with all app routes
- Initial route: `/splash`
- Bottom nav routes: `/home`, `/favorites`, `/cart`, `/profile`
- Auth routes: `/login`, `/signup`, `/phone-verification`

---

## 🎯 WHAT WE WANT TO ACHIEVE

### Immediate Goals (This Week)

1. **Connect Firebase Authentication**
   - Enable Email/Password, Phone, Google Sign-in providers
   - Replace mock implementations with real Firebase Auth calls
   - Test sign-in flows on Android emulator

2. **Setup Firestore Database**
   - Create `restaurants` collection with sample data
   - Create `users` collection for user profiles
   - Create `orders` collection for order history
   - Define data structure and security rules

3. **Implement Real Data Fetching**
   - Replace hardcoded restaurant data with Firestore queries
   - Implement real-time updates for restaurant availability
   - Add error handling and loading states

### Short-term Goals (Next 2 Weeks)

4. **Order Placement System**
   - Create order submission flow
   - Save orders to Firestore
   - Send confirmation to user

5. **User Profile Management**
   - Save user data (addresses, phone, preferences)
   - Order history screen
   - Edit profile screen

6. **Image Management**
   - Upload restaurant images to Firebase Storage
   - Implement image loading with caching
   - Add placeholder images for missing data

7. **Tawseya (Endorsement) System**
   - Implement monthly voting mechanism
   - Track user's single Tawseya per month
   - Display Tawseya count on restaurant cards

### Medium-term Goals (Next Month)

8. **Search & Filtering**
   - Implement Algolia or Firestore search
   - Filter by cuisine, rating, distance
   - Sort by relevance, rating, distance

9. **Push Notifications**
   - Order status updates
   - Special offers from followed restaurants
   - Weekly "Hidden Gems" recommendations

10. **Analytics & Monitoring**
    - Firebase Analytics integration
    - Crashlytics for error tracking
    - Performance monitoring

---

## 🚀 RECOMMENDED DEVELOPMENT APPROACH

### Step 1: Understand the Codebase (DO THIS FIRST)

Before writing ANY code:

1. **Read the architecture**
   - Understand Domain/Data/Presentation layers
   - See how Riverpod providers connect to UI
   - Understand entity models (User, Restaurant, MenuItem, CartItem)

2. **Run the app**
   ```bash
   flutter devices
   flutter run -d emulator-5556
   ```
   - Browse as guest (click "Skip for now")
   - Try to checkout (see guest blocker)
   - Test navigation

3. **Study the mock data**
   - `lib/features/home/presentation/providers/home_provider.dart`
   - See restaurant structure, menu items format
   - This is what Firebase data should look like

4. **Trace authentication flow**
   - Login screen → Auth provider → Auth repository → Firebase datasource
   - See how mock OTP works (hardcoded 123456)
   - Understand how `SharedPrefsHelper` tracks auth state

### Step 2: Firebase Setup (CRITICAL)

**DO NOT skip this - app won't work without Firebase**

1. **Install Firebase CLI**
   ```powershell
   npm install -g firebase-tools
   ```

2. **Login and configure**
   ```powershell
   firebase login
   cd c:\Users\hisham\Desktop\Dev\Projects\Flutter_Otlob\flutter_application_1
   flutterfire configure
   ```
   - Select existing project: `otlob-6e081` (already created)
   - Platforms: Android, iOS, Web
   - This updates `firebase_options.dart`

3. **Update main.dart**
   - Uncomment Firebase initialization
   - Test app launches without errors

4. **Enable Firebase services**
   - Go to https://console.firebase.google.com/project/otlob-6e081
   - Enable Authentication → Email, Phone, Google
   - Create Firestore Database → Start in test mode
   - Enable Firebase Storage

**Full guide:** `docs/FIREBASE_SETUP_GUIDE.md` (exists)

### Step 3: Implement Real Authentication

Replace mock implementations with real Firebase:

**File:** `lib/features/auth/data/datasources/firebase_auth_datasource.dart`

Current (mock):
```dart
Future<User> signInWithGoogle() async {
  Logger().i('Google sign-in stubbed');
  await Future.delayed(const Duration(seconds: 1));
  return User(/* mock user */);
}
```

Replace with real:
```dart
Future<User> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) throw Exception('Google sign-in cancelled');
  
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  final userCredential = await _auth.signInWithCredential(credential);
  final firebaseUser = userCredential.user!;
  
  return User(
    id: firebaseUser.uid,
    email: firebaseUser.email!,
    name: firebaseUser.displayName ?? 'User',
    createdAt: DateTime.now(),
    isVerified: firebaseUser.emailVerified,
  );
}
```

**Do this for:**
- ✅ Phone OTP (replace mock OTP with real Firebase verification)
- ✅ Google Sign-in
- ✅ Facebook Sign-in

### Step 4: Replace Mock Restaurant Data

**File:** `lib/features/home/presentation/providers/home_provider.dart`

Current (hardcoded):
```dart
Future<List<Restaurant>> getHiddenGems() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    Restaurant(/* hardcoded data */),
    Restaurant(/* hardcoded data */),
  ];
}
```

Replace with Firestore:
```dart
Future<List<Restaurant>> getHiddenGems() async {
  final snapshot = await _firestore
    .collection('restaurants')
    .where('isHiddenGem', isEqualTo: true)
    .orderBy('tawseyaCount', descending: true)
    .limit(10)
    .get();
    
  return snapshot.docs
    .map((doc) => Restaurant.fromFirestore(doc))
    .toList();
}
```

### Step 5: Implement Order Placement

**File:** Create `lib/features/cart/data/repositories/order_repository.dart`

```dart
Future<String> placeOrder({
  required String userId,
  required List<CartItem> items,
  required String restaurantId,
  required String paymentMethod,
  required String deliveryAddress,
}) async {
  final order = {
    'userId': userId,
    'restaurantId': restaurantId,
    'items': items.map((item) => item.toJson()).toList(),
    'paymentMethod': paymentMethod,
    'deliveryAddress': deliveryAddress,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
    'total': items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
  };
  
  final docRef = await _firestore.collection('orders').add(order);
  return docRef.id;
}
```

---

## ⚠️ CRITICAL DEVELOPMENT RULES

### 1. Never Break Existing Functionality
- **Always run `flutter analyze`** before committing
- **Test on emulator** after every change
- **Keep git commits small** and focused
- **Don't remove working code** unless you're sure it's obsolete

### 2. Follow Clean Architecture
- **Domain layer** = Pure Dart entities, no Flutter imports
- **Data layer** = Repository implementations, Firebase calls
- **Presentation layer** = Widgets, screens, Riverpod providers
- **Never call Firebase directly from UI** - always use repositories

### 3. Maintain Code Quality
- **Use meaningful variable names**
- **Add comments for complex logic**
- **Handle errors gracefully** with try-catch
- **Show user-friendly error messages**
- **Add loading states** for async operations

### 4. Preserve Guest Mode
- **Don't break the "Skip for now" button**
- **Keep checkout blocker** in cart screen
- **Local storage must work** without authentication
- **Cart persists** across app restarts

### 5. Test Everything
- **Manual testing** on Android emulator
- **Test both guest and authenticated flows**
- **Test offline functionality**
- **Test edge cases** (empty states, errors)

---

## 📝 DEVELOPMENT WORKFLOW

### Making Changes

1. **Create feature branch**
   ```bash
   git checkout -b feature/firebase-auth
   ```

2. **Make incremental changes**
   - Change ONE thing at a time
   - Test after each change
   - Commit frequently

3. **Run quality checks**
   ```bash
   flutter analyze
   flutter test  # When tests exist
   ```

4. **Test on emulator**
   ```bash
   flutter run -d emulator-5556
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: Implement real Firebase Google sign-in"
   git push origin feature/firebase-auth
   ```

### Commit Message Format

Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `refactor:` Code restructuring
- `docs:` Documentation changes
- `style:` Formatting, no code change
- `test:` Adding tests
- `chore:` Maintenance

Examples:
```
feat: Implement Firebase Google authentication
fix: Resolve cart checkout blocker dialog
refactor: Extract restaurant card widget
docs: Update AI agent briefing with current status
```

---

## 🐛 KNOWN ISSUES & GOTCHAS

### 1. Firebase Not Initialized
**Error:** `[core/no-app] No Firebase App '[DEFAULT]' has been created`
**Fix:** Uncomment Firebase initialization in `main.dart`

### 2. Missing Images
**Error:** `Unable to load asset: assets/images/mamas_kitchen.jpg`
**Temporary Fix:** Use placeholder icons
**Permanent Fix:** Upload images to Firebase Storage

### 3. Google Sign-in Package
**Issue:** Needs additional setup for Android
**Fix:** Update `android/app/build.gradle` with correct SHA-1 fingerprint
**Current SHA-1:** `7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB`
**Already added to Firebase Console** ✅

### 4. Phone Authentication
**Issue:** Requires reCAPTCHA verification on web, SMS on mobile
**Fix:** Enable Phone auth in Firebase Console
**Temp Support Email:** `ahmedelasmy97@gmail.com`

### 5. Drift Database
**Status:** Configured but not actively used yet
**Future:** Use for offline caching of restaurants/orders

---

## 🎓 LEARNING RESOURCES

### Essential Reading
1. **Firebase Flutter Docs**: https://firebase.flutter.dev
2. **Riverpod Documentation**: https://riverpod.dev
3. **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
4. **Flutter Architecture**: https://docs.flutter.dev/development/data-and-backend/state-mgmt

### Code Examples
1. **Firebase Auth**: `firebase_auth` package examples
2. **Firestore Queries**: Official Firebase samples
3. **Riverpod Patterns**: riverpod.dev examples

---

## 📞 GETTING UNSTUCK

### If You're Stuck:
1. **Check the error message** - Read it carefully
2. **Run `flutter clean && flutter pub get`** - Fixes 80% of issues
3. **Search the error** - Usually someone had it before
4. **Read this file again** - Make sure you understand the context
5. **Check git history** - See what changed recently

### Useful Commands
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d emulator-5556

# See all devices
flutter devices

# Check for errors
flutter analyze

# View logs
flutter logs

# Update packages
flutter pub upgrade --major-versions
```

---

## ✅ TASK CHECKLIST

### Phase 1: Firebase Setup (Week 1)
- [ ] Install Firebase CLI globally
- [ ] Run `flutterfire configure` for project
- [ ] Uncomment Firebase init in main.dart
- [ ] Verify app launches without errors
- [ ] Enable Auth providers in Console
- [ ] Create Firestore database
- [ ] Test basic read/write to Firestore

### Phase 2: Authentication (Week 1-2)
- [ ] Implement real Phone OTP verification
- [ ] Implement real Google Sign-in
- [ ] Implement real Facebook Sign-in
- [ ] Test guest mode still works
- [ ] Test checkout blocker works
- [ ] Add loading states to auth screens
- [ ] Handle authentication errors gracefully

### Phase 3: Real Data (Week 2)
- [ ] Design Firestore data structure
- [ ] Add sample restaurant data to Firestore
- [ ] Replace mock data in home_provider
- [ ] Implement real-time updates
- [ ] Add loading shimmer effects
- [ ] Handle empty states
- [ ] Add error retry mechanisms

### Phase 4: Orders (Week 2-3)
- [ ] Create order repository
- [ ] Implement order placement
- [ ] Add order confirmation screen
- [ ] Send email/SMS receipts
- [ ] Add order history to profile
- [ ] Implement order tracking

### Phase 5: Polish (Week 3-4)
- [ ] Upload restaurant images to Storage
- [ ] Implement image caching
- [ ] Add search functionality
- [ ] Implement Tawseya voting
- [ ] Add push notifications
- [ ] Performance optimization
- [ ] Comprehensive testing

---

## 🎯 SUCCESS CRITERIA

You'll know you're on track when:

✅ **Code Quality**
- `flutter analyze` returns no errors
- No runtime crashes
- Smooth 60fps UI performance

✅ **Features Working**
- Users can sign in with Google/Phone
- Guest mode browsing works
- Checkout requires authentication
- Restaurant data loads from Firestore
- Orders successfully submitted

✅ **User Experience**
- Loading states shown during async operations
- Errors displayed with helpful messages
- Images load quickly with placeholders
- Navigation feels smooth

✅ **Documentation**
- Code has meaningful comments
- README updated with setup steps
- Commit messages follow conventions
- This briefing stays current

---

## 🚀 LET'S BUILD THIS!

Remember:
- **Start small** - Get one thing working at a time
- **Test constantly** - Don't wait until everything is "done"
- **Ask questions** - Better to clarify than guess
- **Read the code** - Understand before you change
- **Follow patterns** - Match existing code style
- **Stay organized** - Clean commits, clear messages

**The foundation is solid. Now let's bring it to life with real data!**

Good luck, and happy coding! 🎉
