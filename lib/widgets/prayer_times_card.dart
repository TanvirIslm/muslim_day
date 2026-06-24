import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../providers/prayer_settings.dart';
import 'package:hijri/hijri_calendar.dart';
import '../screens/hijri_calendar_screen.dart';

class PrayerTimesCard extends StatelessWidget {
  final List<ExtendedPrayerTime> fivePrayers;
  final ExtendedPrayerTime? currentPrayer;
  final String currentPrayerName;
  final String timeLeftToEnd;
  final double prayerProgress;
  final bool isProhibitedTime;

  const PrayerTimesCard({
    super.key,
    required this.fivePrayers,
    required this.currentPrayer,
    required this.currentPrayerName,
    required this.timeLeftToEnd,
    required this.prayerProgress,
    required this.isProhibitedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(context),
              const SizedBox(width: 16),
              // only for 5 times prayer
              _buildPrayerList(context),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          InkWell(
            onTap: () {
              // Navigate to Hijri Calendar Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HijriCalendarScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month,
                      color: Color(0xFF1D9375), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    HijriCalendar.now().toFormat("d MMM yyyy"),
                    style: const TextStyle(
                      color: Color(0xFF1D9375),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios,
                      color: Color(0xFF1D9375), size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    // if prohibited color change
    final Color progressColor =
        isProhibitedTime ? Colors.red.shade700 : const Color(0xFF1D9375);
    final String title = isProhibitedTime ? 'নিষিদ্ধ সময়' : currentPrayerName;
    final String subtitle =
        isProhibitedTime ? 'সালাত থেকে বিরত থাকুন' : 'শেষ হতে বাকি';

    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: progressColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 8,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CircularProgressIndicator(
                    value: (prayerProgress.isFinite
                        ? prayerProgress.clamp(0.0, 1.0)
                        : 0.0),
                    strokeWidth: 8,
                    color: progressColor,
                  ),
                ),
              ),
              if (!isProhibitedTime)
                Text(
                  timeLeftToEnd,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList(BuildContext context) {
    if (fivePrayers.length < 5) {
      return const Expanded(
        flex: 5,
        child: Center(child: Text('লোড হচ্ছে...')),
      );
    }

    final prayers = [
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.fajr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.dhuhr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.asr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.maghrib),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.isha),
    ];

    return Expanded(
      flex: 5,
      child: Column(
        children: [
          for (int i = 0; i < prayers.length; i++)
            _prayerRow(
              context,
              prayers[i].nameBn,
              prayers[i].time,
              i < prayers.length - 1 ? prayers[i + 1].time : prayers[0].time,
              isActive: currentPrayer?.type == prayers[i].type,
            ),
        ],
      ),
    );
  }

  Widget _prayerRow(
      BuildContext context, String name, DateTime startTime, DateTime endTime,
      {bool isActive = false}) {
    // Bengali number conversion
    String toBengaliNumber(String number) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      for (int i = 0; i < english.length; i++) {
        number = number.replaceAll(english[i], bengali[i]);
      }
      return number;
    }

    // Convert to 12-hour format
    String formatTime12Hour(DateTime time) {
      int hour = time.hour;
      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) hour = 12;
      String minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final String startTimeStr = formatTime12Hour(startTime);
    final String endTimeStr = formatTime12Hour(endTime);
    final String timeRange = '$startTimeStr - $endTimeStr';
    final String bengaliTimeRange = toBengaliNumber(timeRange);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isActive ? const Color(0x1A1D9375) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(
                color: const Color(0xFF1D9375).withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Row(
            children: [
              isActive
                  ? const Icon(Icons.circle, color: Color(0xFF1D9375), size: 8)
                  : const SizedBox(width: 8),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? const Color(0xFF1D9375) : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            bengaliTimeRange,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? const Color(0xFF1D9375) : Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}