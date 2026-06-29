import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dua_collection_page.dart'; 
import 'my_dua_collection.dart';

class CommunityHubPage extends StatefulWidget {
  const CommunityHubPage({super.key});

  @override
  State<CommunityHubPage> createState() => _CommunityHubPageState();
}

class _CommunityHubPageState extends State<CommunityHubPage> {
  // Category Data in Bangla
  final List<Map<String, dynamic>> _categories = [
    {'title': 'সালাত', 'icon': Icons.self_improvement},
    {'title': 'দৈনন্দিন জীবন', 'icon': Icons.edit_calendar_outlined},
    {'title': 'সাওম', 'icon': Icons.dark_mode_outlined},
    {'title': 'সকাল-সন্ধ্যার যিকর', 'icon': Icons.wb_sunny_outlined},
    {'title': 'কুরআনের দুআ', 'icon': Icons.menu_book_outlined},
    {'title': 'বিবিধ', 'icon': Icons.grid_view_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Dua & Adhkar', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildModernGridCard(
                  category['title'], category['icon'], primaryColor, isDarkMode,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaListPage(categoryTitle: category['title']))),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildCollectionBanner(primaryColor, isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernGridCard(String title, IconData icon, Color primaryColor, bool isDarkMode, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 6))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: primaryColor),
            const SizedBox(height: 12),
            // Changed font to notoSansBengali for correct rendering of Bangla text
            Text(title, textAlign: TextAlign.center, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionBanner(Color primaryColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(child: Text("My Collection", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCollectionPage())),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}