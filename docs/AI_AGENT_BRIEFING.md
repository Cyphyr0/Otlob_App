# 🤖 AI AGENT DEVELOPMENT BRIEFING
**Project:** Otlob - Egypti5. **`docs/UI_UX_SPECIFICATION.md`** ⭐ COMPLETE DESIGN GUIDE
   - User flows with diagrams
   - Wireframes for all key screens
   - Design system (colors, typography, spacing)
   - Component library
   - Accessibility requirements (WCAG 2.1 AA)
   - Animation patterns
   - Performance optimization

### Phase 3: Understand Current Status (Read Third)
6. **`docs/CURRENT_STATUS.md`** - What's implemented vs what's pendingcovery App  
**Date:** October 4, 2025  
**Current Phase:** 🎨 **UI/UX COMPLETE REDESIGN REQUIRED** 🎨  
**Your Role:** Lead Designer & Developer

---

## 🚨 CRITICAL NOTICE: UI/UX REDESIGN PRIORITY

**THE CURRENT UI IS TERRIBLE AND NEEDS TO BE REBUILT FROM SCRATCH.**

You are now the **Lead Designer** for this project. Your first priority is to create a **beautiful, modern, techy, and simple-to-use** interface. Before ANY new features, we need to fix the visual design and user experience.

**READ THIS FIRST:** `docs/UI_UX_REDESIGN_BRIEF.md` - Your complete design guide

---

## 📋 CRITICAL: READ THESE FILES FIRST

Before making ANY code changes, you MUST read and understand these documents IN ORDER:

### Phase 1: Understand the Product (Read First)

**0. `docs/UI_UX_REDESIGN_BRIEF.md`** ⭐⭐⭐ **START HERE - UI/UX REDESIGN GUIDE**
   - Complete visual design system (colors, typography, spacing)
   - Screen-by-screen redesign guidelines
   - Animation and interaction patterns
   - Component library specifications
   - Accessibility requirements
   - **THIS IS YOUR PRIMARY DESIGN REFERENCE**

1. **`docs/PRODUCT_REQUIREMENTS.md`** ⭐ COMPREHENSIVE PRD
   - Complete functional requirements (FR1-FR16)
   - Non-functional requirements (performance, security, accessibility)
   - Epic & story breakdown with current status
   - User persona ("Sara, the Urban Explorer")
   - Success criteria and KPIs

2. **`docs/brief.md`** - High-level product vision
   - Problem statement and solution approach
   - Target users and business goals
   - MVP scope and post-MVP roadmap

### Phase 2: Understand the Technical Implementation (Read Second)
3. **`docs/FRONTEND_ARCHITECTURE.md`** ⭐ COMPLETE TECHNICAL GUIDE
   - Clean Architecture layers explained
   - State management patterns (Riverpod)
   - Repository pattern for backend abstraction
   - API integration with Dio
   - Error handling strategy
   - Testing strategy (unit, widget, integration)
   - Developer coding rules and standards

4. **`docs/ADVANCED_ARCHITECTURE_PATTERNS.md`** ⭐ ADVANCED PATTERNS
   - Detailed Clean Architecture implementation examples
   - Riverpod state management patterns (7+ patterns)
   - Error handling with Either/Failure types
   - API client architecture with interceptors
   - Testing strategies with examples
   - Component development standards
   - Performance optimization techniques

5. **`docs/UI_UX_SPECIFICATION.md`** ⭐ COMPLETE DESIGN GUIDE
   - User flows with diagrams
   - Wireframes for all key screens
   - Design system (colors, typography, spacing)
   - Component library
   - Accessibility requirements (WCAG 2.1 AA)
   - Animation patterns
   - Performance optimization

### Phase 3: Understand Current Status (Read Third)
6. **`docs/CURRENT_STATUS.md`** - What's implemented vs what's pending
   - Current feature implementation status
   - Known issues and workarounds

7. **This file (AI_AGENT_BRIEFING.md)** - Development context
   - Step-by-step Firebase setup guide
   - Code examples for replacing mocks
   - Critical development rules
   - Task checklists

### Phase 4: Validate Everything (Do Before Coding)
8. Run **`flutter analyze`** - Verify code compiles with no errors
9. Review **`docs/SECURITY_IMPLEMENTATION.md`** - Security guidelines

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

## � COMPREHENSIVE DOCUMENTATION GUIDE

We have created **three comprehensive documents** that contain ALL the information from the previous Otlob project version, updated for our current implementation. These are your **primary reference materials**:

### 1. PRODUCT_REQUIREMENTS.md (Your Product Bible)

**What it contains:**
- **Complete Functional Requirements (FR1-FR16)**: Every feature specified with current implementation status
- **User Flows**: Detailed flows for order placement, favoriting, reordering, etc.
- **Non-Functional Requirements**: Performance targets, security requirements, accessibility standards
- **Epic & Story Breakdown**: All features organized into epics with completion status
- **Success Metrics**: KPIs and how we measure success

**When to use it:**
- ✅ Before implementing ANY new feature (check requirements first)
- ✅ When clarifying "what should this feature do?"
- ✅ When prioritizing tasks (see epic status)
- ✅ When writing user stories or tasks

**Key sections for developers:**
- Section 2: Functional Requirements (FR1-FR16) - Read for each feature you build
- Section 7: Epic & Story Breakdown - See what's complete vs pending
- Section 8: Success Criteria - Understand definition of done

---

### 2. FRONTEND_ARCHITECTURE.md (Your Technical Bible)

**What it contains:**
- **Complete Clean Architecture Guide**: Domain/Data/Presentation layers with examples
- **State Management Patterns**: When to use AsyncNotifier vs StateNotifier vs Provider
- **Repository Pattern**: How to abstract data sources for easy backend swapping
- **Error Handling**: Failure types, exception handling, UI error display
- **API Integration**: Dio setup, interceptors, request/response handling
- **Testing Strategy**: Unit, widget, integration test examples
- **Coding Standards**: Critical rules, pre-commit checklist, code review checklist

**When to use it:**
- ✅ Before creating ANY new feature (follow architecture patterns)
- ✅ When confused about "where should this code go?"
- ✅ When writing tests (see testing examples)
- ✅ When integrating APIs (see Dio setup and error handling)
- ✅ During code reviews (check against standards)

**Key sections for developers:**
- Section 4: Clean Architecture Layers - READ FIRST, understand entity vs model
- Section 5: State Management with Riverpod - Copy these patterns
- Section 6: Error Handling - Use these failure types
- Section 7: API Integration with Dio - Copy this setup
- Section 9: Testing Strategy - Use these templates
- Section 11: Developer Guidelines - Critical coding rules

---

### 3. UI_UX_SPECIFICATION.md (Your Design Bible)

**What it contains:**
- **Complete User Flows**: Mermaid diagrams for every user journey
- **Wireframes**: Layout for every key screen (Home, Restaurant Detail, Cart, etc.)
- **Design System**: Colors, typography, spacing, border radius, elevation
- **Component Library**: Restaurant Card, Buttons, Bottom Nav, AppBar specs
- **Accessibility**: WCAG 2.1 AA requirements, touch targets, screen reader support
- **Animation Guidelines**: Duration, curves, patterns for all interactions
- **Performance Goals**: 60fps, < 3s startup, < 2s screen load

**When to use it:**
- ✅ Before building ANY UI component (check design system first)
- ✅ When implementing animations (see animation patterns)
- ✅ When styling (use defined colors, typography, spacing)
- ✅ When implementing accessibility (check requirements)
- ✅ When optimizing performance (see goals and strategies)

**Key sections for developers:**
- Section 3: User Flows - Understand complete user journeys
- Section 4: Wireframes - See expected layouts
- Section 6: Visual Design System - Use these exact values
- Section 7: Accessibility - Meet these requirements
- Section 9: Animation & Micro-interactions - Copy these patterns
- Section 10: Performance Considerations - Follow these practices

---

### How These Documents Work Together

**Example: Implementing "Add to Favorites" Feature**

1. **Start with PRODUCT_REQUIREMENTS.md**
   - Read FR11: Favorites System requirements
   - Understand acceptance criteria
   - Check current implementation status

2. **Follow FRONTEND_ARCHITECTURE.md**
   - See Section 4: Domain layer - Create `Favorite` entity
   - See Section 5: State Management - Use StateNotifier pattern
   - See Section 6: Error Handling - Handle network failures
   - See Section 9: Testing - Write unit tests for repository

3. **Implement UI with UI_UX_SPECIFICATION.md**
   - See Section 3: Flow 3 (Favoriting & Tawseya) - Follow this flow
   - See Section 6: Component Library - Use defined heart icon
   - See Section 9: Animation - Use favorite toggle animation (300ms, elasticOut)
   - See Section 7: Accessibility - Add semantic labels

4. **Validate with AI_AGENT_BRIEFING.md (this file)**
   - Check critical development rules
   - Run flutter analyze
   - Test on emulator
   - Commit with clear message

---

### Document Update Policy

These documents are **living documents** - they should be updated when:
- ✅ New features are added (update PRODUCT_REQUIREMENTS.md)
- ✅ Architecture patterns change (update FRONTEND_ARCHITECTURE.md)
- ✅ Design system evolves (update UI_UX_SPECIFICATION.md)
- ✅ Implementation status changes (update AI_AGENT_BRIEFING.md)

**Version control:**
- All updates should be committed to Git
- Add entry to Change Log in each document
- Update "Last Updated" date

---

## �🚀 RECOMMENDED DEVELOPMENT APPROACH

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

## 📖 QUICK REFERENCE: WHERE TO FIND WHAT

When you need specific information, here's where to look:

### Feature Requirements & Specifications
| What You Need | Document | Section |
|--------------|----------|---------|
| "What should this feature do?" | `PRODUCT_REQUIREMENTS.md` | Section 2: Functional Requirements |
| "What's the user flow?" | `UI_UX_SPECIFICATION.md` | Section 3: User Flows |
| "Is this feature complete?" | `PRODUCT_REQUIREMENTS.md` | Section 7: Epic & Story Breakdown |
| "What's the acceptance criteria?" | `PRODUCT_REQUIREMENTS.md` | Functional Requirements (FR1-FR16) |
| "What's the MVP scope?" | `PRODUCT_REQUIREMENTS.md` | Section 6: MVP Scope |

### Technical Implementation
| What You Need | Document | Section |
|--------------|----------|---------|
| "Where should this code go?" | `FRONTEND_ARCHITECTURE.md` | Section 4: Clean Architecture Layers |
| "How do I manage state?" | `FRONTEND_ARCHITECTURE.md` | Section 5: State Management |
| "How do I call the API?" | `FRONTEND_ARCHITECTURE.md` | Section 7: API Integration |
| "How do I handle errors?" | `FRONTEND_ARCHITECTURE.md` | Section 6: Error Handling |
| "How do I write tests?" | `FRONTEND_ARCHITECTURE.md` | Section 10: Testing Strategy |
| "What are the coding rules?" | `FRONTEND_ARCHITECTURE.md` | Section 11: Developer Guidelines |

### UI/UX Implementation
| What You Need | Document | Section |
|--------------|----------|---------|
| "What colors/fonts to use?" | `UI_UX_SPECIFICATION.md` | Section 6: Visual Design System |
| "How should this screen look?" | `UI_UX_SPECIFICATION.md` | Section 4: Wireframes |
| "What animation to use?" | `UI_UX_SPECIFICATION.md` | Section 9: Animation Guidelines |
| "How do I make it accessible?" | `UI_UX_SPECIFICATION.md` | Section 7: Accessibility Requirements |
| "What are the spacing rules?" | `UI_UX_SPECIFICATION.md` | Section 6: Spacing System |
| "How do I optimize performance?" | `UI_UX_SPECIFICATION.md` | Section 10: Performance Considerations |

### Current Status & Setup
| What You Need | Document | Section |
|--------------|----------|---------|
| "What's already implemented?" | `CURRENT_STATUS.md` | Current Implementation Status |
| "How do I setup Firebase?" | `AI_AGENT_BRIEFING.md` | Step 2: Firebase Setup |
| "What are the critical rules?" | `AI_AGENT_BRIEFING.md` | Critical Development Rules |
| "What's the development workflow?" | `AI_AGENT_BRIEFING.md` | Development Workflow |
| "What are known issues?" | `AI_AGENT_BRIEFING.md` | Known Issues & Gotchas |

### Example Workflows

**"I need to implement the Tawseya feature"**
1. Read `PRODUCT_REQUIREMENTS.md` → FR13: 'Tawseya' Recommendation System
2. Read `UI_UX_SPECIFICATION.md` → Section 3: Flow 3 (Favoriting & Tawseya)
3. Read `FRONTEND_ARCHITECTURE.md` → Section 5: State Management (for vote tracking)
4. Read `UI_UX_SPECIFICATION.md` → Section 9: Animation (for celebratory animation)
5. Implement following Clean Architecture pattern
6. Test and commit

**"I need to style a button"**
1. Read `UI_UX_SPECIFICATION.md` → Section 6: Visual Design System
2. Use `AppColors.secondary` for primary buttons
3. Use `AppSpacing.md` for padding
4. Use `medium` border radius (8dp)
5. Add press animation (100ms scale down to 0.95)

**"I need to handle an API error"**
1. Read `FRONTEND_ARCHITECTURE.md` → Section 6: Error Handling
2. Use `ServerFailure` for API errors
3. Catch exceptions in repository
4. Display error with `ErrorView` widget from core/widgets
5. Show user-friendly message, not raw error

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
