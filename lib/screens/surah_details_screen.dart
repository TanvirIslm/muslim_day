import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/quran_settings.dart';
import 'quran_settings_page.dart';

/// ইংরেজি সংখ্যাকে বাংলা সংখ্যায় রূপান্তর করে
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

/// সূরার বিস্তারিত দেখানোর স্ক্রিন
class SurahDetailsScreen extends StatelessWidget {
  final int surahNumber;
  final String surahNameEnglish;
  final String surahNameArabic;
  final String surahNameBengali;
  final String surahNameMeaning;

  const SurahDetailsScreen({
    super.key,
    required this.surahNumber,
    required this.surahNameEnglish,
    required this.surahNameArabic,
    required this.surahNameBengali,
    required this.surahNameMeaning,
  });

  @override
  Widget build(BuildContext context) {
    final verseCount = quran.getVerseCount(surahNumber);
    final settings = Provider.of<QuranSettings>(context);

    // ইংরেজি স্থানকে বাংলায় রূপান্তর
    final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);
    final revelationPlaceBengali =
        placeOfRevelation == "Makkah" ? "মাক্কী" : "মাদানী";

    // !! নতুন লজিক: বিসমিল্লাহ কার্ড দেখানো হবে কিনা?
    final bool showBismillahCard = (surahNumber != 1 && surahNumber != 9);

    // !! নতুন লজিক: মোট আইটেম সংখ্যা গণনা
    // ১ (হেডার) + আয়াত সংখ্যা + (বিসমিল্লাহ কার্ড থাকলে ১, না থাকলে ০)
    final int totalItemCount = 1 + verseCount + (showBismillahCard ? 1 : 0);

    return Scaffold(
      backgroundColor: Colors.grey[50], // হালকা ব্যাকগ্রাউন্ড
      // --- অ্যাপবার ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          surahNameBengali, // বাংলা শিরোনাম
          style: GoogleFonts.notoSansBengali(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined), // ফিল্টার আইকন
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuranSettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border), // বুকমার্ক আইকন
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward), // ফরওয়ার্ড আইকন
            onPressed: () {},
          ),
        ],
      ),
      // --- প্লে বাটন ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
      // --- বডি ---
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // !! itemCount পরিবর্তন করা হয়েছে
        itemCount: totalItemCount,
        itemBuilder: (context, index) {
          // --- ১. সাব-হেডার (সর্বদা index 0) ---
          if (index == 0) {
            return _buildSubHeader(
                revelationPlaceBengali, verseCount, surahNameMeaning);
          }

          // --- ২. বিসমিল্লাহ কার্ড (যদি প্রযোজ্য হয় এবং index 1 হয়) ---
          if (showBismillahCard && index == 1) {
            return _buildBismillahCard(settings);
          }

          // --- ৩. আয়াতসমূহ ---

          // !! নতুন লজিক: আয়াতের নম্বর গণনা
          int verseNumber;
          if (showBismillahCard) {
            // যদি বিসমিল্লাহ কার্ড থাকে (index 1), তবে আয়াত শুরু হয় index 2 থেকে
            // তাই, verseNumber = index - 1 (e.g., index 2 -> verse 1)
            verseNumber = index - 1;
          } else {
            // যদি বিসমিল্লাহ কার্ড না থাকে (সূরা ১ বা ৯), তবে আয়াত শুরু হয় index 1 থেকে
            // তাই, verseNumber = index (e.g., index 1 -> verse 1)
            verseNumber = index;
          }

          final verseText = quran.getVerse(surahNumber, verseNumber);

          // !! গুরুত্বপূর্ণ: এখানে আমরা ইংরেজি অনুবাদ পাচ্ছি
          final verseTranslation =
              quran.getVerseTranslation(surahNumber, verseNumber);

          return _VerseCard(
            verseNumber: verseNumber,
            verseText: verseText,
            verseTranslation: verseTranslation, // placeholder
            settings: settings,
          );
        },
      ),
    );
  }

  /// সাব-হেডার উইজেট
  Widget _buildSubHeader(String place, int verseCount, String meaning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1D9375),
            const Color(0xFF1D9375).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D9375).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            surahNameArabic,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            surahNameBengali,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansBengali(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansBengali(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(Icons.place, place),
              _buildInfoChip(Icons.format_list_numbered,
                  'আয়াত: ${_getBengaliNumber(verseCount)}'),
              _buildInfoChip(
                  Icons.tag, 'সূরা: ${_getBengaliNumber(surahNumber)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.notoSansBengali(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// বিসমিল্লাহ দেখানোর জন্য কার্ড
  Widget _buildBismillahCard(QuranSettings settings) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1D9375).withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.menu_book,
                size: 32,
                color: const Color(0xFF1D9375).withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                quran.basmala,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: settings.arabicFontSize * 1.2,
                  fontFamily: settings.arabicFontFamily,
                  color: const Color(0xFF1D9375),
                  fontWeight: FontWeight.bold,
                  height: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// প্রতিটি আয়াতের জন্য আলাদা কার্ড উইজেট
class _VerseCard extends StatelessWidget {
  const _VerseCard({
    required this.verseNumber,
    required this.verseText,
    required this.verseTranslation,
    required this.settings,
  });

  final int verseNumber;
  final String verseText;
  final String verseTranslation;
  final QuranSettings settings;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- কার্ডের উপরের অংশ (নম্বর ও মেনু) ---
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1D9375),
                        const Color(0xFF1D9375).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1D9375).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getBengaliNumber(verseNumber),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    _buildActionButton(Icons.bookmark_border, () {}),
                    const SizedBox(width: 4),
                    _buildActionButton(Icons.share, () {}),
                    const SizedBox(width: 4),
                    _buildActionButton(Icons.copy, () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- আরবি আয়াত ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D9375).withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                verseText,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: settings.arabicFontSize,
                  fontFamily: settings.arabicFontFamily,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  height: 2.0, // লাইন স্পেসিং বাড়ানো হয়েছে
                ),
              ),
            ),

            // --- বাংলা অনুবাদ ---
            if (settings.showTranslation) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'অনুবাদ',
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        verseTranslation,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansBengali(
                          fontSize: settings.translationFontSize,
                          color: Colors.grey[800],
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.grey.shade600),
      ),
    );
  }
}
