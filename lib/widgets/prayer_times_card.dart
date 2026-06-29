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
  final DateTime sunriseTime;

  const PrayerTimesCard({
    super.key,
    required this.fivePrayers,
    required this.currentPrayer,
    required this.currentPrayerName,
    required this.timeLeftToEnd,
    required this.prayerProgress,
    required this.isProhibitedTime,
    required this.sunriseTime,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF1D9375);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        // 3D Card Effect: সফট লাইটিং এবং শ্যাডো দিয়ে কার্ডটিকে ভাসমান (Realistic) করা হয়েছে
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF4F7F6)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.teal, width: 1), // 3D Highlight
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: brandGreen.withValues(alpha: .20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProgressIndicator(context, brandGreen),
                const SizedBox(width: 16),
                _buildPrayerList(context, brandGreen),
              ],
            ),
          ),
          
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
          
          // 3D Button Feel for Bottom Action
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HijriCalendarScreen(),
                  ),
                );
              },
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              highlightColor: brandGreen.withValues(alpha: 0.05),
              splashColor: brandGreen.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month_rounded, color: brandGreen.withValues(alpha: 0.9), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      HijriCalendar.now().toFormat("d MMMM, yyyy"),
                      style: TextStyle(
                        color: brandGreen.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, color: brandGreen.withValues(alpha: 0.9), size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Color brandGreen) {
    final Color progressColor = isProhibitedTime ? const Color(0xFFE53935) : brandGreen;
    
    final String topLabel = isProhibitedTime ? 'বর্তমান সময়' : 'বর্তমান ওয়াক্ত';
    final String title = isProhibitedTime ? 'নিষিদ্ধ' : currentPrayerName;
    final String subtitle = isProhibitedTime ? 'ওয়াক্ত শুরু হতে' : 'শেষ হতে বাকি';

    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            topLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.grey.shade500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: progressColor,
              letterSpacing: 0.5,
              shadows: isProhibitedTime ? [
                Shadow(color: progressColor.withValues(alpha: 0.3), blurRadius: 8) // হালকা গ্লো
              ] : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          
          // 3D Neumorphic Dial
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(4, 4), // ইনার থ্রিডি শ্যাডো
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(-4, -4), // আউটার হাইলাইট
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6.5,
                    color: progressColor.withValues(alpha: 0.08),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: CircularProgressIndicator(
                      value: (prayerProgress.isFinite ? prayerProgress.clamp(0.0, 1.0) : 0.0),
                      strokeWidth: 6.5,
                      color: progressColor,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeLeftToEnd,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
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

  Widget _buildPrayerList(BuildContext context, Color brandGreen) {
    if (fivePrayers.length < 5) {
      return const Expanded(
        flex: 5,
        child: Center(
            child: 
            SizedBox(
              height: 20, 
              width: 20, 
              child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    final prayers = [
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.fajr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.dhuhr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.asr),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.maghrib),
      fivePrayers.firstWhere((p) => p.type == PrayerTimeType.isha),
    ];

    // প্রো-লেভেল আইকন প্যাক (প্রতিটি ওয়াক্তের জন্য আলাদা)
    final List<IconData> prayerIcons = [
      Icons.wb_twilight_rounded,    
      Icons.wb_sunny_rounded,       
      Icons.brightness_medium_rounded, 
      Icons.brightness_3_rounded,   
      Icons.nights_stay_rounded,  
    ];

    return Expanded(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < prayers.length; i++)
            _prayerRow(
              context,
              prayers[i].nameBn,
              prayers[i].time,
              i == 0
                  ? sunriseTime
                  : (i < prayers.length - 1 ? prayers[i + 1].time : prayers[0].time),
              isActive: currentPrayer?.type == prayers[i].type,
              icon: prayerIcons[i],
              brandGreen: brandGreen,
            ),
        ],
      ),
    );
  }

  Widget _prayerRow(
    BuildContext context,
    String name,
    DateTime startTime,
    DateTime endTime, {
    required bool isActive,
    required IconData icon,
    required Color brandGreen,
  }) {
    String toBengaliNumber(String number) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      for (int i = 0; i < english.length; i++) {
        number = number.replaceAll(english[i], bengali[i]);
      }
      return number;
    }

    String formatTime12Hour(DateTime time) {
      int hour = time.hour;
      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }
      String minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final String timeRange = '${formatTime12Hour(startTime)} - ${formatTime12Hour(endTime)}';
    final String bengaliTimeRange = toBengaliNumber(timeRange);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
        // Glowing Effect Background
        gradient: isActive 
            ? LinearGradient(colors: [brandGreen.withValues(alpha: 0.12), brandGreen.withValues(alpha: 0.04)]) 
            : null,
        color: isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? brandGreen.withValues(alpha: 0.4) : Colors.grey.shade200,
          width: isActive ? 1.5 : 0.8,
        ),
        boxShadow: isActive
            ? [
                // 3D Glow Effect: এক্টিভ ওয়াক্তটি সুন্দর করে জ্বলবে
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // ডটের বদলে প্রো-লেভেল থিমেটিক আইকন
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isActive ? 4 : 2),
            decoration: BoxDecoration(
              color: isActive ? brandGreen : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                color: isActive ? brandGreen : Colors.black87,
                fontSize: 13, 
                letterSpacing: 0.2, 
              ),
            ),
          ),
          
          Text(
            bengaliTimeRange,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? brandGreen : Colors.grey.shade500,
              fontSize: 11.5, 
              letterSpacing: 0.5, 
            ),
          ),
        ],
      ),
    );
  }
}