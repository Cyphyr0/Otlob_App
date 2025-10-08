import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/hijri_calendar_service.dart';

/// Widget to display both Gregorian and Hijri dates
class HijriDateDisplay extends StatelessWidget {

  const HijriDateDisplay({
    required this.gregorianDate, super.key,
    this.gregorianStyle,
    this.hijriStyle,
    this.showHijri = true,
    this.showGregorian = true,
    this.separator = ' / ',
    this.alignment = CrossAxisAlignment.start,
  });
  final DateTime gregorianDate;
  final TextStyle? gregorianStyle;
  final TextStyle? hijriStyle;
  final bool showHijri;
  final bool showGregorian;
  final String separator;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final defaultGregorianStyle = TextStyle(
      fontSize: 14.sp,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Cairo',
    );

    final defaultHijriStyle = TextStyle(
      fontSize: 12.sp,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontFamily: 'Cairo',
    );

    final hijriDate = gregorianDate.toHijri;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (showGregorian) ...[
          Text(
            _formatGregorianDate(gregorianDate),
            style: gregorianStyle ?? defaultGregorianStyle,
          ),
        ],
        if (showGregorian && showHijri) SizedBox(height: 2.h),
        if (showHijri) ...[
          Text(
            HijriCalendarService.formatHijriDateArabic(hijriDate),
            style: hijriStyle ?? defaultHijriStyle,
          ),
        ],
      ],
    );
  }

  String _formatGregorianDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'اليوم ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateOnly == yesterday) {
      return 'أمس ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateOnly == tomorrow) {
      return 'غداً ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('gregorianDate', gregorianDate));
    properties.add(DiagnosticsProperty<TextStyle?>('gregorianStyle', gregorianStyle));
    properties.add(DiagnosticsProperty<TextStyle?>('hijriStyle', hijriStyle));
    properties.add(DiagnosticsProperty<bool>('showHijri', showHijri));
    properties.add(DiagnosticsProperty<bool>('showGregorian', showGregorian));
    properties.add(StringProperty('separator', separator));
    properties.add(EnumProperty<CrossAxisAlignment>('alignment', alignment));
  }
}

/// Compact Hijri date widget for tight spaces
class CompactHijriDate extends StatelessWidget {

  const CompactHijriDate({
    required this.gregorianDate, super.key,
    this.style,
  });
  final DateTime gregorianDate;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final hijriDate = gregorianDate.toHijri;

    return Text(
      '${_formatGregorianDate(gregorianDate)} • ${HijriCalendarService.formatHijriDateArabic(hijriDate)}',
      style: style ?? TextStyle(
        fontSize: 12.sp,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontFamily: 'Cairo',
      ),
    );
  }

  String _formatGregorianDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'اليوم';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('gregorianDate', gregorianDate));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
  }
}

/// Hijri date badge for special occasions
class HijriDateBadge extends StatelessWidget {

  const HijriDateBadge({
    required this.gregorianDate, super.key,
    this.showRamadanBadge = true,
    this.showSacredMonthBadge = true,
  });
  final DateTime gregorianDate;
  final bool showRamadanBadge;
  final bool showSacredMonthBadge;

  @override
  Widget build(BuildContext context) {
    final hijriDate = gregorianDate.toHijri;
    final isRamadan = HijriCalendarService.isRamadan();
    final isSacredMonth = HijriCalendarService.isSacredMonth();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBadgeColor(isRamadan, isSacredMonth),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRamadan && showRamadanBadge) ...[
            Icon(
              Icons.star,
              color: Colors.white,
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
          ],
          if (isSacredMonth && showSacredMonthBadge) ...[
            Icon(
              Icons.mosque,
              color: Colors.white,
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            HijriCalendarService.formatHijriDateArabic(hijriDate),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(bool isRamadan, bool isSacredMonth) {
    if (isRamadan) {
      return const Color(0xFF10B981); // Ramadan green
    } else if (isSacredMonth) {
      return const Color(0xFF8B5CF6); // Sacred month purple
    } else {
      return const Color(0xFF6B7280); // Default gray
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('gregorianDate', gregorianDate));
    properties.add(DiagnosticsProperty<bool>('showRamadanBadge', showRamadanBadge));
    properties.add(DiagnosticsProperty<bool>('showSacredMonthBadge', showSacredMonthBadge));
  }
}

/// Hijri calendar widget for date picker
class HijriCalendarWidget extends StatefulWidget {

  const HijriCalendarWidget({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.showHijriDates = true,
  });
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final bool showHijriDates;

  @override
  State<HijriCalendarWidget> createState() => _HijriCalendarWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime?>('selectedDate', selectedDate));
    properties.add(ObjectFlagProperty<Function(DateTime p1)?>.has('onDateSelected', onDateSelected));
    properties.add(DiagnosticsProperty<bool>('showHijriDates', showHijriDates));
  }
}

class _HijriCalendarWidgetState extends State<HijriCalendarWidget> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Month/Year header
        _buildHeader(),

        // Days of week header
        _buildDaysOfWeekHeader(),

        // Calendar days
        _buildCalendarDays(),
      ],
    );

  Widget _buildHeader() => Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month - 1,
                );
              });
            },
            icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.primary),
          ),
          Column(
            children: [
              Text(
                _getGregorianMonthYear(_focusedDate),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
              ),
              if (widget.showHijriDates) ...[
                SizedBox(height: 2.h),
                Text(
                  _getHijriMonthYear(_focusedDate),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month + 1,
                );
              });
            },
            icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );

  Widget _buildDaysOfWeekHeader() {
    final weekdays = ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: weekdays.map((day) => Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              alignment: Alignment.center,
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          )).toList(),
      ),
    );
  }

  Widget _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Adjust for Arabic week starting on Saturday

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 4.w,
        ),
        itemCount: 42, // 6 weeks * 7 days
        itemBuilder: (context, index) {
          final dayNumber = index - startingWeekday + 1;
          final isValidDay = dayNumber >= 1 && dayNumber <= daysInMonth;
          final dayDate = isValidDay
              ? DateTime(_focusedDate.year, _focusedDate.month, dayNumber)
              : null;

          return _buildDayCell(dayNumber, isValidDay, dayDate);
        },
      ),
    );
  }

  Widget _buildDayCell(int dayNumber, bool isValidDay, DateTime? dayDate) {
    final isSelected = dayDate != null &&
        _selectedDate.year == dayDate.year &&
        _selectedDate.month == dayDate.month &&
        _selectedDate.day == dayDate.day;

    return GestureDetector(
      onTap: isValidDay && dayDate != null
          ? () {
              setState(() => _selectedDate = dayDate);
              widget.onDateSelected?.call(dayDate);
            }
          : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : isValidDay
                  ? Colors.transparent
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isValidDay ? dayNumber.toString() : '',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : isValidDay
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                fontFamily: 'Cairo',
              ),
            ),
            if (widget.showHijriDates && isValidDay && dayDate != null) ...[
              SizedBox(height: 2.h),
              Text(
                dayDate.toHijri.day.toString(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getGregorianMonthYear(DateTime date) {
    final monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];

    return '${monthNames[date.month - 1]} ${date.year}';
  }

  String _getHijriMonthYear(DateTime date) {
    final hijriDate = date.toHijri;
    return HijriCalendarService.formatHijriDateArabic(hijriDate);
  }
}