import 'package:flutter/material.dart';
import 'package:muslim_day/screens/home_screen.dart';
import 'package:muslim_day/screens/mahfil_page.dart';
import 'package:muslim_day/screens/quran_screen.dart';
import 'package:muslim_day/screens/dua_collection_page.dart';
import 'package:muslim_day/screens/menu_screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const CommunityHubPage(),
    const QuranScreen(),
    const DuaCollectionPage(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'হোম',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'কমিউনিটি',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'কুরআন',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5),
            label: 'দোয়া',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'মেনু',
          ),
        ],
      ),
    );
  }
}
