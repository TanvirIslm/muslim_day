import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late HijriCalendar _currentHijri;

  @override
  void initState() {
    super.initState();
    _currentHijri = HijriCalendar.now();
  }

  // Robust Gregorian-math based month change to prevent "stuck" buttons
  void _changeMonth(int delta) {
    setState(() {
      DateTime currentGDate = _currentHijri.hijriToGregorian(_currentHijri.hYear, _currentHijri.hMonth, 1);
      DateTime newGDate = DateTime(currentGDate.year, currentGDate.month + delta, 1);
      _currentHijri = HijriCalendar.fromDate(newGDate);
    });
  }

  // Accurate month length calculation independent of package versions
  int _getDaysInHijriMonth(int year, int month) {
    if (month == 12) return (year % 30 == 2 || year % 30 == 5 || year % 30 == 7 || year % 30 == 10 || year % 30 == 13 || year % 30 == 16 || year % 30 == 18 || year % 30 == 21 || year % 30 == 24 || year % 30 == 26 || year % 30 == 29) ? 30 : 29;
    return month % 2 != 0 ? 30 : 29;
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = _getDaysInHijriMonth(_currentHijri.hYear, _currentHijri.hMonth);
    
    // Safely calculate the first day of the month
    final HijriCalendar firstDayOfMonth = HijriCalendar()..hYear = _currentHijri.hYear..hMonth = _currentHijri.hMonth..hDay = 1;
    final DateTime gregorianFirst = firstDayOfMonth.hijriToGregorian(firstDayOfMonth.hYear, firstDayOfMonth.hMonth, 1);
    
    // Calculate offset to prevent grid overflow
    final int weekdayOffset = gregorianFirst.weekday % 7; 

    return Scaffold(
      appBar: AppBar(
        title: Text('হিজরি ক্যালেন্ডার', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildWeekDaysHeader(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daysInMonth + weekdayOffset,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, 
                mainAxisSpacing: 8, 
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < weekdayOffset) return const SizedBox(); // Empty space for correct alignment
                
                final int day = index - weekdayOffset + 1;
                final DateTime gregorianDate = firstDayOfMonth.hijriToGregorian(
                    firstDayOfMonth.hYear, firstDayOfMonth.hMonth, day);
                
                return _buildDayCell(day, gregorianDate);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int day, DateTime gregorianDate) {
    final bool isToday = day == HijriCalendar.now().hDay && 
                         _currentHijri.hMonth == HijriCalendar.now().hMonth &&
                         _currentHijri.hYear == HijriCalendar.now().hYear;
    
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${_toBengaliNumber(day)} ${_currentHijri.longMonthName} | ${gregorianDate.day}-${gregorianDate.month}-${gregorianDate.year}"),
          backgroundColor: Theme.of(context).primaryColor,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isToday ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_toBengaliNumber(day), style: TextStyle(fontWeight: FontWeight.bold, color: isToday ? Colors.white : Colors.black)),
            Text("${gregorianDate.day}", style: TextStyle(fontSize: 10, color: isToday ? Colors.white70 : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Theme.of(context).primaryColor,
      // Adjusted padding to ensure buttons are easily tappable
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Button restricted to a 50px width
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30), 
              onPressed: () => _changeMonth(-1)
            ),
          ),
          
          // Middle Text takes up remaining space
          Expanded(
            child: Column(
              children: [
                Text(_currentHijri.longMonthName, style: GoogleFonts.amiri(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${_toBengaliNumber(_currentHijri.hYear)} হিজরি", style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          
          // Right Button restricted to a 50px width (Fixes the "Dead Zone" issue)
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white, size: 30), 
              onPressed: () => _changeMonth(1)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['শনি', 'রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র']
            .map((d) => Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))).toList(),
      ),
    );
  }

  // Converts English numbers to Bengali numerals
  String _toBengaliNumber(int number) {
    const b = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((char) => b[int.parse(char)]).join();
  }
}