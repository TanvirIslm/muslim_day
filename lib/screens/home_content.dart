import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_settings.dart';
import '../widgets/location_bar.dart';
import '../widgets/date_time_bar.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/info_card.dart';
import 'app_caution_page.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<ExtendedPrayerTime> _allPrayerTimes = [];
  List<ExtendedPrayerTime> _fivePrayers = [];
  ExtendedPrayerTime? _currentPrayer;
  ExtendedPrayerTime? _nextPrayer;
  Duration _timeLeftToEnd = Duration.zero;
  String _hijriDate = '';
  String _gregorianDate = '';
  Timer? _timer;
  double _prayerProgress = 0.0;
  String _currentPrayerName = '';
  bool _isProhibitedTime = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final prayerSettings =
          Provider.of<PrayerSettings>(context, listen: false);
      if (!prayerSettings.isLoading) {
        _updateAllData(prayerSettings);
      }
      prayerSettings.addListener(_onSettingsChanged);
      _startTimer();
      _isInitialized = true;
    }
  }

  void _onSettingsChanged() {
    final prayerSettings = Provider.of<PrayerSettings>(context, listen: false);
    _updateAllData(prayerSettings);
  }

void _updateAllData(PrayerSettings settings) {
    if (settings.isLoading) return;

    try {
      // FIX: টাইমজোন এবং তারিখের অমিল দূর করতে এই অংশটি চেক করুন
      final now = DateTime.now();
      
      _allPrayerTimes = settings.getExtendedPrayerTimes(now);
      _fivePrayers = settings.getFivePrayers(now);

      // হিজি তারিখ ও গ্রেগরিয়ান তারিখ
      String hijriRaw = HijriCalendar.now().toFormat("d MMMM, yyyy");
      _hijriDate = _toBengaliNumber(hijriRaw); 
      
      // FIX: তারিখ যেন ১ দিন এক্সটেন্ড না হয় তার জন্য লোকাল ফরম্যাট নিশ্চিত করা
      _gregorianDate = DateFormat('d MMMM, EEEE', 'bn_BD').format(now);

      _updatePrayerProgressAndCountdown();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _updatePrayerProgressAndCountdown() {
    if (_allPrayerTimes.isEmpty) return;

    final now = DateTime.now();

    for (int i = 0; i < _allPrayerTimes.length; i++) {
      final prayer = _allPrayerTimes[i];
      final nextPrayer = _allPrayerTimes[(i + 1) % _allPrayerTimes.length];

      DateTime prayerStartTime = prayer.time;
      DateTime nextPrayerTime = nextPrayer.time;

      if (nextPrayerTime.isBefore(prayerStartTime)) {
        if (now.isAfter(prayerStartTime)) {
          nextPrayerTime = nextPrayerTime.add(const Duration(days: 1));
        } else {
          prayerStartTime = prayerStartTime.subtract(const Duration(days: 1));
        }
      }

      if (now.isAfter(prayerStartTime) && now.isBefore(nextPrayerTime)) {
        _currentPrayer = prayer;
        _nextPrayer = nextPrayer;
        _isProhibitedTime = prayer.isProhibited;

        if (_isProhibitedTime) {
          _currentPrayerName = 'নিষিদ্ধ সময়';
          _prayerProgress = 0.0;
        } else {
          _currentPrayerName = prayer.nameBn;
          final totalDuration = nextPrayerTime.difference(prayerStartTime);
          final elapsedDuration = now.difference(prayerStartTime);
          if (totalDuration.inSeconds > 0) {
            _prayerProgress =
                elapsedDuration.inSeconds / totalDuration.inSeconds;
          } else {
            _prayerProgress = 0.0;
          }
        }
        _timeLeftToEnd = nextPrayerTime.difference(now);
        break;
      }
    }

    if (_currentPrayer == null && _allPrayerTimes.isNotEmpty) {
      _currentPrayer = _allPrayerTimes.last;
      _nextPrayer = _allPrayerTimes.first;
      _currentPrayerName = 'পরবর্তী';
      _timeLeftToEnd = _nextPrayer!.time.difference(now);
      _prayerProgress = 0.0;
      _isProhibitedTime = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_allPrayerTimes.isEmpty) return;

        final now = DateTime.now();
        if (_allPrayerTimes.isNotEmpty &&
            now.day != _allPrayerTimes.first.time.day) {
          _updateAllData(Provider.of<PrayerSettings>(context, listen: false));
        } else {
          setState(() {
            _updatePrayerProgressAndCountdown();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    Provider.of<PrayerSettings>(context, listen: false)
        .removeListener(_onSettingsChanged);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String timeStr = "$hours:$minutes:$seconds";

    return _toBengaliNumber(timeStr);
  }

  String _toBengaliNumber(String number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    for (int i = 0; i < english.length; i++) {
      number = number.replaceAll(english[i], bengali[i]);
    }
    return number;
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    String minute = time.minute.toString().padLeft(2, '0');
    String formatted = '$hour:$minute';

    return _toBengaliNumber(formatted);
  }

  void _handleLocationPress() {
    Provider.of<PrayerSettings>(context, listen: false).detectCurrentLocation();
  }

  void _setAlarm(DateTime dateTime, String title) {
    FlutterAlarmClock.createAlarm(
      hour: dateTime.hour,
      minutes: dateTime.minute,
      title: title,
    );
    // ইউজারের কনফারমেশনের জন্য একটি স্ন্যাকবার (Snackbar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title-এর জন্য অ্যালার্ম সেট হয়েছে!'),
        backgroundColor: const Color(0xFF1D9375),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerSettings>(
      builder: (context, settings, child) {
        if (settings.isLoading ||
            _allPrayerTimes.isEmpty ||
            _fivePrayers.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.teal));
        }

        final sunriseTime =
            _allPrayerTimes.firstWhere((p) => p.type == PrayerTimeType.sunrise);
        final maghribTime =
            _fivePrayers.firstWhere((p) => p.type == PrayerTimeType.maghrib);

        final tahajjudTime = _allPrayerTimes
            .firstWhere((p) => p.type == PrayerTimeType.tahajjud);
        final ishrakTime =
            _allPrayerTimes.firstWhere((p) => p.type == PrayerTimeType.ishrak);

        final prohibitedBeforeDhuhr = _allPrayerTimes
            .firstWhere((p) => p.type == PrayerTimeType.prohibitedBeforeDhuhr);

        final dhuhrTime =
            _fivePrayers.firstWhere((p) => p.type == PrayerTimeType.dhuhr);

        // কঠোর নিষিদ্ধ সময়: মাগরিবের ঠিক ১৫ মিনিট আগে থেকে
        final strictSunsetProhibitedStart =
            maghribTime.time.subtract(const Duration(minutes: 15));

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            // আপনার থিমের গাঢ় সবুজ রং
            statusBarColor: Color(0xFF1D9375),
            // আইকনগুলো সাদা দেখানোর জন্য
            statusBarIconBrightness: Brightness.light,
            // আইওএসের (iOS) জন্য
            statusBarBrightness: Brightness.dark,
          ),
          child: SafeArea( // 👈 এখানে Fix করা হয়েছে
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LocationBar(
                    country: ' ',
                    location: settings.locationName,
                    isLoading: settings.isLoading,
                    onLocationPressed: _handleLocationPress,
                  ),
                  DateTimeBar(
                    gregorianDate: _gregorianDate,
                    hijriDate: _hijriDate,
                    sunriseTime: _formatTime(sunriseTime.time),
                    sunsetTime: _formatTime(maghribTime.time),
                  ),
                  PrayerTimesCard(
                    fivePrayers: _fivePrayers,
                    currentPrayer: _currentPrayer,
                    currentPrayerName: _currentPrayerName,
                    timeLeftToEnd: _formatDuration(_timeLeftToEnd),
                    prayerProgress: _prayerProgress,
                    isProhibitedTime: _isProhibitedTime,
                    sunriseTime: sunriseTime.time,
                  ),
                  _buildInfoCardsGrid(
                    ishrakTime: _formatTime(ishrakTime.time),
                    tahajjudTime: _formatTime(tahajjudTime.time),
                    sunriseRange:
                        '${_formatTime(sunriseTime.time)} - ${_formatTime(ishrakTime.time)}',
                    zawalRange:
                        '${_formatTime(prohibitedBeforeDhuhr.time)} - ${_formatTime(dhuhrTime.time)}',
                    sunsetRange:
                        '${_formatTime(strictSunsetProhibitedStart)} - ${_formatTime(maghribTime.time)}',
                  ),
                  _buildSehriIftarRow(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCardsGrid({
    required String ishrakTime,
    required String tahajjudTime,
    required String sunriseRange,
    required String zawalRange,
    required String sunsetRange,
  }) {
    final prohibitedTimesContent =
        'সূর্যোদয়: $sunriseRange\nযাওয়াল: $zawalRange\nসূর্যাস্ত: $sunsetRange';
    final naflTimesContent = 'ইশরাক: $ishrakTime\nতাহাজ্জুদ: $tahajjudTime';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 6.0;
          final double itemWidth = (constraints.maxWidth - spacing) / 2;
          
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // বাম দিকের কলাম (নিষিদ্ধ সময়)
                SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    onTap: () {
                      _showProhibitedTimesInfo(context);
                    },
                    child: InfoCard(
                      title: 'সালাতের নিষিদ্ধ সময়',
                      content: prohibitedTimesContent,
                      hasInfoIcon: true,
                      isSimple: false,
                    ),
                  ),
                ),

                const SizedBox(width: spacing),
                // ডান দিকের কলাম (নফল ওয়াক্ত + FAQ)
                SizedBox(
                  width: itemWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InfoCard(
                        title: 'নফল সালাতের ওয়াক্ত',
                        content: naflTimesContent,
                        isSimple: false,
                      ),
                      const SizedBox(height: spacing),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppCautionPage(),
                              ),
                            );
                          },
                          child: const InfoCard(
                            title: 'বিশেষ দ্রষ্টব্য (FAQ)',
                            isSimple: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

Widget _buildSehriIftarRow() {
    if (_fivePrayers.isEmpty) return const SizedBox.shrink();

    final fajrTime =
        _fivePrayers.firstWhere((p) => p.type == PrayerTimeType.fajr);
    final maghribTime =
        _fivePrayers.firstWhere((p) => p.type == PrayerTimeType.maghrib);

    // অ্যালার্মের জন্য সময় ক্যালকুলেশন
    final DateTime sehriDateTime = fajrTime.time.subtract(const Duration(minutes: 10));
    final DateTime iftarDateTime = maghribTime.time;

    String iftarTimeStr = _formatTime(iftarDateTime);
    String sehriTimeStr = _formatTime(sehriDateTime);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          // সাহরির কার্ড
          Expanded(
            child: GestureDetector(
              onTap: () {
                _setAlarm(sehriDateTime, 'সাহরি');
              },
              child: InfoCard.sehriIftar(title: 'সাহরির শেষ সময়:', time: sehriTimeStr),
            ),
          ),
          const SizedBox(width: 12),
          // ইফতারের কার্ড
          Expanded(
            child: GestureDetector(
              onTap: () {
                _setAlarm(iftarDateTime, 'ইফতার');
              },
              child: InfoCard.sehriIftar(title: 'আজকের ইফতার:', time: iftarTimeStr),
            ),
          ),
        ],
      ),
    );
  }
  void _showProhibitedTimesInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D9375).withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF1D9375),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'নিষিদ্ধ সময়ের বিবরণ',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.black12, thickness: 1),
                  ),

                  // Intro Text
                  const Text(
                    'হাদিসের আলোকে নিচের ৩টি সময়ে যেকোনো সালাত (এমনকি কাজা বা জানাজা) আদায় করা সম্পূর্ণ হারাম:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3 Time Rules with Icons
                  _buildTimeRule(
                    icon: Icons.wb_twilight_rounded,
                    iconColor: Colors.orange.shade600,
                    title: '১. সূর্যোদয়',
                    description:
                        'সূর্য উদিত হওয়া থেকে শুরু করে তা বর্শার সমপরিমাণ উঁচুতে ওঠা পর্যন্ত (প্রায় ১৫ মিনিট)।',
                  ),
                  const SizedBox(height: 12),
                  _buildTimeRule(
                    icon: Icons.wb_sunny_rounded,
                    iconColor: Colors.red.shade500,
                    title: '২. জাওয়াল (দুপুর)',
                    description:
                        'সূর্য ঠিক মাথার ওপর থাকা অবস্থা থেকে হেলে পড়া পর্যন্ত (যোহরের ওয়াক্ত শুরুর ঠিক ১০-১৫ মিনিট আগে)।',
                  ),
                  const SizedBox(height: 12),
                  _buildTimeRule(
                    icon: Icons.brightness_4_rounded,
                    iconColor: Colors.deepOrange.shade600,
                    title: '৩. সূর্যাস্ত',
                    description:
                        'সূর্য হলুদ বর্ণ ধারণ করা থেকে পুরোপুরি অস্ত যাওয়া পর্যন্ত (মাগরিবের ওয়াক্তের ঠিক ১৫ মিনিট আগে)।',
                  ),
                  const SizedBox(height: 20),

                  // Special Note (Caution Box)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.amber.shade800, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ফজরের পর থেকে সূর্যোদয় এবং আসরের পর থেকে সূর্যাস্ত পর্যন্ত নফল সালাত পড়া নিষেধ হলেও, এ সময়ে কাজা সালাত পড়া যাবে।',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.amber.shade900,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9375),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'বুঝতে পেরেছি',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper Widget for the Time Rules
  Widget _buildTimeRule({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}