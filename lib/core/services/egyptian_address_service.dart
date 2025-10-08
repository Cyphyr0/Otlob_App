import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

/// Egyptian address service for validation and autocomplete
class EgyptianAddressService {
  static List<EgyptianGovernorate> _governorates = [];
  static bool _isInitialized = false;

  /// Initialize the address service by loading governorates data
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/egyptian_governorates.json');
      final data = json.decode(jsonString) as List<dynamic>;

      _governorates = data.map((gov) => EgyptianGovernorate.fromJson(gov)).toList();
      _isInitialized = true;
    } catch (e) {
      // Fallback to hardcoded data if JSON file doesn't exist
      _loadFallbackGovernorates();
    }
  }

  /// Get all Egyptian governorates
  static List<EgyptianGovernorate> getGovernorates() {
    if (!_isInitialized) {
      _loadFallbackGovernorates();
    }
    return _governorates;
  }

  /// Get governorate by name
  static EgyptianGovernorate? getGovernorateByName(String name) {
    if (!_isInitialized) {
      _loadFallbackGovernorates();
    }
    return _governorates.where((gov) =>
      gov.name == name ||
      gov.nameEn == name ||
      gov.districts.any((district) => district.name == name || district.nameEn == name)
    ).firstOrNull;
  }

  /// Search governorates and districts
  static List<AddressSearchResult> searchAddresses(String query) {
    if (!_isInitialized) {
      _loadFallbackGovernorates();
    }

    final results = <AddressSearchResult>[];
    final queryLower = query.toLowerCase();

    for (final governorate in _governorates) {
      // Search in governorate names
      if (governorate.name.toLowerCase().contains(queryLower) ||
          governorate.nameEn.toLowerCase().contains(queryLower)) {
        results.add(AddressSearchResult(
          type: AddressType.governorate,
          name: governorate.name,
          nameEn: governorate.nameEn,
          governorate: governorate,
        ));
      }

      // Search in district names
      for (final district in governorate.districts) {
        if (district.name.toLowerCase().contains(queryLower) ||
            district.nameEn.toLowerCase().contains(queryLower)) {
          results.add(AddressSearchResult(
            type: AddressType.district,
            name: district.name,
            nameEn: district.nameEn,
            governorate: governorate,
            district: district,
          ));
        }
      }
    }

    return results.take(10).toList(); // Limit results
  }

  /// Validate Egyptian address
  static AddressValidationResult validateAddress(EgyptianAddress address) {
    final errors = <String>[];

    // Required fields validation
    if (address.governorate.isEmpty) {
      errors.add('المحافظة مطلوبة');
    }

    if (address.city.isEmpty) {
      errors.add('المدينة مطلوبة');
    }

    if (address.street.isEmpty) {
      errors.add('اسم الشارع مطلوب');
    }

    if (address.building.isEmpty) {
      errors.add('رقم المبنى مطلوب');
    }

    // Format validation
    if (address.phone.isNotEmpty && !isValidEgyptianPhoneNumber(address.phone)) {
      errors.add('رقم الهاتف غير صحيح');
    }

    if (address.postalCode.isNotEmpty && !isValidPostalCode(address.postalCode)) {
      errors.add('الرمز البريدي غير صحيح');
    }

    // Length validation
    if (address.street.length < 3) {
      errors.add('اسم الشارع يجب أن يكون 3 أحرف على الأقل');
    }

    if (address.building.isEmpty) {
      errors.add('رقم المبنى مطلوب');
    }

    return AddressValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate Egyptian phone number
  static bool isValidEgyptianPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Egyptian phone number patterns:
    // +20 10/11/12/15 XXXXXXXX (11 digits)
    // 010/011/012/015 XXXXXXXX (11 digits)
    // 10/11/12/15 XXXXXXXX (10 digits)

    if (cleanNumber.length == 11) {
      // 010, 011, 012, 015 prefixes
      return cleanNumber.startsWith('010') ||
             cleanNumber.startsWith('011') ||
             cleanNumber.startsWith('012') ||
             cleanNumber.startsWith('015');
    } else if (cleanNumber.length == 13 && cleanNumber.startsWith('20')) {
      // +20 10/11/12/15 XXXXXXXX
      final withoutCountryCode = cleanNumber.substring(2);
      return withoutCountryCode.startsWith('10') ||
             withoutCountryCode.startsWith('11') ||
             withoutCountryCode.startsWith('12') ||
             withoutCountryCode.startsWith('15');
    } else if (cleanNumber.length == 10) {
      // 10/11/12/15 XXXXXXXX (without leading 0)
      return cleanNumber.startsWith('10') ||
             cleanNumber.startsWith('11') ||
             cleanNumber.startsWith('12') ||
             cleanNumber.startsWith('15');
    }

    return false;
  }

  /// Validate Egyptian postal code
  static bool isValidPostalCode(String postalCode) {
    // Egyptian postal codes are 5 digits
    final regex = RegExp(r'^\d{5}$');
    return regex.hasMatch(postalCode);
  }

  /// Format Egyptian address for display
  static String formatAddress(EgyptianAddress address, {bool useArabic = true}) {
    final parts = <String>[];

    if (address.apartment.isNotEmpty) {
      parts.add(useArabic ? 'شقة ${address.apartment}' : 'Apt ${address.apartment}');
    }

    if (address.floor.isNotEmpty) {
      parts.add(useArabic ? 'الدور ${address.floor}' : 'Floor ${address.floor}');
    }

    parts.add(useArabic ? 'مبنى ${address.building}' : 'Building ${address.building}');

    if (address.street.isNotEmpty) {
      parts.add(useArabic ? 'شارع ${address.street}' : '${address.street} St');
    }

    if (address.district.isNotEmpty) {
      parts.add(useArabic ? address.district : address.district);
    }

    if (address.city.isNotEmpty) {
      parts.add(useArabic ? address.city : address.city);
    }

    if (address.governorate.isNotEmpty) {
      parts.add(useArabic ? address.governorate : address.governorate);
    }

    return parts.join(useArabic ? '، ' : ', ');
  }

  /// Get delivery time estimate based on address
  static String getDeliveryTimeEstimate(EgyptianAddress address) {
    // Simplified delivery time estimation based on governorate
    final governorate = getGovernorateByName(address.governorate);

    if (governorate != null) {
      // Cairo and Giza typically have faster delivery
      if (governorate.name.contains('القاهرة') || governorate.name.contains('الجيزة')) {
        return '15-30 دقيقة';
      }
      // Alexandria and other major cities
      else if (governorate.name.contains('الإسكندرية')) {
        return '20-40 دقيقة';
      }
      // Other governorates
      else {
        return '30-60 دقيقة';
      }
    }

    return '30-45 دقيقة'; // Default estimate
  }

  /// Check if address is in delivery zone (simplified)
  static bool isInDeliveryZone(EgyptianAddress address) {
    // For now, assume all Egyptian addresses are in delivery zone
    // In production, this would check against actual delivery zones
    return true;
  }

  static void _loadFallbackGovernorates() {
    _governorates = [
      const EgyptianGovernorate(
        name: 'القاهرة',
        nameEn: 'Cairo',
        districts: [
          District(name: 'وسط البلد', nameEn: 'Downtown'),
          District(name: 'الزمالك', nameEn: 'Zamalek'),
          District(name: 'المهندسين', nameEn: 'Mohandessin'),
          District(name: 'مدينة نصر', nameEn: 'Nasr City'),
          District(name: 'التجمع الخامس', nameEn: 'New Cairo'),
          District(name: 'الشروق', nameEn: 'El Shorouk'),
          District(name: 'العبور', nameEn: 'El Obour'),
          District(name: 'المقطم', nameEn: 'El Mokattam'),
          District(name: 'حلوان', nameEn: 'Helwan'),
          District(name: 'المعادي', nameEn: 'Maadi'),
        ],
      ),
      const EgyptianGovernorate(
        name: 'الجيزة',
        nameEn: 'Giza',
        districts: [
          District(name: 'الهرم', nameEn: 'El Haram'),
          District(name: 'فيصل', nameEn: 'Faisal'),
          District(name: 'الدقي', nameEn: 'Dokki'),
          District(name: 'العجوزة', nameEn: 'Agouza'),
          District(name: 'إمبابة', nameEn: 'Imbaba'),
          District(name: 'الوراق', nameEn: 'El Warraq'),
          District(name: 'أوسيم', nameEn: 'Oseem'),
          District(name: 'كرداسة', nameEn: 'Kerdasa'),
        ],
      ),
      const EgyptianGovernorate(
        name: 'الإسكندرية',
        nameEn: 'Alexandria',
        districts: [
          District(name: 'وسط المدينة', nameEn: 'Downtown'),
          District(name: 'المنشية', nameEn: 'El Mansheya'),
          District(name: 'كامب شيزار', nameEn: 'Camp Caesar'),
          District(name: 'سموحة', nameEn: 'Smooha'),
          District(name: 'سبورتنج', nameEn: 'Sporting'),
          District(name: 'ميامي', nameEn: 'Miami'),
          District(name: 'ستانلي', nameEn: 'Stanley'),
          District(name: 'أبو قير', nameEn: 'Abu Qir'),
        ],
      ),
      const EgyptianGovernorate(
        name: 'الشرقية',
        nameEn: 'Sharqia',
        districts: [
          District(name: 'الزقازيق', nameEn: 'Zagazig'),
          District(name: 'بلبيس', nameEn: 'Belbeis'),
          District(name: 'منيا القمح', nameEn: 'Minya El Qamh'),
          District(name: 'أبو حماد', nameEn: 'Abu Hammad'),
          District(name: 'فاقوس', nameEn: 'Faqous'),
          District(name: 'الحسينية', nameEn: 'El Husseiniya'),
          District(name: 'ديرب نجم', nameEn: 'Deyerb Negm'),
          District(name: 'كفر صقر', nameEn: 'Kafr Saqr'),
        ],
      ),
      const EgyptianGovernorate(
        name: 'الدقهلية',
        nameEn: 'Dakahlia',
        districts: [
          District(name: 'المنصورة', nameEn: 'Mansoura'),
          District(name: 'طلخا', nameEn: 'Talkha'),
          District(name: 'أجا', nameEn: 'Aga'),
          District(name: 'ميت غمر', nameEn: 'Mit Ghamr'),
          District(name: 'دكرنس', nameEn: 'Dekernes'),
          District(name: 'شربين', nameEn: 'Sherbin'),
          District(name: 'بلقاس', nameEn: 'Belqas'),
          District(name: 'جمصة', nameEn: 'Gamasa'),
        ],
      ),
    ];
    _isInitialized = true;
  }
}

/// Egyptian address model
class EgyptianAddress {

  const EgyptianAddress({
    required this.governorate,
    required this.city,
    required this.street, required this.building, this.district = '',
    this.floor = '',
    this.apartment = '',
    this.postalCode = '',
    this.phone = '',
    this.specialInstructions = '',
  });

  /// Create address from map
  factory EgyptianAddress.fromMap(Map<String, dynamic> map) => EgyptianAddress(
      governorate: map['governorate'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      street: map['street'] ?? '',
      building: map['building'] ?? '',
      floor: map['floor'] ?? '',
      apartment: map['apartment'] ?? '',
      postalCode: map['postalCode'] ?? '',
      phone: map['phone'] ?? '',
      specialInstructions: map['specialInstructions'] ?? '',
    );
  final String governorate;
  final String city;
  final String district;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String postalCode;
  final String phone;
  final String specialInstructions;

  /// Convert address to map
  Map<String, dynamic> toMap() => {
      'governorate': governorate,
      'city': city,
      'district': district,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'postalCode': postalCode,
      'phone': phone,
      'specialInstructions': specialInstructions,
    };

  /// Get formatted address string
  String get formattedAddress => EgyptianAddressService.formatAddress(this);

  /// Validate this address
  AddressValidationResult validate() => EgyptianAddressService.validateAddress(this);

  /// Check if address is in delivery zone
  bool get isInDeliveryZone => EgyptianAddressService.isInDeliveryZone(this);

  /// Get delivery time estimate
  String get deliveryTimeEstimate => EgyptianAddressService.getDeliveryTimeEstimate(this);

  /// Create copy with modified fields
  EgyptianAddress copyWith({
    String? governorate,
    String? city,
    String? district,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? postalCode,
    String? phone,
    String? specialInstructions,
  }) => EgyptianAddress(
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
}

/// Egyptian governorate model
class EgyptianGovernorate {

  const EgyptianGovernorate({
    required this.name,
    required this.nameEn,
    required this.districts,
  });

  factory EgyptianGovernorate.fromJson(Map<String, dynamic> json) => EgyptianGovernorate(
      name: json['name'] ?? '',
      nameEn: json['nameEn'] ?? '',
      districts: (json['districts'] as List<dynamic>?)
          ?.map((district) => District.fromJson(district))
          .toList() ?? [],
    );
  final String name;
  final String nameEn;
  final List<District> districts;
}

/// District model
class District {

  const District({
    required this.name,
    required this.nameEn,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
      name: json['name'] ?? '',
      nameEn: json['nameEn'] ?? '',
    );
  final String name;
  final String nameEn;
}

/// Address search result
class AddressSearchResult {

  const AddressSearchResult({
    required this.type,
    required this.name,
    required this.nameEn,
    this.governorate,
    this.district,
  });
  final AddressType type;
  final String name;
  final String nameEn;
  final EgyptianGovernorate? governorate;
  final District? district;
}

/// Address type enum
enum AddressType {
  governorate,
  district,
  city,
}

/// Address validation result
class AddressValidationResult {

  const AddressValidationResult({
    required this.isValid,
    required this.errors,
  });
  final bool isValid;
  final List<String> errors;
}

/// Extension to get first item or null
extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}