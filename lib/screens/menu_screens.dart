import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qibla_compass.dart';
import 'tasbeeh.dart';
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
    // গ্লোবাল থিম থেকে প্রাইমারি কালারটি নিয়ে নিলাম
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      appBar: AppBar(
        title: Text(
          'মেনু',
          style: GoogleFonts.notoSansBengali(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // গ্লোবাল থিম অনুযায়ী কালার সেট করা হয়েছে
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _buildSectionHeader('বিশেষ ফিচার', primaryColor),
          _buildMenuItem(
            icon: Icons.local_fire_department,
            title: 'নামাজ স্ট্রিক ও পুরস্কার',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerStreakPage())),
          ),
          _buildMenuItem(
            icon: Icons.school_outlined,
            title: 'ইসলামিক শিক্ষার পথ',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningPathPage())),
          ),
          _buildMenuItem(
            icon: Icons.psychology,
            title: 'AI সহায়ক',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIAssistantPage())),
          ),

          // ⚙️ Settings Section
          _buildSectionHeader('সেটিংস', primaryColor),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'বিশেষ দ্রষ্টব্য (FAQ)',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppCautionPage())),
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'সেটিংস',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSettingsPage())),
          ),

          // 🛠️ Tools Section
          _buildSectionHeader('টুলস', primaryColor),
          _buildMenuItem(
            icon: Icons.explore_outlined,
            title: 'কিবলা কম্পাস',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QiblaCompassScreen())),
          ),
          _buildMenuItem(
            icon: Icons.format_list_numbered,
            title: 'তাসবীহ',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TasbeehCounterScreen())),
          ),
          _buildMenuItem(
            icon: Icons.book,
            title: 'দোয়া সমূহ',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DuaCollectionPage())),
          ),
          _buildMenuItem(
            icon: Icons.mosque_outlined,
            title: 'নিকটবর্তী মসজিদ',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NearbyMosquePage())),
          ),

          // 📚 Knowledge Section
          _buildSectionHeader('প্রয়োজনীয় ইলম', primaryColor),
          _buildMenuItem(icon: Icons.book_outlined, title: 'কুরআন-হাদীস', primaryColor: primaryColor, onTap: () {}),
          _buildMenuItem(icon: Icons.web_stories_outlined, title: 'ফজর ফাইটার ওয়েবসাইট', primaryColor: primaryColor, onTap: () {}),
          _buildMenuItem(
            icon: Icons.assignment_outlined,
            title: 'মাসনুন আমল',
            primaryColor: primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MasnoonAmalPage())),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}