import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/prayer_times_provider.dart';
import '../../services/hijri_calendar_service.dart';
import '../../services/prayer_times_service.dart';

/// Prayer times card widget for Egyptian market
class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesState = ref.watch(prayerTimesProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A), // Dark blue
            Color(0xFF3B82F6), // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mosque,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'مواقيت الصلاة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    ref.read(prayerTimesProvider.notifier).refreshPrayerTimes();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),

          // Content
          if (prayerTimesState.isLoading)
            Container(
              padding: EdgeInsets.all(32.h),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (prayerTimesState.error != null)
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[200],
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    prayerTimesState.error!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(prayerTimesProvider.notifier).refreshPrayerTimes();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                    ),
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            )
          else if (prayerTimesState.prayerTimes != null)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Next prayer countdown
                  if (prayerTimesState.timeUntilNextPrayer != null)
                    _buildNextPrayerCountdown(prayerTimesState.timeUntilNextPrayer!)
                  else
                    const SizedBox(),

                  SizedBox(height: 16.h),

                  // Prayer times grid
                  _buildPrayerTimesGrid(prayerTimesState.prayerTimes!),

                  SizedBox(height: 16.h),

                  // Hijri date
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      HijriCalendarService.formatHijriDateArabic(
                        HijriCalendarService.getCurrentHijriDate(),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Notification toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تذكير الصلاة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Switch(
                        value: prayerTimesState.notificationsEnabled,
                        onChanged: (value) {
                          ref.read(prayerTimesProvider.notifier).toggleNotifications(value);
                        },
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerCountdown(TimeUntilNextPrayer timeUntil) => Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'الصلاة القادمة: ${timeUntil.prayerName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              timeUntil.formattedTimeUntil,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildPrayerTimesGrid(PrayerTimesModel prayerTimes) {
    final timings = prayerTimes.timings;

    final prayerData = [
      {'name': 'الفجر', 'time': timings.fajr, 'icon': Icons.wb_sunny_outlined},
      {'name': 'الشروق', 'time': timings.sunrise, 'icon': Icons.wb_sunny},
      {'name': 'الظهر', 'time': timings.dhuhr, 'icon': Icons.sunny},
      {'name': 'العصر', 'time': timings.asr, 'icon': Icons.sunny_snowing},
      {'name': 'المغرب', 'time': timings.maghrib, 'icon': Icons.sunny},
      {'name': 'العشاء', 'time': timings.isha, 'icon': Icons.nightlight},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.2,
      ),
      itemCount: prayerData.length,
      itemBuilder: (context, index) {
        final prayer = prayerData[index];
        return _buildPrayerTimeItem(
          prayer['name'] as String,
          prayer['time'] as String,
          prayer['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildPrayerTimeItem(String name, String time, IconData icon) => DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
}