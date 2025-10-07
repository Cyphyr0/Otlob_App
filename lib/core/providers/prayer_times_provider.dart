import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../services/prayer_times_service.dart';

/// Provider for prayer times state management
final prayerTimesProvider = StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  return PrayerTimesNotifier();
});

/// Prayer times state
class PrayerTimesState {
  final PrayerTimesModel? prayerTimes;
  final bool isLoading;
  final String? error;
  final bool notificationsEnabled;
  final TimeUntilNextPrayer? timeUntilNextPrayer;

  const PrayerTimesState({
    this.prayerTimes,
    this.isLoading = false,
    this.error,
    this.notificationsEnabled = false,
    this.timeUntilNextPrayer,
  });

  PrayerTimesState copyWith({
    PrayerTimesModel? prayerTimes,
    bool? isLoading,
    String? error,
    bool? notificationsEnabled,
    TimeUntilNextPrayer? timeUntilNextPrayer,
  }) {
    return PrayerTimesState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      timeUntilNextPrayer: timeUntilNextPrayer ?? this.timeUntilNextPrayer,
    );
  }
}

/// Prayer times notifier
class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final PrayerTimesService _prayerTimesService = PrayerTimesService();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  Timer? _timer;

  PrayerTimesNotifier() : super(const PrayerTimesState()) {
    _initializeNotifications();
    _loadPrayerTimes();
    _loadNotificationSettings();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(initializationSettings);
  }

  Future<void> _loadPrayerTimes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prayerTimes = await _prayerTimesService.getPrayerTimesForCurrentLocation();
      if (prayerTimes != null) {
        final timeUntilNext = _prayerTimesService.getTimeUntilNextPrayer(prayerTimes);
        state = state.copyWith(
          prayerTimes: prayerTimes,
          isLoading: false,
          timeUntilNextPrayer: timeUntilNext,
        );
        _startTimer();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'فشل في تحميل مواقيت الصلاة',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'خطأ في تحميل مواقيت الصلاة: $e',
      );
    }
  }

  Future<void> refreshPrayerTimes() async {
    await _loadPrayerTimes();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('prayer_notifications_enabled') ?? false;
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_notifications_enabled', enabled);

    state = state.copyWith(notificationsEnabled: enabled);

    if (enabled && state.prayerTimes != null) {
      await _schedulePrayerNotifications();
    } else {
      await _cancelAllNotifications();
    }
  }

  Future<void> _schedulePrayerNotifications() async {
    if (state.prayerTimes == null) return;

    final prayerTimes = state.prayerTimes!;
    final now = DateTime.now();
    final today = DateFormat('dd-MM-yyyy').format(now);

    // Schedule notifications for each prayer
    await _schedulePrayerNotification('Fajr', prayerTimes.timings.fajr, today, 'حان وقت صلاة الفجر');
    await _schedulePrayerNotification('Dhuhr', prayerTimes.timings.dhuhr, today, 'حان وقت صلاة الظهر');
    await _schedulePrayerNotification('Asr', prayerTimes.timings.asr, today, 'حان وقت صلاة العصر');
    await _schedulePrayerNotification('Maghrib', prayerTimes.timings.maghrib, today, 'حان وقت صلاة المغرب');
    await _schedulePrayerNotification('Isha', prayerTimes.timings.isha, today, 'حان وقت صلاة العشاء');
  }

  Future<void> _schedulePrayerNotification(
    String prayerName,
    String timeString,
    String date,
    String message,
  ) async {
    final scheduledTime = _parseNotificationTime(timeString, date);

    if (scheduledTime.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        prayerName.hashCode,
        'مواقيت الصلاة',
        message,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times',
            'مواقيت الصلاة',
            channelDescription: 'تذكير بمواقيت الصلاة اليومية',
            importance: Importance.high,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('azan'),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  DateTime _parseNotificationTime(String time, String date) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);

    final dateParts = date.split('-');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);

    return DateTime(year, month, day, hour, minute);
  }

  Future<void> _cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (state.prayerTimes != null) {
        final timeUntilNext = _prayerTimesService.getTimeUntilNextPrayer(state.prayerTimes!);
        state = state.copyWith(timeUntilNextPrayer: timeUntilNext);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider for current prayer time status
final currentPrayerProvider = Provider<String?>((ref) {
  final prayerTimesState = ref.watch(prayerTimesProvider);
  if (prayerTimesState.prayerTimes == null) return null;

  final now = DateTime.now();
  final today = DateFormat('dd-MM-yyyy').format(now);

  final prayerTimes = prayerTimesState.prayerTimes!;
  final fajr = _parseTime(prayerTimes.timings.fajr, today);
  final dhuhr = _parseTime(prayerTimes.timings.dhuhr, today);
  final asr = _parseTime(prayerTimes.timings.asr, today);
  final maghrib = _parseTime(prayerTimes.timings.maghrib, today);
  final isha = _parseTime(prayerTimes.timings.isha, today);

  if (now.isBefore(fajr)) return 'الفجر';
  if (now.isBefore(dhuhr)) return 'الظهر';
  if (now.isBefore(asr)) return 'العصر';
  if (now.isBefore(maghrib)) return 'المغرب';
  if (now.isBefore(isha)) return 'العشاء';

  return 'الفجر'; // Next day
});

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