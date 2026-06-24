import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quran_settings.dart'; // আপনার সেটিংস

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          // অ্যাপবারটি এখন থিমের সাথে মিল রেখে সাদা/হালকা
          appBar: AppBar(
            title: Text(
              'কুরআন সেটিংস',
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
                color: Colors.black, // টাইটেলের রঙ
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.grey[800]), // ব্যাক অ্যারো
            actions: [
              // !! নতুন ফিচার: রিসেট বাটন
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.grey[800]),
                tooltip: "পুনরায় সেট করুন",
                onPressed: () {
                  // ব্যবহারকারীকে নিশ্চিত করার জন্য একটি ডায়ালগ দেখানো ভালো
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("রিসেট সেটিংস", style: GoogleFonts.notoSansBengali()),
                      content: Text("আপনি কি সব সেটিংস ডিফল্ট অবস্থায় ফিরিয়ে আনতে চান?", style: GoogleFonts.notoSansBengali()),
                      actions: [
                        TextButton(
                          child: Text("না", style: GoogleFonts.notoSansBengali()),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: Text("হ্যাঁ", style: GoogleFonts.notoSansBengali()),
                          onPressed: () {
                            settings.resetToDefault();
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[50], // বডির ব্যাকগ্রাউন্ড
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // !! নতুন ফিচার: লাইভ প্রিভিউ কার্ড
              _buildSectionHeader(context, 'লাইভ প্রিভিউ'),
              _buildPreviewCard(settings),
              const SizedBox(height: 16),

              // --- আরবি ফন্টের সাইজ ---
              _buildSectionHeader(context, 'আরবি ফন্টের সাইজ'),
              Slider(
                value: settings.arabicFontSize,
                min: 18.0,
                max: 40.0,
                divisions: 22,
                label: settings.arabicFontSize.round().toString(),
                activeColor: Colors.teal, // রঙ যোগ করা হয়েছে
                onChanged: (value) {
                  settings.updateArabicFontSize(value);
                },
              ),
              
              // --- বাংলা অনুবাদের সাইজ ---
              _buildSectionHeader(context, 'বাংলা অনুবাদের সাইজ'),
              Slider(
                value: settings.translationFontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: settings.translationFontSize.round().toString(),
                activeColor: Colors.teal, // রঙ যোগ করা হয়েছে
                onChanged: (value) {
                  settings.updateTranslationFontSize(value);
                },
              ),

              // --- আরবি ফন্ট ---
              _buildSectionHeader(context, 'আরবি ফন্ট'),
              Wrap(
                spacing: 8.0,
                children: <Widget>[
                  _buildFontChip(settings, 'IndoPak', const TextStyle(fontFamily: 'IndoPak')),
                  _buildFontChip(settings, 'Amiri', GoogleFonts.amiri()),
                  _buildFontChip(settings, 'NotoNaskhArabic', GoogleFonts.notoNaskhArabic()),
                  _buildFontChip(settings, 'Lateef', GoogleFonts.lateef()),
                  _buildFontChip(settings, 'NotoKufiArabic', GoogleFonts.notoKufiArabic()),
                ],
              ),
              const Divider(height: 32),

              // --- অনুবাদ টগল ---
              SwitchListTile(
                title: Text(
                  'অনুবাদ দেখান',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    color: Colors.black87, // রঙ পরিবর্তন করা হয়েছে
                  ),
                ),
                value: settings.showTranslation,
                activeThumbColor: Colors.teal,
                onChanged: (value) {
                  settings.toggleTranslation(value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // সেকশন হেডার তৈরির হেল্পার
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // ফন্ট চিফ তৈরির হেল্পার
  Widget _buildFontChip(QuranSettings settings, String fontName, TextStyle fontStyle) {
    return ChoiceChip(
      label: Text(fontName, style: fontStyle.copyWith(fontSize: 16)),
      selected: settings.arabicFont == fontName,
      selectedColor: Colors.teal, // উন্নত UI
      checkmarkColor: Colors.white, // উন্নত UI
      labelStyle: TextStyle(color: settings.arabicFont == fontName ? Colors.white : Colors.black),
      onSelected: (bool selected) {
        if (selected) {
          settings.updateArabicFont(fontName);
        }
      },
    );
  }

  // প্রিভিউ কার্ড তৈরির হেল্পার
  Widget _buildPreviewCard(QuranSettings settings) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", // নমুনা আরবি টেক্সট
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: settings.arabicFontSize, // সেটিংস থেকে
                fontFamily: settings.arabicFontFamily, // সেটিংস থেকে
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.8,
              ),
            ),
            if (settings.showTranslation) ...[
              const SizedBox(height: 16),
              Text(
                "শুরু করছি আল্লাহর নামে যিনি পরম করুণাময়, অতি দয়ালু।", // নমুনা বাংলা টেক্সট
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSansBengali(
                  fontSize: settings.translationFontSize, // সেটিংস থেকে
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}