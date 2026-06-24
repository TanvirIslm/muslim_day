import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';
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
      final now = DateTime.now();
      _allPrayerTimes = settings.getExtendedPrayerTimes(now);
      _fivePrayers = settings.getFivePrayers(now);

      _hijriDate = HijriCalendar.now().toFormat("d MMMM, yyyy");
      _gregorianDate = DateFormat('d MMMM, EEEE', 'bn_BD').format(now);

      _updatePrayerProgressAndCountdown();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error in _updateAllData: $e");
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

      // This logic handles the overnight case for prayers like Isha.
      // If the next prayer is on the next day (e.g., Tahajjud after Isha),
      // we adjust its date to be tomorrow.
      if (nextPrayerTime.isBefore(prayerStartTime)) {
        if (now.isAfter(prayerStartTime)) {
          // Current time is after Isha today, next prayer is tomorrow
          nextPrayerTime = nextPrayerTime.add(const Duration(days: 1));
        } else {
          // Current time is before Fajr today, previous prayer was yesterday
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

    // Convert to Bengali numerals
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
    // Convert to 12-hour format
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

        final prohibitedAfterFajr = _allPrayerTimes
            .firstWhere((p) => p.type == PrayerTimeType.prohibitedAfterFajr);
        final prohibitedBeforeDhuhr = _allPrayerTimes
            .firstWhere((p) => p.type == PrayerTimeType.prohibitedBeforeDhuhr);
        final prohibitedAfterAsr = _allPrayerTimes
            .firstWhere((p) => p.type == PrayerTimeType.prohibitedAfterAsr);

        final dhuhrTime =
            _fivePrayers.firstWhere((p) => p.type == PrayerTimeType.dhuhr);

        return SafeArea(
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
                  sunsetTime: _formatTime(
                      maghribTime.time.subtract(const Duration(minutes: 2))),
                ),
                PrayerTimesCard(
                  fivePrayers: _fivePrayers,
                  currentPrayer: _currentPrayer,
                  currentPrayerName: _currentPrayerName,
                  timeLeftToEnd: _formatDuration(_timeLeftToEnd),
                  prayerProgress: _prayerProgress,
                  isProhibitedTime: _isProhibitedTime,
                ),
                _buildInfoCardsGrid(
                  ishrakTime: _formatTime(ishrakTime.time),
                  tahajjudTime: _formatTime(tahajjudTime.time),
                  sunriseRange:
                      '${_formatTime(prohibitedAfterFajr.time)} - ${_formatTime(ishrakTime.time)}',
                  zawalRange:
                      '${_formatTime(prohibitedBeforeDhuhr.time)} - ${_formatTime(dhuhrTime.time)}',
                  sunsetRange:
                      '${_formatTime(prohibitedAfterAsr.time)} - ${_formatTime(maghribTime.time)}',
                ),
                _buildSehriIftarRow(),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 12.0;
          final double itemWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: itemWidth,
                child: InfoCard(
                  title: 'সালাতের নিষিদ্ধ সময়',
                  content: prohibitedTimesContent,
                  hasInfoIcon: true,
                  isSimple: false,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: InfoCard(
                    title: 'নফল সালাতের ওয়াক্ত',
                    content: naflTimesContent,
                    isSimple: false),
              ),
              SizedBox(
                width: itemWidth,
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
                      title: 'বিশেষ দ্রষ্টব্য (FAQ)', isSimple: true),
                ),
              ),
            ],
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

    String iftarTime = _formatTime(maghribTime.time);
    String sehriTime =
        _formatTime(fajrTime.time.subtract(const Duration(minutes: 10)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
              child: InfoCard.sehriIftar(
                  title: 'সাহরির শেষ সময়:', time: sehriTime)),
          const SizedBox(width: 12),
          Expanded(
              child:
                  InfoCard.sehriIftar(title: 'আজকের ইফতার:', time: iftarTime)),
        ],
      ),
    );
  }
}