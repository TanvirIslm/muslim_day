import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;

import '../data/bengali_surah_data.dart';
import '../providers/quran_settings.dart';
import 'quran_settings.dart';
import 'surah_details_screen.dart';

/// Custom helper function that converts English numbers to Bengali numbers.
String _getBengaliNumber(int number) {
  const Map<String, String> bengaliMap = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯'
  };
  return number
      .toString()
      .split('')
      .map((char) => bengaliMap[char] ?? char)
      .join();
}

/// This is the main screen for your Quran section, now with tabs.
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We are using DefaultTabController to manage the three tabs
    return DefaultTabController(
      length: 2, // "আল-কুরআন", "বুকমার্কস",
      child: Scaffold(
        // অ্যাপবারটি এখন সাদা রঙের, স্ক্রিনশটের সাথে মিল রেখে
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          // পেছনের অ্যারো বাটন
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          //   onPressed: () {
          //     // দেখুন এই স্ক্রিনটি স্ট্যাকের প্রথম কিনা
          //     if (Navigator.canPop(context)) {
          //       Navigator.pop(context);
          //     }
          //   },
          // ),
          // বাংলা শিরোনাম
          title: Text(
            "আল-কুরআন",
            style: GoogleFonts.notoSansBengali(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.grey[800]),
          actions: [
            
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // আমরা এটাকে আপনার তৈরি করা SettingsPage এর সাথে লিঙ্ক করছি
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            // সামনের অ্যারো আইকন
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward),
            //   onPressed: () {
            //     // এই বাটনের জন্য নেভিগেশন যোগ করুন
            //   },
            // ),
          ],
          // ২টি বিভাগের জন্য TabBar
          bottom: TabBar(
            labelColor: Colors.teal, // Active tab color
            unselectedLabelColor: Colors.grey[600], // Inactive tab color
            indicatorColor: Colors.teal,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.notoSansBengali(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            tabs: const [
              Tab(text: "আল-কুরআন"),
              Tab(text: "বুকমার্কস"),
            ],
          ),
        ),
        // TabBarView প্রতিটি ট্যাবের কন্টেন্ট ধারণ করে
        body: TabBarView(
          children: [
            // --- ট্যাব ১: সূরা তালিকা ---
            _buildSurahListTab(context),

            // --- ট্যাব ২: বুকমার্কস (স্থানধারক) ---
            const Center(
              child: Text("বুকমার্কস", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  /// এই উইজেটটি প্রথম ট্যাবের কন্টেন্ট তৈরি করে,
  /// যার মধ্যে সার্চ বার এবং সূরা তালিকা রয়েছে।
  Widget _buildSurahListTab(BuildContext context) {
    final settings = Provider.of<QuranSettings>(context);

    return Column(
      children: [
        // --- সূরা তালিকা ---
        Expanded(
          child: ListView.separated(
            itemCount: 114,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 80,
              endIndent: 20,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final surahNumber = index + 1;

              // !! নতুন ডেটা: আমরা আমাদের bengali_surah_data ফাইল থেকে ডেটা নিচ্ছি
              final bengaliData =
                  bengaliSurahData[index]; // যেহেতু তালিকা 0-ভিত্তিক
              final verseCount = quran.getVerseCount(surahNumber);
              final arabicName = quran.getSurahName(surahNumber);

              return ListTile(
                // শুরুতে: বাংলা নম্বর সহ গোলাকার বর্গ
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getBengaliNumber(surahNumber),
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // শিরোনাম: বাংলা নাম (আমাদের ডেটা ফাইল থেকে)
                title: Text(
                  bengaliData.name, // 'আল-ফাতিহা'
                  style: GoogleFonts.notoSansBengali(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                // উপ-শিরোনাম: বাংলা অর্থ এবং আয়াত সংখ্যা
                subtitle: Text(
                  '${bengaliData.meaning} (${_getBengaliNumber(verseCount)})', // 'সূচনা (৭)'
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.grey[600],
                  ),
                ),

                // শেষে: আরবি নাম
                trailing: Text(
                  arabicName,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: settings.arabicFontFamily, // Use mapped font family
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),

                onTap: () {
                  // !! দ্রষ্টব্য: SurahDetailsScreen এখনও ইংরেজি নাম ব্যবহার করছে
                  // অ্যাপবার শিরোনামের জন্য। তাই আমরা এটি পাস করছি।
                  final englishName = quran.getSurahNameEnglish(surahNumber);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailsScreen(
                        surahNumber: surahNumber,
                        surahNameEnglish: englishName,
                        surahNameArabic: arabicName,
                        surahNameBengali: bengaliData.name,
                        surahNameMeaning: bengaliData.meaning,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
