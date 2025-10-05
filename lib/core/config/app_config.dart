import 'sensitive_config.dart';

class AppConfig {
  static const String appName = 'Otlob';
  static const String appVersion = '1.0.0';
  static const String baseUrl =
      'https://api.otlob.com'; // Replace with actual API URL
  static const String termsUrl =
      'https://otlob.com/terms'; // Replace with actual terms URL
  static const String privacyUrl =
      'https://otlob.com/privacy'; // Replace with actual privacy URL

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String userProfileEndpoint = '/user/profile';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String isFirstRunKey = 'is_first_run';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String languageKey = 'language';

  // Default Values
  static const String defaultLanguage = 'ar';
  static const bool defaultDarkMode = false;

  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Cache Config
  static const int maxCacheAge = 7; // days
  static const int maxCacheSize = 100; // MB

  // Firebase Config - Now handled by firebase_keys.dart for platform-specific keys
  static const String firebaseProjectId = 'otlob-6e081';
  static const String firebaseMessagingSenderId = '450554002301';

  // Map Config
  static String get googleMapsApiKey => SensitiveConfig.googleMapsApiKey;
  static const double defaultLatitude = 30.0444; // Cairo's latitude
  static const double defaultLongitude = 31.2357; // Cairo's longitude

  // Payment Config
  static String get payMobApiKey => SensitiveConfig.payMobApiKey;
  static String get payMobFrameId => SensitiveConfig.payMobFrameId;
  static String get payMobIntegrationId => SensitiveConfig.payMobIntegrationId;

  // Unsplash Config
  static String get unsplashAccessKey => SensitiveConfig.unsplashAccessKey;
}
