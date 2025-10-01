# Project Journal: Otlob App

This document records the architectural decisions, dependency choices, and the overall development journey of the Otlob food delivery app. It is intended to be a guide for developers and AI assistants working on this project.

## Project Overview

Otlob is a premium Flutter-based mobile application for discovering and ordering from Egypt's authentic local food scene.

## High-Level Architecture

The project follows a feature-first architecture, with a clear separation of concerns between the data, domain, and presentation layers.

*   **State Management:** We are using **`flutter_riverpod`** for state management. It was chosen for its compile-time safety, simplicity, and good integration with the Flutter ecosystem.
*   **Navigation:** We are using **`go_router`** for declarative routing.
*   **Networking:** We are using **`retrofit`** and **`dio`** for type-safe API calls.

## Dependency Decisions

The selection of dependencies has been a careful process, with a focus on choosing modern, well-maintained, and compatible packages.

### Local Database: The Journey to Drift

The choice of a local database involved a detailed investigation:

1.  **Initial consideration of Hive:** Hive was initially considered, but it was found to be largely unmaintained, with many open issues and a dependency on an old version of `source_gen` that caused conflicts with other packages.
2.  **Evaluation of Isar:** Isar, the successor to Hive, was then considered. However, we discovered that the original Isar repository is also not actively maintained, and there are concerns about its compatibility with upcoming Android versions. While a community fork exists, the situation created uncertainty.
3.  **Final Decision: Drift:** After careful consideration, we decided to use **Drift**. It is a powerful, mature, and actively maintained persistence library built on top of SQLite. It offers strong typing, powerful querying capabilities, and a clear migration path. This choice provides the best long-term stability and robustness for the project.

### Other Key Dependencies

*   **`app_links`:** Replaced the discontinued `uni_links` package for deep linking.
*   **`freezed`:** Used for creating immutable data models and unions, which works well with Riverpod and helps to ensure type safety.
*   **Code Generation Packages:** We have carefully selected a compatible set of versions for `build_runner`, `drift_dev`, `retrofit_generator`, and `json_serializable` to ensure that code generation works smoothly.

## Local Storage Strategy

This project uses a combination of local storage solutions for different purposes:

*   **Drift:** Used as the main local database for structured, relational data.
*   **flutter_secure_storage:** Used for storing sensitive data like authentication tokens.
*   **shared_preferences:** Used for simple key-value settings like theme preferences or feature flags.

## Implemented Services

The following core services have been implemented in `lib/core/services/`:

*   **`database.dart`:** The Drift database setup.
*   **`connectivity_service.dart`:** To check for internet connectivity.
*   **`permission_service.dart`:** To handle permissions for location, camera, etc.
*   **`persistent_provider.dart`:** A Riverpod provider for persisting the cart state using `shared_preferences`.
*   **`profile_image_picker.dart`:** A service for picking images from the gallery.

## 2025-10-01: Refactoring and Dependency Updates

*   Refactored `lib/core/providers/persistent_provider.dart` to use the new `AsyncNotifier` API from Riverpod 3.0. This resolves previous compilation errors and aligns the project with the latest Riverpod best practices.
*   Attempted to update all dependencies to their latest versions. Due to dependency conflicts, not all packages could be updated to the absolute latest. The dependencies have been updated to the latest compatible versions using `flutter pub upgrade`.

## Next Steps

The project is now in a good state to start building features. The next logical steps are:

*   Start building the UI for the home screen.
*   Create the `CartPage` UI and integrate it with the `persistentCartProvider`.
*   Set up the navigation with `go_router`.
*   Implement the authentication flow.
## 2025-09-30: Dependency Audit and Optimization

* Conducted a comprehensive review of all dependencies in pubspec.yaml using `flutter pub outdated`.
* Updated core dependencies to latest compatible versions: flutter_riverpod (^3.0.1), firebase_core (^4.1.1), firebase_auth (^6.1.0), cloud_firestore (^6.0.2), and others where possible without breaking compatibility.
* Resolved drift version conflict by downgrading to ^2.28.2 (from ^2.28.3) to ensure resolution with sqlite3_flutter_libs.
* Regenerated all code files with `build_runner build --delete-conflicting-outputs` after updates; no breaking changes detected.
* Verified project with `flutter analyze` - no issues found.
* Identified potential optimizations:
  - Maps: Both google_maps_flutter and mapbox_maps_flutter are declared but not imported; recommend removing mapbox_maps_flutter unless specific features needed to reduce bundle size.
  - Caching: dio_http_cache_lts (^0.4.2) is outdated; consider migrating to dio_cache_interceptor (^3.5.0) for better HTTP caching with ETag and offline support.
  - No major redundancies; stack aligns well with clean architecture and Firebase-first approach.
* Committed and pushed updates to main branch (commit e7c99f0).

## Next Steps
* Implement navigation with GoRouter and bottom navigation bar.
* Build HomeScreen with curated carousels ('Hidden Gems', 'Local Heroes') and 'Surprise Me!' feature.
* Integrate mock restaurant data via repository pattern.
* Develop search and filtering for discovery.
## 2025-09-30: Authentication System Planning

### Authentication System Overview
The authentication system provides secure user registration, login, and session management using Firebase Authentication. It supports email/password, Google sign-in, and optional phone authentication for Egypt's mobile-first users. The system follows clean architecture, integrating with Riverpod state management and GoRouter navigation.

### Key Goals
- Seamless, premium user experience with social/email sign-up/login.
- Offline support using Drift for local user data persistence.
- Route protection with authentication guards.
- User profile management post-login.
- Compliance with privacy standards for secure data handling.

### Features (MVP)
**Registration (Sign-up):**
- Email/password with validation (8+ chars, confirm match).
- Google sign-in for quick registration.
- Phone authentication (Firebase Phone Auth for OTP).
- Profile completion (name, optional phone).
- Terms acceptance checkbox.

**Login:**
- Email/password with "remember me" (secure token storage).
- Google sign-in.
- Phone login (OTP).
- "Forgot password" with email reset.

**Session Management:**
- Automatic token refresh via Firebase Auth state listeners.
- Logout (clear local data/tokens).
- Offline login using cached credentials.

**Error Handling:**
- Network errors (retry with backoff).
- Invalid credentials (friendly messages).
- Rate limiting ("Too many attempts").
- Validation errors (inline/form level).

**UI/UX:**
- Loading indicators.
- Success messages ("Welcome back!").
- Toggle between login/signup.
- Social proof ("Join 10k+ food lovers").

### Architecture
**Domain Layer:**
- Entities: `User` (id, email, name, phone, createdAt, isVerified).
- Repositories: `AuthRepository` (registerWithEmail, loginWithEmail, loginWithGoogle, logout, getCurrentUser, resetPassword).
- Use Cases: `RegisterUserUseCase`, `LoginUserUseCase`, `LogoutUseCase`.

**Data Layer:**
- Data Sources: `FirebaseAuthDataSource` (Firebase calls), `LocalAuthDataSource` (Drift caching).
- Repositories: `FirebaseAuthRepository` (combines sources, handles `Failure`).
- Models: `UserModel` (freezed for JSON).

**Presentation Layer:**
- Providers: `authProvider` (AsyncNotifier for auth state: loading/authenticated/unauthenticated).
- Screens: `LoginScreen`, `SignupScreen`, `AuthWrapper`.
- Widgets: Form fields, loading overlay, error banners.

**Integration:**
- Firebase: `firebase_auth` for auth, `cloud_firestore` for profiles.
- Local: Drift for user caching.
- Navigation: GoRouter redirect for guards.

### UI Flow
1. App starts at `/auth` (guarded).
2. AuthWrapper: If authenticated → `/home`; else → LoginScreen.
3. LoginScreen: Email/password form, Google button, "Forgot Password?", toggle to Signup.
4. SignupScreen: Email/password/confirm/name form, terms checkbox, Google button, toggle to Login.
5. Success: Save to local, navigate to `/home`, welcome toast.
6. Logout: Clear data, redirect to `/auth`.

### Firebase Integration
- Initialize in `main.dart`.
- Methods: `createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `signInWithCredential` (Google).
- Listener: `FirebaseAuth.instance.authStateChanges()` in provider.
- Profile: Save to Firestore `users` collection (doc ID = user UID).
- Security: HTTPS, Firebase rules for user-specific access.

### Error Handling & Edge Cases
- Map Firebase exceptions to `AuthFailure` (e.g., `emailAlreadyInUse`, `networkError`).
- Offline: Use `connectivity_plus`; fallback to cached login.
- Validation: Client + server-side.
- Loading: AsyncValue in Riverpod.
- Edge: Weak password, invalid email, timeout, locked account.

### Navigation Guards
- GoRouter `redirect`: Unauthenticated on protected routes → `/auth`; authenticated on `/auth` → `/home`.
- Protected: `/home`, `/cart`, `/profile`.
- Deep links: Handle email verification.

### Testing & Security
- Unit: Mock repositories (mockito).
- Integration: Firebase emulator.
- Security: No local passwords; secure storage for tokens; input validation.

### Implementation Timeline
- Week 1: Domain/Use Cases, Repository.
- Week 2: Data sources, providers.
- Week 3: UI, integration, testing.

This plan ensures a robust auth system scalable to .NET backend transition.