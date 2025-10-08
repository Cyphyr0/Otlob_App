/// Application configuration for different environments.
///
/// This class centralizes all configurable values used throughout the app.
/// Environment-specific values are loaded from compile-time constants or
/// environment variables using Dart's const evaluation.
///
/// ## Environment Variables
///
/// Set these at compile time using `--dart-define` or environment variables:
/// - `GOOGLE_MAPS_API_KEY`: Google Maps API key for location services
/// - `MAPBOX_API_KEY`: Mapbox API key for alternative mapping
/// - `PAYMOB_API_KEY`: Paymob payment gateway API key
/// - `UNSPLASH_ACCESS_KEY`: Unsplash API key for image services
/// - `FIREBASE_PROJECT_ID`: Firebase project identifier
/// - `GOOGLE_CLIENT_ID`: Google OAuth client ID
/// - `FACEBOOK_APP_ID`: Facebook OAuth app ID
class AppConfig {
  /// The human-readable application name displayed to users.
  static const String appName = 'Otlob';

  /// Current application version following semantic versioning (MAJOR.MINOR.PATCH).
  static const String version = '1.0.0';

  // Environment Configuration

  /// Whether the app is running in development mode.
  /// Determined by the `dart.vm.product` environment variable.
  static const bool isDevelopment = bool.fromEnvironment('dart.vm.product') == false;

  /// Whether the app is running in production mode.
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // API Configuration

  /// Base URL for REST API endpoints.
  /// Automatically switches based on environment:
  /// - Production: https://api.otlob.com
  /// - Development: https://dev-api.otlob.com
  static const String baseUrl = isProduction
      ? 'https://api.otlob.com'
      : 'https://dev-api.otlob.com';

  // Network timeouts (in milliseconds)

  /// Maximum time to establish a connection to the server.
  static const int connectionTimeout = 30000;

  /// Maximum time to wait for a response from the server.
  static const int receiveTimeout = 30000;

  // Feature Flags

  /// Enable detailed logging in non-production environments.
  static const bool enableLogging = !isProduction;

  /// Enable automatic crash reporting to external services.
  static const bool enableCrashReporting = true;

  /// Enable analytics tracking.
  static const bool enableAnalytics = true;

  // Third-party Service Configurations

  /// Google Maps API key for location services and map display.
  /// Override with `GOOGLE_MAPS_API_KEY` environment variable.
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY',
  );

  /// Mapbox API key for alternative mapping services.
  /// Override with `MAPBOX_API_KEY` environment variable.
  static const String mapboxApiKey = String.fromEnvironment(
    'MAPBOX_API_KEY',
    defaultValue: 'YOUR_MAPBOX_API_KEY',
  );

  /// Paymob payment gateway API key for payment processing.
  /// Override with `PAYMOB_API_KEY` environment variable.
  static const String paymobApiKey = String.fromEnvironment(
    'PAYMOB_API_KEY',
    defaultValue: 'YOUR_PAYMOB_API_KEY',
  );

  /// Unsplash API access key for image services.
  /// Override with `UNSPLASH_ACCESS_KEY` environment variable.
  static const String unsplashAccessKey = String.fromEnvironment(
    'UNSPLASH_ACCESS_KEY',
    defaultValue: 'YOUR_UNSPLASH_ACCESS_KEY',
  );

  // Firebase Configuration

  /// Firebase project identifier.
  /// Override with `FIREBASE_PROJECT_ID` environment variable.
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'otlob-app',
  );

  // App Store Configuration

  /// Apple App Store application identifier.
  static const String appStoreId = 'YOUR_APP_STORE_ID';

  /// Google Play Store application package name.
  static const String playStoreId = 'com.otlob.app';

  // Social Login Configuration

  /// Google OAuth client identifier for social authentication.
  /// Override with `GOOGLE_CLIENT_ID` environment variable.
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: 'YOUR_GOOGLE_CLIENT_ID',
  );

  /// Facebook OAuth application identifier for social authentication.
  /// Override with `FACEBOOK_APP_ID` environment variable.
  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: 'YOUR_FACEBOOK_APP_ID',
  );

  // Convenience Methods

  /// Whether logging is currently enabled based on environment and configuration.
  static bool get loggingEnabled => isDevelopment && enableLogging;

  /// Whether crash reporting is currently active.
  static bool get crashReportingEnabled => enableCrashReporting && isProduction;

  /// Whether analytics tracking is currently active.
  static bool get analyticsEnabled => enableAnalytics;
}
