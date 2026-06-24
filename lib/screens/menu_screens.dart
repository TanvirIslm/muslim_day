import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qibla_compass.dart';
import 'tasbeeh.dart';
// import 'fiqh_assistant_page.dart';
import 'dua_collection_page.dart';
import 'nearby_mosque_page.dart';
import 'masnoon_amal_page.dart';
import 'app_settings_page.dart';
import 'prayer_streak_page.dart';
import 'learning_path_page.dart';
import 'ai_assistant_page.dart';
import 'app_caution_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      appBar: AppBar(
        // অ্যাপবার আপডেট করা হয়েছে
        title: Text(
          'মেনু',
          style: GoogleFonts.notoSansBengali(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          // Unique Features Section
          _buildSectionHeader('🌟 বিশেষ ফিচার'),
          _buildMenuItem(
            icon: Icons.local_fire_department,
            title: 'নামাজ স্ট্রিক ও পুরস্কার',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerStreakPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.school_outlined,
            title: 'ইসলামিক শিক্ষার পথ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LearningPathPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.psychology,
            title: 'AI সহায়ক',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AIAssistantPage(),
                ),
              );
            },
          ),
          
          // General Section
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'বিশেষ দ্রষ্টব্য (FAQ)',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppCautionPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'সেটিংস',
            onTap: () {
              // <-- ৩. নেভিগেশন যোগ করা হয়েছে
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppSettingsPage(),
                ),
              );
            },
          ),
          // _buildMenuItem(
          //     icon: Icons.support_agent_outlined,
          //     title: 'ফিকহ অ্যাসিস্ট্যান্ট', 
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const FiqhAssistantPage(),
          //         ),
          //       );
          //     }),

          // Tools Section
          _buildSectionHeader('টুলস'),
          _buildMenuItem(
              icon: Icons.explore_outlined,
              title: 'কিবলা কম্পাস',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QiblaCompassScreen(),
                  ),
                );
              }),
          _buildMenuItem(
            icon: Icons.format_list_numbered,
            title: 'তাসবীহ',
            onTap: () {
              // Navigate to TasbeehCounterPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TasbeehCounterScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
              icon: Icons.book,
              title: 'দোয়া সমূহ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DuaCollectionPage(),
                  ),
                );
              }),
          _buildMenuItem(
              icon: Icons.mosque_outlined,
              title: 'নিকটবর্তী মসজিদ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NearbyMosquePage(),
                  ),
                );
              }),

          // Knowledge Section
          _buildSectionHeader('প্রয়োজনীয় ইলম'),
          _buildMenuItem(
              icon: Icons.book_outlined,
              title: 'কুরআন-হাদীস (নির্বাচিত অংশ)',
              onTap: () {}),
          _buildMenuItem(
              icon: Icons.web_stories_outlined,
              title: 'ফজর ফাইটার ওয়েবসাইট',
              onTap: () {}),
          _buildMenuItem(
              icon: Icons.assignment_outlined,
              title: 'মাসনুন আমল',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MasnoonAmalPage(),
                  ),
                );
              }),
          _buildMenuItem(
              icon: Icons.article_outlined, title: 'আর্টিকেল', onTap: () {}),
          _buildMenuItem(
              icon: Icons.help_outline, title: 'মাসআলা', onTap: () {}),
        ],
      ),
    );
  }

  // Helper widget for section headers like "টুলস"
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          color: const Color(0xFF1D9375),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper widget for each clickable menu item
  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}