/// Application configuration for different environments
class AppConfig {
  static const String appName = 'Otlob';
  static const String version = '1.0.0';

  // Environment configuration
  static const bool isDevelopment = bool.fromEnvironment('dart.vm.product') == false;
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // API Configuration
  static const String baseUrl = isProduction
      ? 'https://api.otlob.com'
      : 'https://dev-api.otlob.com';

  // Network timeouts (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Feature flags
  static const bool enableLogging = !isProduction;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;

  // Third-party service configurations
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY',
  );

  static const String mapboxApiKey = String.fromEnvironment(
    'MAPBOX_API_KEY',
    defaultValue: 'YOUR_MAPBOX_API_KEY',
  );

  static const String paymobApiKey = String.fromEnvironment(
    'PAYMOB_API_KEY',
    defaultValue: 'YOUR_PAYMOB_API_KEY',
  );

  static const String unsplashAccessKey = String.fromEnvironment(
    'UNSPLASH_ACCESS_KEY',
    defaultValue: 'YOUR_UNSPLASH_ACCESS_KEY',
  );

  // Firebase configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'otlob-app',
  );

  // App Store configuration
  static const String appStoreId = 'YOUR_APP_STORE_ID';
  static const String playStoreId = 'com.otlob.app';

  // Social login configuration
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: 'YOUR_GOOGLE_CLIENT_ID',
  );

  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: 'YOUR_FACEBOOK_APP_ID',
  );
}
