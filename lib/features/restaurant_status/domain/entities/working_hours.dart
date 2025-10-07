import '../utils/time_zone_helper.dart';

class WorkingHours {
  const WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    this.timezone = 'Africa/Cairo',
  });

  factory WorkingHours.alwaysOpen() {
    final alwaysOpen = TimeSlot.open24Hours();
    return WorkingHours(
      monday: alwaysOpen,
      tuesday: alwaysOpen,
      wednesday: alwaysOpen,
      thursday: alwaysOpen,
      friday: alwaysOpen,
      saturday: alwaysOpen,
      sunday: alwaysOpen,
    );
  }

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
      monday: TimeSlot.fromJson(json['monday'] ?? {}),
      tuesday: TimeSlot.fromJson(json['tuesday'] ?? {}),
      wednesday: TimeSlot.fromJson(json['wednesday'] ?? {}),
      thursday: TimeSlot.fromJson(json['thursday'] ?? {}),
      friday: TimeSlot.fromJson(json['friday'] ?? {}),
      saturday: TimeSlot.fromJson(json['saturday'] ?? {}),
      sunday: TimeSlot.fromJson(json['sunday'] ?? {}),
      timezone: json['timezone'] ?? 'Africa/Cairo',
    );

  final TimeSlot monday;
  final TimeSlot tuesday;
  final TimeSlot wednesday;
  final TimeSlot thursday;
  final TimeSlot friday;
  final TimeSlot saturday;
  final TimeSlot sunday;
  final String timezone;

  TimeSlot getTimeSlotForDay(int weekday) {
    switch (weekday) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return monday;
    }
  }

  bool isOpenAt(DateTime dateTime) {
    final daySlot = getTimeSlotForDay(dateTime.weekday);
    return daySlot.isOpenAtInTimeZone(dateTime, timezone);
  }

  String? getNextOpenTime(DateTime currentTime) {
    final daySlot = getTimeSlotForDay(currentTime.weekday);
    return daySlot.getNextOpenTime(currentTime);
  }

  Map<String, dynamic> toJson() => {
    'monday': monday.toJson(),
    'tuesday': tuesday.toJson(),
    'wednesday': wednesday.toJson(),
    'thursday': thursday.toJson(),
    'friday': friday.toJson(),
    'saturday': saturday.toJson(),
    'sunday': sunday.toJson(),
    'timezone': timezone,
  };

  @override
  List<Object?> get props => [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
    timezone,
  ];
}

class TimeSlot {
  const TimeSlot({
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  factory TimeSlot.closed() => const TimeSlot(isOpen: false);

  factory TimeSlot.open24Hours() => const TimeSlot(isOpen: true, openTime: '00:00', closeTime: '23:59');

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
      isOpen: json['isOpen'] ?? false,
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      breakStart: json['breakStart'],
      breakEnd: json['breakEnd'],
    );

  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final String? breakStart;
  final String? breakEnd;

  bool isOpenAt(DateTime dateTime) {
    if (!isOpen) return false;

    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return TimeZoneHelper.isWithinTimeRange(openTime ?? '00:00', closeTime ?? '23:59', timeStr);
  }

  bool isOpenAtInTimeZone(DateTime dateTime, String timeZone) {
    if (!isOpen) return false;

    // Convert to restaurant's timezone for accurate comparison
    final localTime = TimeZoneHelper.convertToTimeZone(dateTime, timeZone);
    return isOpenAt(localTime);
  }

  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String? getNextOpenTime(DateTime currentTime) {
    if (!isOpen || (openTime == null && closeTime == null)) return null;

    // If currently open, return closing time
    if (isOpenAt(currentTime)) {
      return closeTime;
    }

    // Otherwise, return next opening time
    return openTime;
  }

  Map<String, dynamic> toJson() => {
    'isOpen': isOpen,
    'openTime': openTime,
    'closeTime': closeTime,
    'breakStart': breakStart,
    'breakEnd': breakEnd,
  };

  @override
  List<Object?> get props => [
    isOpen,
    openTime,
    closeTime,
    breakStart,
    breakEnd,
  ];
}
