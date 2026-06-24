import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityHubPage extends StatefulWidget {
  const CommunityHubPage({super.key});

  @override
  State<CommunityHubPage> createState() => _CommunityHubPageState();
}

class _CommunityHubPageState extends State<CommunityHubPage> {
  // ক্যাটাগরি ডেটা (পারফেক্ট আইকন সহ)
  final List<Map<String, dynamic>> _categories = [
    {'title': 'সালাত-নামাজ', 'icon': Icons.self_improvement},
    {'title': 'দৈনন্দিন জীবন', 'icon': Icons.edit_calendar_outlined},
    {'title': 'সাওম', 'icon': Icons.dark_mode_outlined},
    {'title': 'সকাল-সন্ধ্যার যিকর', 'icon': Icons.wb_sunny_outlined},
    {'title': 'কুরআন থেকে', 'icon': Icons.menu_book_outlined},
    {'title': 'বিবিধ', 'icon': Icons.grid_view_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      // AppBar
      appBar: AppBar(
        title: Text(
          'দোয়া',
          style: GoogleFonts.notoSansBengali(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- ১. মডার্ন কার্ড-বেজড গ্রিড সেকশন ---
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing:
                    16, // স্পেসিং কমানো হয়েছে যাতে কম্প্যাক্ট মনে হয়
                childAspectRatio: 1.1, // পারফেক্ট কার্ড রেশিও
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildModernGridCard(
                  title: category['title'],
                  icon: category['icon'],
                  primaryColor: primaryColor,
                  isDarkMode: isDarkMode,
                );
              },
            ),

            const SizedBox(height: 32),

            // --- ২. হাইলাইটেড কালেকশন ব্যানার ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildCollectionBanner(primaryColor, isDarkMode),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- হেল্পার উইজেট: মডার্ন গ্রিড কার্ড ---
  Widget _buildModernGridCard({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {
        // Handle click
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.05), // অত্যন্ত সফট শ্যাডো
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ছোট এবং এলিগ্যান্ট আইকন বক্স
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: primaryColor, // আইকনের কালার এখন প্রাইমারি
              ),
            ),
            const SizedBox(height: 12),
            // টেক্সট
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- হেল্পার উইজেট: কালেকশন ব্যানার ---
  Widget _buildCollectionBanner(Color primaryColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E3A32)
            : primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // বাম দিকের টেক্সট অংশ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bookmark_added, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "আমার কালেকশন",
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "আপনার প্রয়োজনীয় দু'আগুলো একসাথে সেভ করে রাখুন নিজের মতো করে।",
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 13,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // ডান দিকের অ্যাকশন বাটন
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Icon(Icons.add, size: 24),
          ),
        ],
      ),
    );
  }
}
