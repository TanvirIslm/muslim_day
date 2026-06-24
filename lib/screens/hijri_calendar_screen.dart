import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late HijriCalendar _selectedHijriDate;
  late DateTime _selectedGregorianDate;
  
  final List<String> _arabicMonths = [
    'المحرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  final List<String> _bengaliMonths = [
    'মুহাররম',
    'সফর',
    'রবিউল আউয়াল',
    'রবিউস সানি',
    'জমাদিউল আউয়াল',
    'জমাদিউস সানি',
    'রজব',
    'শাবান',
    'রমজান',
    'শাওয়াল',
    'জিলকদ',
    'জিলহজ্জ',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGregorianDate = DateTime.now();
    _selectedHijriDate = HijriCalendar.fromDate(_selectedGregorianDate);
  }

  String _toBengaliNumber(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String numStr = number.toString();
    for (int i = 0; i < english.length; i++) {
      numStr = numStr.replaceAll(english[i], bengali[i]);
    }
    return numStr;
  }

  void _changeMonth(int delta) {
    setState(() {
      final newMonth = _selectedHijriDate.hMonth + delta;
      final newYear = _selectedHijriDate.hYear + (newMonth > 12 ? 1 : newMonth < 1 ? -1 : 0);
      final adjustedMonth = newMonth > 12 ? 1 : newMonth < 1 ? 12 : newMonth;
      
      _selectedHijriDate = HijriCalendar()
        ..hYear = newYear
        ..hMonth = adjustedMonth
        ..hDay = 1;
      _selectedGregorianDate = _selectedHijriDate.hijriToGregorian(newYear, adjustedMonth, 1);
    });
  }

  void _selectToday() {
    setState(() {
      _selectedGregorianDate = DateTime.now();
      _selectedHijriDate = HijriCalendar.fromDate(_selectedGregorianDate);
    });
  }

  int _getDaysInHijriMonth(int year, int month) {
    // Hijri months alternate between 29 and 30 days
    // Even months have 30 days, odd months have 29 days (with adjustments for the leap year)
    if (month == 12) {
      // Dhul-Hijjah can have 29 or 30 days
      return _isHijriLeapYear(year) ? 30 : 29;
    }
    return month % 2 == 0 ? 30 : 29;
  }

  bool _isHijriLeapYear(int year) {
    return (year * 11 + 14) % 30 < 11;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInHijriMonth(_selectedHijriDate.hYear, _selectedHijriDate.hMonth);
    final monthNameArabic = _arabicMonths[_selectedHijriDate.hMonth - 1];
    final monthNameBengali = _bengaliMonths[_selectedHijriDate.hMonth - 1];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'হিজরি ক্যালেন্ডার',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1D9375),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1D9375),
                  const Color(0xFF1D9375).withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      onPressed: () => _changeMonth(-1),
                    ),
                    Column(
                      children: [
                        Text(
                          monthNameArabic,
                          style: GoogleFonts.amiri(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          monthNameBengali,
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        Text(
                          _toBengaliNumber(_selectedHijriDate.hYear),
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
                      onPressed: () => _changeMonth(1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _selectToday,
                  icon: const Icon(Icons.today, size: 18),
                  label: Text(
                    'আজ',
                    style: GoogleFonts.notoSansBengali(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1D9375),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar Grid
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final hijriDate = HijriCalendar()
                    ..hYear = _selectedHijriDate.hYear
                    ..hMonth = _selectedHijriDate.hMonth
                    ..hDay = day;
                  
                  final gregorianDate = hijriDate.hijriToGregorian(
                    hijriDate.hYear,
                    hijriDate.hMonth,
                    hijriDate.hDay,
                  );
                  
                  final isToday = gregorianDate.year == DateTime.now().year &&
                      gregorianDate.month == DateTime.now().month &&
                      gregorianDate.day == DateTime.now().day;

                  return _buildDayCell(day, gregorianDate, isToday);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int hijriDay, DateTime gregorianDate, bool isToday) {
    return Container(
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFF1D9375) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? const Color(0xFF1D9375) : Colors.grey.shade300,
          width: isToday ? 2 : 1,
        ),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: const Color(0xFF1D9375).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _toBengaliNumber(hijriDay),
            style: GoogleFonts.notoSansBengali(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            gregorianDate.day.toString(),
            style: TextStyle(
              fontSize: 10,
              color: isToday ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
