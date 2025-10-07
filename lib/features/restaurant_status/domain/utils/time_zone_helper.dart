
class TimeZoneHelper {
  static DateTime convertToTimeZone(DateTime dateTime, String timeZone) {
    // For now, we'll use a simple offset-based approach
    // In a real app, you'd use a proper timezone package
    switch (timeZone) {
      case 'Africa/Cairo':
        return dateTime.add(const Duration(hours: 3)); // UTC+3 for Egypt
      case 'Asia/Riyadh':
        return dateTime.add(const Duration(hours: 3)); // UTC+3 for Saudi Arabia
      case 'Asia/Dubai':
        return dateTime.add(const Duration(hours: 4)); // UTC+4 for UAE
      case 'Europe/Istanbul':
        return dateTime.add(const Duration(hours: 3)); // UTC+3 for Turkey
      default:
        return dateTime; // Return as-is if timezone not recognized
    }
  }

  static DateTime convertFromTimeZone(DateTime dateTime, String timeZone) {
    // Reverse conversion
    switch (timeZone) {
      case 'Africa/Cairo':
        return dateTime.subtract(const Duration(hours: 3));
      case 'Asia/Riyadh':
        return dateTime.subtract(const Duration(hours: 3));
      case 'Asia/Dubai':
        return dateTime.subtract(const Duration(hours: 4));
      case 'Europe/Istanbul':
        return dateTime.subtract(const Duration(hours: 3));
      default:
        return dateTime;
    }
  }

  static DateTime getCurrentTimeInTimeZone(String timeZone) {
    final now = DateTime.now().toUtc();
    return convertToTimeZone(now, timeZone);
  }

  static bool isWithinTimeRange(String startTime, String endTime, String currentTime) {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    final current = _parseTime(currentTime);

    // Handle overnight hours (e.g., 22:00 to 02:00 next day)
    if (start > end) {
      return current >= start || current <= end;
    }

    return current >= start && current <= end;
  }

  static int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }

  static String formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  static String getNextTimeSlot(String currentTime, List<String> timeSlots) {
    if (timeSlots.isEmpty) return '';

    final current = _parseTime(currentTime);

    for (final slot in timeSlots) {
      final slotTime = _parseTime(slot);
      if (slotTime > current) {
        return slot;
      }
    }

    // If no slot found for today, return the first slot for tomorrow
    return timeSlots.first;
  }

  static String addMinutesToTime(String timeStr, int minutes) {
    final totalMinutes = _parseTime(timeStr) + minutes;
    return formatTime(totalMinutes % (24 * 60));
  }

  static String getTimeUntilNextSlot(String currentTime, String nextTime) {
    final current = _parseTime(currentTime);
    final next = _parseTime(nextTime);

    int minutesUntil;
    if (next > current) {
      minutesUntil = next - current;
    } else {
      // Next day
      minutesUntil = (24 * 60 - current) + next;
    }

    if (minutesUntil < 60) {
      return '$minutesUntil دقيقة';
    } else {
      final hours = minutesUntil ~/ 60;
      final minutes = minutesUntil % 60;
      return '$hours ساعة ${minutes > 0 ? 'و $minutes دقيقة' : ''}';
    }
  }
}