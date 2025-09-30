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