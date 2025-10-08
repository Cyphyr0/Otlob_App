/// Payment gateway configuration and settings.
///
/// This class manages all payment-related configurations for multiple
/// payment providers supported by the Otlob application.
///
/// ## Supported Payment Providers
/// - **Stripe**: International credit card payments
/// - **Fawry**: Egyptian payment kiosks and online payments
/// - **Vodafone Cash**: Mobile wallet payments
/// - **Meeza**: Egyptian debit card payments
///
/// ## Environment Variables
///
/// Set these at compile time for security:
/// - `STRIPE_PUBLISHABLE_KEY`: Stripe publishable API key
/// - `STRIPE_SECRET_KEY`: Stripe secret API key
/// - `FAWRY_MERCHANT_CODE`: Fawry merchant identifier
/// - `FAWRY_SECURITY_KEY`: Fawry security key
/// - `VODAFONE_MERCHANT_ID`: Vodafone Cash merchant ID
/// - `VODAFONE_API_KEY`: Vodafone Cash API key
/// - `MEEZA_MERCHANT_ID`: Meeza merchant identifier
/// - `MEEZA_API_KEY`: Meeza API key
/// - `PAYMENT_CALLBACK_BASE_URL`: Base URL for payment callbacks
class PaymentConfig {
  // Stripe Configuration

  /// Stripe publishable API key for client-side payment processing.
  /// Override with `STRIPE_PUBLISHABLE_KEY` environment variable.
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_your_stripe_publishable_key',
  );

  /// Stripe secret API key for server-side payment processing.
  /// **WARNING**: Never expose this in client-side code.
  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'sk_test_your_stripe_secret_key',
  );

  // Fawry Configuration

  /// Fawry merchant code for payment processing.
  /// Override with `FAWRY_MERCHANT_CODE` environment variable.
  static const String fawryMerchantCode = String.fromEnvironment(
    'FAWRY_MERCHANT_CODE',
    defaultValue: 'your_fawry_merchant_code',
  );

  /// Fawry security key for API authentication.
  /// Override with `FAWRY_SECURITY_KEY` environment variable.
  static const String fawrySecurityKey = String.fromEnvironment(
    'FAWRY_SECURITY_KEY',
    defaultValue: 'your_fawry_security_key',
  );

  // Vodafone CASH Configuration

  /// Vodafone Cash merchant identifier.
  /// Override with `VODAFONE_MERCHANT_ID` environment variable.
  static const String vodafoneMerchantId = String.fromEnvironment(
    'VODAFONE_MERCHANT_ID',
    defaultValue: 'your_vodafone_merchant_id',
  );

  /// Vodafone Cash API key for authentication.
  /// Override with `VODAFONE_API_KEY` environment variable.
  static const String vodafoneApiKey = String.fromEnvironment(
    'VODAFONE_API_KEY',
    defaultValue: 'your_vodafone_api_key',
  );

  /// Vodafone Cash secret key for server-side operations.
  /// Secure storage required.
  static const String vodafoneSecretKey = String.fromEnvironment(
    'VODAFONE_SECRET_KEY',
    defaultValue: 'your_vodafone_secret_key',
  );

  // Meeza Configuration

  /// Meeza merchant identifier for payment processing.
  /// Override with `MEEZA_MERCHANT_ID` environment variable.
  static const String meezaMerchantId = String.fromEnvironment(
    'MEEZA_MERCHANT_ID',
    defaultValue: 'your_meeza_merchant_id',
  );

  /// Meeza terminal identifier.
  /// Override with `MEEZA_TERMINAL_ID` environment variable.
  static const String meezaTerminalId = String.fromEnvironment(
    'MEEZA_TERMINAL_ID',
    defaultValue: 'your_meeza_terminal_id',
  );

  /// Meeza API key for authentication.
  /// Override with `MEEZA_API_KEY` environment variable.
  static const String meezaApiKey = String.fromEnvironment(
    'MEEZA_API_KEY',
    defaultValue: 'your_meeza_api_key',
  );

  /// Meeza secret key for server-side operations.
  /// Secure storage required.
  static const String meezaSecretKey = String.fromEnvironment(
    'MEEZA_SECRET_KEY',
    defaultValue: 'your_meeza_secret_key',
  );

  // Payment Settings

  /// Default currency code for all transactions (ISO 4217 format).
  static const String defaultCurrency = 'EGP';

  /// Maximum time allowed for payment completion before timeout.
  static const int paymentTimeoutMinutes = 30;

  /// Whether to automatically retry failed payments.
  static const bool enablePaymentRetry = true;

  /// Maximum number of payment retry attempts.
  static const int maxPaymentRetries = 3;

  // URLs

  /// Base URL for payment processing callbacks.
  /// Override with `PAYMENT_CALLBACK_BASE_URL` environment variable.
  static const String paymentCallbackBaseUrl = String.fromEnvironment(
    'PAYMENT_CALLBACK_BASE_URL',
    defaultValue: 'https://yourapp.com/payment/callback',
  );

  // Feature Flags

  /// Enable Stripe payment processing.
  static const bool enableStripe = true;

  /// Enable Fawry kiosk payment processing.
  static const bool enableFawry = true;

  /// Enable Vodafone Cash mobile wallet payments.
  static const bool enableVodafoneCash = true;

  /// Enable Meeza debit card payments.
  static const bool enableMeeza = true;

  // Validation

  /// Check if Stripe is properly configured and enabled.
  static bool get isStripeEnabled =>
      enableStripe && stripePublishableKey != 'pk_test_your_stripe_publishable_key';

  /// Check if Fawry is properly configured and enabled.
  static bool get isFawryEnabled =>
      enableFawry && fawryMerchantCode != 'your_fawry_merchant_code';

  /// Check if Vodafone Cash is properly configured and enabled.
  static bool get isVodafoneCashEnabled =>
      enableVodafoneCash && vodafoneMerchantId != 'your_vodafone_merchant_id';

  /// Check if Meeza is properly configured and enabled.
  static bool get isMeezaEnabled =>
      enableMeeza && meezaMerchantId != 'your_meeza_merchant_id';

  /// Get a list of all currently enabled and properly configured payment providers.
  ///
  /// Returns provider identifiers like: ['stripe', 'fawry', 'vodafone_cash', 'meeza']
  static List<String> getEnabledProviders() {
    final providers = <String>[];
    if (isStripeEnabled) providers.add('stripe');
    if (isFawryEnabled) providers.add('fawry');
    if (isVodafoneCashEnabled) providers.add('vodafone_cash');
    if (isMeezaEnabled) providers.add('meeza');
    return providers;
  }

  // Environment Detection

  /// Check if the application is running in production mode.
  /// Override with `ENVIRONMENT=production` at compile time.
  static bool get isProduction =>
      const String.fromEnvironment('ENVIRONMENT') == 'production';

  /// Check if the application is running in development/testing mode.
  static bool get isDevelopment => !isProduction;
}
