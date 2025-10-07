class PaymentConfig {
  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_your_stripe_publishable_key',
  );

  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'sk_test_your_stripe_secret_key',
  );

  // Fawry Configuration
  static const String fawryMerchantCode = String.fromEnvironment(
    'FAWRY_MERCHANT_CODE',
    defaultValue: 'your_fawry_merchant_code',
  );

  static const String fawrySecurityKey = String.fromEnvironment(
    'FAWRY_SECURITY_KEY',
    defaultValue: 'your_fawry_security_key',
  );

  // Vodafone CASH Configuration
  static const String vodafoneMerchantId = String.fromEnvironment(
    'VODAFONE_MERCHANT_ID',
    defaultValue: 'your_vodafone_merchant_id',
  );

  static const String vodafoneApiKey = String.fromEnvironment(
    'VODAFONE_API_KEY',
    defaultValue: 'your_vodafone_api_key',
  );

  static const String vodafoneSecretKey = String.fromEnvironment(
    'VODAFONE_SECRET_KEY',
    defaultValue: 'your_vodafone_secret_key',
  );

  // Meeza Configuration
  static const String meezaMerchantId = String.fromEnvironment(
    'MEEZA_MERCHANT_ID',
    defaultValue: 'your_meeza_merchant_id',
  );

  static const String meezaTerminalId = String.fromEnvironment(
    'MEEZA_TERMINAL_ID',
    defaultValue: 'your_meeza_terminal_id',
  );

  static const String meezaApiKey = String.fromEnvironment(
    'MEEZA_API_KEY',
    defaultValue: 'your_meeza_api_key',
  );

  static const String meezaSecretKey = String.fromEnvironment(
    'MEEZA_SECRET_KEY',
    defaultValue: 'your_meeza_secret_key',
  );

  // Payment Settings
  static const String defaultCurrency = 'EGP';
  static const int paymentTimeoutMinutes = 30;
  static const bool enablePaymentRetry = true;
  static const int maxPaymentRetries = 3;

  // URLs
  static const String paymentCallbackBaseUrl = String.fromEnvironment(
    'PAYMENT_CALLBACK_BASE_URL',
    defaultValue: 'https://yourapp.com/payment/callback',
  );

  // Feature Flags
  static const bool enableStripe = true;
  static const bool enableFawry = true;
  static const bool enableVodafoneCash = true;
  static const bool enableMeeza = true;

  // Validation
  static bool get isStripeEnabled => enableStripe && stripePublishableKey != 'pk_test_your_stripe_publishable_key';
  static bool get isFawryEnabled => enableFawry && fawryMerchantCode != 'your_fawry_merchant_code';
  static bool get isVodafoneCashEnabled => enableVodafoneCash && vodafoneMerchantId != 'your_vodafone_merchant_id';
  static bool get isMeezaEnabled => enableMeeza && meezaMerchantId != 'your_meeza_merchant_id';

  // Get enabled payment providers
  static List<String> getEnabledProviders() {
    final providers = <String>[];
    if (isStripeEnabled) providers.add('stripe');
    if (isFawryEnabled) providers.add('fawry');
    if (isVodafoneCashEnabled) providers.add('vodafone_cash');
    if (isMeezaEnabled) providers.add('meeza');
    return providers;
  }

  // Environment detection
  static bool get isProduction => const String.fromEnvironment('ENVIRONMENT') == 'production';
  static bool get isDevelopment => !isProduction;
}