# Otlob App - Product Requirements Document
**Version:** 2.1 (BMAD-METHOD Format)
**Date:** October 7, 2025
**Status:** Active Development - Brownfield Project

---

## Executive Summary

Otlob is a Flutter-based mobile application that connects food enthusiasts in Egypt with authentic, locally-owned restaurants. Unlike generic food delivery apps, Otlob focuses on solving "choice paralysis" and "trust erosion" by providing curated, community-driven discovery of genuine Egyptian cuisine.

**Business Value:**
- Champion local, authentic Egyptian restaurants
- Build trust through transparent dual-rating system
- Provide delightful UX for food discovery and ordering

**Differentiation:**
- 'Tawseya' monthly recommendation system (1 vote per user per month)
- Dual-rating model (food quality vs. delivery experience)
- Curated content, not advertising-driven

---

## Problem Statement

**User Pain Points:**
- Overwhelmed by inauthentic choices on existing platforms
- Fake reviews and paid promotions erode trust
- Hard to discover genuine local Egyptian restaurants
- Generic international chains dominate search results

**Restaurant Pain Points:**
- High-quality local restaurants lost in algorithmic noise
- Unfair rating systems blend food quality with delivery issues
- Cannot compete with big advertising budgets
- Need level playing field for visibility

---

## Solution Overview

Otlob creates a trusted, community-driven ecosystem where:
- Users discover genuinely recommended restaurants
- Local heroes and hidden gems get fair visibility
- Reviews separate food quality from delivery experience
- Monthly 'Tawseya' votes create curated curation

---

## Functional Requirements

### Epic 1: Authentication & User Management
**Priority:** P0 - MVP Foundation

#### Story 1.1: Email/Password Registration
**Acceptance Criteria:**
- User can enter email and password to create account
- Email validation and password strength requirements
- Confirmation email sent after registration
- Error handling for duplicate emails
**Status:** ✅ UI Complete, Backend Mock

#### Story 1.2: Phone Number Authentication
**Acceptance Criteria:**
- User enters phone number and receives OTP
- OTP validation and verification
- Resend OTP functionality with cooldown
- Phone number formatting for Egyptian numbers (+20)
**Status:** ✅ UI Complete, Backend Mock

#### Story 1.3: Social Authentication
**Acceptance Criteria:**
- Google OAuth integration
- Facebook OAuth integration
- Profile data extraction and account creation
- Error handling for OAuth failures
**Status:** ✅ UI Complete, Backend Mock

#### Story 1.4: Guest Browsing Mode
**Acceptance Criteria:**
- User can browse without authentication
- Checkout blocked with sign-up prompt
- Cart persistence during anonymous session
- Clear CTA to convert guest to registered user
**Status:** ✅ Implemented

### Epic 2: Location & Discovery
**Priority:** P0 - Core Value Proposition

#### Story 2.1: Location Detection
**Acceptance Criteria:**
- GPS permission request on app launch
- Location accuracy within 100 meters
- Fallback to manual address entry
- Location settings validation
**Status:** 🚧 UI Framework - Needs Implementation

#### Story 2.2: Curated Home Carousels
**Acceptance Criteria:**
- "Hidden Gems" carousel displays 10 curated restaurants
- "Local Heroes" carousel shows top Tawseya winners
- Restaurant cards show name, rating, cuisine, delivery time
- Tap-to-navigate to restaurant detail
**Status:** ✅ UI Complete, Mock Data

#### Story 2.3: Restaurant Search & Filtering
**Acceptance Criteria:**
- Search by restaurant name or cuisine
- Filter by delivery time, rating, cuisine type
- Minimum 5 cuisine categories (Egyptian, Italian, Asian, etc.)
- Filter results update in real-time as user types
**Status:** 🚧 Basic UI - Needs Backend

### Epic 3: Restaurant & Menu Experience
**Priority:** P0 - Core Ordering Flow

#### Story 3.1: Restaurant Profile Display
**Acceptance Criteria:**
- Hero image with restaurant logo/name overlay
- Dual ratings: Food quality (1-5 ⭐) and Delivery (1-5 ⭐)
- Tawseya count prominently displayed
- Cuisine type, delivery time, minimum order badges
**Status:** ✅ UI Complete, Mock Data

#### Story 3.2: Menu Categories & Items
**Acceptance Criteria:**
- Categorized menu (Appetizers, Mains, Desserts, Drinks)
- Each item shows name, price, image, description
- Add to cart button with quantity selector
- Special instructions field per item
**Status:** ✅ UI Complete, Mock Data

#### Story 3.3: Favorites Management
**Acceptance Criteria:**
- Heart icon to favorite/unfavorite restaurants
- Favorites persist across app sessions
- Favorites screen with horizontal scrolling cards
- Navigation to restaurant from favorites
**Status:** ✅ Implemented (Local Storage)

### Epic 4: Cart & Checkout
**Priority:** P0 - Revenue Generation

#### Story 4.1: Cart Management
**Acceptance Criteria:**
- Add/remove/modify items from any screen
- Quantity controls with +/- buttons
- Special instructions per item
- Cart icon shows item count badge
**Status:** ✅ Riverpod State Management Complete

#### Story 4.2: Cart Review Screen
**Acceptance Criteria:**
- Full cart contents with item details
- Price breakdown (subtotal, delivery, service fee, tax)
- Remove/modify items directly from cart
- Empty cart state with call-to-action
**Status:** ✅ Implemented

#### Story 4.3: Authentication Gate
**Acceptance Criteria:**
- Guest users shown sign-up/login options before checkout
- Registered users proceed directly to checkout
- Cart preserved during authentication flow
- "Continue as Guest" with clear limitations explained
**Status:** ✅ Implemented

#### Story 4.4: Payment Selection
**Acceptance Criteria:**
- Cash on Delivery option available
- Digital payment option (Paymob/Fawry integration)
- Future expansion for card payments
- Payment method persists for future orders
**Status:** 🚧 UI Framework - Payment Integration Pending

### Epic 5: Order Management & Tracking
**Priority:** P1 - Post-Order Experience

#### Story 5.1: Order Confirmation
**Acceptance Criteria:**
- Order summary with all details
- Order ID generation and display
- Estimated delivery time
- Push notification receipt confirmation
**Status:** 🚧 Order State - Needs Backend

#### Story 5.2: Live Order Tracking
**Acceptance Criteria:**
- Real-time status updates (Placed → Confirmed → Preparing → Out for Delivery → Delivered)
- Driver location tracking (when available)
- Contact restaurant/driver options
- ETA updates based on GPS data
**Status:** 🚧 UI Design - Backend Integration Pending

#### Story 5.3: Order History
**Acceptance Criteria:**
- Chronologically sorted past orders
- Order details: date, restaurant, items, total
- Reorder functionality with one tap
- Digital receipt access
**Status:** 🚧 Data Model - No Backend Yet

### Epic 6: Unique Features (Differentiation)
**Priority:** P0 → P1 - Core Value Props

#### Story 6.1: Tawseya Recommendation System
**Acceptance Criteria:**
- Each user gets exactly 1 Tawseya vote per month
- Tawseya awarded to any restaurant (including multiple votes to same)
- Restaurant profile shows Tawseya count prominently
- Monthly vote reset on calendar date
**Status:** 🚧 High Priority - Core Differentiator

#### Story 6.2: Dual-Rating System
**Acceptance Criteria:**
- Separate 1-5 star ratings for food quality and delivery
- Restaurant profile displays both averages clearly
- Review screen collects both ratings
- Weighted overall rating calculation
**Status:** 🚧 Pending Backend

#### Story 6.3: Surprise Me Feature
**Acceptance Criteria:**
- Single randomized restaurant recommendation
- Criteria: high Tawseya count, good food ratings
- One-tap navigation to restaurant menu
- Refresh option for different suggestion
**Status:** 🚧 Algorithm Pending

### Epic 7: User Profile & Settings
**Priority:** P1 - User Experience Enhancement

#### Story 7.1: Profile Management
**Acceptance Criteria:**
- Edit name, email, phone number
- Profile picture upload and display
- Account deletion option with data export
- Profile completion progress indicator
**Status:** ✅ Basic UI Complete

#### Story 7.2: Address Management
**Acceptance Criteria:**
- Add/edit/delete delivery addresses
- GPS-based address detection
- Address validation and formatting
- Default address selection
**Status:** 🚧 Pending Location Services

#### Story 7.3: Notification Preferences
**Acceptance Criteria:**
- Order status notifications toggle
- Promotional notifications opt-in/out
- Push notification settings
- Email notification settings
**Status:** 🚧 Firebase Integration Pending

### Epic 8: App Experience Enhancement
**Priority:** P2 - Polish & Scale

#### Story 8.1: Push Notifications
**Acceptance Criteria:**
- Order status updates (accepted, out for delivery, delivered)
- Promotional offers (opt-in only)
- "Order Ready for Pickup" notifications
- Daily Tawseya opportunities (opt-in)
**Status:** 🚧 Firebase Integration Pending

#### Story 8.2: Digital Receipts
**Acceptance Criteria:**
- Styled PDF receipt generation
- Itemized pricing, taxes, fees
- Restaurant branding and order details
- Download as PDF or image formats
**Status:** 🚧 PDF Generation Integration Pending

#### Story 8.3: Shareable Restaurant Links
**Acceptance Criteria:**
- Deep links to specific restaurants
- Mobile app opens directly, web fallback
- Share via social media, messaging apps
- QR code generation for menus
**Status:** 🚧 Deep Linking Setup Pending

---

## Non-Functional Requirements

### Performance (NFR1)
**Targets:**
- App startup time: < 3 seconds on mid-range devices
- Screen load time: < 2 seconds on 4G connection
- UI animations: 60fps minimum
- API response time: < 1 second for critical operations

### Security (NFR2)
**Requirements:**
- HTTPS-only API communications
- Secure token storage (encrypted preferences)
- Payment data PCI-DSS compliance
- User privacy: GDPR/local law compliance
- Data encryption at rest and in transit

### Reliability (NFR3)
**Targets:**
- Crash-free rate: > 99.5% sessions
- Offline browsing capability
- Data persistence across app restarts
- Graceful error handling and recovery
- Automatic retry for failed network requests

### Compatibility (NFR4)
**Supported Platforms:**
- iOS: 14.0+ (targeting iOS 15+)
- Android: API 26+ (targeting API 29+)
- Screen sizes: 4-7 inch phones
- Orientation: Portrait mode (V1.0)
- Network: WiFi, 4G, 5G connectivity

### Accessibility (NFR5)
**Standards:**
- WCAG 2.1 Level AA compliance
- Color contrast ratios: 4.5:1 minimum
- Text scaling: support up to 200%
- Screen reader support: TalkBack/VoiceOver
- Touch target size: 44x44pt minimum

### Usability (NFR6)
**Targets:**
- Onboarding completion: < 2 minutes for new users
- Order placement: < 60 seconds for returning users
- Error message clarity: user-understandable language
- Help accessibility: in-app support options

---

## Technical Architecture

### Flutter Clean Architecture Implementation

**Tech Stack:**
- Flutter 3.35.0+, Dart 3.9.2+
- Riverpod 2.6.1 for state management
- Clean Architecture (Data/Domain/Presentation)
- Repository pattern for data abstraction

**Architecture Layers:**
```
lib/
├── core/                    # Shared utilities & services
├── features/               # Feature-based modules
│   ├── auth/
│   │   ├── data/          # DataSources, DTOs, Local DB
│   │   ├── domain/        # Entities, Repositories, Use Cases
│   │   └── presentation/  # Screens, Widgets, Providers
│   └── [other features...]/
├── docs/                   # BMAD documentation
└── main.dart
```

### Backend Architecture
**Current Phase:** Mock Data → Firebase Transition → .NET/MySQL

**Data Sources:**
- Firebase Firestore (temporary)
- Cloud Storage for images
- Firebase Auth for authentication
- Future: .NET Core API + MySQL/PostgreSQL

---

## Acceptance Criteria Standards

### Story Completion Checklist
- [ ] UI implementation matches design specifications
- [ ] Unit tests written and passing (70%+ coverage target)
- [ ] Widget tests for critical UI components
- [ ] Integration tests for user flows
- [ ] State management properly implemented
- [ ] Error handling and edge cases covered
- [ ] Code reviewed and approved
- [ ] Documentation updated

### Epic Completion Criteria
- [ ] All stories in epic completed and tested
- [ ] End-to-end user flow validated
- [ ] Performance requirements met
- [ ] Accessibility standards met
- [ ] Code coverage targets achieved
- [ ] Documentation deliverables complete

---

## Success Metrics

### MVP Success Criteria (Version 1.0)
1. ✅ **Technical Foundation**: App runs crash-free on Android and iOS
2. ✅ **Core Flow**: Authentication → Discovery → Cart → Checkout complete
3. ⏸️ **Real Data Integration**: Firebase backend with live restaurant data
4. ⏸️ **Differentiating Features**: Tawseya system and dual ratings functional
5. ⏸️ **Quality Standards**: 70%+ test coverage, accessibility compliance

### Key Performance Indicators
- **User Acquisition**: 1,000+ beta users within 3 months
- **Restaurant Onboarding**: 50+ restaurants live within 2 months
- **Order Completion Rate**: >90% of initiated checkout flows
- **User Retention**: >60% monthly active user retention
- **Local Restaurant Share**: >70% of featured restaurants are local

---

## Development Phases

### Phase 1: Foundation Complete ✅
- Flutter app architecture and UI screens
- Basic navigation and state management
- Authentication and user management UI
- Cart and checkout foundation

### Phase 2: Real Data Integration 🚧
- Firebase backend integration
- Real restaurant and menu data
- User authentication with Firebase
- Order processing and tracking

### Phase 3: Unique Features 🚧
- Tawseya recommendation system
- Dual-rating implementation
- Surprise Me feature
- Advanced curation algorithms

### Phase 4: Scale & Polish 🚧
- Performance optimization
- Comprehensive testing
- Push notifications
- Digital receipts and sharing

---

## Risk Assessment & Mitigation

### High-Risk Items
1. **Payment Integration**: Mitigated by cash-on-delivery fallback
2. **Location Services**: Mitigated by manual address entry
3. **Real-time Order Tracking**: Mitigated by text-based status updates
4. **Restaurant Onboarding**: Mitigated by curated initial set

### Technical Debt Considerations
- Firebase dependency (transition plan to .NET exists)
- Mock data throughout UI (prioritized for demos)
- Limited error handling (comprehensive handling planned)
- Test coverage gaps (continuous improvement approach)

---

**Document Owner:** BMAD-METHOD Implementation Team
**Last Updated:** October 7, 2025
**Next Review:** November 2025
