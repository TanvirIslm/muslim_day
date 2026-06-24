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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'হোম',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign_outlined),
          activeIcon: Icon(Icons.campaign),
          label: 'কমিউনিটি',
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
      selectedFontSize: 12,
      unselectedFontSize: 12,
    );
  }
}