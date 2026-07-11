import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart'; // নামাজের সঠিক সময় বের করার জন্য
import '../providers/prayer_settings.dart'; // আপনার লোকেশন সেটিংস
import 'location_selection_screen.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late DateTime _selectedDate;
  bool _isGridView = false;

  // Month & Year Selections
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<String> _bengaliMonths = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  // --- Light Mode Colors ---
  final Color primaryThemeColor = const Color(0xFF1D9375); 
  final Color bgColor = const Color(0xFFF4F7F6); 
  final Color cardColor = Colors.white; 
  final Color textColor = const Color(0xFF2D3748); 
  final Color secondaryTextColor = const Color(0xFF718096); 
  final Color dangerColor = const Color(0xFFE53935); // নিষিদ্ধ সময়ের জন্য

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  // --- 📅 HIJRI DATE WITHOUT OFFSET ---
  HijriCalendar _getHijriDate(DateTime date) {
    // প্যাকেজ থেকে সরাসরি ডাটা নেওয়া হচ্ছে
    return HijriCalendar.fromDate(date);
  }

  // Converts numbers to Bengali numerals
  String _toBengaliNumber(dynamic number) {
    const b = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((char) {
      if (RegExp(r'[0-9]').hasMatch(char)) {
        return b[int.parse(char)];
      }
      return char;
    }).join();
  }

  String _getBengaliWeekday(DateTime date) {
    List<String> days = ['সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'];
    return days[date.weekday - 1];
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // সময় ফরম্যাট করার ফাংশন (যেমন: ০৪:৪১)
  String _formatTimeBn(DateTime? time) {
    if (time == null) return "--:--";
    final str = DateFormat('hh:mm').format(time); // ১২ ঘণ্টার ফরম্যাট
    return _toBengaliNumber(str);
  }

  @override
  Widget build(BuildContext context) {
    // ইউজারের লোকেশন সেটিংস প্রোভাইডার থেকে নেওয়া হচ্ছে
    final prayerSettings = Provider.of<PrayerSettings>(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('ক্যালেন্ডার', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, color: primaryThemeColor),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildMonthYearSelectors(),
          Expanded(
            child: _isGridView ? _buildGridView() : _buildListView(prayerSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearSelectors() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: _selectedMonth,
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(_bengaliMonths[index], style: GoogleFonts.notoSansBengali(color: textColor, fontWeight: FontWeight.w600)),
                );
              }),
              onChanged: (val) => setState(() => _selectedMonth = val as int),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown(
              value: _selectedYear,
              items: List.generate(10, (index) {
                int year = DateTime.now().year - 2 + index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(_toBengaliNumber(year), style: GoogleFonts.notoSansBengali(color: textColor, fontWeight: FontWeight.w600)),
                );
              }),
              onChanged: (val) => setState(() => _selectedYear = val as int),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required int value, required List<DropdownMenuItem<int>> items, required Function(dynamic) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryThemeColor),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- 📜 List View (Dynamic Data Fetching) ---
  Widget _buildListView(PrayerSettings settings) {
    int daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);

    // ইউজারের লোকেশন কোঅর্ডিনেটস 
    // (যদি null থাকে তবে ডিফল্ট ঢাকার কোঅর্ডিনেট ব্যবহার করা হবে)
    final lat = settings.latitude;
    final lng = settings.longitude;
    
    final coordinates = Coordinates(lat, lng);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        DateTime date = DateTime(_selectedYear, _selectedMonth, index + 1);
        HijriCalendar hijriDate = _getHijriDate(date);
        
        bool isToday = date.year == DateTime.now().year && 
                       date.month == DateTime.now().month && 
                       date.day == DateTime.now().day;

        // 🚀 ওই নির্দিষ্ট দিনের (Specific Date) জন্য ডাইনামিক ডাটা ক্যালকুলেট করা
        final dateComponents = DateComponents(date.year, date.month, date.day);
        final params = CalculationMethod.karachi.getParameters();
        params.madhab = Madhab.hanafi; // হানাফি মাযহাব অনুযায়ী আসরের সময়
        final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

        return _buildDailyCard(date, hijriDate, isToday, prayerTimes);
      },
    );
  }

  Widget _buildDailyCard(DateTime date, HijriCalendar hijriDate, bool isToday, PrayerTimes prayerTimes) {
    // সাহরি এবং ইফতারের হিসাব (সাহরি ফজর থেকে ৫ মিনিট আগে, ইফতার মাগরিবের সময়)
    final sahriTime = prayerTimes.fajr.subtract(const Duration(minutes: 5));
    final iftarTime = prayerTimes.maghrib;

    // নিষিদ্ধ সময়ের হিসাব
    final sunriseEnd = prayerTimes.sunrise.add(const Duration(minutes: 15));
    final zawaalStart = prayerTimes.dhuhr.subtract(const Duration(minutes: 5));
    final sunsetStart = prayerTimes.maghrib.subtract(const Duration(minutes: 15));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isToday ? primaryThemeColor : primaryThemeColor.withValues(alpha: 0.85),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_toBengaliNumber(date.day)} ${_bengaliMonths[date.month - 1]}, ${_toBengaliNumber(date.year)} - ${_getBengaliWeekday(date)}",
                      style: GoogleFonts.notoSansBengali(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Text("আজ", style: GoogleFonts.notoSansBengali(color: primaryThemeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${_toBengaliNumber(hijriDate.hDay)} ${hijriDate.longMonthName}, ${_toBengaliNumber(hijriDate.hYear)}", 
                  style: GoogleFonts.notoSansBengali(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🚀 ৫ ওয়াক্ত নামাজের সময় (Dynamic Data)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _timeColumn("ফজর", _formatTimeBn(prayerTimes.fajr)),
                      _timeColumn("যোহর", _formatTimeBn(prayerTimes.dhuhr)),
                      _timeColumn("আসর", _formatTimeBn(prayerTimes.asr)),
                      _timeColumn("মাগরিব", _formatTimeBn(prayerTimes.maghrib)),
                      _timeColumn("ইশা", _formatTimeBn(prayerTimes.isha)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 🚀 সূর্যোদয়/সূর্যাস্ত এবং সাহরি/ইফতার (Dynamic Data)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _timeColumn("সূর্যোদয়", _formatTimeBn(prayerTimes.sunrise)),
                            _timeColumn("সূর্যাস্ত", _formatTimeBn(prayerTimes.maghrib)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _timeColumn("সাহরি", _formatTimeBn(sahriTime)),
                            _timeColumn("ইফতার", _formatTimeBn(iftarTime)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🚀 নিষিদ্ধ সময় (Dynamic Calculation)
                Text("সালাতের নিষিদ্ধ সময়", style: GoogleFonts.notoSansBengali(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _prohibitedCard("সকাল", "${_formatTimeBn(prayerTimes.sunrise)} - ${_formatTimeBn(sunriseEnd)}"),
                    const SizedBox(width: 8),
                    _prohibitedCard("দুপুর", "${_formatTimeBn(zawaalStart)} - ${_formatTimeBn(prayerTimes.dhuhr)}"),
                    const SizedBox(width: 8),
                    _prohibitedCard("সন্ধ্যা", "${_formatTimeBn(sunsetStart)} - ${_formatTimeBn(prayerTimes.maghrib)}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeColumn(String label, String time) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.notoSansBengali(color: secondaryTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(time, style: GoogleFonts.notoSansBengali(color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _prohibitedCard(String label, String timeRange) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: dangerColor.withValues(alpha: 0.05), 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dangerColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.notoSansBengali(color: dangerColor.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(timeRange, style: GoogleFonts.notoSansBengali(color: dangerColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- 🔲 Grid View (Light Mode UI) ---
  Widget _buildGridView() {
    int daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
    DateTime firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    int weekdayOffset = firstDayOfMonth.weekday % 7;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildWeekDaysHeader(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daysInMonth + weekdayOffset,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < weekdayOffset) return const SizedBox();

                int day = index - weekdayOffset + 1;
                DateTime date = DateTime(_selectedYear, _selectedMonth, day);
                HijriCalendar hijriDate = _getHijriDate(date); // No offset used

                bool isToday = date.year == DateTime.now().year && 
                               date.month == DateTime.now().month && 
                               date.day == DateTime.now().day;

                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${_toBengaliNumber(hijriDate.hDay)} ${hijriDate.longMonthName} | ${_toBengaliNumber(date.day)} ${_bengaliMonths[date.month-1]}"),
                      backgroundColor: primaryThemeColor,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday ? primaryThemeColor : bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isToday ? primaryThemeColor : Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_toBengaliNumber(hijriDate.hDay),
                            style: TextStyle(fontWeight: FontWeight.bold, color: isToday ? Colors.white : textColor, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(_toBengaliNumber(date.day),
                            style: TextStyle(fontSize: 10, color: isToday ? Colors.white70 : secondaryTextColor)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি']
            .map((d) => Text(d, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: primaryThemeColor, fontSize: 13)))
            .toList(),
      ),
    );
  }
}