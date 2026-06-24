import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../data/bengali_surah_data.dart';
import '../providers/quran_settings.dart';
import 'quran_settings_page.dart';
import 'surah_details_screen.dart';

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

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // No backgroundColor needed here! It will use the green from main.dart
          title: Text(
            "আল-কুরআন",
            style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuranSettingsPage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white, // Active tab white
            unselectedLabelColor:
                Colors.white70, // Inactive tab slightly transparent
            indicatorColor: Colors.white, // Indicator matches AppBar
            indicatorWeight: 3,
            labelStyle: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold, fontSize: 15),
            tabs: const [
              Tab(text: "আল-কুরআন"),
              Tab(text: "বুকমার্কস"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSurahListTab(context),
            const Center(
                child: Text("বুকমার্কস", style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahListTab(BuildContext context) {
    final settings = Provider.of<QuranSettings>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 114,
            separatorBuilder: (context, index) => Divider(
                height: 1, indent: 80, endIndent: 20, color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final surahNumber = index + 1;
              final bengaliData = bengaliSurahData[index];
              final verseCount = quran.getVerseCount(surahNumber);
              final arabicName = quran.getSurahName(surahNumber);

              return ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    // Using primaryColor with opacity for the number box
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getBengaliNumber(surahNumber),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                title: Text(
                  bengaliData.name,
                  style: GoogleFonts.notoSansBengali(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
                subtitle: Text(
                  '${bengaliData.meaning} (${_getBengaliNumber(verseCount)})',
                  style: GoogleFonts.notoSansBengali(color: Colors.grey[600]),
                ),
                trailing: Text(
                  arabicName,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: settings.arabicFontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
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
