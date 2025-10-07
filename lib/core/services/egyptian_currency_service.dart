import 'package:intl/intl.dart';

/// Egyptian currency service for EGP formatting and conversion
class EgyptianCurrencyService {
  static const String _currencyCode = 'EGP';
  static const String _currencySymbol = 'ج.م';
  static const String _englishSymbol = 'EGP';

  /// Format amount in Egyptian Pounds with Arabic formatting
  static String formatEGP(double amount, {bool useArabicNumerals = true}) {
    final formatter = NumberFormat.currency(
      locale: useArabicNumerals ? 'ar_EG' : 'en_US',
      symbol: useArabicNumerals ? _currencySymbol : _englishSymbol,
      decimalDigits: 2,
    );

    return formatter.format(amount);
  }

  /// Format amount in Egyptian Pounds for compact display
  static String formatEGPCompact(double amount, {bool useArabicNumerals = true}) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M $_currencySymbol';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K $_currencySymbol';
    } else {
      return formatEGP(amount, useArabicNumerals: useArabicNumerals);
    }
  }

  /// Format price range for restaurants
  static String formatPriceRange(double minPrice, double maxPrice, {bool useArabicNumerals = true}) {
    if (minPrice == maxPrice) {
      return formatEGP(minPrice, useArabicNumerals: useArabicNumerals);
    } else {
      return '${formatEGP(minPrice, useArabicNumerals: useArabicNumerals)} - ${formatEGP(maxPrice, useArabicNumerals: useArabicNumerals)}';
    }
  }

  /// Convert USD to EGP (using approximate current rate)
  static double usdToEGP(double usdAmount) {
    // Current approximate rate: 1 USD ≈ 48 EGP (as of 2024)
    const exchangeRate = 48;
    return usdAmount * exchangeRate;
  }

  /// Convert EUR to EGP (using approximate current rate)
  static double eurToEGP(double eurAmount) {
    // Current approximate rate: 1 EUR ≈ 52 EGP (as of 2024)
    const exchangeRate = 52;
    return eurAmount * exchangeRate;
  }

  /// Convert SAR to EGP (using approximate current rate)
  static double sarToEGP(double sarAmount) {
    // Current approximate rate: 1 SAR ≈ 12.8 EGP (as of 2024)
    const exchangeRate = 12.8;
    return sarAmount * exchangeRate;
  }

  /// Convert AED to EGP (using approximate current rate)
  static double aedToEGP(double aedAmount) {
    // Current approximate rate: 1 AED ≈ 13.07 EGP (as of 2024)
    const exchangeRate = 13.07;
    return aedAmount * exchangeRate;
  }

  /// Convert EGP to other currencies
  static double egpToUSD(double egpAmount) {
    const exchangeRate = 48;
    return egpAmount / exchangeRate;
  }

  static double egpToEUR(double egpAmount) {
    const exchangeRate = 52;
    return egpAmount / exchangeRate;
  }

  static double egpToSAR(double egpAmount) {
    const exchangeRate = 12.8;
    return egpAmount / exchangeRate;
  }

  static double egpToAED(double egpAmount) {
    const exchangeRate = 13.07;
    return egpAmount / exchangeRate;
  }

  /// Format currency with exchange rate information
  static String formatWithExchangeRate(double amount, String targetCurrency, {bool useArabicNumerals = true}) {
    double convertedAmount;
    String symbol;

    switch (targetCurrency.toUpperCase()) {
      case 'USD':
        convertedAmount = egpToUSD(amount);
        symbol = r'$';
        break;
      case 'EUR':
        convertedAmount = egpToEUR(amount);
        symbol = '€';
        break;
      case 'SAR':
        convertedAmount = egpToSAR(amount);
        symbol = 'ر.س';
        break;
      case 'AED':
        convertedAmount = egpToAED(amount);
        symbol = 'د.إ';
        break;
      default:
        return formatEGP(amount, useArabicNumerals: useArabicNumerals);
    }

    final formattedAmount = NumberFormat.currency(
      locale: useArabicNumerals ? 'ar_EG' : 'en_US',
      symbol: symbol,
      decimalDigits: 2,
    ).format(convertedAmount);

    return '$formattedAmount (${formatEGP(amount, useArabicNumerals: useArabicNumerals)})';
  }

  /// Get currency exchange rates (for display purposes)
  static Map<String, double> getExchangeRates() => {
      'USD': 48.0,
      'EUR': 52.0,
      'SAR': 12.8,
      'AED': 13.07,
      'EGP': 1.0,
    };

  /// Format delivery fee with proper Egyptian context
  static String formatDeliveryFee(double fee, {bool useArabicNumerals = true}) {
    if (fee == 0) {
      return useArabicNumerals ? 'توصيل مجاني' : 'Free Delivery';
    } else if (fee < 10) {
      return '${useArabicNumerals ? 'توصيل رخيص' : 'Cheap Delivery'} • ${formatEGP(fee, useArabicNumerals: useArabicNumerals)}';
    } else {
      return formatEGP(fee, useArabicNumerals: useArabicNumerals);
    }
  }

  /// Format minimum order amount
  static String formatMinimumOrder(double amount, {bool useArabicNumerals = true}) => '${useArabicNumerals ? 'الحد الأدنى' : 'Min. Order'}: ${formatEGP(amount, useArabicNumerals: useArabicNumerals)}';

  /// Format discount amount
  static String formatDiscount(double originalPrice, double discountAmount, {bool useArabicNumerals = true}) {
    final discountPercentage = ((discountAmount / originalPrice) * 100).round();
    return '${useArabicNumerals ? 'خصم' : 'Save'} ${formatEGP(discountAmount, useArabicNumerals: useArabicNumerals)} ($discountPercentage%)';
  }

  /// Format price per item (for menu items)
  static String formatItemPrice(double price, {bool useArabicNumerals = true}) => formatEGP(price, useArabicNumerals: useArabicNumerals);

  /// Format total order amount with breakdown
  static String formatOrderTotal(double subtotal, double deliveryFee, double tax, {bool useArabicNumerals = true}) {
    final total = subtotal + deliveryFee + tax;

    if (useArabicNumerals) {
      return '''
المجموع الفرعي: ${formatEGP(subtotal)}
رسوم التوصيل: ${formatEGP(deliveryFee)}
الضريبة: ${formatEGP(tax)}
الإجمالي: ${formatEGP(total)}
      '''.trim();
    } else {
      return '''
Subtotal: ${formatEGP(subtotal, useArabicNumerals: false)}
Delivery Fee: ${formatEGP(deliveryFee, useArabicNumerals: false)}
Tax: ${formatEGP(tax, useArabicNumerals: false)}
Total: ${formatEGP(total, useArabicNumerals: false)}
      '''.trim();
    }
  }

  /// Check if amount is considered expensive in Egyptian market
  static bool isExpensive(double amount) {
    // In Egyptian market, consider amounts above 500 EGP as expensive for food delivery
    return amount > 500;
  }

  /// Check if amount is considered budget-friendly in Egyptian market
  static bool isBudgetFriendly(double amount) {
    // In Egyptian market, consider amounts below 100 EGP as budget-friendly
    return amount < 100;
  }

  /// Get price category for Egyptian market
  static String getPriceCategory(double amount, {bool useArabicNumerals = true}) {
    if (isBudgetFriendly(amount)) {
      return useArabicNumerals ? 'اقتصادي' : 'Budget';
    } else if (isExpensive(amount)) {
      return useArabicNumerals ? 'فاخر' : 'Premium';
    } else {
      return useArabicNumerals ? 'متوسط' : 'Moderate';
    }
  }

  /// Format cash on delivery message
  static String getCashOnDeliveryMessage({bool useArabicNumerals = true}) => useArabicNumerals
        ? 'ادفع نقداً عند التسليم'
        : 'Pay with cash on delivery';

  /// Format digital wallet message
  static String getDigitalWalletMessage({bool useArabicNumerals = true}) => useArabicNumerals
        ? 'ادفع بمحفظتك الرقمية'
        : 'Pay with your digital wallet';

  /// Validate Egyptian phone number for mobile payments
  static bool isValidEgyptianPhoneNumber(String phoneNumber) {
    // Egyptian phone numbers: +20 or 20 followed by 10 digits
    // Mobile numbers start with 10, 11, 12, 15
    final egyptianPhoneRegex = RegExp(r'^(?:\+?20|0)?1[0-2,5]\d{8}$');
    return egyptianPhoneRegex.hasMatch(phoneNumber.replaceAll(' ', ''));
  }

  /// Format Egyptian phone number for display
  static String formatEgyptianPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('20')) {
      // International format
      return '+${cleanNumber.substring(0, 2)} ${cleanNumber.substring(2, 4)} ${cleanNumber.substring(4, 7)} ${cleanNumber.substring(7)}';
    } else if (cleanNumber.startsWith('0')) {
      // Local format
      return '${cleanNumber.substring(0, 1)}${cleanNumber.substring(1, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
    } else {
      // Assume 11-digit mobile number
      return '${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
    }
  }
}

/// Extension to add currency formatting to double values
extension EgyptianCurrencyExtension on double {
  /// Format as EGP currency
  String toEGP({bool useArabicNumerals = true}) => EgyptianCurrencyService.formatEGP(this, useArabicNumerals: useArabicNumerals);

  /// Format as compact EGP currency
  String toEGPCompact({bool useArabicNumerals = true}) => EgyptianCurrencyService.formatEGPCompact(this, useArabicNumerals: useArabicNumerals);

  /// Check if expensive in Egyptian market
  bool get isExpensiveInEgypt => EgyptianCurrencyService.isExpensive(this);

  /// Check if budget-friendly in Egyptian market
  bool get isBudgetFriendlyInEgypt => EgyptianCurrencyService.isBudgetFriendly(this);

  /// Get price category for Egyptian market
  String getPriceCategoryInEgypt({bool useArabicNumerals = true}) => EgyptianCurrencyService.getPriceCategory(this, useArabicNumerals: useArabicNumerals);
}

/// Extension to add phone number formatting to strings
extension EgyptianPhoneExtension on String {
  /// Check if valid Egyptian phone number
  bool get isValidEgyptianPhone => EgyptianCurrencyService.isValidEgyptianPhoneNumber(this);

  /// Format as Egyptian phone number
  String get formatEgyptianPhone => EgyptianCurrencyService.formatEgyptianPhoneNumber(this);
}