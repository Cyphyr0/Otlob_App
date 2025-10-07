import 'package:intl/intl.dart';

/// Hijri (Islamic) calendar service for Egyptian market
class HijriCalendarService {
  /// Convert Gregorian date to Hijri date
  static HijriDate gregorianToHijri(DateTime gregorianDate) {
    // This is a simplified conversion algorithm
    // For production use, consider using a more accurate library like hijri_calendar

    // Known Hijri dates for reference
    final knownConversions = {
      DateTime(2024, 1, 1): const HijriDate(1445, 6, 19), // Approximate
      DateTime(2024, 7, 1): const HijriDate(1445, 12, 24), // Approximate
      DateTime(2025, 1, 1): const HijriDate(1446, 6, 29), // Approximate
      DateTime(2025, 7, 1): const HijriDate(1446, 12, 4),  // Approximate
    };

    // Find closest known date and calculate
    final closestDate = _findClosestDate(gregorianDate, knownConversions.keys);
    final knownHijri = knownConversions[closestDate]!;

    final difference = gregorianDate.difference(closestDate).inDays;

    // Approximate: 1 Hijri month ≈ 29.53 days
    final hijriDays = (difference / 29.53).round();

    return _addHijriDays(knownHijri, hijriDays);
  }

  /// Convert Hijri date to Gregorian date
  static DateTime hijriToGregorian(HijriDate hijriDate) {
    // This is a simplified conversion
    // For production use, consider using a more accurate library

    // Approximate base date: Hijri 1445-01-01 ≈ Gregorian 2023-07-19
    final baseGregorian = DateTime(2023, 7, 19);
    final baseHijri = const HijriDate(1445, 1, 1);

    final hijriDays = _hijriDateToDays(hijriDate) - _hijriDateToDays(baseHijri);
    return baseGregorian.add(Duration(days: (hijriDays * 29.53).round()));
  }

  /// Get current Hijri date
  static HijriDate getCurrentHijriDate() {
    return gregorianToHijri(DateTime.now());
  }

  /// Format Hijri date in Arabic
  static String formatHijriDateArabic(HijriDate hijriDate) {
    final monthNames = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];

    return '${hijriDate.day} ${monthNames[hijriDate.month - 1]} ${hijriDate.year} هـ';
  }

  /// Format Hijri date in English
  static String formatHijriDateEnglish(HijriDate hijriDate) {
    final monthNames = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Shaban',
      'Ramadan', 'Shawwal', 'Dhu al-Qadah', 'Dhu al-Hijjah'
    ];

    return '${hijriDate.day} ${monthNames[hijriDate.month - 1]} ${hijriDate.year} AH';
  }

  /// Get Islamic month name in Arabic
  static String getIslamicMonthNameArabic(int month) {
    final monthNames = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    }
    return 'شهر غير صحيح';
  }

  /// Get Islamic month name in English
  static String getIslamicMonthNameEnglish(int month) {
    final monthNames = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Shaban',
      'Ramadan', 'Shawwal', 'Dhu al-Qadah', 'Dhu al-Hijjah'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    }
    return 'Invalid Month';
  }

  /// Check if current month is Ramadan
  static bool isRamadan() {
    final currentHijri = getCurrentHijriDate();
    return currentHijri.month == 9; // Ramadan is month 9
  }

  /// Check if current month is a sacred month
  static bool isSacredMonth() {
    final currentHijri = getCurrentHijriDate();
    // Sacred months: Muharram (1), Rajab (7), Dhu al-Qadah (11), Dhu al-Hijjah (12)
    return [1, 7, 11, 12].contains(currentHijri.month);
  }

  /// Get days until Ramadan
  static int getDaysUntilRamadan() {
    final currentHijri = getCurrentHijriDate();

    if (currentHijri.month == 9) return 0; // Already Ramadan

    if (currentHijri.month < 9) {
      // Ramadan is later this year
      return (9 - currentHijri.month) * 29; // Approximate
    } else {
      // Ramadan is next year
      return (12 - currentHijri.month + 9) * 29; // Approximate
    }
  }

  static DateTime _findClosestDate(DateTime target, Iterable<DateTime> dates) {
    DateTime closest = dates.first;
    int minDifference = (target.difference(closest)).inDays.abs();

    for (final date in dates) {
      final difference = (target.difference(date)).inDays.abs();
      if (difference < minDifference) {
        minDifference = difference;
        closest = date;
      }
    }

    return closest;
  }

  static HijriDate _addHijriDays(HijriDate hijriDate, int days) {
    int totalDays = _hijriDateToDays(hijriDate) + days;
    return _daysToHijriDate(totalDays);
  }

  static int _hijriDateToDays(HijriDate hijriDate) {
    // Simplified conversion - in production use a proper algorithm
    return hijriDate.year * 354 + hijriDate.month * 29 + hijriDate.day;
  }

  static HijriDate _daysToHijriDate(int totalDays) {
    // Simplified conversion - in production use a proper algorithm
    final year = (totalDays / 354).floor();
    final remainingDays = totalDays % 354;
    final month = (remainingDays / 29).floor() + 1;
    final day = (remainingDays % 29) + 1;

    return HijriDate(year, month > 12 ? month % 12 : month, day);
  }
}

/// Hijri date model
class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate(this.year, this.month, this.day);

  @override
  String toString() {
    return '$day/$month/$year';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HijriDate &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}

/// Extension to add Hijri date formatting to DateTime
extension HijriDateTimeExtension on DateTime {
  /// Get Hijri date for this Gregorian date
  HijriDate get toHijri => HijriCalendarService.gregorianToHijri(this);

  /// Format as Hijri date in Arabic
  String formatHijriArabic() {
    final hijri = toHijri;
    return HijriCalendarService.formatHijriDateArabic(hijri);
  }

  /// Format as Hijri date in English
  String formatHijriEnglish() {
    final hijri = toHijri;
    return HijriCalendarService.formatHijriDateEnglish(hijri);
  }
}

/// Extension to add Hijri date parsing to String
extension HijriStringExtension on String {
  /// Parse Hijri date from Arabic format (e.g., "15 رمضان 1445 هـ")
  HijriDate? parseHijriArabic() {
    try {
      final parts = split(' ');
      if (parts.length >= 3) {
        final day = int.parse(parts[0]);
        final monthName = parts[1];
        final year = int.parse(parts[2]);

        final monthNames = [
          'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
          'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
          'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
        ];

        final month = monthNames.indexOf(monthName) + 1;
        if (month > 0) {
          return HijriDate(year, month, day);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}