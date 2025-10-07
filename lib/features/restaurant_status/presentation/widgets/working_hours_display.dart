import 'package:flutter/material.dart';

import '../../domain/entities/restaurant_status_type.dart';
import '../../domain/entities/working_hours.dart';

class WorkingHoursDisplay extends StatelessWidget {
  const WorkingHoursDisplay({
    required this.workingHours, super.key,
    this.statusType = RestaurantStatusType.open,
    this.compact = false,
    this.showTodayHighlight = true,
  });

  final WorkingHours workingHours;
  final RestaurantStatusType statusType;
  final bool compact;
  final bool showTodayHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Don't show working hours for permanently closed restaurants
    if (statusType == RestaurantStatusType.permanentlyClosed) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          Text(
            'Working Hours',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        _WorkingHoursList(
          workingHours: workingHours,
          statusType: statusType,
          compact: compact,
          showTodayHighlight: showTodayHighlight,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WorkingHours>('workingHours', workingHours));
    properties.add(EnumProperty<RestaurantStatusType>('statusType', statusType));
    properties.add(DiagnosticsProperty<bool>('compact', compact));
    properties.add(DiagnosticsProperty<bool>('showTodayHighlight', showTodayHighlight));
  }
}

class _WorkingHoursList extends StatelessWidget {
  const _WorkingHoursList({
    required this.workingHours,
    required this.statusType,
    required this.compact,
    required this.showTodayHighlight,
  });

  final WorkingHours workingHours;
  final RestaurantStatusType statusType;
  final bool compact;
  final bool showTodayHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final todayWeekday = now.weekday;

    final days = [
      _DayHours('Monday', workingHours.monday, 1, todayWeekday, showTodayHighlight),
      _DayHours('Tuesday', workingHours.tuesday, 2, todayWeekday, showTodayHighlight),
      _DayHours('Wednesday', workingHours.wednesday, 3, todayWeekday, showTodayHighlight),
      _DayHours('Thursday', workingHours.thursday, 4, todayWeekday, showTodayHighlight),
      _DayHours('Friday', workingHours.friday, 5, todayWeekday, showTodayHighlight),
      _DayHours('Saturday', workingHours.saturday, 6, todayWeekday, showTodayHighlight),
      _DayHours('Sunday', workingHours.sunday, 7, todayWeekday, showTodayHighlight),
    ];

    return Column(
      children: days.map((day) => _DayHoursWidget(
          day: day,
          compact: compact,
          theme: theme,
        )).toList(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WorkingHours>('workingHours', workingHours));
    properties.add(EnumProperty<RestaurantStatusType>('statusType', statusType));
    properties.add(DiagnosticsProperty<bool>('compact', compact));
    properties.add(DiagnosticsProperty<bool>('showTodayHighlight', showTodayHighlight));
  }
}

class _DayHours {
  const _DayHours(
    this.name,
    this.timeSlot,
    this.weekday,
    this.todayWeekday,
    this.showTodayHighlight,
  );

  final String name;
  final TimeSlot timeSlot;
  final int weekday;
  final int todayWeekday;
  final bool showTodayHighlight;

  bool get isToday => weekday == todayWeekday && showTodayHighlight;
  bool get isOpen => timeSlot.isOpen;
}

class _DayHoursWidget extends StatelessWidget {
  const _DayHoursWidget({
    required this.day,
    required this.compact,
    required this.theme,
  });

  final _DayHours day;
  final bool compact;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      margin: EdgeInsets.only(bottom: compact ? 2 : 4),
      decoration: day.isToday
          ? BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            )
          : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              day.name,
              style: (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)?.copyWith(
                fontWeight: day.isToday ? FontWeight.w600 : FontWeight.normal,
                color: day.isToday ? theme.primaryColor : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTimeSlot(day.timeSlot),
            style: (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)?.copyWith(
              color: day.isOpen ? Colors.green.shade700 : Colors.grey.shade600,
              fontWeight: day.isToday ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );

  String _formatTimeSlot(TimeSlot timeSlot) {
    if (!timeSlot.isOpen) {
      return 'Closed';
    }

    if (timeSlot.openTime == null || timeSlot.closeTime == null) {
      return '24 Hours';
    }

    final openTime = timeSlot.openTime!;
    final closeTime = timeSlot.closeTime!;

    // Handle overnight hours
    if (openTime.compareTo(closeTime) > 0) {
      return '$openTime - $closeTime (next day)';
    }

    return '$openTime - $closeTime';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_DayHours>('day', day));
    properties.add(DiagnosticsProperty<bool>('compact', compact));
    properties.add(DiagnosticsProperty<ThemeData>('theme', theme));
  }
}