import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_settings.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/ai_assistant_button.dart';
import 'home_content.dart';
import 'quran_screen.dart';
import 'menu_screens.dart';
import '../providers/amal_provider.dart';
import 'amal_journal_page.dart';
import 'dua.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Sets the status bar color to your theme green globally
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF1D9375),
      statusBarIconBrightness: Brightness.light,
    ));
  }

  int _selectedIndex = 0;

  // List of pages to be displayed in the body
  static final List<Widget> _pages = <Widget>[
    const HomeContent(),
    const CommunityHubPage(),
    ChangeNotifierProvider(
      create: (context) => QuranSettings(),
      child: const QuranScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => AmalProvider(),
      child: const AmalJournalPage(),
    ),
    const MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The floatingActionButton property automatically handles placement
      // It will only show if on the Home tab (_selectedIndex == 0)
      floatingActionButton:
          _selectedIndex == 0 ? const AIAssistantButton() : null,

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}