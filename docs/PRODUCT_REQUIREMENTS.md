# Otlob Product Requirements Document (PRD)
**Version:** 2.0 (Updated for Current Implementation)  
**Date:** October 4, 2025  
**Status:** Active Development

---

## Section 1: Goals and Background Context

### Goals
- **Primary Goal:** Deliver a feature-complete, polished "Version 1.0" of the Otlob app that meets all university graduation project requirements
- **User Problem:** Solve "choice paralysis" and "erosion of trust" faced by users of existing food delivery platforms
- **Business Impact:** Champion local, authentic Egyptian restaurants and help them gain visibility
- **UX Goal:** Create a delightful, premium, and trustworthy user experience that makes discovering food exciting and frictionless

### Background Context
The current food delivery market in Egypt presents a dual-sided problem:

**User Pain Points:**
- Overwhelmed with inauthentic choices and untrustworthy reviews
- Dominated by international chains, hard to find local gems
- Fake reviews and paid promotions erode trust

**Restaurant Pain Points:**
- High-quality local restaurants are lost in the noise
- Unfair rating systems (delivery problems hurt food ratings)
- Need for a level playing field vs. big advertising budgets

**Otlob's Solution:**
- Trusted, community-driven ecosystem
- 'Tawseya' recommendation system (1 vote per user per month)
- Dual-rating model (food quality vs. delivery experience)
- Curated discovery (not advertising-driven)

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| Sep 26, 2025 | 1.0 | Initial PRD draft | Product Team |
| Oct 4, 2025 | 2.0 | Updated for current Flutter implementation | AI Agent |

---

## Section 2: Functional Requirements

### Core User Journey (Must-Have for V1.0)

#### FR1: Authentication & Onboarding
- **FR1.1:** Users must be able to sign up using email/password
- **FR1.2:** Users must be able to log in using phone number + OTP
- **FR1.3:** Users must be able to sign in via Google OAuth
- **FR1.4:** Users must be able to sign in via Facebook OAuth
- **FR1.5:** Users must be able to browse as guests with a "Skip for now" option
- **FR1.6:** System must display onboarding screens on first launch
- **Status:** ✅ UI Complete, ⏸️ Backend Mock

#### FR2: Location Services
- **FR2.1:** System must detect user's location via GPS
- **FR2.2:** Users must be able to manually enter and save addresses
- **FR2.3:** Users must be able to manage multiple saved addresses
- **Status:** ⏸️ Not Implemented

#### FR3: Discovery Features
- **FR3.1:** Home screen must display curated carousels ("Hidden Gems", "Local Heroes")
- **FR3.2:** Users must be able to search for restaurants by name
- **FR3.3:** Users must be able to search for dishes by name
- **FR3.4:** Users must be able to filter by cuisine type, rating, delivery time
- **FR3.5:** "Surprise Me!" button must provide a single random restaurant recommendation
- **Status:** ✅ UI Complete (Carousels), ⏸️ Real Data Needed

#### FR4: Restaurant Information
- **FR4.1:** Restaurant profile page must display essential info (name, rating, cuisine, delivery time, location)
- **FR4.2:** Restaurant profile must display full menu with categories
- **FR4.3:** Restaurant profile must display user reviews with dual ratings
- **FR4.4:** Users must be able to favorite a restaurant
- **Status:** ✅ UI Complete, ⏸️ Real Data Needed

#### FR5: Menu Interaction
- **FR5.1:** Users must be able to browse menu items by category
- **FR5.2:** Users must be able to view detailed item information (name, description, price, image, ingredients)
- **FR5.3:** Users must be able to add items to cart with quantity selection
- **FR5.4:** Users must be able to add special text instructions per item
- **Status:** ✅ Basic Implementation, ⏸️ Customization Options Needed

#### FR6: Shopping Cart
- **FR6.1:** Users must be able to view all items in cart
- **FR6.2:** Users must be able to modify item quantities in cart
- **FR6.3:** Users must be able to remove items from cart
- **FR6.4:** System must display price breakdown (subtotal, delivery fee, service fee, total)
- **FR6.5:** Cart must persist across app sessions
- **Status:** ✅ Implemented (Riverpod State)

#### FR7: Checkout Process
- **FR7.1:** System must require authentication before checkout (guests must sign in)
- **FR7.2:** Users must confirm delivery address
- **FR7.3:** Users must select payment method (Cash on Delivery or Digital Payment)
- **FR7.4:** Users must be able to add delivery instructions
- **FR7.5:** System must display final order summary before confirmation
- **Status:** ✅ Checkout Blocker Implemented, ⏸️ Payment Integration Needed

#### FR8: Order Tracking
- **FR8.1:** System must display live order status (Placed, Accepted, Preparing, Out for Delivery, Delivered)
- **FR8.2:** System must send push notifications for status changes
- **FR8.3:** Users must be able to view estimated delivery time
- **FR8.4:** Users must be able to contact restaurant or driver
- **Status:** ⏸️ Not Implemented

#### FR9: Order History
- **FR9.1:** Users must be able to view all past orders
- **FR9.2:** Order history must display date, restaurant, items, total price, status
- **FR9.3:** Users must be able to view detailed order information
- **FR9.4:** Users must be able to reorder past meals with one tap
- **Status:** ⏸️ Not Implemented

#### FR10: User Profile Management
- **FR10.1:** Users must be able to view and edit profile information (name, email, phone)
- **FR10.2:** Users must be able to manage saved addresses
- **FR10.3:** Users must be able to view favorites list
- **FR10.4:** Users must be able to change password
- **FR10.5:** Users must be able to log out
- **Status:** ✅ Basic UI, ⏸️ Full Implementation Needed

### Engagement & Retention Features

#### FR11: Favorites System
- **FR11.1:** Users must be able to add restaurants to favorites
- **FR11.2:** Users must be able to add dishes to favorites
- **FR11.3:** Favorites must persist across sessions
- **FR11.4:** Favorites screen must display all saved items
- **Status:** ✅ Implemented (Local Storage)

#### FR12: Dual-Rating System
- **FR12.1:** Users must rate food quality separately (1-5 stars)
- **FR12.2:** Users must rate delivery experience separately (1-5 stars)
- **FR12.3:** Restaurant profile must display separate averages for food and delivery
- **FR12.4:** System must calculate weighted overall rating
- **Status:** ⏸️ Not Implemented

#### FR13: 'Tawseya' Recommendation System
- **FR13.1:** Each user must have ONE 'Tawseya' vote per month
- **FR13.2:** Users can award their Tawseya to any restaurant
- **FR13.3:** System must display Tawseya count prominently on restaurant profiles
- **FR13.4:** System must reset Tawseya votes monthly
- **FR13.5:** System must prevent multiple votes to same restaurant in one month
- **Status:** ⏸️ Not Implemented (High Priority - Core Differentiator)

### Premium Features ("Wow Factors")

#### FR14: Shareable Items
- **FR14.1:** Users must be able to share a deep link to a specific dish
- **FR14.2:** Deep link must open app directly to that dish detail
- **FR14.3:** If app not installed, deep link must open web preview
- **Status:** ⏸️ Not Implemented

#### FR15: Digital Receipts
- **FR15.1:** System must generate styled, professional digital receipt upon order confirmation
- **FR15.2:** Receipt must display all order details, itemized pricing, restaurant info, order ID
- **FR15.3:** Users must be able to download receipt as PDF
- **FR15.4:** Users must be able to download receipt as image (PNG/JPG)
- **FR15.5:** Receipt must be accessible from order history
- **Status:** ⏸️ Not Implemented

#### FR16: Push Notifications
- **FR16.1:** System must send notification when order is accepted
- **FR16.2:** System must send notification when order is out for delivery
- **FR16.3:** System must send notification when order is delivered
- **FR16.4:** System must send notification for promotional offers (opt-in)
- **Status:** ⏸️ Not Implemented

---

## Section 3: Non-Functional Requirements

### NFR1: Performance
- **Target:** 60fps UI animations and transitions
- **App Startup:** < 3 seconds on mid-range devices
- **Screen Load Time:** < 2 seconds on 4G connection
- **Interaction Response:** < 100ms for all UI interactions
- **Current Status:** ✅ Meeting targets on Android emulator

### NFR2: Usability
- **Onboarding:** First-time user should complete onboarding and discover restaurants in < 2 minutes
- **Order Placement:** Returning user should place order in < 60 seconds
- **Navigation:** All screens accessible within 3 taps from home
- **Current Status:** ✅ Navigation implemented, ⏸️ Full flow testing pending

### NFR3: Visual Design
- **Brand Identity:** Premium, trustworthy, modern Egyptian aesthetic
- **UI Quality:** Visually rich, clean, appetizing presentation
- **Consistency:** Follow Material Design 3 guidelines with custom theme
- **Accessibility:** WCAG 2.1 AA compliance (color contrast, text scaling, screen readers)
- **Current Status:** ✅ Theme system implemented, ⏸️ Accessibility testing needed

### NFR4: Reliability
- **Crash-Free Rate:** > 99.5% of user sessions
- **Offline Capability:** App must function for browsing without network
- **Data Persistence:** Cart and favorites must survive app restarts
- **Error Handling:** Graceful error messages, no app crashes
- **Current Status:** ✅ Local data persistence working

### NFR5: Security
- **Data Encryption:** All API communication via HTTPS
- **Token Storage:** Secure storage of authentication tokens
- **User Privacy:** Compliance with GDPR/local privacy laws
- **Payment Security:** PCI-DSS compliant payment processing
- **Current Status:** ⏸️ Security audit pending

### NFR6: Compatibility
- **iOS Support:** iOS 14+ (target iOS 15+)
- **Android Support:** Android 8.0+ (API Level 26+) (target Android 10+)
- **Screen Sizes:** Optimized for phones (4"-7" screens)
- **Orientation:** Portrait mode (locked for V1.0)
- **Current Status:** ✅ Android tested, ⏸️ iOS testing pending

### NFR7: Maintainability
- **Code Quality:** Follow Flutter best practices and style guide
- **Architecture:** Clean Architecture with clear separation of concerns
- **Testing:** Minimum 70% code coverage (unit + widget tests)
- **Documentation:** All public APIs documented with DartDoc
- **Current Status:** ✅ Architecture implemented, ⏸️ Testing coverage incomplete

---

## Section 4: User Interface Design Goals

### Overall UX Vision
The app must feel like a **personal food concierge** - a trusted friend who knows the city's best-kept culinary secrets.

### Core UX Principles
1. **Visually Appetizing:** High-quality food imagery, clean layouts, beautiful typography
2. **Effortless & Intuitive:** Navigation should be invisible, journey from discovery to order frictionless
3. **Trust Through Transparency:** Clear information, honest reviews, professional presentation
4. **Delight in Details:** Thoughtful animations and micro-interactions

### Target User Persona: "Sara, the Urban Explorer"
- **Age:** 28-year-old tech-savvy professional in Cairo
- **Values:** Authenticity, quality, supporting local businesses
- **Pain Points:** Tired of generic apps, skeptical of fake reviews, wants to discover hidden gems
- **Goals:** Feel like an insider, enjoy variety, support community, have delightful experience

### Key Screens & Views
- ✅ Onboarding (Login/Sign Up with "Skip" option)
- ✅ Home Screen (curated carousels + restaurant list)
- ⏸️ Search & Filter Results Screen
- ✅ Restaurant Profile Screen (with menu)
- ✅ Dish Detail View
- ✅ Shopping Cart & Checkout Flow
- ⏸️ Live Order Tracking Screen
- ⏸️ Order History Screen
- ✅ User Profile Screen (Settings, Addresses, Favorites)

### Accessibility Standards
- **Target:** WCAG 2.1 Level AA compliance
- **Requirements:** 
  - Color contrast ratios (4.5:1 for text)
  - Resizable text (up to 200%)
  - Screen reader support (TalkBack/VoiceOver)
  - Keyboard navigation support
  - Touch target sizes (min 44x44 points)

---

## Section 5: Technical Architecture

### Tech Stack Summary
- **Framework:** Flutter 3.35.0+ / Dart 3.9.2+
- **State Management:** Riverpod 2.6.1 (AsyncNotifier pattern)
- **Architecture:** Clean Architecture (Domain/Data/Presentation)
- **Local Storage:** 
  - Drift 2.28.2 (SQLite) for structured data
  - SharedPreferences for simple key-value pairs
- **Backend:** Firebase (currently) → .NET/MySQL (future transition)
- **Navigation:** GoRouter with deep linking support
- **API Client:** Dio with interceptors (when backend ready)

### Architecture Layers

```
lib/
├── core/                    # Shared utilities
│   ├── config/             # App configuration
│   ├── errors/             # Error handling
│   ├── network/            # Connectivity
│   ├── routes/             # Navigation
│   ├── services/           # Core services
│   ├── theme/              # Design system
│   ├── utils/              # Helpers
│   └── widgets/            # Reusable widgets
│
└── features/               # Feature modules
    ├── splash/
    ├── onboarding/
    ├── auth/              # Authentication
    │   ├── domain/        # Business logic (entities, repositories)
    │   ├── data/          # Data layer (datasources, models)
    │   └── presentation/  # UI layer (screens, widgets, providers)
    ├── home/              # Discovery & restaurant listing
    ├── cart/              # Shopping cart
    ├── favorites/         # User favorites
    └── profile/           # User profile
```

### State Management Pattern
- **Riverpod AsyncNotifier:** For async data fetching and state management
- **Freezed Models:** For immutable data models
- **StateNotifier:** For complex state transitions
- **Simple State:** For basic toggles and simple state

### Repository Pattern
```dart
// Abstract interface (domain layer)
abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants(String location);
  Future<Restaurant> getRestaurantById(String id);
}

// Implementation (data layer) - Easy to swap backends
class FirebaseRestaurantRepository implements RestaurantRepository {
  final RestaurantDataSource dataSource;
  
  @override
  Future<List<Restaurant>> getRestaurants(String location) async {
    try {
      return await dataSource.fetchRestaurants(location);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
```

### Backend Transition Strategy
1. **Phase 1 (Current):** Mock data in providers
2. **Phase 2:** Firebase integration (Firestore + Auth)
3. **Phase 3:** .NET/MySQL backend (replace Firebase datasources)

**Key Design Decision:** All data access goes through Repository → DataSource abstraction. This allows swapping from Firebase to .NET by only changing the DataSource implementation.

---

## Section 6: Testing Requirements

### Testing Strategy

#### Unit Tests
- **Target Coverage:** 80%+ for business logic
- **Focus Areas:**
  - Repository implementations
  - Use cases / business logic
  - Utility functions
  - Data models / serialization

#### Widget Tests
- **Target Coverage:** 70%+ for UI components
- **Focus Areas:**
  - Reusable widgets (RestaurantCard, buttons, etc.)
  - Screen rendering with different states
  - User interactions (taps, swipes, form inputs)

#### Integration Tests
- **Critical User Flows:**
  - Guest browsing → Add to cart → Blocked at checkout
  - Sign up → Browse → Add to cart → Checkout → Order placed
  - View restaurant → Add items → Modify cart → Checkout
  - Favorite restaurant → View favorites → Navigate to restaurant

#### Golden Tests (Visual Regression)
- **Key Components:**
  - RestaurantCard in different states
  - Home screen carousels
  - Cart screen layouts
  - Receipt layouts

### Test Enforcement
- **CI/CD:** All tests must pass before merge
- **Pre-commit Hook:** Run `flutter analyze` and critical tests
- **Code Review:** Test coverage must be maintained

---

## Section 7: Epic & Story Breakdown

### Epic 1: Foundation & User Onboarding
**Status:** ✅ 80% Complete

- ✅ **Story 1.1:** Project Setup & Boilerplate
- ✅ **Story 1.2:** User Sign-Up (UI complete, backend mock)
- ✅ **Story 1.3:** User Login (UI complete, backend mock)
- ✅ **Story 1.4:** Social Login (UI complete, backend mock)
- ⏸️ **Story 1.5:** Address Management (not started)

### Epic 2: Core Discovery & Ordering Journey
**Status:** ✅ 60% Complete

- ⏸️ **Story 2.1:** Location-Based Restaurant Listing (mock data)
- ⏸️ **Story 2.2:** Search & Basic Filtering (UI only)
- ✅ **Story 2.3:** View Restaurant Menu
- ✅ **Story 2.4:** Add & Manage Items in Cart
- ⏸️ **Story 2.5:** Complete Checkout Process (blocker implemented, payment pending)

### Epic 3: Post-Order & Engagement Loop
**Status:** ⏸️ 10% Complete

- ⏸️ **Story 3.1:** Live Order Tracking
- ⏸️ **Story 3.2:** Order History & Reorder
- ✅ **Story 3.3:** Favorites System (basic implementation)
- ⏸️ **Story 3.4:** Dual-Rating System
- ⏸️ **Story 3.5:** Push Notifications

### Epic 4: Unique Features ("Secret Sauce")
**Status:** ⏸️ 0% Complete

- ⏸️ **Story 4.1:** 'Tawseya' Recommendation System (HIGH PRIORITY)
- ⏸️ **Story 4.2:** Home Screen Curated Carousels (UI only, need real data)
- ⏸️ **Story 4.3:** "Surprise Me!" Feature
- ⏸️ **Story 4.4:** Shareable Menu Items
- ⏸️ **Story 4.5:** Styled Digital Receipts

---

## Section 8: Success Criteria

### V1.0 MVP Success Criteria

The MVP will be considered complete when:

1. ✅ **Foundation Complete:**
   - App runs without crashes on Android and iOS
   - All screens navigate correctly
   - Theme and branding consistent throughout

2. ⏸️ **Core Flow Working:**
   - User can sign up/login (with real backend)
   - User can browse restaurants (with real data)
   - User can add items to cart
   - User can complete checkout and place order
   - User receives order confirmation

3. ⏸️ **Differentiating Features Implemented:**
   - 'Tawseya' system functional
   - Dual-rating system working
   - Curated carousels with real data
   - "Surprise Me!" feature working

4. ⏸️ **Polish & Quality:**
   - All animations smooth (60fps)
   - Error handling graceful
   - Offline mode for browsing
   - Push notifications working
   - Digital receipts downloadable

5. ⏸️ **Testing & Documentation:**
   - 70%+ test coverage
   - All critical flows tested
   - Documentation complete
   - Security audit passed

### Post-MVP Roadmap

**Phase 2 Features (Future):**
- Advanced social features (follow users, activity feeds)
- Group ordering & bill splitting
- In-app chat with restaurant
- Dine-in reservations
- Advanced personalization

**Long-term Vision (1-2 Years):**
- Hyper-personalized recommendations
- Content platform (chef stories, restaurant features)
- Community champion program
- Geographic expansion

---

## Section 9: Open Questions & Decisions

### Questions to Resolve

1. **Payment Integration:**
   - Which payment gateway? (Fawry, Paymob, Stripe?)
   - Timeline for integration?
   - Fallback to COD only for V1.0?

2. **Backend Timeline:**
   - When will .NET backend be ready?
   - Should we fully implement Firebase first or wait?
   - Migration strategy from Firebase to .NET?

3. **Restaurant Onboarding:**
   - How will restaurants be added initially?
   - Manual admin entry or self-service portal?
   - What data is required from restaurants?

4. **Delivery System:**
   - In-house delivery or third-party?
   - How does driver assignment work?
   - Driver app timeline?

5. **Content Curation:**
   - Who curates "Hidden Gems" and "Local Heroes"?
   - Algorithm-based or manual curation?
   - Update frequency?

### Decisions Made

- ✅ Use Flutter 3.35.0+ with latest Dart
- ✅ Riverpod for state management (not BLoC)
- ✅ Clean Architecture with Repository pattern
- ✅ Guest mode with checkout blocker (no Firebase anonymous auth)
- ✅ Portrait-only for V1.0
- ✅ Firebase first, then .NET transition
- ✅ Drift (SQLite) for local storage
- ✅ Material Design 3 with custom theme

---

## Section 10: Appendix

### Related Documents
- [AI Agent Briefing](./AI_AGENT_BRIEFING.md) - Development context and current status
- [Technical Architecture](./FRONTEND_ARCHITECTURE.md) - Detailed architecture guide
- [UI/UX Specification](./UI_UX_SPECIFICATION.md) - Design system and user flows
- [Project Brief](./brief.md) - High-level project overview
- [Security Implementation](./SECURITY_IMPLEMENTATION.md) - Security guidelines

### Glossary
- **Tawseya:** Arabic word for "recommendation" - our unique monthly voting system
- **Urban Explorer:** Our target user persona (Sara)
- **Hidden Gems:** Curated carousel of lesser-known quality restaurants
- **Local Heroes:** Curated carousel of top-rated community favorites
- **Dual Rating:** Separate ratings for food quality and delivery experience

### Version History
- **v2.0 (Oct 4, 2025):** Updated for current implementation status
- **v1.0 (Sep 26, 2025):** Initial PRD draft

---

**Document Owner:** Product Team  
**Last Updated:** October 4, 2025  
**Status:** Living Document (Updated as requirements evolve)
