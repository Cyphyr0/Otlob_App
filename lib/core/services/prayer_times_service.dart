import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

/// Islamic prayer times service for Egyptian market
class PrayerTimesService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';
  final Dio _dio = Dio();

  /// Get prayer times for current location
  Future<PrayerTimesModel?> getPrayerTimesForCurrentLocation() async {
    try {
      // Get current location
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return await getPrayerTimesForLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      // Fallback to Cairo coordinates if location fails
      return getPrayerTimesForLocation(30.0444, 31.2357);
    }
  }

  /// Get prayer times for specific location
  Future<PrayerTimesModel?> getPrayerTimesForLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final response = await _dio.get(
        '$_baseUrl/timings/$date',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 5, // Egyptian General Authority of Survey
          'school': 0, // Shafi
        },
      );

      if (response.statusCode == 200) {
        return PrayerTimesModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
      return null;
    }
  }

  /// Get prayer times for specific date and location
  Future<PrayerTimesModel?> getPrayerTimesForDate(
    DateTime date,
    double latitude,
    double longitude,
  ) async {
    try {
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      final response = await _dio.get(
        '$_baseUrl/timings/$formattedDate',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 5, // Egyptian General Authority of Survey
          'school': 0, // Shafi
        },
      );

      if (response.statusCode == 200) {
        return PrayerTimesModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching prayer times for date: $e');
      return null;
    }
  }

  /// Calculate time until next prayer
  TimeUntilNextPrayer getTimeUntilNextPrayer(PrayerTimesModel prayerTimes) {
    final now = DateTime.now();
    final today = DateFormat('dd-MM-yyyy').format(now);

    // Parse prayer times for today
    final fajr = _parseTime(prayerTimes.timings.fajr, today);
    final dhuhr = _parseTime(prayerTimes.timings.dhuhr, today);
    final asr = _parseTime(prayerTimes.timings.asr, today);
    final maghrib = _parseTime(prayerTimes.timings.maghrib, today);
    final isha = _parseTime(prayerTimes.timings.isha, today);

    // Find next prayer
    final prayers = [
      {'name': 'Fajr', 'time': fajr},
      {'name': 'Dhuhr', 'time': dhuhr},
      {'name': 'Asr', 'time': asr},
      {'name': 'Maghrib', 'time': maghrib},
      {'name': 'Isha', 'time': isha},
    ];

    // If all prayers today have passed, get tomorrow's Fajr
    final nextPrayer = <String, DateTime>{};
    for (final prayer in prayers) {
      final prayerTime = prayer['time'] as DateTime;
      if (prayerTime.isAfter(now)) {
        nextPrayer[prayer['name'] as String] = prayerTime;
        break;
      }
    }

    if (nextPrayer.isEmpty) {
      // All prayers passed, get tomorrow's Fajr
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowFormatted = DateFormat('dd-MM-yyyy').format(tomorrow);
      final tomorrowFajr = _parseTime(prayerTimes.timings.fajr, tomorrowFormatted);
      nextPrayer['Fajr'] = tomorrowFajr;
    }

    final nextPrayerName = nextPrayer.keys.first;
    final nextPrayerTime = nextPrayer.values.first;
    final difference = nextPrayerTime.difference(now);

    return TimeUntilNextPrayer(
      prayerName: nextPrayerName,
      timeUntil: difference,
      nextPrayerTime: nextPrayerTime,
    );
  }

  DateTime _parseTime(String time, String date) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);

    final dateParts = date.split('-');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);

    return DateTime(year, month, day, hour, minute);
  }
}

/// Prayer times data model
class PrayerTimesModel {

  PrayerTimesModel({
    required this.timings,
    required this.date,
    required this.meta,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) => PrayerTimesModel(
      timings: Timings.fromJson(json['timings']),
      date: Date.fromJson(json['date']),
      meta: Meta.fromJson(json['meta']),
    );
  final Timings timings;
  final Date date;
  final Meta meta;
}

class Timings {

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
      fajr: json['Fajr'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      sunset: json['Sunset'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
      imsak: json['Imsak'],
      midnight: json['Midnight'],
    );
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
}

class Date {

  Date({
    required this.readable,
    required this.timestamp,
    required this.hijri,
    required this.gregorian,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
      readable: json['readable'],
      timestamp: json['timestamp'],
      hijri: Hijri.fromJson(json['hijri']),
      gregorian: Gregorian.fromJson(json['gregorian']),
    );
  final String readable;
  final String timestamp;
  final Hijri hijri;
  final Gregorian gregorian;
}

class Hijri {

  Hijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
  });

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: json['weekday'],
      month: json['month'],
      year: json['year'],
      designation: json['designation'],
      holidays: List<String>.from(json['holidays'] ?? []),
    );
  final String date;
  final String format;
  final String day;
  final String weekday;
  final String month;
  final String year;
  final String designation;
  final List<String> holidays;
}

class Gregorian {

  Gregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: json['weekday'],
      month: json['month'],
      year: json['year'],
      designation: json['designation'],
    );
  final String date;
  final String format;
  final String day;
  final String weekday;
  final String month;
  final String year;
  final String designation;
}

class Meta {

  Meta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      timezone: json['timezone'],
      method: json['method'],
      latitudeAdjustmentMethod: json['latitudeAdjustmentMethod'],
      midnightMode: json['midnightMode'],
      school: json['school'],
      offset: Map<String, double>.from(json['offset'] ?? {}),
    );
  final double latitude;
  final double longitude;
  final String timezone;
  final String method;
  final String latitudeAdjustmentMethod;
  final String midnightMode;
  final String school;
  final Map<String, double> offset;
}

/// Model for time until next prayer
class TimeUntilNextPrayer {

  TimeUntilNextPrayer({
    required this.prayerName,
    required this.timeUntil,
    required this.nextPrayerTime,
  });
  final String prayerName;
  final Duration timeUntil;
  final DateTime nextPrayerTime;

  String get formattedTimeUntil {
    if (timeUntil.inHours > 0) {
      return '${timeUntil.inHours}ساعة و ${timeUntil.inMinutes.remainder(60)}دقيقة';
    } else {
      return '${timeUntil.inMinutes}دقيقة';
    }
  }
}