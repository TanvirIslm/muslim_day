import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/quran_settings.dart'; 
import '../widgets/bottom_nav.dart';
import 'home_content.dart';
import 'quran_screen.dart'; 
import 'menu_screens.dart';
import '../providers/amal_provider.dart';
import 'amal_journal_page.dart';
import 'mahfil_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          
          // Show AI Assistant only on home screen
          if (_selectedIndex == 0)
            const Positioned(
              right: 16,
              bottom: 80,
              child: _AIFloatingButton(),
            ),
        ],
      ),
      // !! 4. Enabled your BottomNav
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Simple AI button widget embedded here
class _AIFloatingButton extends StatelessWidget {
  const _AIFloatingButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      onPressed: () {
        _showAIDialog(context);
      },
      backgroundColor: const Color(0xFF1D9375),
      heroTag: 'ai_assistant',
      child: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
    );
  }

  void _showAIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF1D9375)),
            SizedBox(width: 12),
            Text('AI ইসলামিক সহায়ক'),
          ],
        ),
        content: const Text(
          'এই ফিচারটি শীঘ্রই আসছে!\n\nআপনি ইসলাম সম্পর্কিত যেকোনো প্রশ্ন জিজ্ঞাসা করতে পারবেন এবং তাৎক্ষণিক উত্তর পাবেন।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }
}