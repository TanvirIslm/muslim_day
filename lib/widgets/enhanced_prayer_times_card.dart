import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/prayer_settings.dart';
import 'package:intl/intl.dart';

class EnhancedPrayerTimesCard extends StatelessWidget {
  final List<ExtendedPrayerTime> allPrayerTimes;
  final ExtendedPrayerTime? currentPrayer;
  final Duration timeRemaining;

  const EnhancedPrayerTimesCard({
    super.key,
    required this.allPrayerTimes,
    required this.currentPrayer,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final fivePrayers = allPrayerTimes.where((p) => 
      !p.isNafil && !p.isProhibited && p.type != PrayerTimeType.sunrise
    ).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D9375), Color(0xFF1A4D4D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D9375).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Current Prayer Status
          _buildCurrentPrayerHeader(),
          
          // Progress Timeline
          _buildProgressTimeline(),
          
          const Divider(color: Colors.white24, height: 32),
          
          // Five Prayer Times
          _buildFivePrayersList(fivePrayers),
        ],
      ),
    );
  }

  Widget _buildCurrentPrayerHeader() {
    String statusText = 'পরবর্তী নামাজ';
    String prayerName = 'ফজর';
    Color statusColor = Colors.white;
    IconData statusIcon = Icons.access_time;

    if (currentPrayer != null) {
      if (currentPrayer!.isProhibited) {
        statusText = 'নিষিদ্ধ সময়';
        prayerName = currentPrayer!.nameBn;
        statusColor = Colors.red.shade300;
        statusIcon = Icons.block;
      } else if (currentPrayer!.isNafil) {
        statusText = 'নফল নামাজের সময়';
        prayerName = currentPrayer!.nameBn;
        statusColor = Colors.amber.shade300;
        statusIcon = Icons.star;
      } else {
        statusText = 'চলমান নামাজ';
        prayerName = currentPrayer!.nameBn;
        statusIcon = Icons.mosque;
      }
    }

    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final timeText = hours > 0 
        ? '$hours ঘন্টা $minutes মিনিট'
        : '$minutes মিনিট';

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: GoogleFonts.notoSansBengali(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prayerName,
                      style: GoogleFonts.notoSansBengali(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (!currentPrayer!.isProhibited)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timeText,
                    style: GoogleFonts.notoSansBengali(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTimeline() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allPrayerTimes.length,
        itemBuilder: (context, index) {
          final prayer = allPrayerTimes[index];
          final isActive = currentPrayer?.type == prayer.type;
          final isPast = DateTime.now().isAfter(prayer.time);
          
          Color dotColor;
          if (prayer.isProhibited) {
            dotColor = Colors.red.shade300;
          } else if (prayer.isNafil) {
            dotColor = Colors.amber.shade300;
          } else if (isActive) {
            dotColor = Colors.white;
          } else if (isPast) {
            dotColor = Colors.white54;
          } else {
            dotColor = Colors.white30;
          }

          return Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isActive ? 16 : 12,
                    height: isActive ? 16 : 12,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      border: isActive
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!prayer.isProhibited)
                    Text(
                      prayer.nameBn,
                      style: GoogleFonts.notoSansBengali(
                        color: isActive ? Colors.white : Colors.white54,
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                ],
              ),
              if (index < allPrayerTimes.length - 1)
                Container(
                  width: 30,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.white30,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFivePrayersList(List<ExtendedPrayerTime> prayers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: prayers.map((prayer) {
          final isActive = currentPrayer?.type == prayer.type;
          final timeFormat = DateFormat('hh:mm a', 'bn_BD');
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: isActive
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getPrayerIcon(prayer.type),
                    color: isActive ? const Color(0xFF1D9375) : Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.nameBn,
                        style: GoogleFonts.notoSansBengali(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isActive)
                        Text(
                          'চলমান',
                          style: GoogleFonts.notoSansBengali(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  timeFormat.format(prayer.time),
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getPrayerIcon(PrayerTimeType type) {
    switch (type) {
      case PrayerTimeType.fajr:
        return Icons.wb_twilight;
      case PrayerTimeType.dhuhr:
        return Icons.wb_sunny;
      case PrayerTimeType.asr:
        return Icons.wb_cloudy;
      case PrayerTimeType.maghrib:
        return Icons.nights_stay;
      case PrayerTimeType.isha:
        return Icons.dark_mode;
      default:
        return Icons.access_time;
    }
  }
}
