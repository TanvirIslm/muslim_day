import 'package:flutter/material.dart';

class Dua {
  final String id;
  final String title;
  final String arabic;
  final String translation;
  final String reference;

  Dua({required this.id, required this.title, required this.arabic, required this.translation, required this.reference});
}

class DuaRepository {
  static final Map<String, List<Dua>> data = {
    'Salah / Namaz': [
      Dua(id: 's1', title: "After Tashahhud", arabic: "اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي...", translation: "O Allah, I have greatly wronged myself...", reference: "Sahih al-Bukhari 834"),
      Dua(id: 's2', title: "Dua Qunut", arabic: "اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ...", translation: "O Allah, guide me among those You have guided...", reference: "Sunan an-Nasa'i 1745"),
    ],
    'Morning-Evening': [
      Dua(id: 'm1', title: "Sayyidul Istighfar", arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ...", translation: "O Allah, You are my Lord...", reference: "Sahih al-Bukhari 6306"),
    ],
    // Add more categories here...
  };
}