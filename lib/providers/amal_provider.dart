import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// একটি আমলের ডেটা মডেল
class Amal {
  final String id; // ইউনিক আইডি (যেমন: 'fajr', 'quran')
  final String title; // বাংলায় নাম
  final IconData icon; // আইকন
  final String category; // আমলের ধরণ (fardh, sunnah, habit)
  final int points; // !! নতুন: আমলের জন্য পয়েন্ট

  const Amal({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.points, // !! নতুন
  });
}

/// ব্যবহারকারীর আমল ট্র্যাক করার জন্য একটি প্রোভাইডার
class AmalProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  // অ্যাপে উপলভ্য সমস্ত আমলের তালিকা
  static const List<Amal> allAmals = [
    // !! 'points' যোগ করা হয়েছে
    Amal(
        id: 'fajr',
        title: 'ফজর',
        icon: Icons.mosque_outlined,
        category: 'fardh',
        points: 10),
    Amal(
        id: 'dhuhr',
        title: 'যোহর',
        icon: Icons.mosque_outlined,
        category: 'fardh',
        points: 10),
    Amal(
        id: 'asr',
        title: 'আসর',
        icon: Icons.mosque_outlined,
        category: 'fardh',
        points: 10),
    Amal(
        id: 'maghrib',
        title: 'মাগরিব',
        icon: Icons.mosque_outlined,
        category: 'fardh',
        points: 10),
    Amal(
        id: 'isha',
        title: 'ইশা',
        icon: Icons.mosque_outlined,
        category: 'fardh',
        points: 10),

    Amal(
        id: 'tahajjud',
        title: 'তাহাজ্জুদ',
        icon: Icons.brightness_3_outlined,
        category: 'sunnah',
        points: 5),
    Amal(
        id: 'morning_azkar',
        title: 'সকালের জিকির',
        icon: Icons.wb_sunny_outlined,
        category: 'sunnah',
        points: 5),
    Amal(
        id: 'evening_azkar',
        title: 'সন্ধ্যার জিকির',
        icon: Icons.nightlight_round,
        category: 'sunnah',
        points: 5),

    Amal(
        id: 'quran',
        title: 'কুরআন তিলাওয়াত',
        icon: Icons.book_outlined,
        category: 'habit',
        points: 2),
    Amal(
        id: 'sadaqah',
        title: 'সাদাকাহ (দান)',
        icon: Icons.volunteer_activism_outlined,
        category: 'habit',
        points: 2),
  ];

  final Map<String, List<String>> _completedAmals = {};
  final Set<String> _datesWithAmal = {};

  // !! নতুন: মোট পয়েন্টের জন্য
  int _totalPoints = 0;
  int get totalPoints => _totalPoints;

  AmalProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    // মোট পয়েন্ট লোড করুন
    _totalPoints = _prefs.getInt('totalPoints') ?? 0;

    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('amal_')) {
        final dateKey = key.substring(5);
        final amals = _prefs.getStringList(key) ?? [];
        _completedAmals[dateKey] = amals;
        if (amals.isNotEmpty) {
          _datesWithAmal.add(dateKey);
        }
      }
    }
    notifyListeners();
  }

  List<String> getAmalsForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _completedAmals[dateKey] ?? [];
  }

  Future<void> toggleAmal(DateTime date, String amalId) async {
    final dateKey = _formatDateKey(date);
    final currentAmals = _completedAmals[dateKey] ?? [];

    // !! পয়েন্ট সিস্টেম লজিক
    final amal = allAmals.firstWhere((a) => a.id == amalId);

    if (currentAmals.contains(amalId)) {
      currentAmals.remove(amalId);
      _totalPoints -= amal.points; // পয়েন্ট কমান
    } else {
      currentAmals.add(amalId);
      _totalPoints += amal.points; // পয়েন্ট বাড়ান
    }

    // মোট পয়েন্ট যেন কখনো ০ এর নিচে না যায়
    if (_totalPoints < 0) _totalPoints = 0;

    _completedAmals[dateKey] = currentAmals;

    if (currentAmals.isEmpty) {
      _datesWithAmal.remove(dateKey);
    } else {
      _datesWithAmal.add(dateKey);
    }

    // সেভ করুন
    await _prefs.setStringList('amal_$dateKey', currentAmals);
    await _prefs.setInt('totalPoints', _totalPoints); // মোট পয়েন্ট সেভ করুন

    notifyListeners();
  }

  String _formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  List<Amal> getAmalsByCategory(String category) {
    return allAmals.where((amal) => amal.category == category).toList();
  }

  double getDailyProgress(DateTime date) {
    if (allAmals.isEmpty) return 0.0;
    final completed = getAmalsForDate(date).length;
    return completed / allAmals.length;
  }

  // !! নতুন: ক্যাটাগরি ভিত্তিক স্ট্রিম গণনার লজিক
  int getCategoryStreak(String category) {
    final categoryAmals = getAmalsByCategory(category).map((a) => a.id).toSet();
    if (categoryAmals.isEmpty) return 0;

    int streak = 0;
    DateTime date = DateTime.now();
    DateTime today = DateTime(date.year, date.month, date.day);

    // আজ ক্যাটাগরির সবগুলো আমল সম্পন্ন হয়েছে কিনা দেখুন
    final completedTodayAmals = getAmalsForDate(today).toSet();
    bool todayDone = completedTodayAmals.containsAll(categoryAmals);

    // যদি আজ সম্পন্ন না হয়, গতকাল থেকে গণনা শুরু করুন
    if (!todayDone) {
      date = today.subtract(const Duration(days: 1));
    } else {
      date = today; // আজ সম্পন্ন হলে, আজ থেকে গণনা শুরু করুন
    }

    // পেছনে যেতে থাকুন
    while (true) {
      final completedAmalsForDay = getAmalsForDate(date).toSet();
      if (completedAmalsForDay.containsAll(categoryAmals)) {
        streak++;
        date = date.subtract(const Duration(days: 1)); // আগের দিনে যান
      } else {
        break; // Streak ভেঙে গেছে
      }
    }
    return streak;
  }
}
