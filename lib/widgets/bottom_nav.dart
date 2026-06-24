import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'হোম',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/dua_icon.png'),
            size: 24,
          ),
          activeIcon: ImageIcon(
            AssetImage('assets/dua_icon.png'),
            size: 26,
          ),
          label: 'দোয়া',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: 'কুরআন',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism_outlined),
          activeIcon: Icon(Icons.volunteer_activism),
          label: 'আমল ট্রাকার',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'মেনু',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color(0xFF1D9375),
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      showUnselectedLabels: true,
      // ওভারফ্লো ফিক্স করার জন্য সাইজ অ্যাডজাস্ট করা হয়েছে
      selectedFontSize: 12,
      unselectedFontSize: 10,
    );
  }
}
